package com.pirkadat.logic 
{
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	public class SoundPlus extends Sound
	{
		public var realURL:String;
		
		public function SoundPlus(stream:URLRequest = null, context:SoundLoaderContext = null) 
		{
			if (stream) realURL = stream.url;
			
			super(stream, context);
		}
		
		override public function load(stream:URLRequest, context:SoundLoaderContext = null):void 
		{
			if (stream) realURL = stream.url;
			
			super.load(stream, context);
		}
		
	}

}