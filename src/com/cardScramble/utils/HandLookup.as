package com.cardScramble.utils
{
	public class HandLookup
	{
		public static const PAIR:int = 1;
		public static const TWO_PAIR:int = 2;
		public static const THREE_OF_A_KIND:int = 3;
		public static const STRAIGHT:int = 4;
		public static const FLUSH:int = 5;
		public static const FULL_HOUSE:int = 6;
		public static const FOUR_OF_A_KIND:int = 7;
		public static const STRAIGHT_FLUSH:int = 8;
		public static const ROYAL_FLUSH:int = 9;
		
		public function HandLookup(){
		}
		
		public static function handToString(handInt:int):String{
			
			var hand:String;
			
			switch(handInt){
				case -1:
				hand = "None"
					break;
				case 1:
				hand = "Pair";
					break;
				case 2:
				hand = "Two Pair";	
					break;
				case 3:
				hand = "Three Of A Kind";
					break;
				case 4:
				hand = "Straight";	
					break;
				case 5:
				hand = "Flush";
					break;
				case 6:
				hand = "Full House";
					break;
				case 7:
				hand = "Four Of A Kind";
					break;
				case 8:
				hand = "Straight Flush";
					break;
				case 9:
				hand = "Royal Flush";
					break;
			}
			
			return hand;
		}
	}
}