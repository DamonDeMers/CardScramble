package com.abacus.core
{
	import com.abacus.assetManager.AssetManager;
	import com.abacus.overlays.SceneTransition;
	import com.feathers.themes.AzureMobileTheme;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Shell extends Sprite{
		
		//framework managers
		protected var _assets:AssetManager = AssetManager.getInstance();
		protected var _transitionMgr:SceneTransition = SceneTransition.getInstance();
		
		//layers
		protected var _bg:Sprite;
		protected var _sceneLayer:Sprite;
		protected var _hud:Sprite;
		protected var _transitionLayer:Sprite;
		
		//theme
		protected var _theme:AzureMobileTheme;
		
		//data
		protected var _model:Model;
		
		//scene
		protected var _scene:IScene;
		protected var _sceneData:ISceneData;		
		
		public function Shell(){
			super();
		}
		
		public function init(model:Model, bgTexture:Texture):void{
			
			this._theme = new AzureMobileTheme(this.stage);
		
			_model = model;
			
			_bg = new Sprite();
			_bg.addChild(new Image(bgTexture));
			_bg.flatten();
			addChild(_bg);
			
			_sceneLayer = new Sprite();
			addChild(_sceneLayer);
			
			_hud = new Sprite();
			addChild(_hud);
			
			_transitionLayer = new Sprite();
			addChild(_transitionLayer);
			
			_transitionMgr.init(_transitionLayer);
			
			_model.addEventListener(Model.UPDATE, onModelUpdate);
		}
		
		protected function onModelUpdate(e:Event):void{
			
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
				
				case Model.PAUSE:
					_scene.pause();
					break;
				
				case Model.CLOSE:
					break;
			}
		}
	}
}