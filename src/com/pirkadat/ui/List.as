package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.shapes.*;
	import flash.events.*;
	
	public class List extends TrueSize
	{
		protected var windowHole:TrueSizeShape;
		protected var windowContent:Pack;
		protected var windowBackground:TrueSizeShape;
		protected var windowFrame:TrueSizeShape;
		protected var scrollBackground:TrueSizeShape;
		protected var scrollButton:TrueSizeShape;
		
		protected var itemWidth:Number;
		protected var itemHeight:Number;
		protected var visibleItemsCount:int;
		
		protected var lastMouseDragY:Number;
		
		public function List(itemWidth:Number, itemHeight:Number, visibleItemsCount:int) 
		{
			super();
			
			this.itemWidth = itemWidth;
			this.itemHeight = itemHeight;
			this.visibleItemsCount = visibleItemsCount;
			
			build();
		}
		
		protected function build():void
		{
			windowFrame = new RoundedBox(10, null, null, new LineStyle(4, Colors.WHITE));
			addChild(windowFrame);
			windowFrame.xSize = itemWidth + 10;
			windowFrame.ySize = itemHeight * visibleItemsCount;
			sizeMask = windowFrame;
			
			//
			
			windowHole = new RoundedBox(10);
			addChild(windowHole);
			windowHole.size = windowFrame.size;
			
			//
			
			windowBackground = new RoundedBox(10, new FillStyle(Colors.WHITE));
			addChild(windowBackground);
			windowBackground.size = windowHole.size;
			
			//
			
			windowContent = new Pack();
			addChild(windowContent);
			windowContent.defaultDistance = 0;
			windowContent.direction = PackDirections.VERTICAL;
			windowContent.mask = windowHole;
			
			//
			
			scrollBackground = new RoundedBoxComplex(0, 10, 0, 10, new FillStyle(Colors.BLACK));
			addChild(scrollBackground);
			scrollBackground.ySize = windowHole.ySize;
			scrollBackground.xSize = 10;
			scrollBackground.right = windowHole.right;
			
			//
			
			scrollButton = new RoundedBoxComplex(0, 10, 0, 10, new FillStyle(Colors.WHITE));
			addChild(scrollButton);
			scrollButton.xSize = 10;
			scrollButton.xMiddle = scrollBackground.xMiddle;
			
			//
			
			correctScrollButton();
			
			//
			
			scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			windowContent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			windowBackground.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		protected function correctScrollButton():void
		{
			if (windowContent.numChildren
				&& windowContent.ySize > ySize)
			{
				scrollButton.ySize = windowFrame.ySize / windowContent.ySize * scrollBackground.ySize;
				var scroll:Number = Math.max(0, Math.min(1, windowContent.y / (windowFrame.ySize - windowContent.ySize)));
				scrollButton.y = scroll * (scrollBackground.ySize - scrollButton.ySize);
			}
			else
			{
				scrollButton.ySize = scrollBackground.ySize;
				scrollButton.y = 0;
			}
		}
		
		protected function correctContentScroll():void
		{
			if (windowContent.numChildren
				&& windowContent.ySize > ySize)
			{
				var scroll:Number = Math.max(0, Math.min(1, scrollButton.y / (scrollBackground.ySize - scrollButton.ySize)));
				windowContent.y = scroll * (ySize - windowContent.ySize);
			}
			else
			{
				windowContent.y = 0;
			}
		}
		
		public function addListItems(listItems:Vector.<TrueSize>):void
		{
			for each (var listItem:TrueSize in listItems)
			{
				windowContent.addChild(listItem);
			}
			
			windowContent.update();
			correctScrollButton();
		}
		
		public function removeListItems(listItems:Vector.<TrueSize>):void
		{
			for each (var listItem:TrueSize in listItems)
			{
				windowContent.removeChild(listItem);
			}
			
			windowContent.update();
			correctScrollButton();
			correctContentScroll();
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case scrollButton:
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onScrollButtonDragged);
				break;
				case windowContent:
				case windowBackground:
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onListDragged);
			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			lastMouseDragY = mouseY;
			
			e.stopPropagation();
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScrollButtonDragged);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onListDragged);
		}
		
		protected function onMouseWheel(e:MouseEvent):void
		{
			windowContent.y += e.delta * (ySize / 30);
			
			correctScrollButton();
			correctContentScroll();
			
			e.stopPropagation();
		}
		
		protected function onScrollButtonDragged(e:MouseEvent):void
		{
			scrollButton.y += mouseY - lastMouseDragY;
			lastMouseDragY = mouseY;
			
			correctContentScroll();
			correctScrollButton();
		}
		
		protected function onListDragged(e:MouseEvent):void
		{
			windowContent.y += mouseY - lastMouseDragY;
			lastMouseDragY = mouseY;
			
			correctScrollButton();
			correctContentScroll();
		}
	}

}