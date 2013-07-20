package com.abacus.core
{	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.EventDispatcher;
	
	public class Model extends EventDispatcher{
		
		//event types
		public static const UPDATE:String = "update";
		
		//scene modes
		public static const INIT:String = "init";
		public static const NEXT_SCENE:String = "nextScene";
		public static const END_SCENE:String = "endScene";
		public static const CLOSE:String = "close";
		
		//scene states
		public static const PAUSE:String = "pause";
		
		//stage reference
		protected var _stage:Stage;
		
		//game schedule
		protected var _schedule:Vector.<SceneVO> = new Vector.<SceneVO>;
		protected var _scheduleCount:int = -1;
		
		//game data
		protected var _pause:Boolean = false;
		
		
		public function Model() {
			
		}
		
		
		//*************** Public Methods ****************//
		
		public function init():void{
			
			dispatchEventWith(UPDATE, true, {mode:INIT});
		}
		
		public function nextScene():void{
			
			dispatchEventWith(UPDATE, true, {mode:NEXT_SCENE});
		}
		
		public function endScene():void{
			
			dispatchEventWith(UPDATE, true, {mode:END_SCENE});
		}
		
		public function close():void{
			
			dispatchEventWith(UPDATE, true, {mode:CLOSE});
		}
		
		
		//************* Getters and Setters *******************//
		
		public function get schedule():Vector.<SceneVO> { return _schedule; }
		
		public function get scheduleCount():int { return _scheduleCount; }
		public function set scheduleCount(count:int):void {
			
			_scheduleCount = count; 
			dispatchEventWith(UPDATE, true, {mode:NEXT_SCENE});
		}
		
		public function get pause():Boolean { return _pause; }
		public function set pause(value:Boolean):void { 
			_pause = value;
			dispatchEventWith(UPDATE, true, {mode:PAUSE});
		}
		
		public function get stage():Stage{
			_stage = Starling.current.stage;
			return _stage;
		}
		
	}
}