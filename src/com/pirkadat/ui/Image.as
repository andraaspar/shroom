package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.shapes.*;
	import com.pirkadat.ui.UIElement;
	import flash.display.*;
	
	public class Image extends UIElement
	{
		public var bg:TrueSizeShape;
		public var bmp:TrueSizeBitmap;
		public var assetID:int;
		public var fitSize:Boolean;
		public var isLoading:Boolean = true;
		
		public function Image(assetID:int, fitSize:Boolean) 
		{
			super();
			
			this.assetID = assetID;
			this.fitSize = fitSize;
			
			bg = new Box(new FillStyle(0, .6));
			addChild(bg);
			sizeMask = bg;
			
			bmp = new TrueSizeBitmap();
			addChild(bmp);
			
			contentsMinSizeX = contentsMinSizeY = 1;
			
			Program.assetLoader.loadAssetByID(assetID);
		}
		
		override public function update():void 
		{
			if (isLoading && Program.mbToUI.allAssetsDownloaded)
			{
				isLoading = false;
				
				var bmd:BitmapData = Program.assetLoader.getAssetByID(assetID);
				bmp.bitmapData = bmd;
				bmp.smoothing = true;
				
				if (fitSize)
				{
					contentsMinSizeX = bmd.width;
					contentsMinSizeY = bmd.height;
				}
				
				sizeChanged = true;
			}
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void 
		{
			sizeChanged = false;
			
			bg.width = xSpace;
			bg.height = ySpace;
			
			if (!isLoading)
			{
				bmp.size = bg.size;
				bmp.scaleX = bmp.scaleY = Math.min(bmp.scaleX, bmp.scaleY);
				bmp.middle = bg.middle;
			}
		}
		
		override public function get width():Number 
		{
			return super.width;
		}
		
		override public function set width(value:Number):void 
		{
			bg.width = value;
			contentsMinSizeX = value;
			sizeChanged = true;
		}
		
		override public function get height():Number 
		{
			return super.height;
		}
		
		override public function set height(value:Number):void 
		{
			bg.height = value;
			contentsMinSizeY = value;
			sizeChanged = true;
		}
	}

}