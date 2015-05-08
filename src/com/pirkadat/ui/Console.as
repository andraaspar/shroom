package com.pirkadat.ui 
{
	import flash.text.*;
	
	public class Console extends TextField
	{
		protected static var instance:Console;
		protected static var lines:int;
		protected static const LINES_LIMIT:int = 5000;
		
		public function Console() 
		{
			if (instance) throw new Error("Already created.");
			instance = this;
			
			border = true;
			borderColor = 0xc8c8ce;
			background = true;
			
			multiline = true;
			wordWrap = true;
			defaultTextFormat = new TextFormat('_typewriter', 13, null, null, null, null, null, null, null, null, null, 15);
			type = TextFieldType.INPUT;
			
			width = 1000;
			height = 600;
		}
		
		public static function say(...what:Array):void
		{
			if (!instance) return;
			
			var formatted:String = "> " + what.join(" ");
			if (lines > LINES_LIMIT)
			{
				instance.text = formatted + "\n";
				lines = 1;
			}
			else
			{
				instance.appendText(formatted + "\n");
				lines++;
			}
			trace(formatted);
		}
		
		public static function sayToString(...what:Array):void
		{
			what.forEach(stringConverter);
			say.apply(null, what);
		}
		
		protected static function stringConverter(item:*, index:int, array:Array):void
		{
			if (item is XML) array[index] = XML(item).toXMLString();
			else if (item is XMLList) array[index] = XMLList(item).toXMLString();
			else array[index] = String(item);
		}
		
		public static function setSize(width:Number, height:Number):void
		{
			instance.width = width;
			instance.height = height;
		}
		
		public static function show():void
		{
			instance.visible = true;
		}
		
		public static function hide():void
		{
			instance.visible = false;
		}
		
		public static function toggleShowHide():void
		{
			instance.visible = !instance.visible;
		}
	}

}