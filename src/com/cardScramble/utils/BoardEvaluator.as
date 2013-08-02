package com.cardScramble.utils
{
	import com.cardScramble.scenes.game.Card;
	import com.cardScramble.scenes.game.data.CardVO;
	import com.cardScramble.scenes.game.data.HandVO;
	import com.cardScramble.scenes.game.data.Paths_5x3;

	public class BoardEvaluator
	{
		
		private var paths:Array;
		private var path:Array;
		private var unsortedHands:Array;
		private var evaluationData:Array;
		private var _boardCards:Array = [];
		
		public function BoardEvaluator(){
			paths = Paths_5x3.paths;
		}
		
		
		/**
		 * Returns highest hand in any grid of cards
		 * 
		 */
		public function getHighestHand(boardCards:Array):void {
		
			_boardCards = boardCards;
			unsortedHands = getHandCards(boardCards);
			
			evaluationData = [];
			
			var handVO:HandVO;
			var i:int;
			for(i = 1; i <= 9; i++) {
				evaluationData[i] = [];
			}
			
			for each(var o:Object in unsortedHands) {
				o.realHand.sort(CardSortUtils.cardCompare);
				handVO = HandEvaluator.getInstance().evaluate(CardSortUtils.sortCardByHighCardSelected(o.realHand));
				if(handVO.valid && handVO.hand) {
					evaluationData[handVO.hand].push({hand:handVO, cards:o.realHand, spaceIndices:o.spaceIndices});
				}
			}
			
			showHighestHand();
		}
		
		private function getHandCards(boardCards:Array):Array {
			
			var realHand:Vector.<CardVO>;
			//var space:Space;
			var i:int = 0;
			var card:Card;
			var cardVO:CardVO;
			var unsortedHands:Array = [];
			
			for each(path in paths) {
				
				realHand = new Vector.<CardVO>;
				
				for each(i in path) {
					
					cardVO = boardCards[i];
					realHand.push(cardVO);
				}
				
				unsortedHands.push({realHand:realHand, spaceIndices:path});
			}
			
			return unsortedHands;
		}
		
		private function showHighestHand():void{
			var i:int;
			var o:Object;
			var data:Object;
			var handName:String;
			for(i = 9; i > 0; i--) {
				data = evaluationData[i];
				if(data.length){
					handName = HandLookup.handToString(i);
					o = data.sort(sortHands).reverse()[0];
					var card:Card;
					for each(var k:int in o.spaceIndices) {
						//card = board.spaces[k].card;
						//card.select(true);
					}
					break;
				}				
			}
			
			trace("highest hand is", handName, getCardsAt(o.spaceIndices));			
		}
		
		private function getCardsAt(indices:Array):String {
			var str:String;
			//var space:Space;
			var pHand:Array = [];
			var card:CardVO;
			var cards:Vector.<CardVO> = new Vector.<CardVO>;
			
			for each(var i:int in indices) {
				
				card = _boardCards[i];
				cards.push(card);
			}
			cards.sort(CardSortUtils.cardCompare);
			for(i = 0; i < cards.length; i++) {
				pHand.push(cards[i].value + cards[i].suit);
			}
			return pHand.join(' ');
		}
		
		private function sortHands(a:Object, b:Object):Number {
			
			var handA:HandVO = a.hand;
			var handB:HandVO = b.hand;
			var result:Number = CardSortUtils.cardCompare(handA.highCardSelected, handB.highCardSelected);
			if(result != 0) {
				return result
			} else {
				if(handA.cards.length){
					result = sortCards(handA.cards,handB.cards);
					if(result != 0) {
						return result
					} else {
						return sortCards(handA.extraCards, handB.extraCards);
					}
				}else{
					return sortCards(handA.extraCards, handB.extraCards);
				}
			}
		}
		
		private function sortCards(cardsA:Vector.<CardVO>, cardsB:Vector.<CardVO>):Number {
			cardsA.sort(CardSortUtils.cardCompare);
			cardsB.sort(CardSortUtils.cardCompare);
			var i:int = cardsA.length - 1;
			var cardA:CardVO;
			var cardB:CardVO;
			var result:Number;
			while(i >= 0) {
				cardA = cardsA[i];
				cardB = cardsB[i];
				result = CardSortUtils.cardCompare(cardA, cardB)
				if(result != 0) {
					return result
				} else {
					i--;
				}
			}
			return 0;
		}
		
		
	}
}