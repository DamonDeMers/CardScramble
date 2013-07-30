package com.cardScramble.scenes.game
{
	import com.abacus.assetManager.AssetManager;
	import com.abacus.core.ISceneData;
	import com.abacus.scenes.game.Game;
	import com.cardScramble.scenes.game.data.CardScrambleGameData;
	import com.cardScramble.scenes.game.data.GameBoard;
	import com.cardScramble.utils.StringUtils;
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
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
	
	public class CardScrambleGame extends Game{
		
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
		private var _gameBoard:GameBoard;
		private var _rewardSequencer:RewardSequencer;
		private var _powerUps:PowerUps;
		//private var _timer:RoundTimer;
		
		//hud
		private var _soundIconsContainer:Sprite;
		private var _musicIcon:Image;
		private var _soundFxIcon:Image;
		
		//text
		private var _timerText:TextField;
		private var _scoreText:TextField;
		
		//data
		private var _prevCard:Card;
		
		//sounds
		private var _stBgMusic:SoundTransform;
		
		
		
		
		public function CardScrambleGame(){
			super();
		}
		
		private function initAssets():void{
		
			//cards
			_gameBoard = new GameBoard(_data);
			_gameBoard.x = 175;
			_gameBoard.y = 162;
			addChild(_gameBoard);
			
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
			
			//power ups
			_powerUps = new PowerUps();
			_powerUps.x = 710;
			_powerUps.y = 150;
			addChild(_powerUps);
			
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
		
		
		
		private function initListeners():void{
			
			_data.addEventListener(CardScrambleGameData.UPDATE, onModelUpdate);
			_powerUps.addEventListener(PowerUps.UPDATE, onPowerUpUpdate);
			_rewardSequencer.addEventListener(RewardSequencer.SEQUENCE_COMPLETE, onSequenceComplete);
			_soundIconsContainer.addEventListener(TouchEvent.TOUCH, onSoundIconTouch);
		}

		private function initGame():void{
			_gameBoard.newHand();
			
			//_powerUps.add(PowerUpTypes.SHUFFLE);
			//_powerUps.add(PowerUpTypes.SCORE2X);
			//_powerUps.add(PowerUpTypes.HOLD3);
		}
		
		
		//================== PUBLIC METHODS =====================//
		
		override public function init(model:ISceneData):void{
			
			_data = model as CardScrambleGameData;
			
			initAssets();
			initListeners();
			initGame();
		}
		
		
		override public function pause():void{
			//stub
		}
		
		override public function close():void{
			//stub
		}
		
		
		
		//================== EVENT HANDLERS =====================//
		
		private function onSoundIconTouch(e:TouchEvent):void{
			
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			
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
					_gameBoard.inactivate();
					_rewardSequencer.createSequence(e.data, GameBoard.MOUSE_POINT);
					if(_data.roundCount % 5 == 0){
						_powerUps.add(PowerUpTypes.SHUFFLE);
					}
					break;
				
				case CardScrambleGameData.UPDATE_SCORE:
					_scoreText.text = String("Score: " + e.data.score);
					break;
			}	
		}
		
		private function onPowerUpUpdate(e:Event):void{
			
			var type:String = e.data.type;
			
			switch(type){
				
				case PowerUps.SHUFFLE:
					_gameBoard.shuffleDeck();
					break;
				
				case PowerUps.SCORE2X:
					_data.scoreMultiplier = 2;
					break;
				
				case PowerUps.HOLD3:
					_gameBoard.holdThree();
					break;
			}
		}
		
		
		
		private function onSequenceComplete(e:Event):void{
			
			_data.MODE == 1 ? _gameBoard.newHand() : _gameBoard.resetHand();
			_gameBoard.activate();
		}
		
		
	}
}