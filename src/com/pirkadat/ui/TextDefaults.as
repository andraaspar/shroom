package com.pirkadat.ui
{
	import com.pirkadat.display.*;
	import flash.text.*;
	
	public class TextDefaults extends TrueSizeText 
	{
		public static var globalEmbedFonts:Boolean = true;
		public static var globalStyleSheet:StyleSheet = new StyleSheet();
		public static var globalDefaultTextFormat:TextFormat = new TextFormat("Font1", 12, Colors.WHITE, null, null, null, null, null, null, null, null, null, 2);
		
		public function TextDefaults()
		{
			tabEnabled = false;
		}
	}
}