package com.pirkadat.ui 
{
	import com.pirkadat.display.ITrueSize;
	import com.pirkadat.display.TrueSize;
	import com.pirkadat.display.TrueSizeShape;
	import com.pirkadat.shapes.Box;
	import com.pirkadat.shapes.FillStyle;
	import flash.display.DisplayObject;
	
	public class Extender extends UIElement 
	{
		public var content:ITrueSize;
		public var contentAsUIElement:UIElement;
		public var extension:ITrueSize;
		public var extensionTop:Number;
		public var extensionRight:Number;
		public var extensionBottom:Number;
		public var extensionLeft:Number;
		
		public function Extender(content:ITrueSize, extensionTop:Number = 40, extensionRight:Number = 20, extensionBottom:Number = 40, extensionLeft:Number = 20) 
		{
			super();
			
			this.content = content;
			this.extensionTop = extensionTop;
			this.extensionRight = extensionRight;
			this.extensionBottom = extensionBottom;
			this.extensionLeft = extensionLeft;
			
			extension = createExtension();
			addChild(DisplayObject(extension));
			sizeMask = extension;
			
			addChild(DisplayObject(content));
			contentAsUIElement = content as UIElement;
		}
		
		protected function createExtension():ITrueSize
		{
			return new Box(new FillStyle(0, 0));
		}
		
		override public function update():void 
		{
			if (contentAsUIElement)
			{
				spaceRuleX = contentAsUIElement.spaceRuleX;
				spaceRuleY = contentAsUIElement.spaceRuleY;
				alignmentX = contentAsUIElement.alignmentX;
				alignmentY = contentAsUIElement.alignmentY;
				
				contentAsUIElement.update();
				sizeChanged = sizeChanged || contentAsUIElement.sizeChanged;
				if (sizeChanged)
				{
					contentsMinSizeX = contentAsUIElement.contentsMinSizeX + extensionLeft + extensionRight;
					contentsMinSizeY = contentAsUIElement.contentsMinSizeY + extensionTop + extensionBottom;
					correctExtension(contentsMinSizeX, contentsMinSizeY);
				}
			}
			else
			{
				if (sizeChanged)
				{
					contentsMinSizeX = content.xSize + extensionLeft + extensionRight;
					contentsMinSizeY = content.ySize + extensionTop + extensionBottom;
					correctExtension(contentsMinSizeX, contentsMinSizeY);
				}
			}
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void 
		{
			sizeChanged = false;
			
			if (contentAsUIElement)
			{
				contentAsUIElement.fitToSpace(xSpace - extensionLeft - extensionRight, ySpace - extensionTop - extensionBottom);
			}
			correctExtension(content.xSize + extensionLeft + extensionRight, content.ySize + extensionTop + extensionBottom);
		}
		
		protected function correctExtension(xSize:Number, ySize:Number):void
		{
			extension.xSize = xSize;
			extension.ySize = ySize;
			content.left = extensionLeft;
			content.top = extensionTop;
		}
		
	}

}