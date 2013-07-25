package com.cardScramble.scenes.results
{
	import com.abacus.core.SceneData;
	import com.cardScramble.core.CardScrambleModel;
	import com.cardScramble.utils.ScoreTable;
	
	import cardScramble.scenes.game.HandVO;
	
	public class CardScrambleResultsData extends SceneData{
		
		//model
		private var _model:CardScrambleModel = CardScrambleModel.getInstance();
		
		//data
		private var _handsAchieved:Vector.<HandVO>;
		
		
		
		
		//============== PUBLIC METHODS ================//
		
		public function CardScrambleResultsData(){	
			super();
		}

		override public function init():void{
			_handsAchieved = _model.handsAchieved;
		}
		
	
		public function handAchievedByType(index:int):int{
			var numHandsAtIndex:int = 0;
			
			var len:int = _handsAchieved.length;
			for (var i:int = 0; i < len; i++) {
				
				if(_handsAchieved[i].hand == index){
					numHandsAtIndex++;
				}
			}
			
			return numHandsAtIndex;	
		}
		
		public function totalPoints():int{
			var totalPoints:int = 0;
			
			var len:int = _handsAchieved.length;
			for (var i:int = 0; i < len; i++) {
				
				totalPoints += ScoreTable.handIntToScoreValue(_handsAchieved[i].hand);
			}
			
			return totalPoints;	
		}
		
		public function totalValidHands():int{
			var totalHands:int = 0;
			
			var len:int = _handsAchieved.length;
			for (var i:int = 0; i < len; i++) {
				
				if(_handsAchieved[i].hand > -1){
					totalHands ++;
				}
				
			}
			
			return totalHands;	
		}

		override public function pause():void{
			//stub
		}
		
		override public function close():void{
			//stub
		}
		
		
		
		//============= GETTERS AND SETTERS =================//
		
		public function get handsAchieved():Vector.<HandVO>{
			return _handsAchieved;
		}

		
		
	}
}