package com.cardScramble.core
{
	import com.abacus.core.IScene;
	import com.abacus.core.ISceneData;
	import com.abacus.core.Model;
	import com.abacus.core.Shell;
	import com.cardScramble.hud.Hud;
	import com.feathers.themes.AzureMobileTheme;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class CardScrambleShell extends Shell{
		
		//HUD
		private var _hud:Hud = Hud.getInstance();
		
		
		public function CardScrambleShell(){
			super();
		}
		
		override public function init(model:Model, bgTexture:Texture):void{
			
			this._theme = new AzureMobileTheme(this.stage);
			
			_model = model;
			
			_bg = new Sprite();
			_bg.addChild(new Image(bgTexture));
			_bg.flatten();
			addChild(_bg);
			
			_sceneLayer = new Sprite();
			addChild(_sceneLayer);
			
			_hud.init();
			addChild(_hud);
			
			_transitionLayer = new Sprite();
			addChild(_transitionLayer);
			
			_transitionMgr.init(_transitionLayer);
			
			_model.addEventListener(Model.UPDATE, onModelUpdate);
		}
		
		
		override protected function onModelUpdate(e:Event):void{
			
			var mode:String = e.data.mode;
			
			switch(mode){
				
				case Model.INIT:
					_model.scheduleCount++;
					break;
				
				case Model.NEXT_SCENE: 
					_sceneData = _model.schedule[_model.scheduleCount].data as ISceneData;
					_sceneData.init();
					
					_scene = _model.schedule[_model.scheduleCount].view as IScene;
					_scene.init(_sceneData);
					
					_sceneLayer.addChild(_scene.view());
					break;
				
				case Model.END_SCENE:
					_scene.close();
					_sceneLayer.removeChild(_scene.view());
					_model.scheduleCount++;
					break;
				
				case CardScrambleModel.GOTO_SCENE:
					_scene.close();
					_sceneLayer.removeChild(_scene.view());
					
					_model.scheduleCount = e.data.sceneIndex;
					break;
				
				case Model.PAUSE:
					_scene.pause();
					break;
				
				case Model.CLOSE:
					break;
			}
		}
		
	}
}