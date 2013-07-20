package com.abacus.common
{
	import flash.system.Capabilities;
	
	public class DeviceType extends Object
	{
		
		public static const DESKTOP:String = "desktop";
		public static const IPAD3:String = "ipad3";
		public static const IPAD2:String = "ipad2";
		public static const IPAD1:String = "ipad1";
		public static const IPHONE5:String = "iphone5";
		public static const IPHONE4:String = "iphone4";
		public static const IPHONE3:String = "iphone3";
		public static const ANDROID:String = "android";
		
		public function DeviceType()
		{
			
		}
		
		public static function getType():String
		{
			var myOS:String = Capabilities.os;
			var deviceType:String = myOS.toLowerCase();
			var deviceStringArray:Array = deviceType.split(" ");
			
			deviceType = deviceStringArray.pop();
			
			if(deviceType.indexOf(",") > -1)
			{
				deviceType = deviceType.split(",").shift();	
			}
			else if(deviceType == "10.8.2") //temp, refers to mac OS version. 
			{
				deviceType = DESKTOP;
			}
			else if(deviceType == "3.0.8-985684")
			{
				deviceType = ANDROID;
			}
			
			return deviceType;
		}
		
	}
	
}


