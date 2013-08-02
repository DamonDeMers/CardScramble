package com.cardScramble.core
{
	import com.abacus.core.Model;
	import com.abacus.core.SceneVO;
	import com.cardScramble.scenes.game.CardScrambleGame;
	import com.cardScramble.scenes.game.data.CardScrambleGameData;
	import com.cardScramble.scenes.game.data.HandVO;
	import com.cardScramble.scenes.results.CardScrambleResults;
	import com.cardScramble.scenes.results.CardScrambleResultsData;
	import com.cardScramble.scenes.store.Store;
	import com.cardScramble.scenes.store.data.StoreData;
	import com.cardScramble.scenes.store.data.StoreItemVO;
	
	import flash.net.SharedObject;
	
	public class CardScrambleModel extends Model{
		
		//const
		public static const GOTO_SCENE:String = "gotoScene";
		
		//instance
		private static var _instance:CardScrambleModel = new CardScrambleModel();
		
		//scenes VOs
		private var _gameVO:SceneVO = new SceneVO(); 
		private var _resultsVO:SceneVO = new SceneVO();
		private var _storeVO:SceneVO = new SceneVO();
		
		//results
		private var _handsAchieved:Vector.<HandVO>;
		
		//shared object
		private var _sharedObject:SharedObject = SharedObject.getLocal("userData");
		
		
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
			//_sharedObject.clear();
			
			
			if(!_sharedObject.data.hasOwnProperty("balance")){
				
				_sharedObject.data.balance = 0;
				_sharedObject.data.inventory = new Vector.<StoreItemVO>;
				_sharedObject.flush();
				
				trace("FLUSH");
			} 

			trace("_sharedObject.data.inventory: " + _sharedObject.data.inventory.length);
			
			_gameVO.view = new CardScrambleGame();
			_gameVO.data = new CardScrambleGameData();
			
			_resultsVO.view = new CardScrambleResults();
			_resultsVO.data = new CardScrambleResultsData();
			
			_storeVO.view = new Store();
			_storeVO.data = new StoreData();
			
			_schedule.push(_gameVO, _resultsVO, _storeVO);

			
			dispatchEventWith(UPDATE, true, {mode:INIT});
			
		}
		
		public function gotoScene(sceneIndex:int):void{
		
			dispatchEventWith(UPDATE, true, {mode:GOTO_SCENE, sceneIndex:sceneIndex});
			
		}
		
		//============= GETTERS AND SETTERS ===============//
		
		public function get handsAchieved():Vector.<HandVO>{
			return CardScrambleGameData(_gameVO.data).handsAchieved;
		}
		
		public function get currencyAmount():int{
			return CardScrambleGameData(_gameVO.data).score;
		}
		
		public function updateCurrency(incrementAmount:int, tweenDelay:Number = 2):void{
			CardScrambleGameData(_gameVO.data).updateScore(incrementAmount, tweenDelay);
		}
		
		public function get sharedObject():SharedObject{
			return _sharedObject;
		}

		
	}
}