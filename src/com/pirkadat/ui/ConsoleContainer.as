package com.pirkadat.ui 
{
	import com.pirkadat.display.LimboHost;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class ConsoleContainer extends LimboHost
	{
		protected var console:Console;
		
		public function ConsoleContainer() 
		{
			console = new Console();
			super.addChild(console);
			Console.hide();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyConsole);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			var returnValue:DisplayObject = super.addChild(child);
			if (console) super.addChild(console);
			return returnValue;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			var returnValue:DisplayObject = super.addChildAt(child, index);
			if (console) super.addChild(console);
			return returnValue;
		}
		
		protected function onKeyConsole(e:KeyboardEvent):void
		{
			if ((e.keyCode == Keyboard.INSERT) && (e.shiftKey))
			{
				Console.setSize(stage.stageWidth, stage.stageHeight);
				Console.toggleShowHide();
				stage.showDefaultContextMenu = console.visible;
			}
		}
	}

}