package com.cardScramble
{
	import com.abacus.assetManager.AssetManager;
	import com.cardScramble.data.CardVO;
	import com.greensock.TweenMax;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class View extends Sprite
	{
		
		[Embed(source="../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;	
		
		//assets
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//bg
		private var _bg:Image;
		
		//model
		private var _model:Model;
		
		//assets
		private var _cardContainer:Sprite = new Sprite();
		
		//text
		private var _timerText:TextField;
		private var _scoreText:TextField;
		private var _messageText:TextField;
		
		//data
		private static var _mousePoint:Point = new Point();
		
		public function View(){
			super();
		}
		
		public function init(model:Model, bgTexture:Texture):void{
			
			_model = model;
			_bg = new Image(bgTexture);
			addChild(_bg);
			
			initAssets();
			initListeners();
		}
		
		private function initAssets():void{
			
			newHand();
			
			//cards
			_cardContainer.x = 197;
			_cardContainer.y = 182;
			addChild(_cardContainer);
			
			//setup text
			var texture:Texture = Texture.fromBitmap(new FontTexture());
			var xml:XML = XML(new FontXml());
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
			
			//timer
			_timerText = new TextField(150, 50, "Time: 60", "JandaManateeSolid", 30, 0xFFFFFF);
			_timerText.fontName = "JandaManateeSolid";
			_timerText.x = 100;
			_timerText.y = 30;
			_timerText.scaleX = _timerText.scaleY = 1.5;
			_timerText.touchable = false;
			addChild(_timerText);
			
			//score
			_scoreText = new TextField(250, 50, "Score: 0", "JandaManateeSolid", 30, 0xFFFFFF);
			_scoreText.fontName = "JandaManateeSolid";
			_scoreText.x = 300;
			_scoreText.y = 30;
			_scoreText.scaleX = _scoreText.scaleY = 1.5;
			_scoreText.touchable = false;
			addChild(_scoreText);
			
			//message
			_messageText = new TextField(300, 50, "Message", "JandaManateeSolid", 30, 0xFFFFFF);
			_messageText.fontName = "JandaManateeSolid";
			_messageText.hAlign = HAlign.CENTER;
			_messageText.x = 150;
			_messageText.y = 250;
			_messageText.alpha = 0;
			_messageText.touchable = false;
			addChild(_messageText);
		}
		
		private function newHand():void{
			
			//remove existing hand
			while(_cardContainer.numChildren > 0){
				_cardContainer.removeChildAt(0);
			}
			
			var cardNameCopy:Array = _model.cardNames.slice(0, _model.cardNames.length-1);
			var xVal:Number = 0;
			var yVal:Number = 0;
			
			for (var i:int = 0; i < _model.NUM_CARDS_VERTICAL; i++) {
				
				for (var j:int = 0; j < _model.NUM_CARDS_HORIZONTAL; j++) {
					
					var ranNum:int = Math.random() * cardNameCopy.length;
					var cardString:String = cardNameCopy[ranNum];
					var cardVO:CardVO = new CardVO;
					var card:Card = new Card(cardString, cardVO);
					
					cardVO.suit = cardString.charAt(0);
					cardVO.value = cardString.substr(1, cardString.length);
					cardVO.verticalPos = i;
					cardVO.horizontalPos = j;

					_model.cardDict[card] = cardVO;
					
					card.x = xVal;
					card.y = yVal;
					card.scaleX = card.scaleY = 0.5;
					
					_cardContainer.addChild(card);
					cardNameCopy.splice(ranNum, 1);
					
					xVal += card.cardImage.width/2 + 10;
				}
				
				xVal = 0;
				yVal += card.cardImage.height/2 + 15;
			}
		}
		
		private function initListeners():void{
			_cardContainer.addEventListener(TouchEvent.TOUCH, onCardTouch);
			_model.addEventListener(Model.UPDATE, onModelUpdate);
		}

		
		
		
		//================== EVENT HANDLERS =====================//
		
		private function onCardTouch(e:TouchEvent):void{
			
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touchMoved){
				
				_mousePoint.x = touchMoved.globalX;
				_mousePoint.y = touchMoved.globalY;

				var len:int = _cardContainer.numChildren;
				for (var j:int = 0; j < len; j++) {
					
					var card:Card = _cardContainer.getChildAt(j) as Card;
					
					if(card.hitTest(card.globalToLocal(_mousePoint)) && card.touchable){
						
						var cardVO:CardVO = _model.cardDict[card];
						card.touchable = false;
						card.selected();
						
						_model.cardSelected.push(cardVO);
						
						if(_model.cardSelected.length == 5){
							_model.selectionComplete();
							_cardContainer.flatten();
						}
					}	
				}
				
			}
			
			if(touchEnded){
				
				var lenEnd:int = _cardContainer.numChildren;
				for (var i:int = 0; i < lenEnd; i++){
					var targetCard:Card = _cardContainer.getChildAt(i) as Card;
					
					targetCard.unselected();
				}
				
				_model.abortSelection();
				_cardContainer.unflatten();
			}
			
		}	
		
		
		
		private function onModelUpdate(e:Event):void{
			
			switch(e.data.type){
				
				case Model.TIMER_UPDATE:
					_timerText.text = String("Time: " + e.data.time);
					break;
				
				case Model.TIMER_COMPLETE:
					
					break;
				
				case Model.SCORE_CHANGE:
					_messageText.text = String(e.data.hand + " +" + e.data.score);
					_scoreText.text = String("Score: " + _model.score);
					TweenMax.to(_messageText, 0.5, {alpha:1, scaleX:2, scaleY:2, yoyo:true, repeat:1});
					break;
				
			}	
		}
		
		
		
	}
}