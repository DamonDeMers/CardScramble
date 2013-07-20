package com.cardScramble
{
	import com.cardScramble.data.CardVO;
	import com.cardScramble.data.HandVO;
	import com.cardScramble.utils.CardSortUtils;
	import com.cardScramble.utils.HandEvaluator;
	import com.cardScramble.utils.HandLookup;
	import com.cardScramble.utils.ScoreTable;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import starling.events.EventDispatcher;
	
	public class Model extends EventDispatcher
	{
		//modes (for testing) 0 = same hand, 1 = new hand after each play
		public static const MODE:int = 0;
		
		//event types
		public static const UPDATE:String = "update";
		public static const TIMER_UPDATE:String = "timerUpdate";
		public static const TIMER_COMPLETE:String = "timerComplete";
		public static const SCORE_CHANGE:String = "scoreChange";
		
		public const NUM_CARDS_HORIZONTAL:Number = 5;
		public const NUM_CARDS_VERTICAL:Number = 3;
		
		private var _cardNames:Array = ["h2", "h3", "h4", "h5", "h6", "h7", "h8", "h9", "h10", "hj", "hq", "hk", "ha", 
			"c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "cj", "cq", "ck", "ca",
			"d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", "d10", "dj", "dq", "dk", "da",
			"s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "sj", "sq", "sk", "sa"];
		
		//global
		private var _handEvaluator:HandEvaluator = HandEvaluator.getInstance();
		
		//storage
		private var _cardDict:Dictionary = new Dictionary();
		private var _cardsSelected:Vector.<CardVO> = new Vector.<CardVO>;
	
		//data
		private var _winningHand:HandVO;
		private var _score:int = 0;
		
		//timers
		private var _countdownTimer:Timer = new Timer(1000, 60);
		
		
		public function Model(){
			
			_countdownTimer.addEventListener(TimerEvent.TIMER, onCountdownTimer);
			_countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCountdownTimerComplete);
			_countdownTimer.start();
			
		}
		
		
		//================ PUBLIC METHODS =================//

		public function selectionComplete():void{
			
			_cardsSelected = CardSortUtils.sortCardByHighCardSelected(_cardsSelected);
			_winningHand = _handEvaluator.evaluate(_cardsSelected);

			var handScoreValue:int = ScoreTable.handIntToScoreValue(_winningHand.hand);
			_score += handScoreValue;
			
			dispatchEventWith(UPDATE, true, {type:SCORE_CHANGE, score:handScoreValue, hand:HandLookup.handToString(_winningHand.hand)});
		}
		
		public function abortSelection():void{
			
			_cardsSelected.length = 0;
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

		public function get cardNames():Array { return _cardNames; }
		
		public function get score():int { return _score; }

	}
}