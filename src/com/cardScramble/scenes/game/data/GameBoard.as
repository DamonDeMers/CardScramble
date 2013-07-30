package com.cardScramble.scenes.game.data
{
	import com.abacus.assetManager.AssetManager;
	import com.cardScramble.scenes.game.Card;
	import com.cardScramble.scenes.game.CardScrambleGame;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameBoard extends Sprite
	{
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//assets
		private var _cardContainer:Sprite
		
		//data
		public static var MOUSE_POINT:Point = new Point();
		private var _data:CardScrambleGameData;
		private var _cardsCopy:Array
		private var _prevCard:Card;
		private var _clickMode:Boolean = false;
		private var _heldCards:Vector.<CardVO> = new Vector.<CardVO>;
		
		
		public function GameBoard(data:CardScrambleGameData){
			_data = data;
			
			initAssets();
			activate();
		}

		
		
		//================== PUBLIC METHODS =================//
		
		public function newHand():void{
			
			//remove existing hand
			while(_cardContainer.numChildren > 0){
				_cardContainer.removeChildAt(0);
			}
			
			_cardsCopy = _data.cardNames.slice(0, _data.cardNames.length-1);
			var xVal:Number = 0;
			var yVal:Number = 0;
			var revealDelay:Number = 0;
			
			
			for (var i:int = 0; i < _data.NUM_CARDS_VERTICAL; i++) {
				
				for (var j:int = 0; j < _data.NUM_CARDS_HORIZONTAL; j++) {
					
					var ranNum:int = Math.random() * _cardsCopy.length;
					var cardString:String = _cardsCopy[ranNum];
					var gridPositionVO:GridPositionVO = new GridPositionVO;
					var cardVO:CardVO = new CardVO;
					
					cardVO.suit = cardString.charAt(0);
					cardVO.value = cardString.substr(1, cardString.length);
					cardVO.verticalPos = i;
					cardVO.horizontalPos = j;
					
					var card:Card = new Card(cardVO);
					
					card.x = xVal;
					card.y = yVal;
					
					//create grid data only once
					if(_data.gridData.length < 15){
						
						gridPositionVO.xVal = xVal;
						gridPositionVO.yVal = yVal;
						gridPositionVO.vertPosition = i;
						gridPositionVO.horzPosition = j;
						_data.gridData.push(gridPositionVO);
					}
					
					_cardContainer.addChild(card);	
					_data.cardDict[card] = cardVO;
					_cardsCopy.splice(ranNum, 1);
					
					xVal += card.cardWidth + 10;
					
					card.reveal(revealDelay);
					revealDelay += 0.1;
				}
				
				xVal = 0;
				yVal += card.cardHeight + 25;
			}
		}
		
		public function resetHand():void{
			
			var len:int = _cardContainer.numChildren;
			for (var i:int = 0; i < len; i++) {
				var card:Card = _cardContainer.getChildAt(i) as Card;
				card.unselected();
			}
		}
		
		public function activate():void{
			_cardContainer.addEventListener(TouchEvent.TOUCH, onCardTouch);
		}
		
		public function inactivate():void{
			_cardContainer.removeEventListener(TouchEvent.TOUCH, onCardTouch);
		}
		
		public function shuffleDeck():void{
			
			//randomize points
			var newVect:Vector.<GridPositionVO> = new Vector.<GridPositionVO>;
			var clone:Vector.<GridPositionVO> = _data.gridData.concat();
			
			while(clone.length > 0){
				var ranNum:int = Math.random() * clone.length;
				var gridPositionVO:GridPositionVO = clone[ranNum];
				
				newVect.push(gridPositionVO);
				clone.splice(ranNum, 1);
			}
			
			//tween card locations to new ponts
			var len:int = _cardContainer.numChildren;
			for (var i:int = 0; i < len; i++) {
				
				var card:Card = _cardContainer.getChildAt(i) as Card;
				var cardVO:CardVO = _data.cardDict[card];
				cardVO.verticalPos = newVect[i].vertPosition;
				cardVO.horizontalPos = newVect[i].horzPosition;
				TweenLite.to(card, 1, {x:newVect[i].xVal, y:newVect[i].yVal, ease:Expo.easeOut});
			}
		}
		
		public function holdThree():void{
			_clickMode = true;
		}
		
		
		
		
		//================== PRIVATE METHODS ==================//
		
		private function initAssets():void{
			_cardContainer = new Sprite();
			addChild(_cardContainer);
		}
		
		private function initListeners():void{
			_cardContainer.addEventListener(TouchEvent.TOUCH, onCardTouch);
		}
		
		private function shuffleAndKeep(heldCards:Vector.<CardVO>):void{
			
			var len:int = _cardContainer.numChildren;
			var revealDelay:Number = 0;
			for (var i:int = 0; i < len; i++) {
				
				//target card
				var card:Card = _cardContainer.getChildAt(i) as Card;
				var cardVO:CardVO = _data.cardDict[card];
				
				//determine if match
				var match:Boolean = false;
				var len2:int = heldCards.length;
				for (var j:int = 0; j < len2; j++) {
					
					if(heldCards[j] == cardVO){
						match = true;
						card.unselected();
					}
				}
				
				//replace cards
				if(!match){
					
					_cardContainer.removeChild(card);

					var ranNum:int = Math.random() * _cardsCopy.length;
					var cardString:String = _cardsCopy[ranNum];
					
					var newCardVO:CardVO = new CardVO;
					var newCard:Card = new Card(cardVO);
					
					newCardVO.suit = cardString.charAt(0);
					newCardVO.value = cardString.substr(1, cardString.length);
					newCardVO.verticalPos = _data.gridData[i].vertPosition;
					newCardVO.horizontalPos = _data.gridData[i].horzPosition;
					_data.cardDict[newCard] = newCardVO;
					
					newCard.x = _data.gridData[i].xVal;
					newCard.y = _data.gridData[i].yVal;
					
					_cardContainer.addChildAt(newCard, i);		
					_cardsCopy.splice(ranNum, 1);
					
					newCard.reveal(revealDelay);
					revealDelay += 0.1;
				}
				
				_clickMode = false;
			}
			
		}
		
		
		//================== EVENT HANDLERS ===================//
		
		private function onCardTouch(e:TouchEvent):void{
			
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(!_clickMode){
				if(touchMoved){
					
					MOUSE_POINT.x = touchMoved.globalX;
					MOUSE_POINT.y = touchMoved.globalY;
					
					var len:int = _cardContainer.numChildren;
					for (var j:int = 0; j < len; j++) {
						
						var card:Card = _cardContainer.getChildAt(j) as Card;
						
						if(card.cardImage.hitTest(card.globalToLocal(MOUSE_POINT)) && card.touchable){
							
							var cardVO:CardVO = _data.cardDict[card];
							
							card.touchable = false;
							card.selected();
							
							_data.cardSelected.push(cardVO);
							
							_assets.playSound(String("CardSelect" + _data.cardSelected.length), 0, 0, CardScrambleGame.ST_SOUND_FX);
							
							if(_data.cardSelected.length > 1){
								
								_prevCard.showConnector(cardVO);
								_cardContainer.setChildIndex(card, _cardContainer.numChildren-1);
								
								if(_data.cardSelected.length == 5){
									
									_data.selectionComplete();
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
					
					_assets.playSound("DropHand", 0, 0, CardScrambleGame.ST_SOUND_FX);
					_data.abortSelection();
				}
			} else {
				
				if(touchBegan){
					var cardTouchBegan:Card = Image(e.target).parent.parent as Card;
					var cardVOTouchBegan:CardVO = _data.cardDict[cardTouchBegan];
					
					cardTouchBegan.selected();
					_heldCards.push(cardVOTouchBegan);
					
					if(_heldCards.length == 3){
						shuffleAndKeep(_heldCards);
					}
				}
				
			}
			
		}
		
		
		
		//================== GETTERS AND SETTERS ===================//
		
		
	}
}