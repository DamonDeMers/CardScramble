package com.cardScramble.scenes.game
{
	import com.abacus.assetManager.AssetManager;
	import com.abacus.core.ISceneData;
	import com.abacus.scenes.game.Game;
	import com.cardScramble.hud.Hud;
	import com.cardScramble.scenes.game.data.CardScrambleGameData;
	import com.cardScramble.scenes.game.data.GameBoard;
	import com.cardScramble.scenes.store.data.StoreItemVO;
	import com.cardScramble.utils.BoardEvaluator;
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class CardScrambleGame extends Game{
		
		[Embed(source="../../../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;	
		
		
		//singletons
		private var _assets:AssetManager = AssetManager.getInstance();
		private var _hud:Hud = Hud.getInstance();

		//model
		private var _data:CardScrambleGameData;
		
		//assets
		private var _gameBoard:GameBoard;
		private var _rewardSequencer:RewardSequencer;
		private var _powerUps:PowerUps;
		
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
		
		//utils
		private var _boardEval:BoardEvaluator = new BoardEvaluator();
		
		
		
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

			//power ups
			_powerUps = new PowerUps();
			_powerUps.x = 710;
			_powerUps.y = 150;
			addChild(_powerUps);
			
			//reward sequencer
			_rewardSequencer = new RewardSequencer();
			addChild(_rewardSequencer);
			
			//sounds
			_stBgMusic = new SoundTransform();
			_stBgMusic.volume = 0.25;
			_assets.playSound("BgMusic", 0, 99, _stBgMusic);
		}
		
		private function initListeners():void{
			
			_data.addEventListener(CardScrambleGameData.UPDATE, onModelUpdate);
			_powerUps.addEventListener(PowerUps.UPDATE, onPowerUpUpdate);
			_rewardSequencer.addEventListener(RewardSequencer.SEQUENCE_COMPLETE, onSequenceComplete);
		}

		private function initGame():void{
			
			_hud.showHud();
			_hud.updateScore(_data.score);
			initPowerUps();
			
			_gameBoard.newHand();
			
			_boardEval.getHighestHand(_data.gameBoardCards);
		}
		
		private function initPowerUps():void{
			
			var len:int = _data.powerUps.length;
			
			for (var i:int = 0; i < len; i++) {
				
				var storeItemVO:StoreItemVO = _data.powerUps[i] as StoreItemVO;
				
				_powerUps.add(storeItemVO.itemType);
			}
			
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
			
			SoundMixer.stopAll();
			_gameBoard.reset();
		}
		
		
		
		//================== EVENT HANDLERS =====================//
		
		private function onModelUpdate(e:Event):void{
			
			switch(e.data.type){
				
				case CardScrambleGameData.TIMER_UPDATE:
					_hud.updateTimer(e.data.time);
					break;
				
				case CardScrambleGameData.TIMER_COMPLETE:
					_data.close();
					break;
				
				case CardScrambleGameData.ROUND_COMPLETE:
					_gameBoard.inactivate();
					_rewardSequencer.createSequence(e.data, GameBoard.MOUSE_POINT);
					if(_data.roundCount == 4){
						_powerUps.add(PowerUpTypes.SHUFFLE);
					}
					break;
				
				case CardScrambleGameData.UPDATE_SCORE:
					_hud.updateScore(e.data.score);
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
			
			_data.powerUpActivated(type);
		}
		
		private function onSequenceComplete(e:Event):void{
			
			_data.MODE == 1 ? _gameBoard.newHand() : _gameBoard.resetHand();
			_boardEval.getHighestHand(_data.gameBoardCards);
			_gameBoard.activate();
		}
		
		
	}
}