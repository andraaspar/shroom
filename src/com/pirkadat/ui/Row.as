package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.*;
	
	/**
	 * @author András Parditka
	 */
	public class Row extends UIElement
	{
		public var isHorizontal:Boolean;
		public var defaultDistance:Number;
		public var distances:Dictionary = new Dictionary(true);
		public var flexibleDistanceCount:int;
		public var greedyElementsCount:int;
		
		public function Row(isHorizontal:Boolean = true, defaultDistance:Number = 0)
		{
			super();
			
			this.isHorizontal = isHorizontal;
			this.defaultDistance = defaultDistance;
		}
		
		override public function update():void 
		{
			var i:int;
			var n:int = numChildren;
			var uiElement:UIElement;
			var word:ITrueSize;
			
			greedyElementsCount = 0;
			contentsMinSizeX = 0;
			contentsMinSizeY = 0;
			
			for (i = 0; i < n; i++)
			{
				word = ITrueSize(getChildAt(i));
				uiElement = word as UIElement;
				
				if (isHorizontal)
				{
					if (uiElement)
					{
						uiElement.update();
						sizeChanged = sizeChanged || uiElement.sizeChanged;
						
						if (uiElement.spaceRuleX == SPACE_RULE_TOP_DOWN_MAXIMUM) greedyElementsCount++;
						
						contentsMinSizeY = Math.max(contentsMinSizeY, uiElement.contentsMinSizeY);
						contentsMinSizeX += uiElement.contentsMinSizeX;
					}
					else
					{
						contentsMinSizeY = Math.max(contentsMinSizeY, word.ySize);
						contentsMinSizeX += word.xSize;
					}
					if (i > 0)
					{
						if (distances[word] !== undefined) contentsMinSizeX += distances[word];
						else contentsMinSizeX += defaultDistance;
					}
				}
				else
				{
					if (uiElement)
					{
						uiElement.update();
						sizeChanged = sizeChanged || uiElement.sizeChanged;
						
						if (uiElement.spaceRuleY == SPACE_RULE_TOP_DOWN_MAXIMUM) greedyElementsCount++;
						
						contentsMinSizeX = Math.max(contentsMinSizeX, uiElement.contentsMinSizeX);
						contentsMinSizeY += uiElement.contentsMinSizeY;
					}
					else
					{
						contentsMinSizeX = Math.max(contentsMinSizeX, word.xSize);
						contentsMinSizeY += word.ySize;
					}
					if (i > 0)
					{
						if (distances[word] !== undefined) contentsMinSizeY += distances[word];
						else contentsMinSizeY += defaultDistance;
					}
				}
			}
			
			if (sizeChanged)
			{
				organize(defaultDistance, contentsMinSizeX, contentsMinSizeY);
			}
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void
		{
			sizeChanged = false;
			//if (xSpace == contentsMinSizeX && ySpace == contentsMinSizeY) return;
			
			var i:int;
			var n:int = numChildren;
			var word:ITrueSize;
			var uiElement:UIElement;
			var flexibleDistance:Number;
			var extraSpace:Number;
			var greedSpace:Number;
			
			if (isHorizontal) extraSpace = Math.max(0, xSpace - contentsMinSizeX);
			else extraSpace = Math.max(0, ySpace - contentsMinSizeY);
			
			if (greedyElementsCount) greedSpace = extraSpace / greedyElementsCount;
			
			var elementXSpace:Number;
			var elementYSpace:Number;
			for (i = 0; i < n; i++)
			{
				word = ITrueSize(getChildAt(i));
				uiElement = word as UIElement;
				if (uiElement)
				{
					if (isHorizontal)
					{
						switch (uiElement.spaceRuleX)
						{
							case SPACE_RULE_BOTTOM_UP:
								elementXSpace = uiElement.contentsMinSizeX;
								break;
							case SPACE_RULE_TOP_DOWN_MINIMUM:
								elementXSpace = uiElement.contentsMinSizeX;
								break;
							case SPACE_RULE_TOP_DOWN_MAXIMUM:
								elementXSpace = uiElement.contentsMinSizeX + greedSpace;
								break;
						}
						switch (uiElement.spaceRuleY)
						{
							case SPACE_RULE_BOTTOM_UP:
								elementYSpace = uiElement.contentsMinSizeY;
								break;
							case SPACE_RULE_TOP_DOWN_MINIMUM:
								elementYSpace = ySpace;
								break;
							case SPACE_RULE_TOP_DOWN_MAXIMUM:
								elementYSpace = ySpace;
								break;
						}
						uiElement.fitToSpace(elementXSpace, elementYSpace);
					}
					else
					{
						switch (uiElement.spaceRuleY)
						{
							case SPACE_RULE_BOTTOM_UP:
								elementYSpace = uiElement.contentsMinSizeY;
								break;
							case SPACE_RULE_TOP_DOWN_MINIMUM:
								elementYSpace = uiElement.contentsMinSizeY;
								break;
							case SPACE_RULE_TOP_DOWN_MAXIMUM:
								elementYSpace = uiElement.contentsMinSizeY + greedSpace;
								break;
						}
						switch (uiElement.spaceRuleX)
						{
							case SPACE_RULE_BOTTOM_UP:
								elementXSpace = uiElement.contentsMinSizeX;
								break;
							case SPACE_RULE_TOP_DOWN_MINIMUM:
								elementXSpace = xSpace;
								break;
							case SPACE_RULE_TOP_DOWN_MAXIMUM:
								elementXSpace = xSpace;
								break;
						}
						uiElement.fitToSpace(elementXSpace, elementYSpace);
					}
				}
			}
			
			if (flexibleDistanceCount > 0 && greedyElementsCount == 0) flexibleDistance = defaultDistance + extraSpace / flexibleDistanceCount;
			else flexibleDistance = defaultDistance;
			
			organize(flexibleDistance, xSpace, ySpace);
		}
		
		protected function organize(flexibleDistance:Number, xSpace:Number, ySpace:Number):void
		{
			var i:int;
			var n:int = numChildren;
			var word:ITrueSize;
			var lastWord:ITrueSize;
			var uiElement:UIElement;
			var distance:Number;
			
			flexibleDistanceCount = n - 1;
			
			for (i = 0; i < n; i++)
			{
				word = ITrueSize(getChildAt(i));
				uiElement = word as UIElement;
				
				distance = distances[word];
				if (isNaN(distance)) distance = flexibleDistance;
				else if (i > 0) flexibleDistanceCount--;
				
				if (isHorizontal)
				{
					if (lastWord) word.left = lastWord.right + distance;
					else word.left = 0;
					
					if (uiElement)
					{
						if (uiElement.alignmentY > 0) uiElement.bottom = ySpace;
						else if (uiElement.alignmentY < 0) uiElement.top = 0;
						else uiElement.yMiddle = ySpace / 2;
					}
					else
					{
						word.yMiddle = ySpace / 2;
					}
				}
				else
				{
					if (lastWord) word.top = lastWord.bottom + distance;
					else word.top = 0;
					
					if (uiElement)
					{
						if (uiElement.alignmentX > 0) uiElement.right = xSpace;
						else if (uiElement.alignmentX < 0) uiElement.left = 0;
						else uiElement.xMiddle = xSpace / 2;
					}
					else
					{
						word.xMiddle = xSpace / 2;
					}
				}
				
				lastWord = word;
			}
		}
	}
}