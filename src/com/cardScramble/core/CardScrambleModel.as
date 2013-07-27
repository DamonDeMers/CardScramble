package com.cardScramble.core
{
	import com.abacus.core.Model;
	import com.abacus.core.SceneVO;
	import com.cardScramble.scenes.game.CardScrambleGame;
	import com.cardScramble.scenes.game.data.CardScrambleGameData;
	import com.cardScramble.scenes.game.data.HandVO;
	import com.cardScramble.scenes.results.CardScrambleResults;
	import com.cardScramble.scenes.results.CardScrambleResultsData;
	
	public class CardScrambleModel extends Model{
		
		private static var _instance:CardScrambleModel = new CardScrambleModel();
		
		//scenes VOs
		private var _gameVO:SceneVO = new SceneVO(); 
		private var _resultsVO:SceneVO = new SceneVO();
		
		//results
		private var _handsAchieved:Vector.<HandVO>;
		
		public function CardScrambleModel(){
			super();
			
			if(_instance){
				throw new Error("CardScrambleModel is a Singleton class, use getInstance");
			}
		}
		
		public static function getInstance():CardScrambleModel{
			return _instance;
		}

		override public function init():void{
			
			_gameVO.view = new CardScrambleGame();
			_gameVO.data = new CardScrambleGameData();
			
			_resultsVO.view = new CardScrambleResults();
			_resultsVO.data = new CardScrambleResultsData();
			
			_schedule.push(_gameVO, _resultsVO);
			
			dispatchEventWith(UPDATE, true, {mode:INIT});
		}
		
		
		//============= GETTERS AND SETTERS ===============//
		
		public function get handsAchieved():Vector.<HandVO>{
			return CardScrambleGameData(_gameVO.data).handsAchieved;
		}
		
	}
}