package com.abacus.utils
{
	import com.abacus.common.Global;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;


	public class ImageUtils
	{
		public function ImageUtils()
		{
		}
		
		public static function centerStageX(image:DisplayObject):Number //Todo:  Consider pivotX in the calculations
		{
			var stageWidth:Number = Global.getInstance().stageWidth;
			var centerX:Number = (stageWidth/2 - image.width/2);
			
			return centerX;
		}
		
		public static function centerStageY(image:DisplayObject):Number //Todo:  Consider pivotY in the calculations
		{
			var stageHeight:Number = Global.getInstance().stageHeight;
			var centerY:Number = stageHeight/2 - image.height/2;
			
			return centerY;
		}
		
		public static function centerRelativeX(image:DisplayObject, targetImage:DisplayObject):Number
		{
			var centerX:Number = (targetImage.width/2 - image.width/2) + targetImage.x;
			
			return centerX;
		}
		
		public static function centerRelativeY(image:DisplayObject, targetImage:DisplayObject):Number
		{
			var targetY:Number = targetImage.parent.localToGlobal(new Point(targetImage.x, targetImage.y)).y;
			
			
			var centerY:Number = targetY + (targetImage.height- image.height)/2;
			trace("Target image.y: " + targetImage.parent.localToGlobal(new Point(targetImage.x, targetImage.y)).y );
			
			return centerY;
		}
		
		public static function randomX():Number		
		{
			return Math.random() * Global.getInstance().stageWidth; 
		}
		
		public static function randomY():Number
		{
			return Math.random() * Global.getInstance().stageHeight; 
		}
		
	}
}