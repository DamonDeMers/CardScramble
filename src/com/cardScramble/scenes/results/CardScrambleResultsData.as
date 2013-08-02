package com.cardScramble.scenes.results
{
	import com.abacus.core.SceneData;
	import com.cardScramble.core.CardScrambleModel;
	import com.cardScramble.scenes.game.data.HandVO;
	import com.cardScramble.utils.PokerConsts;
	import com.cardScramble.utils.ScoreTable;
	import com.greensock.TweenLite;
	
	public class CardScrambleResultsData extends SceneData{
		
		public static const UPDATE:String = "update";
		
		public static const SCORES_UPDATE:String = "scoresUpdate";
		
		//model
		private var _model:CardScrambleModel = CardScrambleModel.getInstance();
		
		//data
		private var _handsAchieved:Vector.<HandVO>;
		private var _numHandAchievedByType:Array = [];
		private var _handScores:Array = [];
		private var _totalHandsAcheived:int;
		private var _totalScore:int;
		
		//tweenObj
		private var _tweenObj:Object = new Object();
		
		
		
		
		//============== PUBLIC METHODS ================//
		
		public function CardScrambleResultsData(){	
			super();
		}

		override public function init():void{
			_handsAchieved = _model.handsAchieved; //fakeHandsForTest();  
			_numHandAchievedByType = handsAchievedByType();
			_handScores = handScores();
			updateHandScores();
		}
		
		override public function pause():void{
			//stub
		}
		
		override public function close():void{
			
			_numHandAchievedByType = [];
			_handsAchieved.length = 0;
			_handScores = [];
			_totalHandsAcheived = 0;
			_totalScore = 0;
			_model.endScene();
		}
		
		
		
		
		//============== PRIVATE METHODS ================//
		
		private function fakeHandsForTest():Vector.<HandVO>{
			
			var returnVect:Vector.<HandVO> = new Vector.<HandVO>;
			
			var hand1:HandVO = new HandVO();
			hand1.hand = 1;
			var hand2:HandVO = new HandVO();
			hand2.hand = 1;
			var hand3:HandVO = new HandVO();
			hand3.hand = 1;
			var hand4:HandVO = new HandVO();
			hand4.hand = 2;
			var hand5:HandVO = new HandVO();
			hand5.hand = 3;
			var hand6:HandVO = new HandVO();
			hand5.hand = 4;
			var hand7:HandVO = new HandVO();
			hand6.hand = 4;
			var hand8:HandVO = new HandVO();
			hand8.hand = 5;
			var hand9:HandVO = new HandVO();
			hand9.hand = 7;
			var hand10:HandVO = new HandVO();
			hand10.hand = 8;
			
			returnVect.push(hand1, hand2, hand3, hand4, hand5, hand6, hand7, hand8, hand9, hand10);
			
			return returnVect;
		}
	
		private function handsAchievedByType():Array{
			
			var handAchievedByType:Array = [];
			
			var len:int = PokerConsts.NUM_HAND_TYPES;
			for (var i:int = 0; i < len; i++) {
				var handType:int = i + 1;
				handAchievedByType.push(getHandsAcheived(handType));	
			}
			
			return handAchievedByType;	
		}
		
		private function getHandsAcheived(handInt:int):int{
			
			var numHands:int = 0;
			
			var len:int = _handsAchieved.length;
			for (var i:int = 0; i < len; i++) {
				
				if(_handsAchieved[i].hand == handInt){
					numHands++;
					_totalHandsAcheived++;
				}
			}
			
			return numHands;	
		}

		private function handScores():Array{
			
			var handScoreArr:Array = [];
			
			var len:int = _numHandAchievedByType.length;
			for (var i:int = 0; i < len; i++) {
				
				var score:int = ScoreTable.handIntToScoreValue(i+1) * _numHandAchievedByType[i];
				
				handScoreArr.push(score);
				_totalScore += score;
			}
			
			return handScoreArr;	
		}
		
		private function updateHandScores():void{
			
			var len:int = PokerConsts.NUM_HAND_TYPES;
			
			for (var i:int = 0; i < len; i++) {
				
				var score:String = String(i); //append score props to tween obj
				var scoreObj:Object = new Object; //object that will be tweened
				_tweenObj[score] = 0; //set initial score to 0
				var delay:Number = 1.5;
				
				//assign score values to the tween object
				switch(i){
					
					case 0:
					scoreObj = {delay:delay, 0:_handScores[0], onUpdate:dispatchScores}
						break;
					case 1:
						scoreObj = {delay:delay, 1:_handScores[1], onUpdate:dispatchScores}
						break;
					case 2:
						scoreObj = {delay:delay, 2:_handScores[2], onUpdate:dispatchScores}
						break;
					case 3:
						scoreObj = {delay:delay, 3:_handScores[3], onUpdate:dispatchScores}
						break;
					case 4:
						scoreObj = {delay:delay, 4:_handScores[4], onUpdate:dispatchScores}
						break;
					case 5:
						scoreObj = {delay:delay, 5:_handScores[5], onUpdate:dispatchScores}
						break;
					case 6:
						scoreObj = {delay:delay, 6:_handScores[6], onUpdate:dispatchScores}
						break;
					case 7:
						scoreObj = {delay:delay, 7:_handScores[7], onUpdate:dispatchScores}
						break;
					case 8:
						scoreObj = {delay:delay, 8:_handScores[8], onUpdate:dispatchScores}
						break;
				}
				
				TweenLite.to(_tweenObj, 1, scoreObj);
			}
			
		}
		
		private function dispatchScores():void{
			
			dispatchEventWith(UPDATE, true, {type:SCORES_UPDATE, tweenObj:_tweenObj})
		}
		

		
		//============= GETTERS AND SETTERS =================//
		
		public function get totalScore():int {
			return _totalScore;
		}
		
		public function get totalHandsAcheived():int{
			return _totalHandsAcheived;
		}
		
		public function get handsScoresArray():Array{
			return _handScores;
		}
		
		public function get numHandAchievedByType():Array{
			return _numHandAchievedByType;
		}
		
	}
}