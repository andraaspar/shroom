package com.pirkadat.logic 
{
	import com.pirkadat.events.*;
	import com.pirkadat.ui.*;
	import com.pirkadat.ui.windows.MultiProgressWindow;
	import flash.events.*;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.*;
	
	public class Program
	{
		public static const STATE_CREATED:int = 0;
		public static const STATE_LOADING_ASSET_DATA:int = 1;
		public static const STATE_LOADING_BASIC_ASSETS:int = 2;
		public static const STATE_WORKING:int = 3;
		
		public static const ASSET_DATA_URL:String = "data/asset_info.xml";
		
		public static var mbToP:MBToP = new MBToP();
		public static var mbToUI:MBToUI = new MBToUI();
		
		public static var gui:Gui;
		public static var assetLoader:AssetLoaderWithIDs;
		public static var netRequestHandler:NetRequestHandler;
		public static var game:Game;
		public static var fastFakeThread:FakeThread = new FakeThread(30);
		
		public static var state:int;
		
		public static var progressWindow:MultiProgressWindow;
		
		public function Program(gui:Gui) 
		{
			Console.say("Flash version:", Capabilities.version, Capabilities.isDebugger ? "Debug" : "Release");
			Console.say("Location:", gui.loaderInfo.url);
			
			Program.gui = gui;
			gui.addEventListener(Event.ENTER_FRAME, onFrameEntered);
			
			onFrameEntered();
		}
		
		protected function setState(newState:int):void
		{
			state = newState;
			
			switch (state)
			{
				case STATE_LOADING_ASSET_DATA:
					progressWindow = Gui.showProgressWindow(["Loading asset data", "Loading basic assets"]);
					
					assetLoader.cancelAllDownloads();
					assetLoader.unloadAllData();
					assetLoader.loadTextOrBinary(ASSET_DATA_URL);
					break;
				case STATE_LOADING_BASIC_ASSETS:
					var basicAssets:Vector.<int> = new Vector.<int>();
					var assetIDStrings:Array = assetLoader.assetInfo.basic.@ids.toString().split(" ");
					for each (var assetIDString:String in assetIDStrings) basicAssets.push(int(assetIDString));
					assetLoader.loadAssetsByID(basicAssets);
					break;
				case STATE_WORKING:
					Gui.modalWindowManager.removeWindow(progressWindow);
					break;
			}
		}
		
		protected function onFrameEntered(e:Event = null):void
		{
			if (fastFakeThread.hasTasks) fastFakeThread.execute();
			
			switch (state)
			{
				case STATE_CREATED:
					assetLoader = new AssetLoaderWithIDs();
					netRequestHandler = new NetRequestHandler();
					
					setState(STATE_LOADING_ASSET_DATA);
					
				case STATE_LOADING_ASSET_DATA:
					progressWindow.setProgress(0, assetLoader.getProgress());
					
					if (mbToP.allAssetsDownloaded)
					{
						mbToP.allAssetsDownloaded = false;
						assetLoader.assetInfo = new XML(assetLoader.getDownloadedData(ASSET_DATA_URL));
						setState(STATE_LOADING_BASIC_ASSETS);
					}
					else break;
				case STATE_LOADING_BASIC_ASSETS:
					progressWindow.setProgress(1, assetLoader.getProgress());
					
					if (mbToP.allAssetsDownloaded)
					{
						setState(STATE_WORKING);
					}
					else break;
				case STATE_WORKING:
					
					if (game) game.execute();
					
					if (!game || mbToP.gameDestroyRequested)
					{
						Gui.removeWorldWindow();
						if (game)
						{
							game.destroy();
							game = game.spawnNew();
						}
						else
						{
							game = new Game();
						}
						game.execute();
					}
					break;
			}
			
			//
			
			mbToP = new MBToP();
			
			//
			
			gui.onFrameEntered();
			
			//
			
			mbToUI = new MBToUI();
		}
	}
}