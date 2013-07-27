package com.cardScramble.scenes.game.data
{
	public class HandVO
	{
		public var valid:Boolean = false;
		public var hand:int = -1;
		public var cards:Vector.<CardVO> = new Vector.<CardVO>;
		public var highCardInHand:CardVO;
		public var highCardSelected:CardVO;
		
		public function HandVO(){
		}
	}
}