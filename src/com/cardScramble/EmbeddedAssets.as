package com.cardScramble
{
	public class EmbeddedAssets
	{
		
		//images
		[Embed(source = "../../assets/images/Assets.png")]
		public static const Assets:Class;
		
		[Embed(source = "../../assets/images/Cards.png")]
		public static const Cards:Class;
		
		[Embed(source="../../assets/images/Assets.xml", mimeType="application/octet-stream")]
		public static const AssetsXml:Class;
		
		[Embed(source="../../assets/images/Cards.xml", mimeType="application/octet-stream")]
		public static const CardsXml:Class;
		
		
		//sounds
		[Embed(source = "../../assets/sounds/achieve1.mp3")]
		public static const Achieve1:Class;
		
		[Embed(source = "../../assets/sounds/achieve2.mp3")]
		public static const Achieve2:Class;
		
		[Embed(source = "../../assets/sounds/applause.mp3")]
		public static const Applause:Class;
		
		[Embed(source = "../../assets/sounds/bgMusic.mp3")]
		public static const BgMusic:Class;
		
		[Embed(source = "../../assets/sounds/cardFlip.mp3")]
		public static const CardFlip:Class;
		
		[Embed(source = "../../assets/sounds/cardSelect1.mp3")]
		public static const CardSelect1:Class;
		
		[Embed(source = "../../assets/sounds/cardSelect2.mp3")]
		public static const CardSelect2:Class;
		
		[Embed(source = "../../assets/sounds/cardSelect3.mp3")]
		public static const CardSelect3:Class;
		
		[Embed(source = "../../assets/sounds/cardSelect4.mp3")]
		public static const CardSelect4:Class;
		
		[Embed(source = "../../assets/sounds/cardSelect5.mp3")]
		public static const CardSelect5:Class;
		
		[Embed(source = "../../assets/sounds/coinDrop.mp3")]
		public static const CoinDrop:Class;
		
		[Embed(source = "../../assets/sounds/coinRedeem.mp3")]
		public static const CoinRedeem:Class;
		
		[Embed(source = "../../assets/sounds/dropHand.mp3")]
		public static const DropHand:Class;
		
		[Embed(source = "../../assets/sounds/lose.mp3")]
		public static const Lose:Class;
		
		[Embed(source = "../../assets/sounds/noValidHand.mp3")]
		public static const NoValidHand:Class;
		
		[Embed(source = "../../assets/sounds/selectionComplete.mp3")]
		public static const SelectionComplete:Class;
		
		
		public function EmbeddedAssets(){
		}
	}
}