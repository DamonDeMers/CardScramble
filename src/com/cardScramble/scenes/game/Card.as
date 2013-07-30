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
		//const
		private const VERTICAL_PADDING:int = 15;
		private const HORIZONTAL_PADDING:int = 15;
		private const FULL_SCALE:Number = 0.8;
		
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//data
		private var _data:CardVO;
		private var _selectedBool:Boolean = false;
		
		//assets
		private var _card:Sprite;
		private var _cardBg:Image;
		private var _cardSelectOutline:Image;
		private var _cardValTop:Image;
		private var _cardValBottom:Image;
		private var _cardSuit:Image;
		private var _cardDropShadow:Image;
		private var _cardBack:Image;
		private var _connectorContainer:Sprite;
		
		
		
		public function Card(cardVO:CardVO){
			
			_data = cardVO;
			
			_connectorContainer = new Sprite();
			_connectorContainer.touchable = false;
			addChild(_connectorContainer);
			
			_card = new Sprite();
			addChild(_card);
			
			//drop shadow
			_cardDropShadow = new Image(_assets.getTexture("cardShadow"));
			_card.addChild(_cardDropShadow);
			
			//bg
			_cardBg = new Image(_assets.getTexture("card"));
			_card.addChild(_cardBg);
			
			//val top
			_cardValTop = new Image(_assets.getTexture(getCardValue()));
			_cardValTop.x = HORIZONTAL_PADDING;
			_cardValTop.y = VERTICAL_PADDING;
			_cardValTop.touchable = false;
			_card.addChild(_cardValTop);
			
			//val bottom
			_cardValBottom = new Image(_assets.getTexture(getCardValue()));
			_cardValBottom.x = _cardBg.width - _cardValBottom.width - HORIZONTAL_PADDING;
			_cardValBottom.y = _cardBg.height - _cardValBottom.height - VERTICAL_PADDING;
			_cardValBottom.touchable = false;
			_card.addChild(_cardValBottom);
			
			//val top
			_cardSuit = new Image(_assets.getTexture(getCardSuit()));
			_cardSuit.pivotX = _cardSuit.width/2;
			_cardSuit.pivotY = _cardSuit.height/2;
			_cardSuit.x = _cardBg.width/2;
			_cardSuit.y = _cardBg.height/2;
			_cardSuit.touchable = false;
			_card.addChild(_cardSuit);	
			
			//select outline
			_cardSelectOutline = new Image(_assets.getTexture("cardSelectOutline"));
			_cardSelectOutline.visible = false;
			_card.addChild(_cardSelectOutline);
			
			//back of card
			_cardBack = new Image(_assets.getTexture("cardBack"));
			addChild(_cardBack);
			
			addConnectors();
			
			this.pivotX = _card.width/2;
			this.pivotY = _card.height/2;
			
			this.scaleX = this.scaleY = FULL_SCALE;
		}
		

		private function addConnectors():void{
			
			var count:int = 8;
			var step:Number =  ( Math.PI * 2 / count );
			var angle:Number = 45;
			var center:Point = new Point(_card.width/2, _card.height/2);
			var radius:Number = -3;
			
			for (var i:int = 0; i < count; i++ ){
				
				var c:Image = new Image(_assets.getTexture("connector"));
				
				c.pivotY = -c.height/6;
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
		
		private function getCardValue():String{
			
			return (_data.value.toUpperCase()) + ((_data.suit == "d" || _data.suit == "h") ? "R" : "B");
		}
		
		private function getCardSuit():String{
			
			var cardSuit:String;
			
			switch(_data.suit){
				case "s":
					cardSuit = "spade";
					break;
				case "c":
					cardSuit = "club";
					break;
				case "d":
					cardSuit = "diamond";
					break;
				case "h":
					cardSuit = "heart";
					break;
			}
			
			return cardSuit;
		}
		
		
		
		//============== PUBLIC METHODS =================//
	

		public function selected():void{
			
			this.touchable = false;
			_selectedBool = true;
			
			TweenMax.to(this, 0.5, {scaleX:FULL_SCALE + 0.025, scaleY:FULL_SCALE + 0.025, yoyo:true, repeat:-1, ease:Quad.easeInOut});
			
			this.filter = null;
			this.filter = BlurFilter.createGlow(0xFFFFFF, 1, 1, 0.25);
		}
		
		public function unselected():void{
			
			this.touchable = true;
			_selectedBool = false;
			
			TweenLite.to(this, 0.5, {scaleX:FULL_SCALE, scaleY:FULL_SCALE, ease:Expo.easeIn});
			removeAllConnectors();
			
			this.filter = null;
		}
		
		public function reveal(delay:Number = 0.1):void{
			
			var cardOrigX:Number = _card.x;
			
			_card.x += _card.width/2;
			_card.scaleX = 0;
			TweenLite.to(_cardBack, 0.1, {delay:delay, x:_cardBack.x + _cardBack.width/2, scaleX:0, onStart:onRevealStart, onComplete:onRevealComplete, onCompleteParams:[cardOrigX]});
			
			function onRevealStart():void{
				_assets.playSound("CardFlip", 0, 0, CardScrambleGame.ST_SOUND_FX);
			}
			
			function onRevealComplete(origX:Number):void{
				_cardBack.visible = false;
				_card.visible = true;
				TweenLite.to(_card, 0.1, {x:origX, scaleX:1});
			}
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
		
		public function get cardWidth():Number { return _cardBg.width * FULL_SCALE; }
		public function get cardHeight():Number { return _cardBg.height * FULL_SCALE; }
		public function get cardImage():Image { return _cardBg }
		public function get selectedBool():Boolean { return _selectedBool; }
		
	}
}