package com.abacus.scenes.loader
{	
	import com.abacus.core.ISceneData;
	import com.abacus.core.Scene;
	import com.abacus.utils.ImageUtils;
	
	import feathers.controls.ProgressBar;
	
	import starling.core.Starling;

	
	public class Loader extends Scene{
		
		//data
		private var _sceneData:ISceneData;
		
		//assets
		protected var _progressBar:ProgressBar;
		
		
		public function Loader(){
			super();
		}
		
		override public function init(sceneData:ISceneData):void{
			_sceneData = sceneData;
			
			_progressBar = new ProgressBar();
			_progressBar.x = ImageUtils.centerStageX(_progressBar) - 67;
			_progressBar.y = ImageUtils.centerStageY(_progressBar);
			addChild(_progressBar);
			
			
			_assets.loadQueue(function(ratio:Number):void
			{
				_progressBar.value = ratio;
				
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						removeChild(_progressBar);
						
						_sceneData.close();
					}, 0.15);
			});	
		}
		
		override public function close():void{
			
		}
		
	}
}