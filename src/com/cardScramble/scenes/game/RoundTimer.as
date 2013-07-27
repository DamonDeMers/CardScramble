package com.cardScramble.scenes.game
{
	import com.abacus.assetManager.AssetManager;
	import com.greensock.TweenLite;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class RoundTimer extends Sprite
	{
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//assets
		private var _timerLine:Image;
		
		//data
		private var _endPercentage:Number;
		
		public function RoundTimer(){
			_timerLine = new Image(_assets.getTexture("timer"));
			_timerLine.pivotY = _timerLine.height;
			_timerLine.y += _timerLine.height;
			addChild(_timerLine);
		}
		
		public function start(time:Number = 20):void{
			TweenLite.to(_timerLine, time, {scaleY:0, onUpdate:onTimerUpdate});
		}
		
		private function onTimerUpdate():void{
			_endPercentage = _timerLine.scaleY;
		}
		
		public function stop():void{
			TweenLite.killTweensOf(_timerLine);
		}
		
		public function reset():void{
			TweenLite.killTweensOf(_timerLine);
			TweenLite.to(_timerLine, 0.25, {scaleY:1});
		}
		
		
		//=========== GETTERS AND SETTERS ==============//
		
		public function get endPercentage():Number{
			return _endPercentage;
		}

	}
}