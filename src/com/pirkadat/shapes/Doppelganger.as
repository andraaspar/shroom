package com.pirkadat.shapes 
{
	import com.pirkadat.display.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class Doppelganger extends TrueSizeBitmap
	{
		
		public function Doppelganger() 
		{
			
		}
		
		public function draw(what:DisplayObject):void
		{
			var aMatrix:Matrix = what.transform.matrix.clone();
			aMatrix.scale(Main.instance.scaleX, Main.instance.scaleY);
			
			if (bitmapData) bitmapData.dispose();
			try
			{
				bitmapData = new BitmapData(what.width * Main.instance.scaleX, what.height * Main.instance.scaleY, true, 0x00ffffff);
				bitmapData.draw(what as IBitmapDrawable, aMatrix, what.transform.colorTransform, null, null, true);
			}
			catch (e:Error) {trace('Doppelganger: BitmapData error.')};
			
			scaleX = 1 / Main.instance.scaleX;
			scaleY = 1 / Main.instance.scaleY;
		}
	}
	
}