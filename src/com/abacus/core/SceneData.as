package com.abacus.core
{
	import starling.events.EventDispatcher;
	
	public class SceneData extends EventDispatcher implements ISceneData{

		
		public function SceneData(){
			super();
		}
		
		public function init():void{
			throw new Error("SceneData is an abstract class.  The init() method should be implemented by the subclass"); 
		}
		
		public function pause():void{
			throw new Error("SceneData is an abstract class.  The pause() method should be implemented by the subclass"); 
		}
		
		public function close():void{
			throw new Error("SceneData is an abstract class.  The close() method should be implemented by the subclass"); 
		}
	}
}