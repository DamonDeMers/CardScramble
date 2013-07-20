package com.abacus.common
{
	import flash.geom.Rectangle;
	
	public class Global
	{
		private static var m_instance:Global = null;
		
		//Bools
		private var _debug:Boolean;
		
		//viewport
		private var _viewPort:Rectangle;
		private var _viewPortWidth:Number;
		private var _viewPortHeight:Number;
		
		//stage
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		
		//device type
		private var _deviceType:String;
		private var _assetFolder:String;
		
		//Nums
		private var _scaleFactor:Number = 1;

		//orientaion
		private var _orientation:String;
		
		public function Global(enforcer:SingletonEnforcer)
		{
			if (enforcer == null)
			{
				throw Error("You are trying to create a new instance of a Singleton class.  Use Global.getInstance()");
			}
		}

		public static function getInstance():Global
		{
			if (m_instance == null)
			{
				m_instance = new Global( new SingletonEnforcer() );
			}
			return m_instance;
		}
		
		
		//=============== Getters and Setters ===============//
		
		public function get deviceType():String { return _deviceType; }
		public function set deviceType(deviceType:String):void { _deviceType = deviceType; }
		
		public function get assetFolder():String{ return _assetFolder; }
		public function set assetFolder(value:String):void{ _assetFolder = value; }
		
		public function get debug():Boolean { return _debug; }
		public function set debug(isDebug:Boolean):void { _debug = isDebug; }
		
		public function get orientation():String{ return _orientation; }
		public function set orientation(value:String):void { _orientation = value;}
		
		public function get scaleFactor():Number { return _scaleFactor; }
		public function set scaleFactor(scaleFactor:Number):void { _scaleFactor = scaleFactor; }
		
		public function get viewPort():Rectangle{return _viewPort;}
		public function set viewPort(value:Rectangle):void { _viewPort = value; }
		
		public function get viewPortWidth():Number { return _stageWidth; }
		public function set viewPortWidth(vWidth:Number):void { _viewPortWidth = vWidth; }
		
		public function get viewPortHeight():Number { return _stageHeight; }
		public function set viewPortHeight(vHeight:Number):void { _viewPortHeight = vHeight; }
		
		public function get stageWidth():Number { return _stageWidth; }
		public function set stageWidth(sWidth:Number):void { _stageWidth = sWidth; }
		
		public function get stageHeight():Number { return _stageHeight; }
		public function set stageHeight(sHeight:Number):void { _stageHeight = sHeight; }
		
	}
	
}


class SingletonEnforcer{}