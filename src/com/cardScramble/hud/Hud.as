package com.cardScramble.hud
{
	import com.abacus.assetManager.AssetManager;
	import com.cardScramble.utils.StringUtils;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class Hud extends Sprite{
		
		[Embed(source="../../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;	
		
		//consts
		public static const ST_SOUND_FX:SoundTransform = new SoundTransform();
		private static const GLOBAL_ST:SoundTransform = new SoundTransform();
		
		//instance
		private static var _instance:Hud = new Hud();
		
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//assets
		private var _soundIconsContainer:Sprite;
		private var _musicIcon:Image;
		private var _soundFxIcon:Image;
		private var _coinIcon:Image;
		
		//text
		private var _timerText:TextField;
		private var _scoreText:TextField;
		
		
		public function Hud(){
			if(_instance){
				throw new Error("Singleton class. Use getInstance()");
			}
		}
		
		private function initAssets():void{
			
			//timer
			_timerText = new TextField(200, 50, "Time: 60", "JandaManateeSolid", 30, 0xFFFFFF);
			_timerText.fontName = "JandaManateeSolid";
			_timerText.x = 90;
			_timerText.y = 10;
			_timerText.scaleX = _timerText.scaleY = 1.5;
			_timerText.touchable = false;
			addChild(_timerText);
			
			//score
			_coinIcon = new Image(_assets.getTexture("coin_11"));
			_coinIcon.pivotX = _coinIcon.pivotY = _coinIcon.width/2;
			_coinIcon.x = 425;
			_coinIcon.y = 42;
			addChild(_coinIcon);
			
			_scoreText = new TextField(250, 50, "0", "JandaManateeSolid", 30, 0xFFFFFF);
			_scoreText.hAlign = HAlign.LEFT;
			_scoreText.fontName = "JandaManateeSolid";
			_scoreText.x = 450;
			_scoreText.y = 10;
			_scoreText.scaleX = _scoreText.scaleY = 1.5;
			_scoreText.touchable = false;
			addChild(_scoreText);
			
			//music and soundFx
			_soundIconsContainer = new Sprite();
			_soundIconsContainer.x = 725;
			_soundIconsContainer.y = 20;
			addChild(_soundIconsContainer);
			
			_musicIcon = new Image(_assets.getTexture("speakerIcon"));
			_musicIcon.name = "music";
			_soundIconsContainer.addChild(_musicIcon);
			
			_soundFxIcon = new Image(_assets.getTexture("musicNoteIcon"));
			_soundFxIcon.x = 50;
			_soundFxIcon.name = "soundFx";
			//_soundIconsContainer.addChild(_soundFxIcon);	
		}
		
		private function initListeners():void{
			_soundIconsContainer.addEventListener(TouchEvent.TOUCH, onSoundIconTouch);
		}
		
		private function onSoundIconTouch(e:TouchEvent):void{
			
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			
			if(touchBegan){
				var icon:Image = e.target as Image;
				var filter:ColorMatrixFilter = new ColorMatrixFilter();
				
				if(GLOBAL_ST.volume == 0){
					
					icon.filter = null;
					GLOBAL_ST.volume = 1;
				} else {
					
					filter.adjustBrightness(0.75);
					icon.filter = filter;
					GLOBAL_ST.volume = 0;
				}
				
				SoundMixer.soundTransform = GLOBAL_ST;
			}
		}

		
		
		//===================== PUBLIC METHODS =======================//
		
		public static function getInstance():Hud{
			return _instance;
		}
		
		public function init():void{
			initAssets();
			initListeners();
		}
		
		public function updateTimer(time:Number):void{
			_timerText.text = String("Time: " + StringUtils.convertToHHMMSS(time));
		}
		
		public function updateScore(score:Number):void{
			_scoreText.text = String(score);
			TweenLite.delayedCall(0.25, animateCoinIcon);
		}
		
		public function animateCoinIcon():void{
			
			if(_coinIcon.scaleX > 1){
				TweenMax.to(_coinIcon, 0.1, {scaleX:1, scaleY:1, onComplete:onCoinComplete});
			} else {
				TweenMax.to(_coinIcon, 0.1, {scaleX:1.25, scaleY:1.25, onComplete:onCoinComplete});
			}
			
			function onCoinComplete():void{
				TweenLite.to(_coinIcon, 0.05, {scaleX:1, scaleY:1});
			}
		}
		
		public function hideTimer():void{
			_timerText.visible = false;
		}
		
		public function showTimer():void{
			_timerText.visible = true;
		}
		
		public function hideScore():void{
			_timerText.visible = true;
		}
		
		public function showScore():void{
			_timerText.visible = true;
		}
		
		public function hideHud():void{
			this.visible = false;
		}
		
		public function showHud():void{
			this.visible = true;
			showScore();
			showTimer();
		}
		
	}
}