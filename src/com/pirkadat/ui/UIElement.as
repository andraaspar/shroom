package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSize;
	import flash.events.Event;
	
	public class UIElement extends TrueSize 
	{
		public static const SPACE_RULE_BOTTOM_UP:int = 0;
		public static const SPACE_RULE_TOP_DOWN_MINIMUM:int = 1;
		public static const SPACE_RULE_TOP_DOWN_MAXIMUM:int = 2;
		
		public var spaceRuleX:int = 1;
		public var spaceRuleY:int = 1;
		
		public var alignmentX:Number;
		public var alignmentY:Number;
		
		public var contentsMinSizeX:Number = 0;
		public var contentsMinSizeY:Number = 0;
		
		public var sizeChanged:Boolean = true;
		
		public function UIElement() 
		{
			addEventListener(Event.ADDED, onChildAdded);
			addEventListener(Event.REMOVED, onChildRemoved);
		}
		
		public function update():void
		{
			
		}
		
		public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void
		{
			sizeChanged = false;
		}
		
		protected function onChildAdded(e:Event):void
		{
			sizeChanged = true;
			if (e.target != this) e.stopPropagation();
		}
		
		protected function onChildRemoved(e:Event):void
		{
			sizeChanged = true;
			if (e.target != this) e.stopPropagation();
		}
	}

}