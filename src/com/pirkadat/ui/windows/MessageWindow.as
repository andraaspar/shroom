package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.filters.*;
	import flash.text.*;
	public class MessageWindow extends Window 
	{
		public var textField:DynamicText;
		public var tfExtender:Extender;
		public var messageTime:int;
		
		public function MessageWindow() 
		{
			super(createContent(), null, false, false, false, false, 0);
			alignmentY = -1;
		}
		
		protected function createContent():ITrueSize
		{
			textField = new DynamicText();
			textField.wordWrap = true;
			textField.width = 750;
			textField.defaultTextFormat = new TextFormat(TextDefaults.globalDefaultTextFormat.font
				, 26
				, TextDefaults.globalDefaultTextFormat.color
				, null, null, null, null, null
				, TextFormatAlign.CENTER);
			
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			textField.filters = [new GlowFilter(0, 1, 10, 10, 1, 1)];
			tfExtender = new Extender(textField, 50, 0, 16, 0);
			return tfExtender;
		}
		
		override public function update():void 
		{
			if (Program.mbToUI.newMessageBoxText != null)
			{
				textField.text = Program.mbToUI.newMessageBoxText;
				messageTime = Program.mbToUI.newMessageBoxTime;
				tfExtender.sizeChanged = true;
			}
			
			if (messageTime == 0) textField.text = "";
			else if (messageTime > 0) messageTime--;
			
			super.update();
		}
	}

}