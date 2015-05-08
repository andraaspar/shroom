package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSize;
	import flash.display.Sprite;
	
	public class AssetBundle extends TrueSize
	{
		//[Embed(source='../../../../lib/Vanilla.ttf', fontName='Font1', mimeType='application/x-font', unicodeRange='')]
		[Embed(source='../../../../lib/Vanilla.ttf', fontName='Font1', mimeType='application/x-font', embedAsCFF="false")]
		private var font1:Class;
	}

}