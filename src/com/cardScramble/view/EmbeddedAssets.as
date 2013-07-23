package com.cardScramble.view
{
	public class EmbeddedAssets
	{
		[Embed(source = "../../../assets/images/Assets.png")]
		public static const Assets:Class;
		
		[Embed(source = "../../../assets/images/Cards.png")]
		public static const Cards:Class;
		
		[Embed(source="../../../assets/images/Assets.xml", mimeType="application/octet-stream")]
		public static const AssetsXml:Class;
		
		[Embed(source="../../../assets/images/Cards.xml", mimeType="application/octet-stream")]
		public static const CardsXml:Class;
		
		
		
		public function EmbeddedAssets()
		{
		}
	}
}