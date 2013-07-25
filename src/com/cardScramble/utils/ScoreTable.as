package com.cardScramble.utils
{
	public class ScoreTable
	{
		public function ScoreTable(){
		}
		
		public static function handIntToScoreValue(handInt:int):int{
			var score:int;
			
			switch(handInt){
				case -1:
					score = 0;
					break;
				case 1:
					score = 250;
					break;
				case 2:
					score = 500;	
					break;
				case 3:
					score = 1000;
					break;
				case 4:
					score = 2500;	
					break;
				case 5:
					score = 4000;
					break;
				case 6:
					score = 6000;
					break;
				case 7:
					score = 10000;
					break;
				case 8:
					score = 20000;
					break;
				case 9:
					score = 100000;
					break;
			}
			
			return score;
		}
	}
}