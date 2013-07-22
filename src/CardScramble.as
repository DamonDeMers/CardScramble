package
{
	import com.abacus.assetManager.AssetManager;
	import com.abacus.common.Global;
	import com.cardScramble.data.Model;
	import com.cardScramble.view.View;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
	[SWF(width = "800", height = "580", frameRate = "60", backgroundColor = "#000000")]
	
	public class CardScramble extends Sprite {
		
		[Embed(source = "assets/images/bg.png")]
		private static var Background:Class;
		
		private var _background:Bitmap;
		
		//starlig
		private var _mStarling:Starling;
		
		//assets
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//global
		private var _global:Global = Global.getInstance();
		private var _debug:Boolean;
		
		private var _view:View;
		private var _model:Model = new Model();
		
		
		public function CardScramble() {
			
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true; 
			Starling.handleLostContext = !iOS;  

			var appDir:File = File.applicationDirectory;
			_assets.verbose = Capabilities.isDebugger;
			_assets.enqueue(
				appDir.resolvePath("assets/images/")
			);
			
			
			_background = new Background();
			_background.smoothing = true;
			addChild(_background);
			
			// launch Starling
			_mStarling = new Starling(View, stage);
			_mStarling.simulateMultitouch  = false;
			_mStarling.enableErrorChecking = false;
			_mStarling.showStats = true;
			
			_mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onStarlingRootCreated);
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { _mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { _mStarling.stop(); });
		}
		
		
		private function onStarlingRootCreated(e:starling.events.Event):void{
			
			_view = _mStarling.root as View;
			_assets.loadQueue(onAssetsProgress);
		}
		
		private function onAssetsProgress(ratio:Number):void{
			
			var percentage:int = ratio * 100;
			
			if (ratio == 1){
				onAssetsLoadComplete();
			}
			
			trace("Loading " + percentage + "%");
		}
		
		private function onAssetsLoadComplete():void{
			
			var bgTexture:Texture = Texture.fromBitmap(_background, false, false);
			
			removeChild(_background);
			
			_view.init(_model, bgTexture);
			_mStarling.start();
		}
		
	}
}