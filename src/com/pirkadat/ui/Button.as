package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.ExactColorTransform;
	import com.pirkadat.shapes.*;
	import com.pirkadat.trans.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	
	/**
	 * @author András Parditka
	 */
	public class Button extends UIElement
	{
		public static const FRAME_THICKNESS:Number = 6;
		public static const CORNER_RADIUS:Number = 10;
		
		public var insetX:Number = 10;
		public var insetY:Number = 10;
		
		public var background:RoundedBox;
		public var frame:RoundedBox;
		public var content:ITrueSize;
		public var contentAsUIElement:UIElement;
		
		public var isSelected:Boolean;
		
		public function Button(content:ITrueSize) 
		{
			super();
			
			this.content = content;
			contentAsUIElement = content as UIElement;
			build();
		}
		
		protected function build():void
		{
			background = new RoundedBox(CORNER_RADIUS, new FillStyle(Colors.BLACK, .6));
			addChild(background);
			sizeMask = background;
			
			frame = new RoundedBox(CORNER_RADIUS - FRAME_THICKNESS / 2, null, null, new LineStyle(FRAME_THICKNESS, Colors.WHITE, 1, false, LineScaleMode.NORMAL));
			addChild(frame);
			
			addChild(DisplayObject(content));
			contentAsUIElement = content as UIElement;
			
			//organize(content.xSize + insetX * 2, content.ySize + insetY * 2);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		}
		
		override public function update():void 
		{
			if (contentAsUIElement)
			{
				contentAsUIElement.update();
				sizeChanged = sizeChanged || contentAsUIElement.sizeChanged;
				if (sizeChanged)
				{
					contentsMinSizeX = contentAsUIElement.contentsMinSizeX + insetX * 2;
					contentsMinSizeY = contentAsUIElement.contentsMinSizeY + insetY * 2;
					organize(contentsMinSizeX, contentsMinSizeY);
				}
			}
			else
			{
				if (sizeChanged)
				{
					organize(content.xSize + insetX * 2, content.ySize + insetY * 2);
					contentsMinSizeX = xSize;
					contentsMinSizeY = ySize;
				}
			}
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void
		{
			sizeChanged = false;
			//if (xSpace == contentsMinSizeX && ySpace == contentsMinSizeY) return;
			
			if (contentAsUIElement)
			{
				var elementXSpace:Number;
				var elementYSpace:Number;
				switch (contentAsUIElement.spaceRuleX)
				{
					case SPACE_RULE_BOTTOM_UP:
					case SPACE_RULE_TOP_DOWN_MINIMUM:
						elementXSpace = contentAsUIElement.contentsMinSizeX;
						break;
					case SPACE_RULE_TOP_DOWN_MAXIMUM:
						elementXSpace = xSpace - insetX * 2;
						break;
				}
				switch (contentAsUIElement.spaceRuleY)
				{
					case SPACE_RULE_BOTTOM_UP:
					case SPACE_RULE_TOP_DOWN_MINIMUM:
						elementYSpace = contentAsUIElement.contentsMinSizeY;
						break;
					case SPACE_RULE_TOP_DOWN_MAXIMUM:
						elementYSpace = ySpace - insetY * 2;
						break;
				}
				contentAsUIElement.fitToSpace(elementXSpace, elementYSpace);
			}
			
			organize(xSpace, ySpace);
		}
		
		protected function organize(backgroundXSize:Number, backgroundYSize:Number):void
		{
			background.setSizeAndRadius(backgroundXSize, backgroundYSize);
			frame.setSizeAndRadius(backgroundXSize - FRAME_THICKNESS, backgroundYSize - FRAME_THICKNESS);
			
			content.middle = frame.middle = background.middle;
		}
		
		protected function onPressed(e:MouseEvent):void
		{
			Trans.add(new ColorInfo(background, new ExactColorTransform(Colors.WHITE)));
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		}
		
		protected function onReleased(e:MouseEvent):void
		{
			EventDispatcher(e.target).removeEventListener(MouseEvent.MOUSE_UP, onReleased);
			
			Trans.add(new ColorInfo(background, new ColorTransform(), 15));
		}
		
		public function setSelected(flag:Boolean):void
		{
			if (isSelected == flag) return;
			
			isSelected = flag;
			if (isSelected)
			{
				frame.filters = [new GlowFilter(Colors.WHITE, 1, 10, 10, 1.5, 2)];
			}
			else
			{
				frame.filters = [];
			}
		}
	}

}