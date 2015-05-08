package com.pirkadat.logic 
{
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * ...
	 * @author András Parditka
	 */
	public class NetRequest extends EventDispatcher
	{
		public static const EVENT_FINISHED:String = "NetRequestFinished";
		
		public var urlLoader:URLLoader;
		public var callback:Function;
		
		public var httpStatus:int;
		public var progress:Number;
		public var errorEvent:Event;
		
		public function NetRequest(urlLoader:URLLoader, callback:Function) 
		{
			this.urlLoader = urlLoader;
			urlLoader.addEventListener(Event.COMPLETE, onCompleted);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorOccured);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorOccured);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressed);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusReceived);
			
			this.callback = callback;
		}
		
		protected function onCompleted(e:Event):void
		{
			onFinished();
		}
		
		protected function onIOErrorOccured(e:IOErrorEvent):void
		{
			errorEvent = e;
			onFinished();
		}
		
		protected function onSecurityErrorOccured(e:SecurityErrorEvent):void
		{
			errorEvent = e;
			onFinished();
		}
		
		protected function onProgressed(e:ProgressEvent):void
		{
			progress = e.bytesLoaded / e.bytesTotal;
		}
		
		protected function onHTTPStatusReceived(e:HTTPStatusEvent):void
		{
			httpStatus = e.status;
		}
		
		protected function onFinished():void
		{
			callback(this);
			dispatchEvent(new Event(EVENT_FINISHED));
		}
	}

}