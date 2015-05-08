package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.shapes.*;
	import com.pirkadat.ui.UIElement;
	import flash.display.*;
	
	public class PreviewWindow extends UIElement
	{
		public var bg:TrueSizeShape;
		public var bmp:TrueSizeBitmap;
		public var bmpMask:TrueSizeShape;
		public var bmpFrame:TrueSizeShape;
		public var assetID:int;
		public var isLoading:Boolean;
		
		public function PreviewWindow() 
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
			
			spaceRuleX = spaceRuleY = SPACE_RULE_BOTTOM_UP;
		}
		
		override public function update():void 
		{
			if (!isNaN(Program.mbToUI.newPreviewAssetID))
			{
				assetID = Program.mbToUI.newPreviewAssetID;
			}
			
			if (!isNaN(Program.mbToUI.newPreviewAssetID)
				|| isLoading && Program.mbToUI.allAssetsDownloaded)
			{
				var bmd:BitmapData = Program.assetLoader.getAssetByID(assetID);
				if (bmd)
				{
					//Console.say("Preview loaded.");
					isLoading = false;
					bmp.bitmapData = bmd;
					bmp.smoothing = true;
					visible = true;
					correctSize();
				}
				else
				{
					//Console.say("Preview loading...",assetID);
					isLoading = true;
					Program.assetLoader.loadAssetByID(assetID);
					visible = false;
				}
			}
		}
		
		protected function correctSize():void
		{
			if (bmp.bitmapData)
			{
				bmp.xSize = bg.xSize;
				bmp.ySize = bg.ySize;
				bmp.scaleX = bmp.scaleY = Math.min(bmp.scaleX, bmp.scaleY);
				bmp.middle = bg.middle;
				
				bmpFrame.size = bmpMask.size = bmp.size;
				bmpFrame.location = bmpMask.location = bmp.location;
			}
		}
		
		override public function get width():Number { return bg.xSize; }
		
		override public function set width(value:Number):void 
		{
			bg.xSize = contentsMinSizeX = value;
		}
		
		override public function get height():Number { return bg.ySize; }
		
		override public function set height(value:Number):void 
		{
			bg.ySize = contentsMinSizeY = value;
		}
	}

}