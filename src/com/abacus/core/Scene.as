package com.abacus.core
{
	import com.abacus.assetManager.AssetManager;
	
	import starling.display.Sprite;
	
	public class Scene extends Sprite implements IScene{
		
		protected var _assets:AssetManager = AssetManager.getInstance();
		
		public function Scene(){
			super();
		}
		
		public function init(model:ISceneData):void{
			
			throw new Error("Scene is an abstract class.  The init method should be implemented by the subclass");  
		}
		
		public function pause():void{
			
			throw new Error("Scene is an abstract class.  The pause method should be implemented by the subclass");
		}
		
		public function view():Sprite{
			return this;
		}
		
		public function close():void{
			
			throw new Error("Scene is an abstract class.  The close method should be implemented by the subclass");
		}
	}
}