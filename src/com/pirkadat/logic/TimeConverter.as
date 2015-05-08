package com.pirkadat.logic 
{
	
	/**
	 * Converts milliseconds in numbers to string represetation.
	 * @author András Parditka
	 */
	public class TimeConverter 
	{
		/**
		 * Automatic.
		 */
		public static const AUTO:String = 'Auto';
		
		/**
		 * This format will result in 'ss.ss'.
		 */
		public static const SECONDS:String = 'Seconds';
		
		/**
		 * This format will result in 'mm:ss'.
		 */
		public static const MINUTES_SECONDS:String = 'Minutes:Seconds';
		
		/**
		 * This format will result in 'hh:mm'.
		 */
		public static const HOURS_MINUTES:String = 'Hours:Minutes';
		
		/**
		 * This format will result in 'hh:mm:ss'.
		 */
		public static const HOURS_MINUTES_SECONDS:String = 'Hours:Minutes:Seconds';
		
		/**
		 * Convert milliseconds to a string representation.
		 * @param	ms
		 * Milliseconds.
		 * @param	format
		 * Format of string.
		 * @return
		 * String representation.
		 */
		public static function msToTime(ms:int, format:String = 'Minutes:Seconds'):String
		{
			var sec:String;
			var min:String;
			var hour:String;
			var result:String = '';
			
			if (ms < 0) result = '-';
			ms = Math.abs(ms);
			
			switch (format)
			{
				case SECONDS:
					result += String(Math.floor(ms / 10) * .01);
				break;
				
				case MINUTES_SECONDS:
					sec = String(Math.floor((ms % 60000) / 1000));
					if (sec.length < 2) sec = '0' + sec;
					
					min = String(Math.floor(ms / 60000));
					if (min.length < 2) min = '0' + min;
					
					result += min + ':' + sec;
				break;
				
				case HOURS_MINUTES:
					min = String(Math.floor((ms % 360000) / 60000));
					if (min.length < 2) min = '0' + min;
					
					hour = String(Math.floor(ms / 360000));
					if (hour.length < 2) hour = '0' + hour;
					
					result += hour + ':' + min;
				break;
				
				case HOURS_MINUTES_SECONDS:
					sec = String(Math.floor((ms % 60000) / 1000));
					if (sec.length < 2) sec = '0' + sec;
					
					min = String(Math.floor((ms % 360000) / 60000));
					if (min.length < 2) min = '0' + min;
					
					hour = String(Math.floor(ms / 360000));
					if (hour.length < 2) hour = '0' + hour;
					
					result += hour + ':' + min + ':' + sec;
				break;
				
				default:
					throw new Error('Format not recognized: '+format);
			}
			
			return result;
		}
		
		/**
		 * Convert a string representation to milliseconds.
		 * @param	time
		 * String representation.
		 * @param	format
		 * Format of string.
		 * @return
		 * Milliseconds.
		 */
		public static function timeToMs(time:String, format:String = 'Auto'):int
		{
			var isPositive:Boolean;
			if (time.slice(0, 1) == '-') 
			{
				isPositive = false;
				time = time.slice(1);
			}
			else
			{
				isPositive = true;
			}
			
			if (format == AUTO)
			{
				if (time.match(/^[-+]?(\d+)?(\.\d+)?$/)) format = SECONDS;
				else if (time.match(/^[-+]?\d+:\d+(\.\d+)?$/)) format = MINUTES_SECONDS;
				else if (time.match(/^[-+]?\d+:\d+:\d+(\.\d+)?$/)) format = HOURS_MINUTES_SECONDS;
				else throw new Error('Could not determine the format of: '+time);
			}
			
			var timeArr:Array = time.split(':');
			
			var sec:int;
			var min:int;
			var hour:int;
			var result:int;
			
			switch (format)
			{
				case SECONDS:
					result = Number(time) * 1000;
				break;
				
				case MINUTES_SECONDS:
					min = Number(timeArr[0]) * 60000;
					sec = Number(timeArr[1]) * 1000;
					
					if (isPositive)
					{
						result = min + sec;
					}
					else
					{
						result = -min - sec;
					}
				break;
				
				case HOURS_MINUTES:
					hour = Number(timeArr[0]) * 360000;
					min = Number(timeArr[1]) * 60000;
					
					if (isPositive)
					{
						result = hour + min;
					}
					else
					{
						result = -hour - min;
					}
				break;
				
				case HOURS_MINUTES_SECONDS:
					hour = Number(timeArr[0]) * 360000;
					min = Number(timeArr[1]) * 60000;
					sec = Number(timeArr[2]) * 1000;
					
					if (isPositive)
					{
						result = hour + min + sec;
					}
					else
					{
						result = -hour - min - sec;
					}
				break;
			}
			
			return result;
		}
		
	}
	
}