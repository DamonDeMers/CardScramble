package com.cardScramble.utils
{
	import com.cardScramble.scenes.game.data.CardVO;
	import com.cardScramble.scenes.game.data.HandVO;

	public class CardSortUtils
	{
		public function CardSortUtils(){
		}
		
		public static var VALUE_ORDER:Array = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "j", "q", "k", "a"];
		public static var SUIT_ORDER:Array = ["c", "d", "h", "s"];
		
		public static function sortCardByHighCardSelected(unsortedHandSource:Vector.<CardVO>):Vector.<CardVO>{
			
			var sortedHand:Vector.<CardVO> = new Vector.<CardVO>;
			var unsortedHand:Vector.<CardVO> = copyVect(unsortedHandSource);
			
			for (var i:int = 0; i < VALUE_ORDER.length; i++) {
				
				for (var j:int = 0; j < SUIT_ORDER.length; j++) {
					
					for (var k:int = 0; k < unsortedHand.length; k++) {
						
						var cardVO:CardVO = unsortedHand[k] as CardVO;
						
						if(cardVO.value == VALUE_ORDER[i] && cardVO.suit == SUIT_ORDER[j]){
							sortedHand.push(cardVO);
							unsortedHand.splice(k, 1);
							trace("cardVO.value: " + cardVO.value + " cardVO.suit: " + cardVO.suit);
						}
					}
				}
			}
			
			return sortedHand;
		}
		
		public static function sortHandByHighCardInHand(unsortedCards:Vector.<CardVO>):Vector.<CardVO>{
			var sortedHand:Vector.<CardVO> = new Vector.<CardVO>;
			
			return sortedHand;
		}
		
		public static function getHighestHand(hands:Vector.<HandVO>):HandVO{
			var highestHand:HandVO = new HandVO();
			var handSorted:Vector.<HandVO> = Vector.<HandVO>(vectorToArray(hands).sortOn("hand", Array.NUMERIC));
			
			highestHand = handSorted[handSorted.length-1];
			
			return highestHand;
		}
		
		public static function copyVect(cards:Vector.<CardVO>):Vector.<CardVO>{
			
			var copy:Vector.<CardVO> = new Vector.<CardVO>;
			
			for (var i:int = 0; i < cards.length; i++) {
				
				copy[i] = cards[i];
			}
			
			return copy;
		}
		
		public static function vectorToArray(vector:*):Array {
			
			var result:Array = [];
			for (var i:int = 0; i < vector.length; ++i) {
				result[i] = vector[i];
			}
			return result;
		}
	}
}