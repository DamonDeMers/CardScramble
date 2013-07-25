package com.cardScramble.utils
{
	public class StringUtils
	{
		public function StringUtils(){
		}
		
		public static function convertToHHMMSS($seconds:Number):String
		{
			var s:Number = $seconds % 60;
			var m:Number = Math.floor(($seconds % 3600 ) / 60);
			var h:Number = Math.floor($seconds / (60 * 60));
			
			var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
			var minuteStr:String = doubleDigitFormat(m) + ":";
			var secondsStr:String = doubleDigitFormat(s);
			
			function doubleDigitFormat($num:uint):String{
				if ($num < 10)
				{
					return ("0" + $num);
				}
				return String($num);
			}
			
			return hourStr + minuteStr + secondsStr;
		}
		
	}
}