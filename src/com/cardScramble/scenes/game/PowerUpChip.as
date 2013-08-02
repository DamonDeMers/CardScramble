package com.cardScramble.scenes.game
{
	import com.abacus.assetManager.AssetManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class PowerUpChip extends Sprite{
		
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//assets
		private var _chipImage:Image;
		private var _quantityCountText:TextField;
		
		//data
		private var _quantity:int;
		
		public function PowerUpChip(type:String){
			
			_chipImage = new Image(_assets.getTexture(type));
			
			_chipImage.pivotX = _chipImage.pivotY = _chipImage.width/2;
			_chipImage.filter = BlurFilter.createDropShadow(5, 0.785, 0x0, 0.75);
			addChild(_chipImage);
			
			//message 1
			_quantityCountText = new TextField(50, 50, "1", "JandaManateeSolid", 30, 0xFFFFFF);
			_quantityCountText.fontName = "JandaManateeSolid";
			_quantityCountText.hAlign = HAlign.CENTER;
			_quantityCountText.x = -70;
			_quantityCountText.y = -70;
			_quantityCountText.touchable = false;
			addChild(_quantityCountText);
			
		}
		
		public function updateQuantity(quantity:int):void{
			
			_quantity = quantity;
			
			if(quantity > 1){
				_quantityCountText.visible = true;
				_quantityCountText.text = String(quantity);
			} else {
				_quantityCountText.visible = false;
			}
		}
		
		
		//=============== GETTERS AND SETTERS =====================//
		
		public function get quantity():int
		{
			return _quantity;
		}

		
		
	}
}