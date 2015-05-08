package com.pirkadat.ui
{
	import flash.events.Event;
	import flash.text.*;
	import com.pirkadat.display.*;
	
	public class InputText extends TextDefaults 
	{
		public function InputText()
		{
			antiAliasType = AntiAliasType.ADVANCED;
			defaultTextFormat = globalDefaultTextFormat;
			embedFonts = globalEmbedFonts;
			gridFitType = GridFitType.SUBPIXEL;
			multiline = true;
			type = TextFieldType.INPUT;
			wordWrap = true;
			mouseWheelEnabled = false;
		}
	}
}