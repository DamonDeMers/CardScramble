package com.abacus.utils
{

	public class MathUtils
	{
		public function MathUtils()
		{
		}
		
		/*
		* Returns a random number within the exclusionary range of the target number, without exceeding the min or max values
		*/
		public static function randomNumberInRange(targetNumber:Number, maxVal:Number, minVal:Number, exclusionRange:Number):Number 
		{
			var returnNum:Number;
			var aboveThresh:Number = maxVal - (targetNumber + exclusionRange); 
			var belowThresh:Number = minVal - (targetNumber - exclusionRange); 
			var ranNum:Number = Math.random() * (Math.abs(aboveThresh) + Math.abs(belowThresh));
			
			//error checking
			if(targetNumber > maxVal)
			{
				throw new Error("[randomNumberInRange]: Target number must not exceed max value");
			}
			if(exclusionRange > (Math.abs(aboveThresh) + Math.abs(belowThresh)/2))
			{
				throw new Error("[randomNumberInRange]: Exclusion range is too large");
			}
			
			//return val logic
			if(ranNum < Math.abs(belowThresh))
			{
				returnNum = (Math.random() * belowThresh) + (minVal - belowThresh);
			}
			else if (ranNum > Math.abs(belowThresh))
			{
				returnNum = (Math.random() * aboveThresh) + (targetNumber + exclusionRange);
			}
			
			return returnNum;
		}
	}
}