package com.cardScramble.view
{
	import com.abacus.assetManager.AssetManager;
	import com.cardScramble.data.CardVO;
	import com.cardScramble.data.Model;
	
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
	
	public class View extends Sprite
	{
		
		[Embed(source="../../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;	
		
		
		//singletons
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//bg
		private var _bg:Image;
		
		//model
		private var _model:Model;
		
		//assets
		private var _cardContainer:Sprite = new Sprite();
		private var _rewardSequencer:RewardSequencer;
		
		//text
		private var _timerText:TextField;
		private var _scoreText:TextField;
		
		//data
		private static var _mousePoint:Point = new Point();
		private var _prevCard:Card;
		
		
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
			_cardContainer.x = 180;
			_cardContainer.y = 168;
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
			
			//reward sequencer
			_rewardSequencer = new RewardSequencer();
			addChild(_rewardSequencer);
		}
		
		private function newHand():void{
			
			//remove existing hand
			while(_cardContainer.numChildren > 0){
				_cardContainer.removeChildAt(0);
			}
			
			var cardNameCopy:Array = _model.cardNames.slice(0, _model.cardNames.length-1);
			var xVal:Number = 0;
			var yVal:Number = 0;
			var revealDelay:Number = 0;
			
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
			
					_cardContainer.addChild(card);		
					cardNameCopy.splice(ranNum, 1);
					
					xVal += card.cardImage.width + 20;
					
					card.reveal(revealDelay);
					revealDelay += 0.1;
				}
				
				xVal = 0;
				yVal += card.cardImage.height + 25;
			}
		}
		
		private function resetHand():void{
			
			var len:int = _cardContainer.numChildren;
			for (var i:int = 0; i < len; i++) {
				var card:Card = _cardContainer.getChildAt(i) as Card;
				card.unselected();
			}
			
		}
		
		private function initListeners():void{
			_cardContainer.addEventListener(TouchEvent.TOUCH, onCardTouch);
			_model.addEventListener(Model.UPDATE, onModelUpdate);
			_rewardSequencer.addEventListener(RewardSequencer.SEQUENCE_COMPLETE, onSequenceComplete);
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
					
					if(card.cardImage.hitTest(card.globalToLocal(_mousePoint)) && card.touchable){
						
						var cardVO:CardVO = _model.cardDict[card];
						
						card.touchable = false;
						card.selected();
						
						_model.cardSelected.push(cardVO);
						
						if(_model.cardSelected.length > 1){
							
							_prevCard.showConnector(cardVO);
							_cardContainer.setChildIndex(card, _cardContainer.numChildren-1);
							
							if(_model.cardSelected.length == 5){
								
								_model.selectionComplete();
							}
						}
						
						_prevCard = card;
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
			}
		}	
		
		
		private function onModelUpdate(e:Event):void{
			
			switch(e.data.type){
				
				case Model.TIMER_UPDATE:
					_timerText.text = String("Time: " + e.data.time);
					break;
				
				case Model.TIMER_COMPLETE:
					
					break;
				
				case Model.ROUND_COMPLETE:
					_cardContainer.removeEventListener(TouchEvent.TOUCH, onCardTouch);
					_rewardSequencer.createSequence(e.data, _mousePoint);
					break;
				
				case Model.UPDATE_SCORE:
					_scoreText.text = String("Score: " + e.data.score);
					break;
				
			}	
		}
		
		private function onSequenceComplete(e:Event):void{
			
			_model.MODE == 1 ? newHand() : resetHand();
			_cardContainer.addEventListener(TouchEvent.TOUCH, onCardTouch);
		}
		
		
	}
}