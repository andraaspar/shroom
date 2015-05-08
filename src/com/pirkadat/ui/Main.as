package com.pirkadat.ui
{
	import com.pirkadat.display.LimboHost;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	
	public class Main extends ConsoleContainer 
	{
		public static var folderURL:String;
		
		public function Main() 
		{
			folderURL = getFolderURL();
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onDownloadProgressed);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onDownloadError);
			loaderInfo.addEventListener(Event.COMPLETE, onDownloadFinished);
		}
		
		protected function onDownloadProgressed(e:ProgressEvent):void 
		{
			trace(int(e.bytesLoaded / e.bytesTotal * 100) + "%");
		}
		
		protected function onDownloadError(e:IOErrorEvent):void
		{
			Console.say(e.text);
		}
		
		protected function onDownloadFinished(e:Event):void 
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onDownloadProgressed);
			loaderInfo.removeEventListener(Event.COMPLETE, onDownloadFinished);
			
			//
			
			gotoAndStop(totalFrames);
			Console.say("Download complete.");
			
			//
			
			var guiClass:Class = Class(getDefinitionByName("com.pirkadat.ui.Gui"));
			addChild(DisplayObject(new guiClass()));
		}
		
		protected function getFolderURL():String
		{
			var urlArray:Array = root.loaderInfo.url.split('/');
			urlArray.pop();
			return urlArray.join('/') + '/';
		}
	}
	
}