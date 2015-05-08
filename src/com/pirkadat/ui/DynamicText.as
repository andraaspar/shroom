package com.pirkadat.ui
{
	import flash.events.Event;
	import flash.text.*;
	import com.pirkadat.display.*;
	
	public class DynamicText extends TextDefaults
	{
		public function DynamicText(text:String = "")
		{
			antiAliasType = AntiAliasType.ADVANCED;
			autoSize = TextFieldAutoSize.LEFT;
			defaultTextFormat = globalDefaultTextFormat;
			embedFonts = globalEmbedFonts;
			gridFitType = GridFitType.SUBPIXEL;
			multiline = true;
			selectable = false;
			wordWrap = false;
			mouseWheelEnabled = false;
			this.text = text;
		}
	}
}