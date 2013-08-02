package com.cardScramble.scenes.game
{
	import com.abacus.assetManager.AssetManager;
	import com.cardScramble.scenes.store.data.StoreItemVO;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PowerUps extends Sprite{
		
		//consts
		public static const UPDATE:String = "update";
		
		//power up types
		public static const SHUFFLE:String = "shuffleChip";
		public static const HOLD3:String = "hold3Chip";
		public static const SCORE2X:String = "score2xChip";
		public static const SUPER_HAND:String = "superHandChip";
		public static const WILD_CARD:String = "wildCardChip";
		public static const ONE_COLOR:String = "oneColorChip";
		
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
				var powerUpBegan:PowerUpChip = Image(e.target).parent as PowerUpChip;
				TweenLite.to(powerUpBegan, 0.01, {scaleX:0.95, scaleY:0.95, ease:Expo.easeOut});
			}
			
			//mouse over and mouse out
			if(touchHover){
				var powerUpHoverOver:PowerUpChip = Image(e.target).parent as PowerUpChip;
				TweenLite.to(powerUpHoverOver, 0.25, {scaleX:1.05, scaleY:1.05, ease:Expo.easeOut});
				
			} else {
				var powerUpHoverOut:PowerUpChip = Image(e.target).parent as PowerUpChip;
				TweenLite.to(powerUpHoverOut, 0.25, {scaleX:1, scaleY:1, ease:Expo.easeOut});
			}
			
			//ended
			if(touchEnded){
				var powerUpEnded:PowerUpChip = Image(e.target).parent as PowerUpChip;
				TweenLite.to(powerUpEnded, 0.01, {scaleX:1.05, scaleY:1.05, ease:Expo.easeOut, onComplete:onTouchComplete, onCompleteParams:[powerUpEnded]});
				dispatchEventWith(UPDATE, true, {type:_powerUpDict[powerUpEnded]});
			}
			
		}
		
		private function onTouchComplete(powerUp:PowerUpChip):void{
			
			powerUp.updateQuantity(powerUp.quantity-1);
			
			if(powerUp.quantity == 0){
				
				TweenLite.to(powerUp, 1, {x:250, ease:Expo.easeOut, onComplete:removePowerUp});
				
				function removePowerUp():void{
					removeChild(powerUp);
				}
			} 

		}
		
		
		
		//=============== PUBLIC METHODS ==================//
		
		public function add(itemVO:StoreItemVO):void{
			
			var powerUpChip:PowerUpChip = new PowerUpChip(itemVO.itemType);
			
			powerUpChip.y = _powerUpChipsContainer.height;
			if(_powerUpChipsContainer.numChildren > 0){
				powerUpChip.y += 20;
			}
			
			powerUpChip.updateQuantity(itemVO.quantity);
			_powerUpChipsContainer.addChild(powerUpChip);
			
			//associate chip with event type
			switch(itemVO.itemType){
				
				case "shuffleChip":
					_powerUpDict[powerUpChip] = SHUFFLE;
					break;
				case "score2xChip":
					_powerUpDict[powerUpChip] = SCORE2X;
					break;
				case "hold3Chip":
					_powerUpDict[powerUpChip] = HOLD3;
					break;
				case "wildCardChip":
					_powerUpDict[powerUpChip] = WILD_CARD;
					break;
				case "oneColorChip":
					_powerUpDict[powerUpChip] = ONE_COLOR;
					break;
				case "superHandChip":
					_powerUpDict[powerUpChip] = SUPER_HAND;
					break;
			}
		}
		
		public function reset():void{
			
			_powerUpDict = null;
			
			while(_powerUpChipsContainer.numChildren > 0){
				_powerUpChipsContainer.removeChildAt(0);
			}
		}
		
	}
}