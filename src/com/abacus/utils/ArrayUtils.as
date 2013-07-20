package com.abacus.utils
{
	import flash.media.Sound;

	public class ArrayUtils
	{
		public function ArrayUtils()
		{
		}
		
		public static function removeDuplicates(vector:Vector.<Sound>):Vector.<Sound>{
			
			var tempVect:Vector.<Sound> = vector.concat();
			var i: int;  
			var j: int;
			
			for (i = 0; i < tempVect.length - 1; i++)  
			{  
				for (j = i + 1; j < tempVect.length; j++)  
				{  
					if (tempVect[i] === tempVect[j])  
					{  
						tempVect.splice(j, 1);
						j--;
					}  
				}  
			}
			
			return tempVect; 
		}
		
		public static function removeDups(vector:Vector.<Sound>):Vector.<Sound>{
			
			var arr:Vector.<Sound> = vector.concat();
			
			arr.filter(function(e:*, i:int, a:Vector.<Sound>):Boolean 
			{
				return a.indexOf(e) == i;
			}
			);
			
			return new Vector.<Sound>;
		}
		
		
	}
}