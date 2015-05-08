package com.pirkadat.logic 
{
	import com.pirkadat.events.*;
	import com.pirkadat.ui.*;
	import flash.display.*;
	import flash.errors.IOError;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.utils.*;
	
	public class AssetLoader
	{
		protected var loaders:Dictionary;
		protected var data:Dictionary;
		protected var filters:Dictionary;
		
		public var activeDownloads:int;
		
		public function AssetLoader()
		{
			loaders = new Dictionary();
			data = new Dictionary();
			filters = new Dictionary();
		}
		
		public function loadMultiple(urls:Vector.<String>, filters:Dictionary = null):void
		{
			for each (var url:String in urls)
			{
				load(url, (filters && filters[url]) ? filters[url] : null);
			}
		}
		
		public function load(url:String, filterVec:Vector.<AssetFilter> = null):void
		{
			var extension:String = url.slice( -4).toLowerCase();
			
			switch (extension)
			{
				case ".png":
				case ".jpg":
				case ".gif":
				case ".swf":
					loadBitmapOrSWF(url, filterVec);
				break;
				
				case ".mp3":
					loadSound(url, filterVec);
				break;
				
				default:
					loadTextOrBinary(url, filterVec);
			}
		}
		
		public function loadTextOrBinary(url:String, filterVec:Vector.<AssetFilter> = null):void
		{
			if (loaders[url] !== undefined) return;
			
			CONFIG::debug { Console.say("Loading text or binary:", url); }
			
			var urlLoader:URLLoaderPlus = new URLLoaderPlus(new URLRequest(url));
			loaders[url] = urlLoader;
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorOccured);
			urlLoader.addEventListener(Event.COMPLETE, onDownloadCompleted);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorOccured);
			
			if (filterVec) filters[url] = filterVec;
			
			activeDownloads++;
		}
		
		public function loadBitmapOrSWF(url:String, filterVec:Vector.<AssetFilter> = null):void
		{
			if (loaders[url] !== undefined) return;
			
			CONFIG::debug { Console.say("Loading bitmap or swf:", url); }
			
			//var context:LoaderContext = new LoaderContext();
			//context.allowCodeImport = false;
			//context.checkPolicyFile = true;
			
			var loader:LoaderPlus = new LoaderPlus();
			loader.load(new URLRequest(url));
			//loader.load(new URLRequest(url), context);
			
			var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
			loaders[url] = loaderInfo;
			
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorOccured);
			loaderInfo.addEventListener(Event.INIT, onSWFInit);
			loaderInfo.addEventListener(Event.COMPLETE, onDownloadCompleted);
			loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorOccured);
			
			if (filterVec) filters[url] = filterVec;
			
			activeDownloads++;
		}
		
		public function loadSound(url:String, filterVec:Vector.<AssetFilter> = null):void
		{
			if (loaders[url] !== undefined) return;
			
			CONFIG::debug { Console.say("Loading sound:",url); }
			
			var sound:SoundPlus = new SoundPlus();
			sound.load(new URLRequest(url));
			loaders[url] = sound;
			
			sound.addEventListener(IOErrorEvent.IO_ERROR, onErrorOccured);
			sound.addEventListener(Event.COMPLETE, onDownloadCompleted);
			sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorOccured);
			
			if (filterVec) filters[url] = filterVec;
			
			activeDownloads++;
		}
		
		public function cancelDownload(url:String):void
		{
			CONFIG::debug { Console.say("Cancelling download:", url); }
			
			var aLoader:IEventDispatcher = IEventDispatcher(loaders[url]);
			
			aLoader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorOccured);
			aLoader.removeEventListener(Event.INIT, onSWFInit);
			aLoader.removeEventListener(Event.COMPLETE, onDownloadCompleted);
			aLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorOccured);
			
			var loaderInfo:LoaderInfo = aLoader as LoaderInfo;
			if (loaderInfo)
			{
				loaderInfo.loader.close();
				loaderInfo.loader.unload();
			}
			
			var sound:SoundPlus = aLoader as SoundPlus;
			if (sound)
			{
				try
				{
					sound.close();
				}
				catch (e:IOError) { };
			}
			
			delete loaders[url];
			delete filters[url];
			
			activeDownloads--;
		}
		
		public function cancelAllDownloads():void
		{
			for (var url:String in loaders)
			{
				cancelDownload(url);
			}
		}
		
		public function unloadData(url:String):void
		{
			CONFIG::debug { Console.say("Unloading:", url); }
			
			var bitmapData:BitmapData = data[url] as BitmapData;
			var bmdVec:Vector.<BitmapData> = data[url] as Vector.<BitmapData>;
			
			if (bitmapData) bitmapData.dispose();
			if (bmdVec) for each (bitmapData in bmdVec) bitmapData.dispose();
			
			delete data[url];
		}
		
		public function unloadAllData():void
		{
			for (var url:String in data)
			{
				unloadData(url);
			}
		}
		
		public function getDownloadedData(url:String):*
		{
			return data[url];
		}
		
		protected function onErrorOccured(e:ErrorEvent):void
		{
			var urlLoader:URLLoaderPlus = e.target as URLLoaderPlus;
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			var sound:SoundPlus = e.target as SoundPlus;
			
			var url:String;
			if (urlLoader) url = urlLoader.url;
			else if (loaderInfo) url = LoaderPlus(loaderInfo.loader).url;
			else if (sound) url = sound.realURL;
			
			delete loaders[url];
			delete filters[url];
			delete data[url];
			Console.say(getQualifiedClassName(this), e.text, "(", url, ")");
			
			//activeDownloads--;
			Gui.prompt("There was a download error.\n\nPlease reload the page, and if the problem persists, report the problem to feedback@shroomgame.com.");
		}
		
		protected function onSWFInit(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			if (!loaderInfo
				|| !(loaderInfo.content is MovieClip))
				return;
			
			MovieClip(loaderInfo.content).stop();
			CONFIG::debug { Console.say("MovieClip stopped on init."); }
		}
		
		protected function onDownloadCompleted(e:Event):void
		{
			var urlLoader:URLLoaderPlus = e.target as URLLoaderPlus;
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			var sound:SoundPlus = e.target as SoundPlus;
			var url:String;
			var loadedData:*;
			var filterVec:Vector.<AssetFilter>;
			
			if (urlLoader)
			{
				url = urlLoader.url;
				
				CONFIG::debug { Console.say("Text or binary downloaded:", url) }
				
				loadedData = urlLoader.data;
				delete loaders[url];
			}
			else if (loaderInfo)
			{
				url = LoaderPlus(loaderInfo.loader).url;
				
				CONFIG::debug { Console.say("Bitmap or swf downloaded:", url) }
				
				var loadedBitmap:Bitmap = loaderInfo.content as Bitmap;
				var loadedMovieClip:MovieClip = loaderInfo.content as MovieClip;
				
				if (loadedBitmap)
				{
					CONFIG::debug { Console.say("...and it is a bitmap.") }
					loadedData = loadedBitmap.bitmapData;
				}
				else if (loadedMovieClip)
				{
					CONFIG::debug { Console.say("...and it is a swf.") }
					loadedData = loadedMovieClip;
				}
				else
				{
					throw new Error("Unknown content type.");
				}
				
				loaderInfo.loader.unload();
				delete loaders[url];
			}
			else if (sound)
			{
				url = sound.realURL;
				
				CONFIG::debug { Console.say("Sound downloaded:", url) }
				
				loadedData = sound;
				delete loaders[url];
			}
			else
			{
				throw new Error("Unknown content type.");
			}
			
			filterVec = filters[url];
			if (filterVec)
			{
				for each (var filter:AssetFilter in filterVec)
				{
					loadedData = filter.execute(loadedData);
				}
				delete filters[url];
			}
			
			data[url] = loadedData;
			
			var allDownloadsCompleted:Boolean = true;
			for (url in loaders)
			{
				//Console.say("Still loading:",url);
				allDownloadsCompleted = false;
				break;
			}
			
			if (allDownloadsCompleted)
			{
				Program.mbToP.allAssetsDownloaded = true;
				Program.mbToUI.allAssetsDownloaded = true;
				activeDownloads = 0;
			}
		}
		
		public function getProgress():Number
		{
			var loaded:Number = 0;
			var finishedDownloads:int = activeDownloads;
			
			var urlLoader:URLLoaderPlus;
			var loaderInfo:LoaderInfo;
			var sound:SoundPlus;
			
			for each (var aLoader:* in loaders)
			{
				urlLoader = aLoader as URLLoaderPlus;
				loaderInfo = aLoader as LoaderInfo;
				sound = aLoader as SoundPlus;
				
				if (urlLoader)
				{
					if (urlLoader.bytesTotal
						&& urlLoader.bytesLoaded)
					{
						loaded += urlLoader.bytesLoaded / urlLoader.bytesTotal;
					}
				}
				else if (loaderInfo)
				{
					if (loaderInfo.bytesTotal
						&& loaderInfo.bytesLoaded)
					{
						loaded += loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
					}
				}
				else if (sound)
				{
					if (sound.bytesTotal
						&& sound.bytesLoaded)
					{
						loaded += sound.bytesLoaded / sound.bytesTotal;
					}
				}
				
				finishedDownloads--;
			}
			
			if (activeDownloads) return (loaded + finishedDownloads) / activeDownloads;
			else return 1;
		}
	}
}