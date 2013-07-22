package com.cardScramble.view
{
	import com.abacus.assetManager.AssetManager;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	TweenPlugin.activate([BezierPlugin]);
	
	public class RewardSequencer extends Sprite
	{
		[Embed(source="../../../assets/fonts/JandaManateeSolid.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../../assets/fonts/JandaManateeSolid.png")]
		public static const FontTexture:Class;
		
		[Embed(source="../../../assets/particles/coins.pex", mimeType="application/octet-stream")]
		private static const _pdSwipePEX:Class;
		
		[Embed(source = "../../../assets/particles/coins.png")]
		private static const _pdSwipePNG:Class;
		
		//consts
		public static const SEQUENCE_COMPLETE:String = "sequenceComplete";
		
		//global
		private var _assets:AssetManager = AssetManager.getInstance();
		
		//text
		private var _messageText:TextField;
		private var _message2Text:TextField;
		
		//particle
		private var _particles:PDParticleSystem;
		private var _psSwipeXML:XML;
		private var _psSwipeTexture:Texture;
		
		
		public function RewardSequencer(){
			
			initAssets();
		}
		
		
		private function initAssets():void{
			
			//message 1
			_messageText = new TextField(300, 50, "Message", "JandaManateeSolid", 30, 0xFFFFFF);
			_messageText.fontName = "JandaManateeSolid";
			_messageText.hAlign = HAlign.CENTER;
			_messageText.pivotX = _messageText.width/2;
			_messageText.pivotY = _messageText.height/2;
			_messageText.x = 400;
			_messageText.y = 250;
			_messageText.alpha = 0;
			_messageText.touchable = false;
			addChild(_messageText);
			
			//message 2
			_message2Text = new TextField(300, 50, "Message", "JandaManateeSolid", 30, 0xFFFFFF);
			_message2Text.fontName = "JandaManateeSolid";
			_message2Text.hAlign = HAlign.CENTER;
			_message2Text.pivotX = _message2Text.width/2;
			_message2Text.pivotY = _message2Text.height/2;
			_message2Text.x = 350;
			_message2Text.y = 375;
			_message2Text.alpha = 0;
			_message2Text.touchable = false;
			addChild(_message2Text);
			
			//swipe particle system
			_psSwipeXML = XML(new _pdSwipePEX());
			_psSwipeTexture = Texture.fromBitmap(new _pdSwipePNG());
			_particles = new PDParticleSystem(_psSwipeXML, _psSwipeTexture);
			_particles.x = Starling.current.stage.stageWidth/2;
			_particles.y = Starling.current.stage.stageHeight;
			addChild(_particles);
			Starling.juggler.add(_particles);
		}
		
		
		//=============== PUBLIC METHODS ================//
		
		public function createSequence(data:Object, endPoint:Point):void{
			
			//messages
			_messageText.text = String(data.hand + "!");
			_message2Text.text = String(" +" + data.score);
			TweenMax.to(_messageText, 0.5, {alpha:1, scaleX:4, scaleY:4, onComplete:onMessageComplete, onCompleteParams:[data, endPoint]});
			TweenMax.to(_message2Text, 0.5, {delay:0.25, alpha:1, scaleX:4, scaleY:4});
			
			//particles
			if(data.handInt > 2){
				_particles.start(data.handInt/10);
			}
			
		}
		
		private function onMessageComplete(data:Object, endPoint:Point):void{
			
			//coins
			var len:int = int(data.handInt * 2);
			for (var i:int = 0; i < len; i++) {
				
				//coin
				var coin:MovieClip = new MovieClip(_assets.getTextures("coin_"), 30);
				var tweenDelay:Number = (Math.random() * 1.5) + (data.handInt > 2 ? data.handInt/5 : 0);
				
				coin.x = endPoint.x;
				coin.y = endPoint.y;
				coin.alpha = 0;
				coin.filter = BlurFilter.createDropShadow();

				Starling.juggler.add(coin);
				addChild(coin);
				
				coin.play();
				
				TweenLite.to(coin, 1, {delay:tweenDelay, bezier:[{x:650, y:250}, {x:400, y:30}], onStart:onCoinStart, onStartParams:[coin], onComplete:removeCoin, onCompleteParams:[coin]}); //makes my_mc travel through 250,50 and end up at 500,0. 	
			}
			
			
			//remove messages
			TweenMax.to(_messageText, 0.5, {alpha:0, onComplete:onSequenceComplete});
			TweenMax.to(_message2Text, 0.5, {alpha:0});
		}
		
		private function onCoinStart(coin:MovieClip):void{
			
			coin.alpha = 1;
		}
		
		private function removeCoin(coin:MovieClip):void{
			
			removeChild(coin);
		}
		
		private function onSequenceComplete():void{
			
			//reset message text
			_messageText.scaleX = _messageText.scaleY = 1;
			_message2Text.scaleX = _message2Text.scaleY = 1;
			
			dispatchEventWith(SEQUENCE_COMPLETE, true);
		}
		
		
	}
}