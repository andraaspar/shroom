package com.pirkadat.ui 
{
	public class Spacer extends UIElement 
	{
		
		public function Spacer() 
		{
			spaceRuleX = spaceRuleY = SPACE_RULE_TOP_DOWN_MAXIMUM;
			contentsMinSizeX = contentsMinSizeY = 0;
		}
		
		override public function update():void 
		{
			graphics.clear();
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void 
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, xSpace, ySpace);
		}
	}

}