package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.ui.*;
	import flash.events.*;
	public class ConfirmationWindow extends Window 
	{
		public var onConfirmCallback:Function;
		public var onCancelCallback:Function;
		
		public function ConfirmationWindow(action:String, title:String, onConfirmCallback:Function, onCancelCallback:Function) 
		{
			this.onConfirmCallback = onConfirmCallback;
			this.onCancelCallback = onCancelCallback;
			
			super(createContent(action), new DynamicText(title), true, false, true, true);
		}
		
		protected function createContent(action:String):ITrueSize
		{
			var mainRow:Row = new Row(false, 6);
			
			var confirmation:DynamicText = new DynamicText("Are you sure you want to " + action + "?");
			mainRow.addChild(confirmation);
			
			var buttonsRow:Row = new Row(true, 6);
			mainRow.addChild(buttonsRow);
			
			var confirmButton:Button = new Button(new DynamicText("Yes"));
			buttonsRow.addChild(confirmButton);
			confirmButton.addEventListener(MouseEvent.CLICK, onConfirmButtonClicked);
			
			var cancelButton:Button = new Button(new DynamicText("No"));
			buttonsRow.addChild(cancelButton);
			buttonsRow.distances[cancelButton] = 6;
			cancelButton.addEventListener(MouseEvent.CLICK, onCancelButtonClicked);
			
			return new Extender(mainRow);
		}
		
		protected function onConfirmButtonClicked(e:Event):void
		{
			if (onConfirmCallback != null) onConfirmCallback();
			dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
		}
		
		protected function onCancelButtonClicked(e:Event):void
		{
			if (onCancelCallback != null) onCancelCallback();
			dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
		}
	}

}