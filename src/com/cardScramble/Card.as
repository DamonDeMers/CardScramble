package com.cardScramble
{
	import com.abacus.assetManager.AssetManager;
	import com.cardScramble.data.CardVO;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.utils.deg2rad;
	
	public class Card extends Sprite
	{
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//data
		private var _data:CardVO;
		
		//assets
		private var _cardImage:Image;
		private var _connectorContainer:Sprite;
		
		
		public function Card(cardType:String, cardVO:CardVO){
			
			_cardImage = new Image(_assets.getTexture(cardType));
			addChild(_cardImage);
			
			_connectorContainer = new Sprite();
			_connectorContainer.touchable = false;
			addChild(_connectorContainer);
			addConnectors();
			
			this.pivotX = _cardImage.width/2;
			this.pivotY = _cardImage.height/2;
			
			this.filter = BlurFilter.createDropShadow();
		}
		
		private function addConnectors():void{
			
			var count:int = 8;
			var step:Number =  ( Math.PI * 2 / count );
			var angle:Number = 45;
			var center:Point = new Point(_cardImage.width/2, _cardImage.height/2);
			var radius:Number = -3;
			
			for (var i:int = 0; i < count; i++ ){
				
				var c:Image = new Image(_assets.getTexture("connector"));
				c.pivotY = -c.height;
				c.name = String(i);
				_connectorContainer.addChild( c );
				
				angle = step * i;
				c.x = center.x + Math.cos( angle ) * radius;
				c.y = center.y + Math.sin( angle ) * radius;
				c.rotation =  deg2rad(angle * 180 / Math.PI);
			}
			
		}
		
		
		
		//============== PUBLIC METHODS =================//
	

		public function selected():void{
			
			this.touchable = false;
			
			TweenLite.to(this, 0.5, {scaleX:0.55, scaleY:0.55, ease:Expo.easeOut});
			
			this.filter = null;
			this.filter = BlurFilter.createGlow();
		}
		
		public function unselected():void{
			
			this.touchable = true;
			
			TweenLite.to(this, 0.5, {scaleX:0.5, scaleY:0.5, ease:Expo.easeIn});
			
			this.filter = null;
			this.filter = BlurFilter.createDropShadow();
		}
		
		
		
		//============== GETTERS AND SETTERS =================//
		
		public function get cardImage():Image { return _cardImage; }
		
	}
}