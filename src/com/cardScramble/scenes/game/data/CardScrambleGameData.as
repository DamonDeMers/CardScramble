package com.cardScramble.scenes.game.data
{
	import com.abacus.core.SceneData;
	import com.cardScramble.core.CardScrambleModel;
	import com.cardScramble.scenes.store.Store;
	import com.cardScramble.scenes.store.data.StoreItemVO;
	import com.cardScramble.utils.CardSortUtils;
	import com.cardScramble.utils.HandEvaluator;
	import com.cardScramble.utils.HandLookup;
	import com.cardScramble.utils.ScoreTable;
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class CardScrambleGameData extends SceneData
	{
		//modes (for testing) 0 = same hand, 1 = new hand after each play
		public const MODE:int = 1;
		
		//model
		private var _model:CardScrambleModel = CardScrambleModel.getInstance();
		
		//event types
		public static const UPDATE:String = "update";
		
		public static const ROUND_COMPLETE:String = "roundComplete"
		public static const TIMER_UPDATE:String = "timerUpdate";
		public static const TIMER_COMPLETE:String = "timerComplete";
		public static const UPDATE_SCORE:String = "updateScore";
		
		public const NUM_CARDS_VERTICAL:Number = 3;
		public const NUM_CARDS_HORIZONTAL:Number = 5;
		
		private var _cardNames:Array = ["h2", "h3", "h4", "h5", "h6", "h7", "h8", "h9", "h10", "hj", "hq", "hk", "ha", 
			"c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck", "ca",
			"d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", "d10", "dj", "dq", "dk", "da",
			"s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "sj", "sq", "sk", "sa"];
		
		//global
		private var _handEvaluator:HandEvaluator = HandEvaluator.getInstance();
		
		//storage
		private var _cardDict:Dictionary;
		private var _cardsSelected:Vector.<CardVO>;
		private var _handsAchieved:Vector.<HandVO>;
		private var _gameBoardCards:Array = [];
	
		//data
		private var _winningHand:HandVO;
		private var _score:int;
		private var _scoreMultiplier:int = 1;
		private var _tweenObj:Object = new Object;
		private var _roundCount:int = 0;
		private var _powerUps:Vector.<StoreItemVO> = new Vector.<StoreItemVO>;
		
		//view data
		private var _gridData:Vector.<GridPositionVO> = new Vector.<GridPositionVO>;
		
		//timers
		private var _countdownTimer:Timer;
		
		
		
		public function CardScrambleGameData(){
			
		}
		
		
		//================ PUBLIC METHODS =================//

		override public function init():void{
			
			_countdownTimer = new Timer(1000, 5);
			_cardsSelected = new Vector.<CardVO>;
			_handsAchieved = new Vector.<HandVO>;
			
			_cardDict = new Dictionary();
			
			_score = _model.sharedObject.data.balance;
			_powerUps = initPowerUps();
			
			_countdownTimer.addEventListener(TimerEvent.TIMER, onCountdownTimer);
			_countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCountdownTimerComplete);
			_countdownTimer.start();
		}

		override public function close():void{
			
			_model.sharedObject.data.balance = _score;
			_model.sharedObject.data.inventory = _powerUps;
			
			_gridData.length = 0;
			_gameBoardCards = [];
			_scoreMultiplier = 1;
			_winningHand = null;
			
			_roundCount = 0;
			
			_countdownTimer.removeEventListener(TimerEvent.TIMER, onCountdownTimer);
			_countdownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCountdownTimerComplete);
			
			_model.endScene();
		}
		
		public function selectionComplete():void{
			
			_cardsSelected = CardSortUtils.sortCardByHighCardSelected(_cardsSelected);
			_winningHand = _handEvaluator.evaluate(_cardsSelected);

			var handScoreValue:int = ScoreTable.handIntToScoreValue(_winningHand.hand) * _scoreMultiplier;
			_tweenObj.score = _score;
			updateScore(handScoreValue);
			
			_roundCount++;
			
			_handsAchieved.push(_winningHand);
			_gridData.length = 0;
			_gameBoardCards = [];
			_scoreMultiplier = 1;
			
			dispatchEventWith(UPDATE, true, {type:ROUND_COMPLETE, score:handScoreValue, hand:HandLookup.handToString(_winningHand.hand), handInt:_winningHand.hand});
		}
		
		public function updateScore(incrementAmount:int, tweenDelay:Number = 2):void{
			
			_score += incrementAmount;
			TweenLite.to(_tweenObj, 1, {delay:tweenDelay, score:_score, onUpdate:onScoreUpdate});
		}
		
		public function abortSelection():void{
			
			_cardsSelected.length = 0;
		}
		
		override public function pause():void{
			//stub
		}
		
		public function powerUpActivated(powerUpType:String):void{
			
			for (var i:int = 0; i < _powerUps.length; i++) {
				
				var powerUp:StoreItemVO = _powerUps[i];
				
				if(powerUp.itemType == powerUpType){
					
					powerUp.quantity--;
					
					if(powerUp.quantity == 0){
						
						_powerUps.splice(i, 1);
					}	
				}	
			}	
		}

		//================ PRIVATE METHODS =================//
		
		private function onScoreUpdate():void{
			dispatchEventWith(UPDATE, true, {type:UPDATE_SCORE, score:int(_tweenObj.score)});
		}
		
		private function initPowerUps():Vector.<StoreItemVO>{
			
			var powerUps:Vector.<StoreItemVO> = new Vector.<StoreItemVO>;
			
			var len:int = _model.sharedObject.data.inventory.length;
			
			for (var i:int = 0; i < len; i++) {
				
				var item:Object = _model.sharedObject.data.inventory[i];
				var storeItemVO:StoreItemVO = new StoreItemVO();
				
				storeItemVO.price = item.price;
				storeItemVO.quantity = item.quantity;
				storeItemVO.itemType = item.itemType;
				
				for (var j:* in item) trace(j+" = "+item[j]);

				
				powerUps.push(storeItemVO);
			}
			
			return powerUps;
		}
		
		//================ EVENT HANDLERS =================//
		
		private function onCountdownTimer(e:TimerEvent):void{
			dispatchEventWith(UPDATE, true, {type:TIMER_UPDATE, time:(_countdownTimer.repeatCount - _countdownTimer.currentCount)});
		}
		
		private function onCountdownTimerComplete(e:TimerEvent):void{
			dispatchEventWith(UPDATE, true, {type:TIMER_COMPLETE});
		}
		
		
		
		//================ GETTERS AND SETTERS ===============//
		
		public function get cardSelected():Vector.<CardVO> { return _cardsSelected; }
		public function set cardSelected(value:Vector.<CardVO>):void { _cardsSelected = value; }

		public function get cardDict():Dictionary { return _cardDict; }
		public function set cardDict(value:Dictionary):void { _cardDict = value; }
		
		public function get scoreMultiplier():int { return _scoreMultiplier; }
		public function set scoreMultiplier(value:int):void { _scoreMultiplier = value; }
		
		public function get gameBoardCards():Array { return _gameBoardCards; }
		
		public function get gridData():Vector.<GridPositionVO> { return _gridData; }
		
		public function get handsAchieved():Vector.<HandVO> { return _handsAchieved; }

		public function get cardNames():Array { return _cardNames; }
		
		public function get score():int { return _score; }
		
		public function get roundCount():int { return _roundCount; }
		
		public function get powerUps():Vector.<StoreItemVO> { return _powerUps; }

	}
}