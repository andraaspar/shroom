package com.pirkadat.logic 
{
	import flash.net.*;
	
	public class URLLoaderPlus extends URLLoader
	{
		public var url:String;
		
		public function URLLoaderPlus(request:URLRequest = null) 
		{
			url = request.url;
			
			super(request);
		}
		
		override public function load(request:URLRequest):void 
		{
			url = request.url;
			
			super.load(request);
		}
	}

}