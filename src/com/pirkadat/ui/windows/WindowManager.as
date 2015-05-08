package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.shapes.Box;
	import com.pirkadat.shapes.FillStyle;
	import com.pirkadat.ui.UIElement;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.geom.*;
	
	/**
	 * @author András Parditka
	 */
	public class WindowManager extends UIElement 
	{
		public static const TASK_NONE:int = 0;
		public static const TASK_DRAG:int = 1;
		public static const TASK_SCALE:int = 2;
		public static const TASK_RESIZE:int = 3;
		
		public var focusedWindow:Window;
		public var activeTask:int;
		public var pressWindowX:Number;
		public var pressWindowY:Number;
		public var pressWindowScale:Number;
		public var resizeOffsetX:Number;
		public var resizeOffsetY:Number;
		public var pressMouseX:Number;
		public var pressMouseY:Number;
		public var pressMouseDistance:Number;
		public var isModal:Boolean;
		
		public function WindowManager(xSpace:Number = 100, ySpace:Number = 100) 
		{
			super();
			
			sizeMask = new Box(new FillStyle(0, .5));
			addChild(DisplayObject(sizeMask));
			DisplayObject(sizeMask).visible = false;
			sizeMask.xSize = contentsMinSizeX = xSpace;
			sizeMask.ySize = contentsMinSizeY = ySpace;
		}
		
		override public function update():void 
		{
			contentsMinSizeX = xSize;
			contentsMinSizeY = ySize;
			
			var window:Window;
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				window = getChildAt(i) as Window;
				if (!window) continue;
				window.update();
				if (window.sizeChanged)
				{
					var elementXSpace:Number;
					var elementYSpace:Number;
					switch (window.spaceRuleX)
					{
						case SPACE_RULE_BOTTOM_UP:
						case SPACE_RULE_TOP_DOWN_MINIMUM:
							elementXSpace = Math.min(window.contentsMinSizeX * window.scaleX, contentsMinSizeX);
							break;
						case SPACE_RULE_TOP_DOWN_MAXIMUM:
							elementXSpace = contentsMinSizeX;
							break;
					}
					switch (window.spaceRuleY)
					{
						case SPACE_RULE_BOTTOM_UP:
						case SPACE_RULE_TOP_DOWN_MINIMUM:
							elementYSpace = Math.min(window.contentsMinSizeY * window.scaleY, contentsMinSizeY);
							break;
						case SPACE_RULE_TOP_DOWN_MAXIMUM:
							elementYSpace = contentsMinSizeY;
							break;
					}
					window.fitToSpace(elementXSpace / window.scaleX, elementYSpace / window.scaleY);
					correctWindowPosition(window);
				}
			}
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void 
		{
			sizeChanged = false;
			
			sizeMask.xSize = contentsMinSizeX = xSpace;
			sizeMask.ySize = contentsMinSizeY = ySpace;
			
			var window:Window;
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				window = getChildAt(i) as Window;
				if (!window) continue;
				var elementXSpace:Number;
				var elementYSpace:Number;
				switch (window.spaceRuleX)
				{
					case SPACE_RULE_BOTTOM_UP:
					case SPACE_RULE_TOP_DOWN_MINIMUM:
						elementXSpace = Math.min(window.contentsMinSizeX * window.scaleX, contentsMinSizeX);
						break;
					case SPACE_RULE_TOP_DOWN_MAXIMUM:
						elementXSpace = contentsMinSizeX;
						break;
				}
				switch (window.spaceRuleY)
				{
					case SPACE_RULE_BOTTOM_UP:
					case SPACE_RULE_TOP_DOWN_MINIMUM:
						elementYSpace = Math.min(window.contentsMinSizeY * window.scaleY, contentsMinSizeY);
						break;
					case SPACE_RULE_TOP_DOWN_MAXIMUM:
						elementYSpace = contentsMinSizeY;
						break;
				}
				window.fitToSpace(elementXSpace / window.scaleX, elementYSpace / window.scaleY);
				correctWindowPosition(window);
			}
		}
		
		public function focusWindow(window:Window):void
		{
			if (focusedWindow == window) return;
			if (activeTask) stopAllTasks();
			
			focusedWindow = window;
			
			if (window) addChild(window);
		}
		
		protected function correctWindowPosition(window:Window):void
		{
			if (isNaN(window.alignmentX))
			{
				if (window.right > sizeMask.xSize) window.right = sizeMask.xSize;
				if (window.left < 0) window.left = 0;
			}
			else
			{
				if (window.alignmentX > 0) window.right = contentsMinSizeX;
				else if (window.alignmentX < 0) window.left = 0;
				else window.xMiddle = contentsMinSizeX / 2;
			}
			if (isNaN(window.alignmentY))
			{
				if (window.bottom > sizeMask.ySize) window.bottom = sizeMask.ySize;
				if (window.top < 0) window.top = 0;
			}
			else
			{
				if (window.alignmentY > 0) window.bottom = contentsMinSizeY;
				else if (window.alignmentY < 0) window.top = 0;
				else window.yMiddle = contentsMinSizeY / 2;
			}
		}
		
		public function addWindow(window:Window):void
		{
			if (isModal)
			{
				DisplayObject(sizeMask).visible = true;
			}
			
			if (window.parent !== this)
			{
				window.addEventListener(Window.EVENT_FOCUS_REQUESTED, onWindowFocusRequested, false, 0, true);
				window.addEventListener(Window.EVENT_CLOSE_REQUESTED, onWindowCloseRequested, false, 0, true);
				window.addEventListener(Window.EVENT_DRAG_START_REQUESTED, onWindowDragStartRequested, false, 0, true);
				window.addEventListener(Window.EVENT_DRAG_END_REQUESTED, onWindowDragEndRequested, false, 0, true);
				window.addEventListener(Window.EVENT_SCALE_START_REQUESTED, onWindowScaleStartRequested, false, 0, true);
				window.addEventListener(Window.EVENT_SCALE_END_REQUESTED, onWindowScaleEndRequested, false, 0, true);
				window.addEventListener(Window.EVENT_RESIZE_START_REQUESTED, onWindowResizeStartRequested, false, 0, true);
				window.addEventListener(Window.EVENT_RESIZE_END_REQUESTED, onWindowResizeEndRequested, false, 0, true);
				window.addEventListener(Window.EVENT_CORRECT_POSITION_REQUESTED, onWindowCorrectPositionRequested, false, 0, true);
			}
			
			focusWindow(window);
			window.setCollapsed(false);
		}
		
		public function removeWindow(window:Window):void
		{
			if (window.parent !== this) return;
			removeChild(window);
			
			if (focusedWindow == window) focusWindow(getTopWindow());
			if (!focusedWindow)
			{
				DisplayObject(sizeMask).visible = false;
			}
			
			window.removeEventListener(Window.EVENT_FOCUS_REQUESTED, onWindowFocusRequested);
			window.removeEventListener(Window.EVENT_CLOSE_REQUESTED, onWindowCloseRequested);
			window.removeEventListener(Window.EVENT_DRAG_START_REQUESTED, onWindowDragStartRequested);
			window.removeEventListener(Window.EVENT_DRAG_END_REQUESTED, onWindowDragEndRequested);
			window.removeEventListener(Window.EVENT_SCALE_START_REQUESTED, onWindowScaleStartRequested);
			window.removeEventListener(Window.EVENT_SCALE_END_REQUESTED, onWindowScaleEndRequested);
			window.removeEventListener(Window.EVENT_RESIZE_START_REQUESTED, onWindowResizeStartRequested);
			window.removeEventListener(Window.EVENT_RESIZE_END_REQUESTED, onWindowResizeEndRequested);
			window.removeEventListener(Window.EVENT_CORRECT_POSITION_REQUESTED, onWindowCorrectPositionRequested);
		}
		
		public function getTopWindow():Window
		{
			var result:Window;
			
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				result = getChildAt(i) as Window;
				if (result) break;
			}
			
			return result;
		}
		
		public function removeAllWindows():void
		{
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				var w:Window = getChildAt(i) as Window;
				if (w) removeWindow(w);
			}
		}
		
		protected function onWindowCloseRequested(e:Event):void
		{
			removeWindow(Window(e.currentTarget));
		}
		
		protected function onWindowDragStartRequested(e:Event):void
		{
			activeTask = TASK_DRAG;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved, false, 0, true);
			pressWindowX = focusedWindow.x;
			pressWindowY = focusedWindow.y;
			pressMouseX = mouseX;
			pressMouseY = mouseY;
		}
		
		protected function onWindowDragEndRequested(e:Event):void
		{
			stopAllTasks();
			
			var isClick:Boolean = Math.abs(mouseX - pressMouseX) < 5
				&& Math.abs(mouseY - pressMouseY) < 5;
				
			if (isClick) focusedWindow.setCollapsed(!focusedWindow.getCollapsed());
		}
		
		protected function onWindowScaleStartRequested(e:Event):void
		{
			activeTask = TASK_SCALE;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved, false, 0, true);
			pressWindowX = focusedWindow.x;
			pressWindowY = focusedWindow.y;
			pressMouseX = mouseX;
			pressMouseY = mouseY;
			//lastMouseDistance = new Point(pressMouseX, pressMouseY).subtract(focusedWindow.location).length;
			pressMouseDistance = new Point(pressMouseX, pressMouseY).subtract(focusedWindow.location).length;
			pressWindowScale = focusedWindow.scaleX;
		}
		
		protected function onWindowScaleEndRequested(e:Event):void
		{
			stopAllTasks();
			
			var isClick:Boolean = Math.abs(mouseX - pressMouseX) < 5
				&& Math.abs(mouseY - pressMouseY) < 5;
				
			if (isClick)
			{
				focusedWindow.scaleX = focusedWindow.scaleY = 1;
				focusedWindow.sizeChanged = true;
			}
		}
		
		protected function onWindowResizeStartRequested(e:Event):void
		{
			activeTask = TASK_RESIZE;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved, false, 0, true);
			pressWindowX = focusedWindow.x;
			pressWindowY = focusedWindow.y;
			pressMouseX = mouseX;
			pressMouseY = mouseY;
			resizeOffsetX = focusedWindow.right - mouseX;
			resizeOffsetY = focusedWindow.bottom - mouseY;
			
			focusedWindow.contentsMinSizeX = focusedWindow.xSize / focusedWindow.scaleX;
			focusedWindow.contentsMinSizeY = focusedWindow.ySize / focusedWindow.scaleY;
			focusedWindow.spaceRuleX = focusedWindow.spaceRuleY = SPACE_RULE_BOTTOM_UP;
		}
		
		protected function onWindowResizeEndRequested(e:Event):void
		{
			stopAllTasks();
			
			var isClick:Boolean = Math.abs(mouseX - pressMouseX) < 5
				&& Math.abs(mouseY - pressMouseY) < 5;
				
			if (isClick)
			{
				focusedWindow.spaceRuleX = focusedWindow.spaceRuleY = SPACE_RULE_TOP_DOWN_MINIMUM;
				focusedWindow.sizeChanged = true;
			}
		}
		
		protected function onMouseMoved(e:MouseEvent):void
		{
			switch (activeTask)
			{
				case TASK_DRAG:
					focusedWindow.alignmentX = NaN;
					focusedWindow.alignmentY = NaN;
					focusedWindow.x = pressWindowX + mouseX - pressMouseX;
					focusedWindow.y = pressWindowY + mouseY - pressMouseY;
					break;
				case TASK_SCALE:
					var mouseDistance:Number = new Point(mouseX, mouseY).subtract(new Point(pressWindowX, pressWindowY)).length;
					var scale:Number = mouseDistance / pressMouseDistance * pressWindowScale;
					focusedWindow.scaleX = scale;
					focusedWindow.scaleY = scale;
					break;
				case TASK_RESIZE:
					focusedWindow.contentsMinSizeX = (mouseX - pressWindowX + resizeOffsetX) / focusedWindow.scaleX;
					focusedWindow.contentsMinSizeY = (mouseY - pressWindowY + resizeOffsetY) / focusedWindow.scaleY;
					break;
			}
			
			focusedWindow.sizeChanged = true;
		}
		
		protected function stopAllTasks():void
		{
			activeTask = TASK_NONE;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved);
		}
		
		protected function onWindowFocusRequested(e:Event):void
		{
			if (e.target == focusedWindow) return;
			
			focusWindow(Window(e.currentTarget));
		}
		
		protected function onWindowCorrectPositionRequested(e:Event):void
		{
			correctWindowPosition(Window(e.target));
		}
	}
}