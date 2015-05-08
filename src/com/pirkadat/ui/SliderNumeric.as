package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.shapes.*;
	import flash.events.*;
	
	public class SliderNumeric extends TrueSize implements IUIElement
	{
		public var values:Vector.<Number>;
		public var prevSelectedIndex:int;
		public var selectedIndex:int;
		public var changed:Boolean;
		
		public var background:TrueSizeShape;
		public var label:DynamicText;
		public var hole:TrueSizeShape;
		public var stops:Row;
		public var button:TrueSize;
		
		public var isDragged:Boolean;
		
		public var minX:Number;
		public var maxX:Number;
		public var pathX:Number;
		
		public var targetX:Number;
		
		public function SliderNumeric(labelText:String, values:Vector.<Number>, selectedIndex:int, xSpace:Number) 
		{
			super();
			
			//
			
			this.values = values;
			this.selectedIndex = selectedIndex;
			
			//
			
			build(labelText, xSpace);
		}
			
		protected function build(labelText:String, xSpace:Number):void
		{
			background = new Box(new FillStyle(0, 0));
			addChild(background);
			sizeMask = background;
			
			//
			
			label = new DynamicText(labelText);
			addChild(label);
			
			//
			
			stops = new Row(true, 6);
			addChild(stops);
			
			for (var i:int = values.length - 1; i >= 0; i--)
			{
				stops.addChildAt(new SliderStop(String(values[i])), 0);
			}
			
			//
			
			hole = new RoundedBox(3, new FillStyle(0), null, new LineStyle(2, 0xffffff));
			addChild(hole);
			hole.ySize = 6;
			
			//
			
			button = new TrueSize();
			addChild(button);
			button.graphics.beginFill(0xffffff);
			button.graphics.drawCircle(0, 0, 8);
			
			/*minX = stops.left;
			maxX = stops.right;
			pathX = maxX - minX;
			
			button.x = minX + (selectedIndex / (values.length - 1)) * pathX;
			
			//
			
			background.ySize = stops.bottom + 2;*/
			
			//
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed);
		}
		
		protected function onMousePressed(e:MouseEvent):void
		{
			isDragged = true;
			prevSelectedIndex = selectedIndex;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseReleased, false, 0, true);
			
			e.stopPropagation();
		}
		
		protected function onMouseReleased(e:MouseEvent):void
		{
			isDragged = false;
			changed = selectedIndex != prevSelectedIndex;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseReleased);
		}
		
		/* INTERFACE com.pirkadat.ui.IUIElement */
		
		public function updateGetSizeChanged():Boolean 
		{
			stops.update();
			stops.top = label.bottom + 6;
			
			hole.xSize = stops.xSize + 12;
			hole.yMiddle = stops.yMiddle;
			stops.left = hole.left + 6;
			
			button.yMiddle = hole.yMiddle;
			
			if (isDragged)
			{
				button.x = targetX = Math.max(minX, Math.min(maxX, mouseX));
				selectedIndex = Math.round((targetX - minX) / pathX * (values.length - 1));
			}
			else
			{
				targetX = minX + (selectedIndex / (values.length - 1)) * pathX;
				button.x += (targetX - button.x) / 4;
			}
			
			return false;
		}
		
		public function fit(minXSize:Number = 0, maxXSize:Number = 0, minYSize:Number = 0, maxYSize:Number = 0):void 
		{
			
		}
	}

}