package com.cardScramble.scenes.store.data
{
	import com.abacus.core.ISceneData;
	import com.abacus.core.SceneData;
	import com.cardScramble.core.CardScrambleModel;
	import com.cardScramble.scenes.game.PowerUpTypes;
	
	public class StoreData extends SceneData implements ISceneData{
		
		//consts
		public static const UPDATE:String = "update";
		public static const INIT:String = "init";
		public static const PURCHASE:String = "purchase";
		
		//global
		private var _model:CardScrambleModel = CardScrambleModel.getInstance();
		
		private var _storeItems:Vector.<StoreItemVO> = new Vector.<StoreItemVO>;
		private var _inventory:Vector.<StoreItemVO> = new Vector.<StoreItemVO>;
		
		
		public function StoreData(){
			super();
		}
		
		
		
		//================== PUBLIC METHODS ==================//
		

		override public function init():void{
			
			//inventory items
			var item1:StoreItemVO = new StoreItemVO();
			item1.itemType = PowerUpTypes.SHUFFLE;
			item1.price = 100;
			
			var item2:StoreItemVO = new StoreItemVO();
			item2.itemType = PowerUpTypes.SCORE2X;
			item2.price = 200;
			
			var item3:StoreItemVO = new StoreItemVO();
			item3.itemType = PowerUpTypes.HOLD3;
			item3.price = 300;
			
			//inventory items
			var item4:StoreItemVO = new StoreItemVO();
			item4.itemType = PowerUpTypes.SHUFFLE;
			item4.price = 10000;
			
			var item5:StoreItemVO = new StoreItemVO();
			item5.itemType = PowerUpTypes.SCORE2X;
			item5.price = 20000;
			
			var item6:StoreItemVO = new StoreItemVO();
			item6.itemType = PowerUpTypes.HOLD3;
			item6.price = 30000;
			
			_storeItems.push(item1, item2, item3, item4, item5, item6);
			updateInventory();
			updateStoreItemQuantity();
			
			dispatchEventWith(UPDATE, true, {type:INIT});
		}
		
		override public function pause():void{
			
		}
		
		override public function close():void{
			
			_model.sharedObject.data.balance = _model.currencyAmount;
			_model.sharedObject.data.inventory = _inventory;
			
			trace("inventory.len: " + _inventory.length);

			_storeItems.length = 0;
			_model.gotoScene(0);
		}
		
		public function purchase(itemVO:StoreItemVO):void{
			
			_model.updateCurrency(-itemVO.price, 0);
			
			if(!inventoryItemExists(itemVO)){
				_inventory.push(itemVO);
			}
			
			dispatchEventWith(UPDATE, true, {type:PURCHASE});
		}
		
		
		//=================== PRIVATE METHODS =====================//
		
		private function updateInventory():void{
			
			var len:int = _model.sharedObject.data.inventory.length;
			
			for (var i:int = 0; i < len; i++) {
				
				var item:Object = _model.sharedObject.data.inventory[i];
				var storeItemVO:StoreItemVO = new StoreItemVO();
				
				storeItemVO.price = item.price;
				storeItemVO.quantity = item.quantity;
				storeItemVO.itemType = item.itemType;
						
				_inventory.push(storeItemVO);
			}
			
		}
		
		private function updateStoreItemQuantity():void{
			
			var len1:int = _storeItems.length;
			for (var i:int = 0; i < len1; i++) {
				
				var storeItemVO:StoreItemVO = _storeItems[i];
				
				var len2:int = _inventory.length;
				for (var j:int = 0; j < len2; j++) {
					
					var inventoryItem:StoreItemVO = _inventory[j];
					
					if(storeItemVO.itemType == inventoryItem.itemType){
				
						storeItemVO.quantity = inventoryItem.quantity;
					}
				}
			}
			
		}
		
		private function inventoryItemExists(itemVO:StoreItemVO):Boolean{
			
			var returnBool:Boolean = false;
			
			for (var i:int = 0; i < _inventory.length; i++) {
				
				var storeItemVO:StoreItemVO = _inventory[i];
				
				if(storeItemVO == itemVO){
					returnBool = true;
					break;
				}
			}
			
			return returnBool;
		}
		
		
		//================== GETTERS AND SETTERS ==================//
		
		public function get storeItems():Vector.<StoreItemVO> { return _storeItems; }
		public function get inventory():Vector.<StoreItemVO> { return _inventory; }
		public function get currencyAmount():int { return _model.currencyAmount; }
		
		
	}
}