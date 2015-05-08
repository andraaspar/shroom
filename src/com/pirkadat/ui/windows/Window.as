package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.shapes.*;
	import com.pirkadat.ui.Button;
	import com.pirkadat.ui.Colors;
	import com.pirkadat.ui.DynamicText;
	import com.pirkadat.ui.UIElement;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	
	/**
	 * @author András Parditka
	 */
	public class Window extends UIElement
	{
		public var cornerRadius:Number = 4;
		
		public static const EVENT_FOCUS_REQUESTED:String = "Window.Focus.Requested";
		public static const EVENT_CLOSE_REQUESTED:String = "Window.Close.Requested";
		public static const EVENT_DRAG_START_REQUESTED:String = "Window.Drag.Start.Requested";
		public static const EVENT_DRAG_END_REQUESTED:String = "Window.Drag.End.Requested";
		public static const EVENT_SCALE_START_REQUESTED:String = "Window.Scale.Start.Requested";
		public static const EVENT_SCALE_END_REQUESTED:String = "Window.Scale.End.Requested";
		public static const EVENT_RESIZE_START_REQUESTED:String = "Window.Resize.Start.Requested";
		public static const EVENT_RESIZE_END_REQUESTED:String = "Window.Resize.End.Requested";
		public static const EVENT_CORRECT_POSITION_REQUESTED:String = "Window.Correct.Position.Requested";
		
		public var collapsingParts:TrueSize;
		
		public var background:RoundedBox;
		public var contentMask:RoundedBox;
		public var frame:RoundedBox;
		public var content:ITrueSize;
		public var contentAsUIElement:UIElement;
		public var titleButton:Button;
		public var closeButton:Button;
		public var resizeButton:Button;
		public var scaleButton:Button;
		public var scrollBarXButton:Button;
		public var scrollBarYButton:Button;
		
		public var scrollBarXSpace:Number;
		public var scrollBarYSpace:Number;
		public var scrollBarXStart:Number;
		public var scrollBarYStart:Number;
		
		public var mousePressTarget:Object;
		public var lastMouseX:Number;
		public var lastMouseY:Number;
		public var pressMouseX:Number;
		public var pressMouseY:Number;
		
		public var xLeftRatio:Number = 0;
		public var yTopRatio:Number = 0;
		
		public function Window(content:ITrueSize, titleLabel:ITrueSize = null, hasBackground:Boolean = true, hasCloseButton:Boolean = false, hasResizeButton:Boolean = false, hasScaleButton:Boolean = false, cornerRadius:Number = 4) 
		{
			super();
			
			this.cornerRadius = cornerRadius;
			alignmentX = 0;
			alignmentY = 0;
			
			build(content, titleLabel, hasCloseButton, hasResizeButton, hasScaleButton, hasBackground);
		}
		
		protected function build(content:ITrueSize, titleLabel:ITrueSize, hasCloseButton:Boolean, hasResizeButton:Boolean, hasScaleButton:Boolean, hasBackground:Boolean):void
		{
			collapsingParts = new TrueSize();
			addChild(collapsingParts);
			
			if (hasBackground)
			{
				background = new RoundedBox(cornerRadius, new FillStyle(Colors.DARKESTGRAY));
				collapsingParts.addChild(background);
			}
			
			contentMask = new RoundedBox(cornerRadius);
			collapsingParts.addChild(contentMask);
			sizeMask = contentMask;
			
			this.content = content;
			contentAsUIElement = content as UIElement;
			collapsingParts.addChild(DisplayObject(content));
			DisplayObject(content).mask = contentMask;
			content.top = contentMask.top;
			content.left = contentMask.left;
			IEventDispatcher(content).addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed, false, 0, true);
			
			if (hasBackground)
			{
				frame = new RoundedBox(cornerRadius, null, null, new LineStyle(1, Colors.WHITE, 1, false, LineScaleMode.NORMAL));
				//frame.filters = [new GlowFilter(0xffffdd, 1, 10, 10, 3, 2)];
				collapsingParts.addChild(frame);
			}
			
			if (titleLabel)
			{
				titleButton = new Button(titleLabel);
				addChild(titleButton);
				titleButton.update();
				titleButton.left = -Button.FRAME_THICKNESS;
				titleButton.top = -Button.FRAME_THICKNESS;
				titleButton.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed, false, 0, true);
			}
			
			var buttonMaxXSize:Number = 0;
			var buttonMaxYSize:Number = 0;
			
			if (hasCloseButton)
			{
				var closeButtonLabel:DynamicText = new DynamicText();
				closeButtonLabel.text = "X";
				
				closeButton = new Button(closeButtonLabel);
				collapsingParts.addChild(closeButton);
				closeButton.update();
				buttonMaxXSize = closeButton.xSize;
				buttonMaxYSize = closeButton.ySize;
				closeButton.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed, false, 0, true);
			}
			
			if (hasScaleButton)
			{
				var scaleButtonLabel:DynamicText = new DynamicText();
				scaleButtonLabel.text = "\\\\\\";
				
				scaleButton = new Button(scaleButtonLabel);
				collapsingParts.addChild(scaleButton);
				scaleButton.update();
				buttonMaxXSize = Math.max(buttonMaxXSize, scaleButton.xSize);
				buttonMaxYSize = Math.max(buttonMaxYSize, scaleButton.ySize);
				scaleButton.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed, false, 0, true);
			}
			
			if (hasResizeButton)
			{
				var resizeButtonLabel:DynamicText = new DynamicText();
				resizeButtonLabel.text = "///";
				
				resizeButton = new Button(resizeButtonLabel);
				collapsingParts.addChild(resizeButton);
				resizeButton.update();
				buttonMaxXSize = Math.max(buttonMaxXSize, resizeButton.xSize);
				buttonMaxYSize = Math.max(buttonMaxYSize, resizeButton.ySize);
				resizeButton.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed, false, 0, true);
			}
			
			if (buttonMaxXSize)
			{
				if (closeButton) closeButton.fitToSpace(buttonMaxXSize, buttonMaxYSize);
				if (resizeButton) resizeButton.fitToSpace(buttonMaxXSize, buttonMaxYSize);
				if (scaleButton) scaleButton.fitToSpace(buttonMaxXSize, buttonMaxYSize);
			}
			
			var sbContent:ITrueSize = new Box(new FillStyle(0, 0));
			sbContent.xSize = 10;
			sbContent.ySize = 1;
			
			scrollBarXButton = new Button(sbContent);
			collapsingParts.addChild(scrollBarXButton);
			scrollBarXButton.insetX = scrollBarXButton.insetY = Button.CORNER_RADIUS;
			scrollBarXButton.spaceRuleX = scrollBarXButton.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			
			scrollBarXButton.update();
			scrollBarXButton.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed, false, 0, true);
			
			sbContent = new Box(new FillStyle(0, 0));
			sbContent.xSize = 1;
			sbContent.ySize = 10;
			
			scrollBarYButton = new Button(sbContent);
			collapsingParts.addChild(scrollBarYButton);
			scrollBarYButton.insetX = scrollBarYButton.insetY = Button.CORNER_RADIUS;
			scrollBarYButton.spaceRuleX = scrollBarYButton.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			
			scrollBarYButton.update();
			scrollBarYButton.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed, false, 0, true);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseScrolled, false, 0, true);
		}
		
		override public function update():void
		{
			if (titleButton)
			{
				titleButton.update();
				if (titleButton.sizeChanged)
				{
					titleButton.fitToSpace(titleButton.contentsMinSizeX, titleButton.contentsMinSizeY);
				}
			}
			
			if (contentAsUIElement)
			{
				contentAsUIElement.update();
				sizeChanged = sizeChanged || contentAsUIElement.sizeChanged;
				if (sizeChanged)
				{
					if (spaceRuleX == SPACE_RULE_TOP_DOWN_MINIMUM) contentsMinSizeX = contentAsUIElement.contentsMinSizeX;
					if (spaceRuleY == SPACE_RULE_TOP_DOWN_MINIMUM) contentsMinSizeY = contentAsUIElement.contentsMinSizeY;
					/*
					organizeFrame(contentsMinSizeX, contentsMinSizeY);
					correctContentLocation();
					organizeButtons();*/
				}
			}
			else
			{
				if (sizeChanged)
				{
					if (spaceRuleX == SPACE_RULE_TOP_DOWN_MINIMUM) contentsMinSizeX = content.xSize;
					if (spaceRuleY == SPACE_RULE_TOP_DOWN_MINIMUM) contentsMinSizeY = content.ySize;
					/*
					organizeFrame(contentsMinSizeX, contentsMinSizeY);
					correctContentLocation();
					organizeButtons();*/
				}
			}
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void 
		{
			sizeChanged = false;
			
			if (contentAsUIElement)
			{
				var elementXSpace:Number;
				var elementYSpace:Number;
				switch (contentAsUIElement.spaceRuleX)
				{
					case SPACE_RULE_BOTTOM_UP:
						elementXSpace = contentAsUIElement.contentsMinSizeX;
						break;
					case SPACE_RULE_TOP_DOWN_MINIMUM:
						elementXSpace = contentAsUIElement.contentsMinSizeX;
						break;
					case SPACE_RULE_TOP_DOWN_MAXIMUM:
						elementXSpace = Math.max(contentAsUIElement.contentsMinSizeX, xSpace);
						break;
				}
				switch (contentAsUIElement.spaceRuleY)
				{
					case SPACE_RULE_BOTTOM_UP:
						elementYSpace = contentAsUIElement.contentsMinSizeY;
						break;
					case SPACE_RULE_TOP_DOWN_MINIMUM:
						elementYSpace = contentAsUIElement.contentsMinSizeY;
						break;
					case SPACE_RULE_TOP_DOWN_MAXIMUM:
						elementYSpace = Math.max(contentAsUIElement.contentsMinSizeY, ySpace);
						break;
				}
				contentAsUIElement.fitToSpace(elementXSpace, elementYSpace);
			}
			
			organizeFrame(xSpace, ySpace);
			correctContentLocation();
			organizeButtons();
		}
		
		protected function organizeFrame(xSpace:Number, ySpace:Number):void
		{
			if (background)
			{
				background.setSizeAndRadius(xSpace, ySpace);
				frame.setSizeAndRadius(xSpace, ySpace);
			}
			contentMask.setSizeAndRadius(xSpace, ySpace);
			
			matchRatios();
		}
		
		protected function organizeButtons():void
		{
			scrollBarXSpace = contentMask.xSize;
			scrollBarYSpace = contentMask.ySize;
			
			if (closeButton)
			{
				closeButton.right = contentMask.right + Button.FRAME_THICKNESS;
				closeButton.top = contentMask.top - Button.FRAME_THICKNESS;
				scrollBarYSpace -= closeButton.bottom;
				scrollBarYStart = closeButton.bottom;
			}
			else
			{
				scrollBarYSpace -= cornerRadius;
				scrollBarYStart = cornerRadius;
			}
			
			if (resizeButton)
			{
				resizeButton.right = contentMask.right + Button.FRAME_THICKNESS;
				resizeButton.bottom = contentMask.bottom + Button.FRAME_THICKNESS;
				scrollBarYSpace -= resizeButton.ySize - Button.FRAME_THICKNESS;
				scrollBarXSpace -= resizeButton.xSize - Button.FRAME_THICKNESS;
			}
			else
			{
				scrollBarYSpace -= cornerRadius;
				scrollBarXSpace -= cornerRadius;
			}
			
			if (scaleButton)
			{
				scaleButton.left = contentMask.left - Button.FRAME_THICKNESS;
				scaleButton.bottom = contentMask.bottom + Button.FRAME_THICKNESS;
				scrollBarXSpace -= scaleButton.right;
				scrollBarXStart = scaleButton.right;
			}
			else
			{
				scrollBarXSpace -= cornerRadius;
				scrollBarXStart = cornerRadius;
			}
			
			scrollBarXButton.bottom = contentMask.bottom + Button.FRAME_THICKNESS;
			scrollBarYButton.right = contentMask.right + Button.FRAME_THICKNESS;
			
			correctScrollButtons();
		}
		
		protected function correctScrollButtons():void
		{
			var xVisibleRatio:Number = contentMask.xSize / content.xSize;
			var yVisibleRatio:Number = contentMask.ySize / content.ySize;
			scrollBarXButton.visible = content.xSize - contentMask.xSize >= 1;
			scrollBarYButton.visible = content.ySize - contentMask.ySize >= 1;
			xLeftRatio = (contentMask.left - content.left) / content.xSize;
			yTopRatio = (contentMask.top - content.top) / content.ySize;
			
			if (scrollBarXButton.visible)
			{
				scrollBarXButton.fitToSpace(scrollBarXSpace * xVisibleRatio, scrollBarXButton.contentsMinSizeY);
				scrollBarXButton.left = scrollBarXStart + scrollBarXSpace * xLeftRatio;
			}
			
			if (scrollBarYButton.visible)
			{
				scrollBarYButton.fitToSpace(scrollBarYButton.contentsMinSizeX, scrollBarYSpace * yVisibleRatio);
				scrollBarYButton.top = scrollBarYStart + scrollBarYSpace * yTopRatio;
			}
		}
		
		protected function correctContentLocation():void
		{
			if (content.xSize > contentMask.xSize)
			{
				if (content.left > contentMask.left) content.left = contentMask.left;
				else if (content.right < contentMask.right) content.right = contentMask.right;
			}
			else
			{
				if (contentAsUIElement)
				{
					if (contentAsUIElement.alignmentX > 0) contentAsUIElement.right = contentMask.right;
					else if (contentAsUIElement.alignmentX < 0) contentAsUIElement.left = contentMask.left;
					else contentAsUIElement.xMiddle = contentMask.xMiddle;
				}
				else
				{
					content.xMiddle = contentMask.xMiddle;
				}
			}
			
			if (content.ySize > contentMask.ySize)
			{
				if (content.top > contentMask.top) content.top = contentMask.top;
				else if (content.bottom < contentMask.bottom) content.bottom = contentMask.bottom;
			}
			else
			{
				if (contentAsUIElement)
				{
					if (contentAsUIElement.alignmentY > 0) contentAsUIElement.bottom = contentMask.bottom;
					else if (contentAsUIElement.alignmentY < 0) contentAsUIElement.top = contentMask.top;
					else contentAsUIElement.yMiddle = contentMask.yMiddle;
				}
				else
				{
					content.yMiddle = contentMask.yMiddle;
				}
			}
		}
		
		protected function onMousePressed(e:MouseEvent):void
		{
			dispatchEvent(new Event(EVENT_FOCUS_REQUESTED, true));
			
			mousePressTarget = e.currentTarget;
			pressMouseX = lastMouseX = mouseX;
			pressMouseY = lastMouseY = mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseReleased, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved, false, 0, true);
			
			switch (mousePressTarget)
			{
				case titleButton:
					dispatchEvent(new Event(EVENT_DRAG_START_REQUESTED, true));
					break;
				case scaleButton:
					dispatchEvent(new Event(EVENT_SCALE_START_REQUESTED, true));
					break;
				case resizeButton:
					dispatchEvent(new Event(EVENT_RESIZE_START_REQUESTED, true));
					break;
			}
		}
		
		protected function onMouseMoved(e:MouseEvent):void
		{
			var xDelta:Number = mouseX - lastMouseX;
			var yDelta:Number = mouseY - lastMouseY;
			switch (mousePressTarget)
			{
				case scrollBarXButton:
					content.x -= xDelta * (content.xSize / scrollBarXSpace);
					correctContentLocation();
					correctScrollButtons();
					
					e.stopImmediatePropagation();
					break;
				case scrollBarYButton:
					content.y -= yDelta * (content.ySize / scrollBarYSpace);
					correctContentLocation();
					correctScrollButtons();
					
					e.stopImmediatePropagation();
					break;
				case content:
					content.x += xDelta;
					content.y += yDelta;
					correctContentLocation();
					correctScrollButtons();
					
					e.stopImmediatePropagation();
					break;
			}
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
		}
		
		protected function onMouseReleased(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseReleased);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved);
			
			switch (mousePressTarget)
			{
				case titleButton:
					dispatchEvent(new Event(EVENT_DRAG_END_REQUESTED, true));
					break;
				case resizeButton:
					dispatchEvent(new Event(EVENT_RESIZE_END_REQUESTED, true));
					break;
				case scaleButton:
					dispatchEvent(new Event(EVENT_SCALE_END_REQUESTED, true));
					break;
				case closeButton:
					if (closeButton.contains(DisplayObject(e.target))) dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
					break;
			}
		}
		
		protected function onMouseScrolled(e:MouseEvent):void
		{
			if (e.shiftKey)
			{
				content.x += e.delta * (contentMask.xSize * .03);
				if (content.xSize > contentMask.xSize) e.stopPropagation();
			}
			else
			{
				content.y += e.delta * (contentMask.ySize * .03);
				if (content.ySize > contentMask.ySize) e.stopPropagation();
			}
			correctContentLocation();
			correctScrollButtons();
		}
		
		public function setCollapsed(flag:Boolean):void
		{
			if (collapsingParts.visible != flag) return;
			collapsingParts.visible = !flag;
			if (flag) sizeMask = titleButton;
			else sizeMask = contentMask;
			dispatchEvent(new Event(EVENT_CORRECT_POSITION_REQUESTED, true));
		}
		
		public function getCollapsed():Boolean
		{
			return !collapsingParts.visible;
		}
		
		protected function matchRatios():void
		{
			content.left = contentMask.left - content.xSize * xLeftRatio;
			content.top = contentMask.top - content.ySize * yTopRatio;
		}
	}

}