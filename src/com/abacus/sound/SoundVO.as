package com.abacus.sound
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundVO
	{
		private var _soundChannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		private var _soundDuration:Number;
		private var _volume:Number;
		private var _soundLoopCount:int;
		private var _sequenceBool:Boolean;
		private var _sequenceVector:Vector.<Sound>
		private var _sequenceLength:int;
		private var _sequenceLoopCount:int;
		private var _sequenceCurrentIndex:int;
		
		
		public function SoundVO()
		{
		}

		// Sound
		
		public function get soundChannel():SoundChannel { return _soundChannel; }
		public function set soundChannel(value:SoundChannel):void { _soundChannel = value; }
		
		public function get soundTransform():SoundTransform { return _soundTransform; }
		public function set soundTransform(value:SoundTransform):void { _soundTransform = value; }
		
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void { _volume = value; }
		
		public function get soundLoopCount():int { return _soundLoopCount; }
		public function set soundLoopCount(value:int):void { _soundLoopCount = value; }
		
		public function get soundDuration():Number { return _soundDuration; }
		public function set soundDuration(value:Number):void { _soundDuration = value; }
		
		// Sequence
		
		public function get sequenceBool():Boolean { return _sequenceBool; }
		public function set sequenceBool(value:Boolean):void { _sequenceBool = value; }
		
		public function get sequenceVector():Vector.<Sound> { return _sequenceVector; }
		public function set sequenceVector(value:Vector.<Sound>):void { _sequenceVector = value; }
		
		public function get sequenceLength():int { return _sequenceLength; }
		public function set sequenceLength(value:int):void { _sequenceLength = value; }
		
		public function get sequenceLoopCount():int { return _sequenceLoopCount; }
		public function set sequenceLoopCount(value:int):void { _sequenceLoopCount = value; }
		
		public function get sequenceCurrentIndex():int { return _sequenceCurrentIndex; }
		public function set sequenceCurrentIndex(value:int):void { _sequenceCurrentIndex = value; }

	}
}