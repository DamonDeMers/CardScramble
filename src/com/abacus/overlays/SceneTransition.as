package com.abacus.overlays
{
	import com.abacus.common.Global;
	import com.greensock.TweenLite;
	
	import starling.display.Shape;
	import starling.display.Sprite;

	
	public class SceneTransition extends Sprite
	{
		private static var _instance:SceneTransition = new SceneTransition();
		
		private var _global:Global = Global.getInstance();
		private var _transitionContainer:Sprite;
		
		public function SceneTransition()
		{
			if(_instance){
				throw new Error ("Singleton class, use getInstance()");
			}
		}
		
		public function init(targetLayer:Sprite):void{
			
			_transitionContainer = new Sprite();
			
			var shape:Shape = new Shape();
			_transitionContainer.addChild(shape);	
			
			shape.graphics.beginFill(0x000000, 1);
			shape.graphics.drawRect(0, 0, _global.stageWidth, _global.stageHeight);
			shape.graphics.endFill();

			_transitionContainer.alpha = 0;
			_transitionContainer.visible = false;
			targetLayer.addChild(_transitionContainer);
		}
		
		public function fadeIn(duration:Number):void{
			
			TweenLite.to(_transitionContainer, duration, {alpha:0, onComplete:toggleVisibility});
		}
		
		public function fadeOut(duration:Number):void{
			
			_transitionContainer.visible == false ? _transitionContainer.visible = true: null;
			TweenLite.to(_transitionContainer, duration, {alpha:1});
		}
		
		private function toggleVisibility():void{
			
			_transitionContainer.visible = false;
		}
		
		public static function getInstance():SceneTransition{
			
			return _instance;
		}
	}
}
