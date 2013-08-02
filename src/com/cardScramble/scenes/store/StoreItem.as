package com.cardScramble.scenes.store
{
	import com.abacus.assetManager.AssetManager;
	import com.cardScramble.scenes.store.data.StoreData;
	import com.cardScramble.scenes.store.data.StoreItemVO;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	
	public class StoreItem extends Sprite{
		
		[Embed(source="../../../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;
		
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//assets
		private var _buyBox:Image;
		private var _buyButton:Image;
		private var _item:Image;
		
		//text
		private var _priceText:TextField;
		private var _numItems:TextField;
		
		//data
		private var _storeData:StoreData;
		private var _itemData:StoreItemVO;
		
		public function StoreItem(itemVO:StoreItemVO, data:StoreData){
			
			_itemData = itemVO;
			_storeData = data;
			
			initAssets();
			initListeners();
			updateAvailability();
			updateQuantity();
		}
		
		private function initAssets():void{
			
			_buyBox = new Image(_assets.getTexture("buyBox"));
			addChild(_buyBox);
			
			//score
			_priceText = new TextField(125, 50, String(_itemData.price), "JandaManateeSolid", 30, 0xFFFFFF);
			_priceText.fontName = "JandaManateeSolid";
			_priceText.x = 50;
			_priceText.y = 154;
			_priceText.touchable = false;
			addChild(_priceText);
			
			_numItems = new TextField(50, 50, "1", "JandaManateeSolid", 30, 0xFFFFFF);
			_numItems.fontName = "JandaManateeSolid";
			_numItems.x = 10;
			_numItems.y = 14;
			_numItems.touchable = false;
			addChild(_numItems);
			
			_buyButton = new Image(_assets.getTexture("buyButton"));
			_buyButton.pivotX = _buyButton.width/2;
			_buyButton.pivotY = _buyButton.height/2;
			_buyButton.x = 112;
			_buyButton.y = 215;
			addChild(_buyButton);
			
			_item = new Image(_assets.getTexture(_itemData.itemType));
			_item.x = 60;
			_item.y = 45;
			_item.filter = BlurFilter.createDropShadow();
			addChild(_item);
		}
		
		private function initListeners():void{
			
			_buyButton.addEventListener(TouchEvent.TOUCH, onBuyTouch);
		}
		
		
		
		//=============== PUBLIC FUNCTION ==============//
		
		public function updateAvailability():void{
			
			if(_storeData.currencyAmount < _itemData.price){
				
				_buyButton.alpha = 0.35;
				_buyButton.touchable = false;
			}
		}
		
		public function updateQuantity():void{
			
			_numItems.text = String(_itemData.quantity);
		}
		
		public function updateNumItemsInInventory():void{
			
		}
		
		
		//============== EVENT HANDLERS ===============//
		
		private function onBuyTouch(e:TouchEvent):void{
			
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchHover:Touch = e.getTouch(this, TouchPhase.HOVER);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			//touch began
			if(touchBegan){
				var buyButton:Image = e.target as Image;
				TweenLite.to(buyButton, 0.01, {scaleX:0.95, scaleY:0.95, ease:Expo.easeOut});
			}
			
			//mouse over and mouse out
			if(touchHover){
				var buyButtonOver:Image = e.target as Image;
				TweenLite.to(buyButtonOver, 0.25, {scaleX:1.05, scaleY:1.05, ease:Expo.easeOut});
				
			} else {
				var buyButtonOut:Image = e.target as Image;
				TweenLite.to(buyButtonOut, 0.25, {scaleX:1, scaleY:1, ease:Expo.easeOut});
			}
			
			//ended
			if(touchEnded){
				var buyButtonEnded:Image = e.target as Image;
				TweenLite.to(buyButtonEnded, 0.01, {scaleX:1.05, scaleY:1.05, ease:Expo.easeOut});
				
				_itemData.quantity++;
				_storeData.purchase(_itemData);
				_assets.playSound("RegisterRing2");
				updateQuantity();
			} 
		}
		
	}
}