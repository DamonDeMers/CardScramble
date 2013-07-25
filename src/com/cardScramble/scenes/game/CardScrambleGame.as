package com.cardScramble.scenes.game
{
	import com.abacus.assetManager.AssetManager;
	import com.abacus.core.ISceneData;
	import com.abacus.scenes.game.Game;
	import com.cardScramble.utils.StringUtils;
	
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import cardScramble.scenes.game.CardVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class CardScrambleGame extends Game
	{
		
		[Embed(source="../../../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;	
		
		public static const ST_SOUND_FX:SoundTransform = new SoundTransform();
		private static const GLOBAL_ST:SoundTransform = new SoundTransform();
		
		//singletons
		private var _assets:AssetManager = AssetManager.getInstance();

		//model
		private var _data:CardScrambleGameData;
		
		//assets
		private var _cardContainer:Sprite = new Sprite();
		private var _rewardSequencer:RewardSequencer;
		private var _soundIconsContainer:Sprite;
		private var _musicIcon:Image;
		private var _soundFxIcon:Image;
		
		//text
		private var _timerText:TextField;
		private var _scoreText:TextField;
		
		//data
		private static var _mousePoint:Point = new Point();
		private var _prevCard:Card;
		
		//souns
		private var _stBgMusic:SoundTransform;
		
		public function CardScrambleGame(){
			super();
		}
		
		private function initAssets():void{
			
			newHand();
			
			//cards
			_cardContainer.x = 180;
			_cardContainer.y = 168;
			addChild(_cardContainer);
			
			//setup text
			var texture:Texture = Texture.fromBitmap(new FontTexture());
			var xml:XML = XML(new FontXml());
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
			
			//timer
			_timerText = new TextField(200, 50, "Time: 60", "JandaManateeSolid", 30, 0xFFFFFF);
			_timerText.fontName = "JandaManateeSolid";
			_timerText.x = 90;
			_timerText.y = 30;
			_timerText.scaleX = _timerText.scaleY = 1.5;
			_timerText.touchable = false;
			addChild(_timerText);
			
			//score
			_scoreText = new TextField(250, 50, "Score: 0", "JandaManateeSolid", 30, 0xFFFFFF);
			_scoreText.fontName = "JandaManateeSolid";
			_scoreText.x = 320;
			_scoreText.y = 30;
			_scoreText.scaleX = _scoreText.scaleY = 1.5;
			_scoreText.touchable = false;
			addChild(_scoreText);
			
			//reward sequencer
			_rewardSequencer = new RewardSequencer();
			addChild(_rewardSequencer);
			
			//music and soundFx
			_soundIconsContainer = new Sprite();
			_soundIconsContainer.x = 725;
			_soundIconsContainer.y = 20;
			addChild(_soundIconsContainer);
			
			_musicIcon = new Image(_assets.getTexture("speakerIcon"));
			_musicIcon.name = "music";
			_soundIconsContainer.addChild(_musicIcon);
			
			_soundFxIcon = new Image(_assets.getTexture("musicNoteIcon"));
			_soundFxIcon.x = 50;
			_soundFxIcon.name = "soundFx";
			//_soundIconsContainer.addChild(_soundFxIcon);
			
			//sounds
			_stBgMusic = new SoundTransform();
			_stBgMusic.volume = 0.25;
			_assets.playSound("BgMusic", 0, 99, _stBgMusic);
		}
		
		private function newHand():void{
			
			//remove existing hand
			while(_cardContainer.numChildren > 0){
				_cardContainer.removeChildAt(0);
			}
			
			var cardNameCopy:Array = _data.cardNames.slice(0, _data.cardNames.length-1);
			var xVal:Number = 0;
			var yVal:Number = 0;
			var revealDelay:Number = 0;

			
			for (var i:int = 0; i < _data.NUM_CARDS_VERTICAL; i++) {
				
				for (var j:int = 0; j < _data.NUM_CARDS_HORIZONTAL; j++) {
					
					var ranNum:int = Math.random() * cardNameCopy.length;
					var cardString:String = cardNameCopy[ranNum];
					var cardVO:CardVO = new CardVO;
					var card:Card = new Card(cardString, cardVO);
					
					cardVO.suit = cardString.charAt(0);
					cardVO.value = cardString.substr(1, cardString.length);
					cardVO.verticalPos = i;
					cardVO.horizontalPos = j;

					_data.cardDict[card] = cardVO;
					
					card.x = xVal;
					card.y = yVal;
			
					_cardContainer.addChild(card);		
					cardNameCopy.splice(ranNum, 1);
					
					xVal += card.cardImage.width + 20;
					
					card.reveal(revealDelay);
					revealDelay += 0.1;
				}
				
				xVal = 0;
				yVal += card.cardImage.height + 25;
			}
		}
		
		private function resetHand():void{
			
			var len:int = _cardContainer.numChildren;
			for (var i:int = 0; i < len; i++) {
				var card:Card = _cardContainer.getChildAt(i) as Card;
				card.unselected();
			}
			
		}
		
		private function initListeners():void{
			_cardContainer.addEventListener(TouchEvent.TOUCH, onCardTouch);
			_data.addEventListener(CardScrambleGameData.UPDATE, onModelUpdate);
			_rewardSequencer.addEventListener(RewardSequencer.SEQUENCE_COMPLETE, onSequenceComplete);
			_soundIconsContainer.addEventListener(TouchEvent.TOUCH, onSoundIconTouch);
		}

		
		//================== PUBLIC METHODS =====================//
		
		override public function init(model:ISceneData):void{
			
			_data = model as CardScrambleGameData;
			
			initAssets();
			initListeners();
		}
		
		
		override public function pause():void{
			//stub
		}
		
		override public function close():void{
			//stub
		}
		
		
		
		//================== EVENT HANDLERS =====================//
		
		private function onCardTouch(e:TouchEvent):void{
			
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touchMoved){
				
				_mousePoint.x = touchMoved.globalX;
				_mousePoint.y = touchMoved.globalY;

				var len:int = _cardContainer.numChildren;
				for (var j:int = 0; j < len; j++) {
					
					var card:Card = _cardContainer.getChildAt(j) as Card;
					
					if(card.cardImage.hitTest(card.globalToLocal(_mousePoint)) && card.touchable){
						
						var cardVO:CardVO = _data.cardDict[card];
						
						card.touchable = false;
						card.selected();
						
						_data.cardSelected.push(cardVO);
						
						_assets.playSound(String("CardSelect" + _data.cardSelected.length), 0, 0, ST_SOUND_FX);
						
						if(_data.cardSelected.length > 1){
							
							_prevCard.showConnector(cardVO);
							_cardContainer.setChildIndex(card, _cardContainer.numChildren-1);
							
							if(_data.cardSelected.length == 5){
								
								_data.selectionComplete();
							}
						}
						
						_prevCard = card;
					}	
				}
			}
			
			if(touchEnded){
				
				var lenEnd:int = _cardContainer.numChildren;
				for (var i:int = 0; i < lenEnd; i++){
					var targetCard:Card = _cardContainer.getChildAt(i) as Card;
					
					targetCard.unselected();
				}
				
				_assets.playSound("DropHand", 0, 0, ST_SOUND_FX);
				_data.abortSelection();
			}
		}	
		
		private function onSoundIconTouch(e:TouchEvent):void{
			
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			//var touchHover:Touch = e.getTouch(this, TouchPhase.BEGAN);
			
			if(touchBegan){
				var icon:Image = e.target as Image;
				var filter:ColorMatrixFilter = new ColorMatrixFilter();
				
				if(GLOBAL_ST.volume == 0){
					
					icon.filter = null;
					GLOBAL_ST.volume = 1;
				} else {
					
					filter.adjustBrightness(0.75);
					icon.filter = filter;
					GLOBAL_ST.volume = 0;
				}
				
				SoundMixer.soundTransform = GLOBAL_ST;
			}
		}
		
		private function onModelUpdate(e:Event):void{
			
			switch(e.data.type){
				
				case CardScrambleGameData.TIMER_UPDATE:
					_timerText.text = String("Time: " + StringUtils.convertToHHMMSS(e.data.time));
					break;
				
				case CardScrambleGameData.TIMER_COMPLETE:
					_data.close();
					break;
				
				case CardScrambleGameData.ROUND_COMPLETE:
					_cardContainer.removeEventListener(TouchEvent.TOUCH, onCardTouch);
					_rewardSequencer.createSequence(e.data, _mousePoint);
					break;
				
				case CardScrambleGameData.UPDATE_SCORE:
					_scoreText.text = String("Score: " + e.data.score);
					break;
				
			}	
		}
		
		private function onSequenceComplete(e:Event):void{
			
			_data.MODE == 1 ? newHand() : resetHand();
			_cardContainer.addEventListener(TouchEvent.TOUCH, onCardTouch);
		}
		
		
	}
}