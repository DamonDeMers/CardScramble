package com.cardScramble.scenes.game
{
	import com.abacus.assetManager.AssetManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	
	public class PowerUps extends Sprite{
		
		//consts
		public static const UPDATE:String = "update";
		
		//power up types
		public static const SHUFFLE:String = "shuffle";
		public static const HOLD3:String = "hold3";
		public static const SCORE2X:String = "score2x";
		
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//data
		private var _powerUpDict:Dictionary = new Dictionary();
		
		//assets
		private var _powerUpChipsContainer:Sprite;
		
		
		public function PowerUps(){
			initAssets();
			initListeners();
		}
		
		
		
		//=============== PRIVATE METHODS ==================//
		
		private function initAssets():void{
			
			_powerUpChipsContainer = new Sprite();
			addChild(_powerUpChipsContainer);
		}
		
		private function initListeners():void{
			_powerUpChipsContainer.addEventListener(TouchEvent.TOUCH, onPowerUpTouch);
		}
		
		private function onPowerUpTouch(e:TouchEvent):void{
			
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchHover:Touch = e.getTouch(this, TouchPhase.HOVER);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			//touch began
			if(touchBegan){
				var powerUpBegan:Image = e.target as Image;
				TweenLite.to(powerUpBegan, 0.01, {scaleX:0.95, scaleY:0.95, ease:Expo.easeOut});
			}
			
			//mouse over and mouse out
			if(touchHover){
				var powerUpHoverOver:Image = e.target as Image;
				TweenLite.to(powerUpHoverOver, 0.25, {scaleX:1.05, scaleY:1.05, ease:Expo.easeOut});
				
			} else {
				var powerUpHoverOut:Image = e.target as Image;
				TweenLite.to(powerUpHoverOut, 0.25, {scaleX:1, scaleY:1, ease:Expo.easeOut});
			}
			
			//ended
			if(touchEnded){
				var powerUpEnded:Image = e.target as Image;
				TweenLite.to(powerUpEnded, 0.01, {scaleX:1.05, scaleY:1.05, ease:Expo.easeOut, onComplete:onTouchComplete, onCompleteParams:[powerUpEnded]});
				dispatchEventWith(UPDATE, true, {type:_powerUpDict[powerUpEnded]});
			}
			
		}
		
		private function onTouchComplete(powerUp:Image):void{
			TweenLite.to(powerUp, 1, {x:250, ease:Expo.easeOut, onComplete:removePowerUp});
			
			function removePowerUp():void{
				removeChild(powerUp);
			}
		}
		
		
		
		//=============== PUBLIC METHODS ==================//
		
		public function add(type:String):void{
			
			var powerUpChip:Image = new Image(_assets.getTexture(type));
			
			powerUpChip.pivotX = powerUpChip.pivotY = powerUpChip.width/2;
			powerUpChip.filter = BlurFilter.createDropShadow(5, 0.785, 0x0, 0.75);
			powerUpChip.y = _powerUpChipsContainer.height;
			
			if(_powerUpChipsContainer.numChildren > 0){
				powerUpChip.y += 20;
			}
			
			_powerUpChipsContainer.addChild(powerUpChip);
			
			//associate chip with event type
			switch(type){
				
				case "shuffleChip":
					_powerUpDict[powerUpChip] = SHUFFLE;
					break;
				case "score2xChip":
					_powerUpDict[powerUpChip] = SCORE2X;
					break;
				case "hold3Chip":
					_powerUpDict[powerUpChip] = HOLD3;
					break;
			}
		}
		
		
	}
}