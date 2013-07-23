package com.cardScramble.utils {
	
	import com.cardScramble.data.CardVO;
	import com.cardScramble.data.HandVO;
	
	public class HandEvaluator {
		public static const ACE:String = "A";
		private static var _instance:HandEvaluator = new HandEvaluator();
		
		private var _cardsSelected:Vector.<CardVO>;
		private var _handCheckFunctions:Array = [pair, twoPair, threeOfAKind, straight, flush, fullHouse, fourOfAKind, straightFlush, royalFlush];
		private var _hands:Vector.<HandVO> = new Vector.<HandVO>;
		private var _winningHand:HandVO;
		
		
		public function HandEvaluator() {
			
			if (_instance) {
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
			
			_cardsSelected = cards;
			
			var len:int = _handCheckFunctions.length;
			
			for (var i:int = 0; i < len; i++) {
				_handCheckFunctions[i]();
			}
			
			_winningHand = CardSortUtils.getHighestHand(_hands);
			_winningHand.highCardSelected = _cardsSelected[_cardsSelected.length - 1];
			
			//cleanup
			_hands.length = 0;
			_cardsSelected.length = 0;
			
			
			return _winningHand;
		}
		
		
		//************** HAND ALGOS *****************//
		
		private function pair():HandVO {
			
			var handVO:HandVO = new HandVO();
			
			var len:int = _cardsSelected.length;
			for (var i:int = 0; i < len; i++) {
				
				var cardVO:CardVO = _cardsSelected[i] as CardVO;
				
				var len2:int = _cardsSelected.length;
				for (var j:int = 0; j < len2; j++) {
					
					var cardVO2:CardVO = _cardsSelected[j] as CardVO;
					
					if (cardVO.value == cardVO2.value && cardVO != cardVO2) {
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
			
			for (var i:int = 0; i < 5; i++) {				
				if(!cardsSelectedCopy[i])
					continue;
				
				var cardVO:CardVO = cardsSelectedCopy[i] as CardVO;
				
				for (var j:int = 0; j < 5; j++) {					
					if(!cardsSelectedCopy[j])
						continue;
					
					var cardVO2:CardVO = cardsSelectedCopy[j] as CardVO;
					
					if (cardVO.value == cardVO2.value && cardVO != cardVO2) {
						matchCount++;
						
						handVO.cards.push(cardVO, cardVO2);
						
						if (matchCount == 1) {
							cardsSelectedCopy[cardsSelectedCopy.indexOf(cardVO)] = null;
							cardsSelectedCopy[cardsSelectedCopy.indexOf(cardVO2)] = null;
							break;
						} else if (matchCount == 2) {
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
			for (var i:int = 0; i < len; i++) {
				
				var cardVO:CardVO = _cardsSelected[i] as CardVO;
				var matchCount:int = 0;
				
				var len2:int = _cardsSelected.length;
				for (var j:int = 0; j < _cardsSelected.length; j++) {
					
					var cardVO2:CardVO = _cardsSelected[j] as CardVO;
					
					if (cardVO.value == cardVO2.value && cardVO != cardVO2) {
						matchCount++
							handVO.cards.push(cardVO2);
					}
				}
				
				if (matchCount >= 2) {
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
			
			
			for (var i:int = 0; i < _cardsSelected.length; i++) {
				
				var cardVO:CardVO = _cardsSelected[i] as CardVO;
				
				if (cardVO.value == CardSortUtils.VALUE_ORDER[(valueIndex + i)]) {
					handVO.cards.push(cardVO);
					matchCount++;
				}
				
				if (matchCount == 5) {
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
			
			for (var i:int = 0; i < _cardsSelected.length; i++) {
				
				var cardVO:CardVO = _cardsSelected[i] as CardVO;
				
				if (cardVO.suit == suit) {
					handVO.cards.push(cardVO);
					matchCount++;
				}
				
				if (matchCount == 5) {
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
			for (var i:int = 0; i < len; i++) {
				
				var hand:HandVO = _hands[i];
				
				hand.hand == HandLookup.TWO_PAIR ? twoPairVO = hand : null;
				hand.hand == HandLookup.THREE_OF_A_KIND ? threeOfAKindVO = hand : null;
			}
			
			if (twoPairVO != null && threeOfAKindVO != null) {
				
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
			
			for (var i:int = 0; i < cardsSelectedCopy.length; i++) {
				
				var cardVO:CardVO = cardsSelectedCopy[i] as CardVO;
				
				for (var j:int = 0; j < cardsSelectedCopy.length; j++) {
					
					var cardVO2:CardVO = cardsSelectedCopy[j] as CardVO;
					
					if (cardVO.value == cardVO2.value && cardVO != cardVO2) {
						
						handVO.cards.push(cardVO);
						cardsSelectedCopy.splice(cardsSelectedCopy.indexOf(cardVO), 1);
						matchCount++
						
						if (matchCount == 4) {
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
			for (var i:int = 0; i < len; i++) {
				
				var hand:HandVO = _hands[i];
				
				hand.hand == HandLookup.STRAIGHT ? straight = true : null;
				hand.hand == HandLookup.FLUSH ? flush = true : null;
				
				//note: Not pushing cards into array here...not sure it matters
			}
			
			if (straight && flush) {
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
			for (var i:int = 0; i < len; i++) {
				
				var hand:HandVO = _hands[i];
				
				hand.hand == HandLookup.STRAIGHT_FLUSH ? straightFlush = true : null;
			}
			
			if (straightFlush && _cardsSelected[_cardsSelected.length - 1].value == ACE) {
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
