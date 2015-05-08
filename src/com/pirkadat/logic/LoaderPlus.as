package com.pirkadat.logic 
{
	import flash.system.LoaderContext;
	import com.pirkadat.display.TrueSizeBitmap;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class LoaderPlus extends Loader
	{
		public var url:String;
		
		public function LoaderPlus() 
		{
			super();
		}
		
		override public function load(request:URLRequest, context:LoaderContext = null):void 
		{
			url = request.url;
			
			super.load(request, context);
		}
	}

}