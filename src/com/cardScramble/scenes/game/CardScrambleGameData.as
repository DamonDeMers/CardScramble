package com.cardScramble.scenes.game
{
	import com.abacus.core.SceneData;
	import com.cardScramble.core.CardScrambleModel;
	import com.cardScramble.utils.CardSortUtils;
	import com.cardScramble.utils.HandEvaluator;
	import com.cardScramble.utils.HandLookup;
	import com.cardScramble.utils.ScoreTable;
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import cardScramble.scenes.game.CardVO;
	import cardScramble.scenes.game.HandVO;
	
	public class CardScrambleGameData extends SceneData
	{
		//modes (for testing) 0 = same hand, 1 = new hand after each play
		public const MODE:int = 1;
		
		//model
		private var _model:CardScrambleModel = CardScrambleModel.getInstance();
		
		//event types
		public static const UPDATE:String = "update";
		
		public static const ROUND_COMPLETE:String = "roundComplete";

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
		private var _cardDict:Dictionary = new Dictionary();
		private var _cardsSelected:Vector.<CardVO> = new Vector.<CardVO>;
		private var _handsAchieved:Vector.<HandVO> = new Vector.<HandVO>;
	
		//data
		private var _winningHand:HandVO;
		private var _score:int = 0;
		private var _tweenObj:Object = new Object;
		
		//view data
		private var _cardLocations:Vector.<Point> = new Vector.<Point>;
		
		//timers
		private var _countdownTimer:Timer = new Timer(1000, 180);
		
		
		
		public function CardScrambleGameData(){

		}
		
		
		//================ PUBLIC METHODS =================//

		override public function init():void{
			_countdownTimer.addEventListener(TimerEvent.TIMER, onCountdownTimer);
			_countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCountdownTimerComplete);
			_countdownTimer.start();
		}

		public function selectionComplete():void{
			
			_cardsSelected = CardSortUtils.sortCardByHighCardSelected(_cardsSelected);
			_winningHand = _handEvaluator.evaluate(_cardsSelected);

			var handScoreValue:int = ScoreTable.handIntToScoreValue(_winningHand.hand);
			_tweenObj.score = _score;
			_score += handScoreValue;
			
			_handsAchieved.push(_winningHand);
			_cardLocations.length = 0;
			
			TweenLite.to(_tweenObj, 1, {delay:2, score:_score, onUpdate:onScoreUpdate});
			
			dispatchEventWith(UPDATE, true, {type:ROUND_COMPLETE, score:handScoreValue, hand:HandLookup.handToString(_winningHand.hand), handInt:_winningHand.hand});
		}
		
		public function abortSelection():void{
			
			_cardsSelected.length = 0;
		}
		
		override public function pause():void{
			//stub
		}
		
		override public function close():void{
			_model.endScene();
		}
		
		
		
		//================ PRIVATE METHODS =================//
		
		private function onScoreUpdate():void{
			
			dispatchEventWith(UPDATE, true, {type:UPDATE_SCORE, score:int(_tweenObj.score)});
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
		
		public function get cardLocations():Vector.<Point> { return _cardLocations; }
		
		public function get handsAchieved():Vector.<HandVO> { return _handsAchieved; }

		public function get cardNames():Array { return _cardNames; }
		
		public function get score():int { return _score; }

	}
}