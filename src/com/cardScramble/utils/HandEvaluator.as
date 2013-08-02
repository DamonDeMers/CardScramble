package com.cardScramble.utils {
	
	import com.cardScramble.scenes.game.data.CardVO;
	import com.cardScramble.scenes.game.data.HandVO;
	
	public class HandEvaluator {
		
		public static const ACE:String = "A";
		private static var _instance:HandEvaluator = new HandEvaluator();
		
		private var _cardsSelected:Vector.<CardVO>;
		private var _handCheckFunctions:Array = [pair, twoPair, threeOfAKind, straight, flush, fullHouse, fourOfAKind, straightFlush, royalFlush];
		private var _hands:Vector.<HandVO> = new Vector.<HandVO>;
		private var _winningHand:HandVO;
		
		public function HandEvaluator() {
			
			if(_instance) {
				throw new Error("Singleton Class: Use getInstance");
			}
		}
		
		public static function getInstance():HandEvaluator {
			return _instance;
		}
		
		/**
		 * Evaluates 5 cards for all possible valid poker hands and returns winning hand as HandVO
		 */
		public function evaluate(cards:Vector.<CardVO>):HandVO {
			
			_cardsSelected = cards.slice();
			
			var i:int;
			var handVO:HandVO;
			var cardVO:CardVO;
			
			for(i = 0; i < _handCheckFunctions.length; i++) {
				handVO = _handCheckFunctions[i]();
			}
			
			_winningHand = CardSortUtils.getHighestHand(_hands);
			_winningHand.highCardSelected = _cardsSelected[_cardsSelected.length - 1];
			
			for each(cardVO in _cardsSelected){
				if(_winningHand.cards.indexOf(cardVO) == -1){
					_winningHand.extraCards.push(cardVO);
				}
			}
			
			//			check(_winningHand);
			
			//cleanup
			_hands.length = 0;
			_cardsSelected.length = 0;
			
			return _winningHand;
		}
		
		private var invalidHands:int =0;
		
		private function check(handVO:HandVO):void {
			var highestCard:CardVO = handVO.highCardSelected;
			var i:int;
			var k:int;
			var handVO:HandVO;
			var handName:String;
			var error:String = "";
			var cardVO:CardVO;
			var value:int;
			var suit:int;
			var matchingCards:Vector.<CardVO>;
			var cards:Vector.<CardVO> = handVO.cards.slice();
			
			if(handVO.valid) {
				handName = HandLookup.handToString(handVO.hand);
				switch(handName) {
					
					case HandLookup.PAIR:
						if(cards.length != 2) {
							reportError(handVO, cards.length + " cards in hand");
							break;
						} else {
							matchingCards = findMatchingValues(cards.shift(), cards);
							if(matchingCards.length != 2) {
								reportError(handVO, matchingCards.length + " cards match");
							}
						}
						break;
					
					case HandLookup.TWO_PAIR:
						if(cards.length != 4) {
							reportError(handVO, cards.length + " significant cards in hand");
							break;
						} else {
							matchingCards = findMatchingValues(cards.shift(), cards);
							if(matchingCards.length != 2) {
								reportError(handVO, matchingCards.length + " cards match in 1st pair");
							}
							matchingCards = findMatchingValues(cards.shift(), cards);
							if(matchingCards.length != 2) {
								reportError(handVO, matchingCards.length + " cards match in 2nd pair");
							}
						}
						break;
					
					case HandLookup.THREE_OF_A_KIND:
						if(cards.length != 3) {
							reportError(handVO, cards.length + " significant cards in hand");
							break;
						} else {
							matchingCards = findMatchingValues(cards.shift(), cards);
							if(matchingCards.length != 3) {
								reportError(handVO, matchingCards.length + " cards match");
							}
						}
						break;
					
					case HandLookup.STRAIGHT:
						if(cards.length != 5) {
							reportError(handVO, cards.length + " significant cards in hand");
							break;
						}
						if(!isStraight(cards)) {
							reportError(handVO, "not straight");
						}
						break;
					
					case HandLookup.FLUSH:
						if(cards.length != 5) {
							reportError(handVO, cards.length + " significant cards in hand");
							break;
						}
						if(!isSameSuit(cards)) {
							reportError(handVO, "not same suit");
						}
						break;
					
					case HandLookup.FULL_HOUSE:
						if(cards.length != 5) {
							reportError(handVO, cards.length + " significant cards in hand");
							break;
						}
						matchingCards = findMatchingValues(cards.shift(), cards);
						var matched:int = matchingCards.length;
						if(matched != 2 || matched != 3) {
							reportError(handVO, matched + " cards match");
						} else {
							matchingCards = findMatchingValues(cards.shift(), cards);
							if(matched == 2) {
								if(matchingCards.length != 3) {
									reportError(handVO, matched + " cards match in other 3");
								}
							} else {
								if(matchingCards.length != 2) {
									reportError(handVO, matched + " cards match in other 2");
								}
							}
						}
						break;
					
					case HandLookup.FOUR_OF_A_KIND:
						if(cards.length != 4) {
							reportError(handVO, cards.length + " significant cards in hand");
							break;
						}
						matchingCards = findMatchingValues(cards.shift(), cards);
						if(matchingCards.length != 4) {
							reportError(handVO, matchingCards.length + " cards match");
						}
						
						break;
					
					case HandLookup.STRAIGHT_FLUSH:
						if(cards.length != 5) {
							reportError(handVO, cards.length + " significant cards in hand");
							break;
						}
						if(!isStraight(cards)) {
							reportError(handVO, "not straight");
						}
						if(!isSameSuit(cards)) {
							reportError(handVO, "not same suit");
						}
						break;
					
					case HandLookup.ROYAL_FLUSH:
						if(cards.length != 5) {
							reportError(handVO, cards.length + " significant cards in hand");
							break;
						}
						if(!isStraight(cards)) {
							reportError(handVO, "not straight");
						}
						if(!isSameSuit(cards)) {
							reportError(handVO, "not same suit");
						}
						if(int(cards[0].value) != 10){
							reportError(handVO, "not royal flush");
						}
						break;
					
				}
			}else{
				invalidHands++;
			}
		}
		
		private function reportError(handVO:HandVO, error:String):void {
			var cardsInHand:Array = [];
			for each(var cardVO:CardVO in handVO) {
				cardsInHand.push(cardVO.value + cardVO.suit);
			}
			trace(HandLookup.handToString(handVO.hand), cardsInHand.join(), "error", error);
		}
		
		private function isStraight(cards:Vector.<CardVO>):Boolean {
			cards.sort(valueLowToHigh);
			var success:Boolean = true;
			var cardVO:CardVO = cards.shift();
			var value:int = int(cardVO.value);
			for(var i:int = 1; i < cards.length; i++) {
				cardVO = cards[i]
				if(int(cardVO.value) != value + i) {
					success = false;
					break;
				}
			}
			return success;
		}
		
		private function isSameSuit(cards:Vector.<CardVO>):Boolean {
			var success:Boolean = true;
			var cardVO:CardVO = cards.shift();
			var suit:int = CardSortUtils.SUIT_ORDER.indexOf(cardVO.suit);
			for(var i:int = 1; i < cards.length; i++) {
				cardVO = cards[i]
				if(CardSortUtils.SUIT_ORDER.indexOf(cardVO.suit) != suit) {
					success = false;
					break;
				}
			}
			return success;
		}
		
		private function valueLowToHigh(a:CardVO, b:CardVO):int {
			if(CardSortUtils.VALUE_ORDER.indexOf(a.value) < CardSortUtils.VALUE_ORDER.indexOf(b.value)) {
				return -1;
			} else if(CardSortUtils.VALUE_ORDER.indexOf(a.value) > CardSortUtils.VALUE_ORDER.indexOf(b.value)) {
				return 1;
			} else {
				return 0
			}
		}
		
		private function suitLowToHigh(a:CardVO, b:CardVO):int {
			if(CardSortUtils.SUIT_ORDER.indexOf(a.suit) < CardSortUtils.SUIT_ORDER.indexOf(b.suit)) {
				return -1;
			} else if(CardSortUtils.SUIT_ORDER.indexOf(a.suit) > CardSortUtils.SUIT_ORDER.indexOf(b.suit)) {
				return 1;
			} else {
				return 0
			}
		}
		
		private function transferCardFromTo(cardVO:CardVO, from:Vector.<CardVO>, to:Vector.<CardVO>):void {
			to.push(from.slice(from.indexOf(cardVO), 1));
		}
		
		private function findMatchingValues(cardVO:CardVO, cardsToSearch:Vector.<CardVO>):Vector.<CardVO> {
			var success:Boolean = true;
			var matchingCards:Vector.<CardVO>;
			matchingCards.push(cardVO);
			while(cardVO = cardsToSearch.shift()) {
				if(cardVO.value == matchingCards[0].value) {
					transferCardFromTo(cardVO, cardsToSearch, matchingCards);
				}
			}
			return matchingCards;
		}
		
		//************** HAND ALGOS *****************//
		
		private function pair():HandVO {
			
			var handVO:HandVO = new HandVO();
			
			var len:int = _cardsSelected.length;
			for(var i:int = 0; i < len; i++) {
				
				var cardVO:CardVO = _cardsSelected[i] as CardVO;
				
				var len2:int = _cardsSelected.length;
				for(var j:int = 0; j < len2; j++) {
					
					var cardVO2:CardVO = _cardsSelected[j] as CardVO;
					
					if(cardVO.value == cardVO2.value && cardVO != cardVO2) {
						handVO.valid = true;
						handVO.hand = HandLookup.PAIR;
						handVO.cards.push(cardVO, cardVO2);
						_hands.push(handVO);
						report("Test Hand: " + HandLookup.handToString(HandLookup.PAIR) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
						return handVO;
					}
				}
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.PAIR) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			return handVO;
		}
		
		private function twoPair():HandVO {
			var handVO:HandVO = new HandVO();
			var cardsSelectedCopy:Vector.<CardVO> = CardSortUtils.copyVect(_cardsSelected);
			var matchCount:int = 0;
			
			for(var i:int = 0; i < 5; i++) {
				if(!cardsSelectedCopy[i])
					continue;
				
				var cardVO:CardVO = cardsSelectedCopy[i] as CardVO;
				
				for(var j:int = 0; j < 5; j++) {
					if(!cardsSelectedCopy[j])
						continue;
					
					var cardVO2:CardVO = cardsSelectedCopy[j] as CardVO;
					
					if(cardVO.value == cardVO2.value && cardVO != cardVO2) {
						matchCount++;
						
						handVO.cards.push(cardVO, cardVO2);
						
						if(matchCount == 1) {
							cardsSelectedCopy[cardsSelectedCopy.indexOf(cardVO)] = null;
							cardsSelectedCopy[cardsSelectedCopy.indexOf(cardVO2)] = null;
							break;
						} else if(matchCount == 2) {
							handVO.valid = true;
							handVO.hand = HandLookup.TWO_PAIR;
							_hands.push(handVO);
							report("Test Hand: " + HandLookup.handToString(HandLookup.TWO_PAIR) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
							
							return handVO;
						}
					}
				}
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.TWO_PAIR) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			
			return handVO;
		}
		
		private function threeOfAKind():HandVO {
			
			var handVO:HandVO = new HandVO();
			
			var len:int = _cardsSelected.length;
			for(var i:int = 0; i < len; i++) {
				
				var cardVO:CardVO = _cardsSelected[i] as CardVO;
				var matchCount:int = 0;
				
				var len2:int = _cardsSelected.length;
				for(var j:int = 0; j < _cardsSelected.length; j++) {
					
					var cardVO2:CardVO = _cardsSelected[j] as CardVO;
					
					if(cardVO.value == cardVO2.value && cardVO != cardVO2) {
						matchCount++
							handVO.cards.push(cardVO2);
					}
				}
				
				if(matchCount >= 2) {
					_hands.push(handVO);
					handVO.valid = true;
					handVO.hand = HandLookup.THREE_OF_A_KIND;
					
					report("Test Hand: " + HandLookup.handToString(HandLookup.THREE_OF_A_KIND) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
					
					return handVO;
					
				} else {
					
					handVO.cards.length = 0;
				}
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.THREE_OF_A_KIND) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			
			return handVO;
		}
		
		private function straight():HandVO {
			
			var handVO:HandVO = new HandVO();
			var firstCard:CardVO = _cardsSelected[0];
			var valueIndex:int = CardSortUtils.VALUE_ORDER.indexOf(firstCard.value);
			var matchCount:int = 0;
			
			for(var i:int = 0; i < _cardsSelected.length; i++) {
				
				var cardVO:CardVO = _cardsSelected[i] as CardVO;
				
				if(cardVO.value == CardSortUtils.VALUE_ORDER[(valueIndex + i)]) {
					handVO.cards.push(cardVO);
					matchCount++;
				}
				
				if(matchCount == 5) {
					handVO.valid = true;
					handVO.hand = HandLookup.STRAIGHT;
				}
				
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.STRAIGHT) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			
			return handVO;
		}
		
		private function flush():HandVO {
			
			var handVO:HandVO = new HandVO();
			var suit:String = _cardsSelected[0].suit;
			var matchCount:int = 0;
			
			for(var i:int = 0; i < _cardsSelected.length; i++) {
				
				var cardVO:CardVO = _cardsSelected[i] as CardVO;
				
				if(cardVO.suit == suit) {
					handVO.cards.push(cardVO);
					matchCount++;
				}
				
				if(matchCount == 5) {
					handVO.valid = true;
					handVO.hand = HandLookup.FLUSH;
				}
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.FLUSH) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			
			return handVO;
		}
		
		private function fullHouse():HandVO {
			
			var handVO:HandVO = new HandVO();
			var twoPairVO:HandVO = null;
			var threeOfAKindVO:HandVO = null;
			
			var len:int = _hands.length;
			for(var i:int = 0; i < len; i++) {
				
				var hand:HandVO = _hands[i];
				
				hand.hand == HandLookup.TWO_PAIR ? twoPairVO = hand : null;
				hand.hand == HandLookup.THREE_OF_A_KIND ? threeOfAKindVO = hand : null;
			}
			
			if(twoPairVO != null && threeOfAKindVO != null) {
				
				handVO.valid = true;
				handVO.hand = HandLookup.FULL_HOUSE;
				
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.FULL_HOUSE) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			
			return handVO;
		}
		
		private function fourOfAKind():HandVO {
			
			var handVO:HandVO = new HandVO();
			var cardsSelectedCopy:Vector.<CardVO> = CardSortUtils.copyVect(_cardsSelected);
			var matchCount:int = 0;
			
			for(var i:int = 0; i < cardsSelectedCopy.length; i++) {
				
				var cardVO:CardVO = cardsSelectedCopy[i] as CardVO;
				
				for(var j:int = 0; j < cardsSelectedCopy.length; j++) {
					
					var cardVO2:CardVO = cardsSelectedCopy[j] as CardVO;
					
					if(cardVO.value == cardVO2.value && cardVO != cardVO2) {
						
						handVO.cards.push(cardVO);
						cardsSelectedCopy.splice(cardsSelectedCopy.indexOf(cardVO), 1);
						matchCount++
						
						if(matchCount == 4) {
							handVO.valid = true;
							handVO.hand = HandLookup.FOUR_OF_A_KIND;
							break;
						}
					}
				}
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.FOUR_OF_A_KIND) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			
			return handVO;
		}
		
		private function straightFlush():HandVO {
			
			var handVO:HandVO = new HandVO();
			var straight:Boolean = false;
			var flush:Boolean = false;
			
			var len:int = _hands.length;
			for(var i:int = 0; i < len; i++) {
				
				var hand:HandVO = _hands[i];
				
				hand.hand == HandLookup.STRAIGHT ? straight = true : null;
				hand.hand == HandLookup.FLUSH ? flush = true : null;
				
				//note: Not pushing cards into array here...not sure it matters
			}
			
			if(straight && flush) {
				handVO.valid = true;
				handVO.hand = HandLookup.STRAIGHT_FLUSH;
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.STRAIGHT_FLUSH) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			
			return handVO;
		}
		
		private function royalFlush():HandVO {
			
			var handVO:HandVO = new HandVO();
			var straightFlush:Boolean = false;
			
			var len:int = _hands.length;
			for(var i:int = 0; i < len; i++) {
				
				var hand:HandVO = _hands[i];
				
				hand.hand == HandLookup.STRAIGHT_FLUSH ? straightFlush = true : null;
			}
			
			if(straightFlush && _cardsSelected[_cardsSelected.length - 1].value == ACE) {
				handVO.valid = true;
				handVO.hand = HandLookup.ROYAL_FLUSH;
			}
			
			_hands.push(handVO);
			report("Test Hand: " + HandLookup.handToString(HandLookup.ROYAL_FLUSH) + " ~~ Valid? " + handVO.valid + " ~~ Num Cards Stored " + handVO.cards.length);
			
			return handVO;
		}
		
		private function report(msg:String):void {
			//			trace(msg);
		}
		
	}
}


