package com.abacus.sound
{
	import com.abacus.assetManager.AssetManager;
	import com.abacus.utils.ArrayUtils;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.CustomEase;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VolumePlugin;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	TweenPlugin.activate([VolumePlugin]);

	
	CustomEase.create("audioFadeIn", [{s:0,cp:0.03539,e:0.2854},{s:0.2854,cp:0.5354,e:1}]);
	CustomEase.create("audioFadeOut", [{s:0,cp:0.4362,e:0.6862},{s:0.6862,cp:0.9362,e:1}]);
	
	public class SoundManager
	{
		//const
		private const OFFSET:Number = 63;
		
		//singleton instance
		private static var m_instance:SoundManager = null;
		
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//sound dictionary
		private var _soundVODict:Dictionary = new Dictionary();
		

		
		public function SoundManager(enforcer:SingletonEnforcer)
		{
			if (enforcer == null)
			{
				throw Error("You are trying to create a new instance of a Singleton class.  Use SoundManager.getInstance()");
			}
		}
		
		public static function getInstance():SoundManager
		{
			if (m_instance == null)
			{
				m_instance = new SoundManager( new SingletonEnforcer() );
			}
			
			return m_instance;
		}
		
		
		//*************** Public Methods ****************//
		
		public function play(sound:Sound, loopCount:int = 1, vol:Number = 1):void
		{	
			registerSound(sound, loopCount, vol);
			
			var soundVO:SoundVO = _soundVODict[sound];
			
			if(soundVO.soundLoopCount > 1)
			{ 	
				soundVO.soundLoopCount--;
				TweenMax.delayedCall(soundVO.soundDuration, onLoopComplete, [sound]);
			}
			
			if(soundVO.sequenceBool == true && soundVO.sequenceLoopCount > 1) 
			{
				var soundSeqVect:Vector.<Sound> = soundVO.sequenceVector;
				var deDupedVect:Vector.<Sound> = ArrayUtils.removeDuplicates(soundSeqVect);
				
				for(var i:int = 0; i < deDupedVect.length; i++)
				{
					var sVO:SoundVO = _soundVODict[deDupedVect[i]];
					sVO.sequenceCurrentIndex++; 
				}
				
				if(soundVO.sequenceCurrentIndex > (soundVO.sequenceLength - 1))
				{
					for(var j:int = 0; j < soundSeqVect.length; j++)
					{
						var seqVO:SoundVO = _soundVODict[soundSeqVect[j]];
						
						seqVO.sequenceLoopCount--; 
						seqVO.sequenceCurrentIndex = 0;
					}
				}
				
				sound = soundSeqVect[soundVO.sequenceCurrentIndex];
				TweenMax.delayedCall(soundVO.soundDuration, onLoopComplete, [sound]);
			}
			else if (soundVO.sequenceBool == true && soundVO.sequenceLoopCount == 1)
			{
				var soundSeqVectEnd:Vector.<Sound> = soundVO.sequenceVector;
				
				for(var k:int = 0; k < soundSeqVectEnd.length; k++)
				{
					var sVOEnd:SoundVO = _soundVODict[soundSeqVectEnd[k]];
					sVOEnd.sequenceCurrentIndex++;
				}
				
				sound = soundSeqVectEnd[soundVO.sequenceCurrentIndex];
				TweenMax.delayedCall(soundVO.soundDuration, onSequenceComplete, [sound]);
			}
			
			
			SoundTransform(soundVO.soundTransform).volume = vol;
			SoundChannel(soundVO.soundChannel).soundTransform = SoundTransform(soundVO.soundTransform);
			
			soundVO.soundChannel = sound.play(0, 1, soundVO.soundTransform);
		}
		
		public function playSequence(sounds:Vector.<Sound>, seqLoopCount:int = 1, vol:Number = 1):void
		{
			for (var i:int = 0; i < sounds.length; i++)
			{
				var sound:Sound = sounds[i];
				registerSound(sound, 1, vol, sounds, seqLoopCount);
			}
			
			sound = sounds[0];	
			play(sound);
		}
		
		public function fadeIn(duration:Number):void
		{
			for(var sound:Sound in _soundVODict)
			{
				var soundVO:SoundVO = _soundVODict[sound];
				var sc:SoundChannel = soundVO.soundChannel;
				var st:SoundTransform = soundVO.soundTransform;
				
				TweenLite.to(sc, duration, {volume:st.volume, ease:CustomEase.byName("audioFadeIn")});
			}
		}
		
		public function fadeOut(duration:Number):void
		{
			for(var sound:Sound in _soundVODict)
			{
				var soundVO:SoundVO = _soundVODict[sound];
				var sc:SoundChannel = soundVO.soundChannel;
				var st:SoundTransform = soundVO.soundTransform;
				
				TweenLite.to(sc, duration, {volume:0, ease:CustomEase.byName("audioFadeOut")});
			}
		}
		
		public function mute():void
		{
			for(var sound:Sound in _soundVODict)
			{
				var soundVO:SoundVO = _soundVODict[sound];
				
				SoundTransform(soundVO.soundTransform).volume = 0;
				SoundChannel(soundVO.soundChannel).soundTransform = SoundTransform(soundVO.soundTransform);
			}
		}
		
		public function unMute():void
		{
			for(var sound:Sound in _soundVODict)
			{
				var soundVO:SoundVO = _soundVODict[sound];
				
				SoundTransform(soundVO.soundTransform).volume = _soundVODict[sound].sVol;
				SoundChannel(soundVO.soundChannel).soundTransform = SoundTransform(soundVO.soundTransform);
			}
		}
		
		public function stop():void
		{
			TweenMax.killAll();
			
			for(var sound:Sound in _soundVODict)
			{
				var soundVO:SoundVO = _soundVODict[sound];
				
				SoundChannel(soundVO.soundChannel).stop();
			}
			
			killAllSequences();
		}
		
		
		//************* Private Methods *****************//
		
		private function registerSound(sound:Sound, loopCount:int = 1, vol:Number = 1, seqVect:Vector.<Sound> = null, seqLoopCount:int = 1):void
		{
			if(_soundVODict[sound] == undefined)
			{
				var soundVO:SoundVO = new SoundVO();
				var soundChannel:SoundChannel = new SoundChannel();
				var soundTransform:SoundTransform = new SoundTransform();
				
				soundVO.soundChannel = soundChannel;
				soundVO.soundTransform = soundTransform;
				soundVO.volume = vol;
				soundVO.soundLoopCount = loopCount;
				soundVO.soundDuration = (sound.length - OFFSET)/1000;
				soundVO.sequenceBool = seqVect != null ? true : false;
				soundVO.sequenceVector = seqVect;
				soundVO.sequenceLength = seqVect != null ? seqVect.length : 0;
				soundVO.sequenceLoopCount = seqLoopCount;
				soundVO.sequenceCurrentIndex = -1;
				
				_soundVODict[sound] = soundVO;
				
				trace("[SoundManager]: registerSound()");
			}
			
		}
		
		private function killAllSequences():void
		{
			for(var sound:Sound in _soundVODict)
			{
				var soundVO:SoundVO = _soundVODict[sound];
				
				if(soundVO.sequenceBool == true)
				{
					soundVO = null;
					_soundVODict[sound] = null;
				}
			}
		}
		
		
		//************* Event Handlers *****************//
		
		private function onLoopComplete(sound:Sound):void
		{	
			var soundVO:SoundVO = _soundVODict[sound];
			var loopCount:int = soundVO.soundLoopCount;
			var soundDurationMs:Number = soundVO.soundDuration * 1000;
			var soundPositionMs:Number = SoundChannel(soundVO.soundChannel).position;
			
			if(soundDurationMs - soundPositionMs > OFFSET && soundPositionMs != 0)
			{
				var delay:Number = (soundDurationMs - soundPositionMs - 12)/1000;
				TweenMax.delayedCall(delay, function ():void { play(sound, loopCount); });
			} 
			else
			{
				play(sound, loopCount);
			}
		}
		
		private function onSequenceComplete(sound:Sound):void
		{	
			var soundVO:SoundVO = _soundVODict[sound];
			var soundSeqVect:Vector.<Sound> = soundVO.sequenceVector;
			
			for(var i:int = 0; i < soundSeqVect.length; i++)
			{
				var sVO:SoundVO = _soundVODict[soundSeqVect[i]];
				sVO = null;
				_soundVODict[soundSeqVect[i]] = null;
			}
		}
	
		private function traceSoundVO(soundVO:SoundVO, log:String):void
		{
		
			trace("[SoundManager]: " + log +
				" soundChannel: " + soundVO.soundChannel +
				" soundTransform: " + soundVO.soundTransform + 
				" volume: " + soundVO.volume + 
				" soundLoopCount: " + soundVO.soundLoopCount + 
				" soundDuration: " + soundVO.soundDuration + 
				" sequenceBool: " + soundVO.sequenceBool + 
				" sequenceVect: " + soundVO.sequenceVector + 
				" sequenceLength: " + soundVO.sequenceLength +
				" sequenceLoopCount: " + soundVO.sequenceLoopCount +
				" sequenceCurrentIndex: " + soundVO.sequenceCurrentIndex
				);
		}
	}
}

class SingletonEnforcer{}