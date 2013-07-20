package com.abacus.core
{
	import starling.display.Sprite;

	public interface IScene{
		
		function init(sceneData:ISceneData):void;
		function pause():void;
		function view():Sprite;
		function close():void;
	}
}