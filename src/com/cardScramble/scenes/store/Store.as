package com.cardScramble.scenes.store
{
	import com.abacus.core.IScene;
	import com.abacus.core.ISceneData;
	import com.abacus.core.Scene;
	import com.cardScramble.hud.Hud;
	import com.cardScramble.scenes.store.data.StoreData;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	
	public class Store extends Scene implements IScene{
		
		//global
		private var _hud:Hud = Hud.getInstance();
		
		//data
		private var _data:StoreData;
		
		//assets
		private var _bg:Image;
		private var _storeItemContainer:Sprite;
		
		//buttons
		private var _playAgainButton:Image;
		
		
		
		public function Store(){
			
		}
		
		
		//================== PUBLIC METHODS ==================//
		
		override public function init(data:ISceneData):void{
			
			_data = data as StoreData;
			
			_hud.showHud();
			_hud.hideTimer();
			
			//bg
			_bg = new Image(_assets.getTexture("storeBg"));
			addChild(_bg);
			
			//store item container
			_storeItemContainer = new Sprite();
			_storeItemContainer.x = 80;
			_storeItemContainer.y = 60;
			addChild(_storeItemContainer);
			
			//buttons
			_playAgainButton = new Image(_assets.getTexture("playAgainButton"));
			_playAgainButton.pivotX = _playAgainButton.width/2;
			_playAgainButton.pivotY = _playAgainButton.height/2;
			_playAgainButton.x = Starling.current.stage.stageWidth - _playAgainButton.width/2;
			_playAgainButton.y = Starling.current.stage.stageHeight - _playAgainButton.height/2;
			addChild(_playAgainButton);
			
			initListeners();
			initStoreItems();
		}
		
		override public function pause():void{
			
		}
		
		override public function close():void{
			
		}
		
		
		
		//=================== PRIVATE METHODS ===================//
		
		private function initListeners():void{
			_data.addEventListener(StoreData.UPDATE, onStoreDataUpdate);
			_playAgainButton.addEventListener(TouchEvent.TOUCH, onPlayAgainTouch);
		}
		
		
		private function initStoreItems():void{
			
			var xVal:int = 0;
			var yVal:int = 0;
			
			var len:int = 2;
			var count:int = 0;
			for (var i:int = 0; i < len; i++) {
				
				var len2:int = 3;
				for (var j:int = 0; j < len2; j++) {
					
					var storeItem:StoreItem = new StoreItem(_data.storeItems[count], _data);
					storeItem.x = xVal;
					storeItem.y = yVal;
					_storeItemContainer.addChild(storeItem);
					
					xVal += storeItem.width;
					count++;
				}
				
				yVal += storeItem.height - 20;
				xVal = 0;
				
			}
		}
		
		private function updateItemAvailability():void{
			
			var len:int = _storeItemContainer.numChildren;
			for (var i:int = 0; i < len; i++) {
				
				var storeItem:StoreItem = _storeItemContainer.getChildAt(i) as StoreItem;
				storeItem.updateAvailability();
			}
		}
		
		
		
		//=================== EVENT HANDLERS ===================//
		
		private function onStoreDataUpdate(e:Event):void{
			
			var type:String = e.data.type;
			
			switch(type){
				
				case StoreData.INIT:
					initStoreItems();
					break;
				case StoreData.PURCHASE:
					updateItemAvailability();
					break;
			}
		}
		

		private function onPlayAgainTouch(e:TouchEvent):void{
			
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchHover:Touch = e.getTouch(this, TouchPhase.HOVER);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			//touch began
			if(touchBegan){
				var playAgainButtonBegin:Image = e.target as Image;
				TweenLite.to(playAgainButtonBegin, 0.01, {scaleX:0.95, scaleY:0.95, ease:Expo.easeOut});
			}
			
			//mouse over and mouse out
			if(touchHover){
				var playAgainButtonHover:Image = e.target as Image;
				TweenLite.to(playAgainButtonHover, 0.25, {scaleX:1.05, scaleY:1.05, ease:Expo.easeOut});
				
			} else {
				var playAgainButtonOut:Image = e.target as Image;
				TweenLite.to(playAgainButtonOut, 0.25, {scaleX:1, scaleY:1, ease:Expo.easeOut});
			}
			
			//ended
			if(touchEnded){
				var playAgainButtonEnded:Image = e.target as Image;
				TweenLite.to(playAgainButtonEnded, 0.01, {scaleX:1.05, scaleY:1.05, ease:Expo.easeOut});
				_data.close();
			}
		}
		
		
	}
}