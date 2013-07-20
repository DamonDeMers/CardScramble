package com.abacus.utils
{
	import com.abacus.common.Constants;
	import com.abacus.common.Global;
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import starling.utils.RectangleUtil;

	public class StartUpUtils
	{
		
		public static function setStartupParams(stage:Stage, aspectRatio:String):void
		{	
			var global:Global = Global.getInstance();
			var scale:int;
				
			if(aspectRatio == Constants.PORTRAIT)
			{
				if(stage.fullScreenWidth <= Constants.IPHONE3_WIDTH_PORTRAIT)
				{
					scale = 1; 
				}
				else if(stage.fullScreenWidth > Constants.IPHONE3_WIDTH_PORTRAIT && stage.fullScreenWidth <= Constants.IPHONE4_WIDTH_PORTRAIT)
				{
					scale = 2;
				}
				else if(stage.fullScreenWidth > Constants.IPHONE4_WIDTH_PORTRAIT)
				{
					scale = 4;
				}	
			}
			else if(aspectRatio == Constants.LANDSCAPE)
			{
				if(stage.fullScreenWidth <= Constants.IPHONE3_WIDTH_LANDSCAPE)
				{
					scale = 1; 
				}
				else if(stage.fullScreenWidth > Constants.IPHONE3_WIDTH_LANDSCAPE && stage.fullScreenWidth <= Constants.IPHONE4_WIDTH_LANDSCAPE)
				{
					scale = 2;
				}
				else if(stage.fullScreenWidth > Constants.IPHONE5_WIDTH_LANDSCAPE)
				{
					scale = 4;
				}
			}
			
			switch(scale){
				
				case 1:
					global.stageWidth = stage.fullScreenWidth;
					global.stageHeight = stage.fullScreenHeight;
					global.assetFolder = Constants.ASSETS_1X;
					global.scaleFactor = 1;
					break;
				
				case 2:
					global.stageWidth = stage.fullScreenWidth / 2;
					global.stageHeight = stage.fullScreenHeight / 2;
					global.assetFolder = Constants.ASSETS_2X;
					global.scaleFactor = 2;
					break;
				
				case 4:
					global.stageWidth = stage.fullScreenWidth / 4;
					global.stageHeight = stage.fullScreenHeight / 4;
					global.assetFolder = Constants.ASSETS_4X;
					global.scaleFactor = 4;
					break;
				
				default:
					global.stageWidth = stage.fullScreenWidth / 2;
					global.stageHeight = stage.fullScreenHeight / 2;
					global.assetFolder = Constants.ASSETS_2X;
					global.scaleFactor = 2;
					break;
			}
			
			global.viewPort = RectangleUtil.fit(
				new Rectangle(0, 0, global.stageWidth, global.stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			
		}
	}
}