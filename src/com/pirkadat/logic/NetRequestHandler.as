package com.pirkadat.logic 
{
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * @author András Parditka
	 */
	public class NetRequestHandler 
	{
		public var netRequests:Vector.<NetRequest> = new Vector.<NetRequest>();
		
		public function NetRequestHandler() 
		{
			
		}
		
		public function makeRequest(callback:Function, url:String, method:String = "GET", data:Object = null, contentType:String = "application/x-www-form-urlencoded"):void
		{
			var urlRequest:URLRequest = new URLRequest(url);
			urlRequest.method = method;
			urlRequest.data = data;
			urlRequest.contentType = contentType;
			
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			
			var netRequest:NetRequest = new NetRequest(urlLoader, callback);
			netRequest.addEventListener(NetRequest.EVENT_FINISHED, onFinished);
			netRequests.push(netRequest);
		}
		
		protected function onFinished(e:Event):void
		{
			var netRequest:NetRequest = NetRequest(e.target);
			netRequests.splice(netRequests.indexOf(netRequest), 1);
		}
	}

}