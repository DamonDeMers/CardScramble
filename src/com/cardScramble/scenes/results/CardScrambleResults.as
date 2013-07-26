package com.cardScramble.scenes.results {
	
	import com.abacus.core.ISceneData;
	import com.abacus.scenes.results.Results;
	import com.cardScramble.utils.PokerConsts;
	import com.cardScramble.utils.ScoreTable;
	import com.greensock.TweenLite;
	
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class CardScrambleResults extends Results{
		
		[Embed(source="../../../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;	
		
		//assets
		private var _bg:Image;
		private var _numAchievedContainer:Sprite;
		private var _scoreContainer:Sprite;
		
		//data
		private var _data:CardScrambleResultsData;
		
		//text
		private var _resultsText:TextField;
		private var _resultsAchieved:TextField;
		private var _totalScore:TextField;
		
		public function CardScrambleResults(){
			super();
		}
		
		override public function init(data:ISceneData):void{
			
			_data = data as CardScrambleResultsData;
			
			initListeners();
			initAssets();
			animateAssets();
		}
		
		private function initListeners():void{
			_data.addEventListener(CardScrambleResultsData.UPDATE, onResultsDataUpdate);
		}
		
		private function initAssets():void{
			
			_bg = new Image(_assets.getTexture("resultsBg"));
			addChild(_bg);
			
			//containers
			_numAchievedContainer = new Sprite();
			addChild(_numAchievedContainer);
			
			_scoreContainer = new Sprite();
			addChild(_scoreContainer);
			
			var yVal:int = 48;
			var xSpacer:Boolean = false;
			
			for (var i:int = 0; i < PokerConsts.NUM_HAND_TYPES; i++) {
				
				var handInt:int = i+1;
				
				//achieved
				var numAchieved:int = _data.numHandAchievedByType[i];
				var numAchievedText:TextField = new TextField(250, 50, String(numAchieved), "JandaManateeSolid", 30, 0xFFFFFF);
				numAchievedText.fontName = "JandaManateeSolid";
				numAchievedText.x = xSpacer ? 385 : 340;
				numAchievedText.y = yVal;
				numAchievedText.scaleX = numAchievedText.scaleY = 1.25;
				numAchievedText.touchable = false;
				numAchievedText.alpha = 0;
				_numAchievedContainer.addChild(numAchievedText);
				
				//score
				var score:TextField = new TextField(250, 50, "0", "JandaManateeSolid", 30, 0xFFFFFF);
				score.fontName = "JandaManateeSolid";
				score.x = 500;
				score.y = yVal;
				score.name = String(i);
				score.scaleX = score.scaleY = 1.25;
				score.touchable = false;
				_scoreContainer.addChild(score);
				
				yVal += 45;
				xSpacer = !xSpacer;
			}
			
			//text
			_resultsText = new TextField(250, 50, "Results", "JandaManateeSolid", 30, 0xFFFFFF);
			_resultsText.fontName = "JandaManateeSolid";
			_resultsText.hAlign = HAlign.CENTER;
			_resultsText.x = -40;
			_resultsText.y = 480;
			_resultsText.scaleX = _resultsText.scaleY = 1.5;
			_resultsText.touchable = false;
			addChild(_resultsText);
			
			
			_resultsAchieved = new TextField(250, 50, String(_data.totalHandsAcheived), "JandaManateeSolid", 30, 0xFFFFFF);
			_resultsAchieved.fontName = "JandaManateeSolid";
			_resultsAchieved.x = 315;
			_resultsAchieved.y = 480;
			_resultsAchieved.scaleX = _resultsAchieved.scaleY = 1.5;
			_resultsAchieved.touchable = false;
			_resultsAchieved.alpha = 0;
			addChild(_resultsAchieved);
			
			
			_totalScore = new TextField(250, 50, String(_data.totalScore), "JandaManateeSolid", 30, 0xFFFFFF);
			_totalScore.fontName = "JandaManateeSolid";
			_totalScore.x = 465;
			_totalScore.y = 480;
			_totalScore.scaleX = _totalScore.scaleY = 1.5;
			_totalScore.touchable = false;
			_totalScore.alpha = 0;
			addChild(_totalScore);

		}
		
		
		private function animateAssets():void{
			
			//Num Hands Acheived By Type
			var len:int = _numAchievedContainer.numChildren;
			var delay:Number = 0;
			
			for (var i:int = 0; i < len; i++) {
				var numAchieved:TextField = _numAchievedContainer.getChildAt(i) as TextField;
				
				TweenLite.to(numAchieved, 0.25, {delay:delay, alpha:1, x:numAchieved.x-8, scaleX:1.35, scaleY:1.35, onStart:onNumAchievedStart, onComplete:onNumAchievedComplete, onCompleteParams:[numAchieved]});
				delay += 0.15;
			}
			
			//Total Hands Achieved
			TweenLite.to(_resultsAchieved, 0.5, {delay:delay, alpha:1, onStart:onNumAchievedStart});
			
			function onNumAchievedStart():void{
				_assets.playSound("WaterDrop");
			}
			
			function onNumAchievedComplete(tf:TextField):void{
				TweenLite.to(tf, 0.25, {x:tf.x+8, scaleX:1.25, scaleY:1.25});
			}
			
			//Total Score
			TweenLite.delayedCall(1.2, playTallySound);
			TweenLite.to(_totalScore, 0.25, {delay:2.5, alpha:1, x:_totalScore.x - 15, scaleX:1.75, scaleY:1.75, onStart:onTotalScoreStart, onComplete:onTotalScoreComplete});
			
			function playTallySound():void{
				_assets.playSound("Tally");
			}
			
			function onTotalScoreStart():void{
				_assets.playSound("RegisterRing1");
			}
			
			function onTotalScoreComplete():void{
				TweenLite.to(_totalScore, 0.25, {alpha:1, x:_totalScore.x + 15, scaleX:1.5, scaleY:1.5});
			}
		}
		
		
		
		override public function pause():void{
			
		}
		
		override public function close():void{
			
		}
		
		
		//==================== EVENT HANDLERS ===================//
		
		private function onResultsDataUpdate(e:Event):void{
			
			var type:Object = e.data.type;
			
			switch(type){
				
				case CardScrambleResultsData.SCORES_UPDATE:
					
					var tweenObj:Object = e.data.tweenObj;
					for (var score:Number in tweenObj){
						trace("score: " + score + ": " + tweenObj[score]);
						var scoreText:TextField = _scoreContainer.getChildAt(score) as TextField;
						scoreText.text = String(int(tweenObj[score]));
					}
	
					break;	
			}	
		}
		
	}
}