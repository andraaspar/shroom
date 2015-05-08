package com.pirkadat.ui
{
	import com.pirkadat.logic.*;
	import com.pirkadat.trans.*;
	import com.pirkadat.ui.windows.BottomRightWindow;
	import com.pirkadat.ui.windows.BounceWindow;
	import com.pirkadat.ui.windows.GameRoundsWindow;
	import com.pirkadat.ui.windows.MenuButtonsWindow;
	import com.pirkadat.ui.windows.MessageWindow;
	import com.pirkadat.ui.windows.MultiProgressWindow;
	import com.pirkadat.ui.windows.StartWindow;
	import com.pirkadat.ui.windows.TeamQueueWindow;
	import com.pirkadat.ui.windows.TeamWindow;
	import com.pirkadat.ui.windows.Window;
	import com.pirkadat.ui.windows.WindowManager;
	import flash.events.*;
	
	[Frame(factoryClass = "com.pirkadat.ui.Main")]
	
	public class Gui extends AssetBundle 
	{
		public static var keyboardInput:KeyboardInput;
		public static var windowManager:WindowManager;
		public static var modalWindowManager:WindowManager;
		public static var worldWindow:WorldWindow;
		
		public static var instance:Gui;
		
		public static var teamWindow:Window;
		public static var messageWindow:Window;
		public static var bounceWindow:Window;
		public static var startWindow:Window;
		
		public function Gui():void 
		{
			instance = this;
			
			TextDefaults.globalStyleSheet.parseCSS(
				"p{font-family:Font1;font-size:12;color:#ffffff;leading:2;}"
				+"s{font-family:_sans;font-size:10;color:#ffffff;}"
				+"l{font-size:18px;display:inline;}"
				+"c{text-align:center;display:inline;}"
				+"f{color:#aaaaaa;display:inline;}"
				+"y{color:#ffcc00;display:inline;}"
				+"g{color:#66ff33;display:inline;}"
				+"r{color:#bf0000;display:inline;}"
			);
			
			keyboardInput = new KeyboardInput(stage);
			
			windowManager = new WindowManager(stage.stageWidth, stage.stageHeight);
			addChild(windowManager);
			
			modalWindowManager = new WindowManager(stage.stageWidth, stage.stageHeight);
			modalWindowManager.isModal = true;
			addChild(modalWindowManager);
			
			stage.addEventListener(Event.RESIZE, onStageResized);
			onStageResized();
			
			new Program(this);
		}
		
		public function onFrameEntered():void
		{
			Trans.execute();
			
			windowManager.update();
			modalWindowManager.update();
			if (worldWindow) worldWindow.update();
		}
		
		protected function onStageResized(e:Event = null):void
		{
			windowManager.fitToSpace(stage.stageWidth, stage.stageHeight);
			modalWindowManager.fitToSpace(stage.stageWidth, stage.stageHeight);
		}
		
		public static function prompt(message:String, title:String = "Warning"):void
		{
			var text:DynamicText = new DynamicText(message);
			text.wordWrap = true;
			text.width = 400;
			var extender:Extender = new Extender(text);
			var dialog:Window = new Window(extender, new DynamicText(title), true, true, true, true);
			modalWindowManager.addWindow(dialog);
		}
		
		public static function showProgressWindow(labels:Array):MultiProgressWindow
		{
			var w:MultiProgressWindow = new MultiProgressWindow(labels);
			modalWindowManager.addWindow(w);
			return w;
		}
		
		public static function showWorldWindow():void
		{
			worldWindow = new WorldWindow();
			instance.addChildAt(worldWindow, 0);
			
			windowManager.addWindow(new MessageWindow());
			
			windowManager.addWindow(new MenuButtonsWindow());
			
			windowManager.addWindow(new BottomRightWindow());
		}
		
		public static function showTeamQueueWindow():void
		{
			windowManager.addWindow(new GameRoundsWindow());
			windowManager.addWindow(new TeamQueueWindow());
		}
		
		public static function removeWorldWindow():void
		{
			if (worldWindow)
			{
				instance.removeChild(worldWindow);
				worldWindow = null;
			}
			windowManager.removeAllWindows();
		}
		
		public static function showTeamWindow():void
		{
			if (teamWindow) removeTeamWindow();
			teamWindow = new TeamWindow(Program.game.currentRound.selectedTeam);
			windowManager.addWindow(teamWindow);
		}
		
		public static function removeTeamWindow():void
		{
			if (teamWindow) windowManager.removeWindow(teamWindow);
			teamWindow = null;
		}
		
		public static function showBounceWindow():void
		{
			if (!bounceWindow) bounceWindow = new BounceWindow();
			
			windowManager.addWindow(bounceWindow);
		}
		
		public static function removeBounceWindow():void
		{
			if (bounceWindow) windowManager.removeWindow(bounceWindow); 
		}
		
		public static function showStartWindow():void
		{
			if (!startWindow) startWindow = new StartWindow();
			windowManager.addWindow(startWindow);
		}
	}
}