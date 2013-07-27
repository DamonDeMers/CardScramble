package com.cardScramble.scenes.game
{
	import com.abacus.assetManager.AssetManager;
	import com.cardScramble.scenes.game.data.CardVO;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	
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
		private var _selectedBool:Boolean = false;
		
		//assets
		private var _cardImage:Image;
		private var _cardBack:Image;
		private var _connectorContainer:Sprite;
		
		
		public function Card(cardType:String, cardVO:CardVO){
			
			_data = cardVO;
			
			_connectorContainer = new Sprite();
			_connectorContainer.touchable = false;
			addChild(_connectorContainer);
			
			_cardImage = new Image(_assets.getTexture(cardType));
			_cardImage.visible = false;
			addChild(_cardImage);
			
			_cardBack = new Image(_assets.getTexture("cardBack"));
			addChild(_cardBack);
			
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
				
				c.pivotY = -c.height/3;
				c.name = String(i);
				c.visible = false;
				_connectorContainer.addChild(c);
				
				angle = step * i;
				c.x = center.x + Math.cos( angle ) * radius;
				c.y = center.y + Math.sin( angle ) * radius;
				c.rotation =  deg2rad(angle * 180 / Math.PI);
			}
		}
		
		private function removeAllConnectors():void{
			
			var len:int = _connectorContainer.numChildren;
			for (var i:int = 0; i < len; i++) {
				var c:Image = _connectorContainer.getChildAt(i) as Image;
				
				c.visible = false;				
			}
		}
		
		
		//============== PUBLIC METHODS =================//
	

		public function selected():void{
			
			this.touchable = false;
			_selectedBool = true;
			
			TweenMax.to(this, 0.5, {scaleX:1.025, scaleY:1.025, yoyo:true, repeat:-1, ease:Quad.easeInOut});
			
			this.filter = null;
			this.filter = BlurFilter.createGlow(0xFFFFFF, 1, 1, 0.25);
		}
		
		public function unselected():void{
			
			this.touchable = true;
			_selectedBool = false;
			
			TweenLite.to(this, 0.5, {scaleX:1, scaleY:1, ease:Expo.easeIn});
			removeAllConnectors();
			
			this.filter = null;
			this.filter = BlurFilter.createDropShadow();
		}
		
		public function reveal(delay:Number = 0.1):void{
			
			var cardOrigX:Number = _cardImage.x;
			
			_cardImage.x += _cardImage.width/2;
			_cardImage.scaleX = 0;
			TweenLite.to(_cardBack, 0.1, {delay:delay, x:_cardBack.x + _cardBack.width/2, scaleX:0, onStart:onRevealStart, onComplete:onRevealComplete, onCompleteParams:[cardOrigX]});
		}
		
		private function onRevealStart():void{
			_assets.playSound("CardFlip", 0, 0, CardScrambleGame.ST_SOUND_FX);
		}
		
		private function onRevealComplete(origX:Number):void{
			_cardBack.visible = false;
			_cardImage.visible = true;
			TweenLite.to(_cardImage, 0.1, {x:origX, scaleX:1});
		}
		
		public function showConnector(prevCardVO:CardVO):void{
			
			var vertDiff:int = prevCardVO.verticalPos - _data.verticalPos;
			var horzDiff:int = prevCardVO.horizontalPos - _data.horizontalPos;
			
			trace("vertDiff: " + vertDiff + " horzDif " + horzDiff);
			
			var connector:Image;
			
			if(vertDiff == -1 && horzDiff == 0){
				connector = _connectorContainer.getChildAt(4) as Image;
				connector.visible = true;
			}
			else if (vertDiff == -1 && horzDiff == 1) {
				connector = _connectorContainer.getChildAt(5) as Image;
				connector.visible = true;
			}
			else if (vertDiff == 0 && horzDiff == 1){
				connector = _connectorContainer.getChildAt(6) as Image;
				connector.visible = true;
			}
			else if (vertDiff == 1 && horzDiff == 1){
				connector = _connectorContainer.getChildAt(7) as Image;
				connector.visible = true;
			}
			else if (vertDiff == 1 && horzDiff == 0){
				connector = _connectorContainer.getChildAt(0) as Image;
				connector.visible = true;
			}
			else if (vertDiff == 1 && horzDiff == -1){
				connector = _connectorContainer.getChildAt(1) as Image;
				connector.visible = true;
			}
			else if (vertDiff == 0 && horzDiff == -1){
				connector = _connectorContainer.getChildAt(2) as Image;
				connector.visible = true;
			}
			else if (vertDiff == -1 && horzDiff == -1){
				connector = _connectorContainer.getChildAt(3) as Image;
				connector.visible = true;
			}
			
		}
		
		
		
		
		//============== GETTERS AND SETTERS =================//
		
		public function get cardImage():Image { return _cardImage; }
		public function get selectedBool():Boolean { return _selectedBool; }
		
	}
}