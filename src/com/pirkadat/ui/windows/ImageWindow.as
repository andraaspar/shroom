package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.shapes.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	
	public class ImageWindow extends TrueSize
	{
		public var bg:TrueSize;
		public var bmp:TrueSizeBitmap;
		public var bmpMask:TrueSize;
		public var bmpFrame:TrueSize;
		public var assetID:int;
		public var isLoading:Boolean;
		
		public function ImageWindow() 
		{
			super();
			
			bg = new Box(new FillStyle(0, 0));
			addChild(bg);
			sizeMask = bg;
			
			bmpMask = new RoundedBox(10);
			addChild(bmpMask);
			
			bmp = new TrueSizeBitmap();
			addChild(bmp);
			bmp.mask = bmpMask;
			
			bmpFrame = new RoundedBox(10, null, null, new LineStyle(2, 0xffffff));
			addChild(bmpFrame);
			
			visible = false;
			
			addEventListener(MouseEvent.CLICK, onClicked);
		}
		
		public function update():void
		{
			if (isLoading)
			{
				if (Program.mbToUI.allAssetsDownloaded)
				{
					showImageByAssetID(assetID);
				}
			}
		}
		
		public function showImageByAssetID(assetID:int):void
		{
			this.assetID = assetID;
			bmp.bitmapData = Program.assetLoader.getAssetByID(assetID);
			
			if (bmp.bitmapData)
			{
				visible = true;
				isLoading = false;
				
				correctScale();
			}
			else
			{
				visible = false;
				isLoading = true;
				
				Program.assetLoader.loadAssetByID(assetID);
			}
		}
		
		public function correctScale():void
		{
			if (visible && bmp.bitmapData)
			{
				bmp.xSize = bg.xSize - 40;
				bmp.ySize = bg.ySize - 40;
				bmp.scaleX = bmp.scaleY = Math.min(bmp.scaleX, bmp.scaleY);
				bmp.middle = bg.middle;
				
				bmpFrame.size = bmpMask.size = bmp.size;
				bmpFrame.location = bmpMask.location = bmp.location;
			}
		}
		
		public function hideImage():void
		{
			bmp.bitmapData = null;
			isLoading = false;
			visible = false;
			Program.assetLoader.unloadAssetByID(assetID);
		}
		
		override public function get width():Number { return bg.xSize; }
		
		override public function set width(value:Number):void 
		{
			bg.xSize = value;
			correctScale();
		}
		
		override public function get height():Number { return bg.ySize; }
		
		override public function set height(value:Number):void 
		{
			bg.ySize = value;
			correctScale();
		}
		
		public function onClicked(e:MouseEvent):void
		{
			hideImage();
		}
	}

}