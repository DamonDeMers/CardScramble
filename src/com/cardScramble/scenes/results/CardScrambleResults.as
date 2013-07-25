package com.cardScramble.scenes.results {
	
	import com.abacus.core.ISceneData;
	import com.abacus.scenes.results.Results;
	import com.cardScramble.utils.ScoreTable;
	
	import starling.display.Image;
	import starling.text.TextField;
	
	public class CardScrambleResults extends Results{
		
		[Embed(source="../../../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;	
		
		//assets
		private var _bg:Image;
		
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
			
			_bg = new Image(_assets.getTexture("resultsBg"));
			addChild(_bg);
			
			var numHands:int = 9;
			var yVal:int = 48;
			var xSpacer:Boolean = false;
			
			for (var i:int = 0; i < numHands; i++) {
				
				var handInt:int = i+1;
				
				//achieved
				var numAchieved:int = _data.handAchievedByType(handInt);
				var numAchievedText:TextField = new TextField(250, 50, String(numAchieved), "JandaManateeSolid", 30, 0xFFFFFF);
				numAchievedText.fontName = "JandaManateeSolid";
				numAchievedText.x = xSpacer ? 385 : 340;
				numAchievedText.y = yVal;
				numAchievedText.scaleX = numAchievedText.scaleY = 1.25;
				numAchievedText.touchable = false;
				addChild(numAchievedText);
				
				//score
				var scoreInt:int = numAchieved * ScoreTable.handIntToScoreValue(handInt);
				var score:TextField = new TextField(250, 50, String(scoreInt), "JandaManateeSolid", 30, 0xFFFFFF);
				score.fontName = "JandaManateeSolid";
				score.x = 500;
				score.y = yVal;
				score.scaleX = score.scaleY = 1.25;
				score.touchable = false;
				addChild(score);
				
				yVal += 45;
				xSpacer = !xSpacer;
			}
			
			
			//text
			_resultsText = new TextField(250, 50, "Results", "JandaManateeSolid", 30, 0xFFFFFF);
			_resultsText.fontName = "JandaManateeSolid";
			_resultsText.x = -40;
			_resultsText.y = 480;
			_resultsText.scaleX = _resultsText.scaleY = 1.5;
			_resultsText.touchable = false;
			addChild(_resultsText);
			
			
			_resultsAchieved = new TextField(250, 50, String(_data.totalValidHands()), "JandaManateeSolid", 30, 0xFFFFFF);
			_resultsAchieved.fontName = "JandaManateeSolid";
			_resultsAchieved.x = 315;
			_resultsAchieved.y = 480;
			_resultsAchieved.scaleX = _resultsAchieved.scaleY = 1.5;
			_resultsAchieved.touchable = false;
			addChild(_resultsAchieved);
			
			
			_totalScore = new TextField(250, 50, String(_data.totalPoints()), "JandaManateeSolid", 30, 0xFFFFFF);
			_totalScore.fontName = "JandaManateeSolid";
			_totalScore.x = 465;
			_totalScore.y = 480;
			_totalScore.scaleX = _totalScore.scaleY = 1.5;
			_totalScore.touchable = false;
			addChild(_totalScore);
		}
		
		
		override public function pause():void{
			
		}
		
		override public function close():void{
			
		}
		
	}
}