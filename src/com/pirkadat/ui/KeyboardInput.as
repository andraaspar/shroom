package com.pirkadat.ui 
{
	import com.pirkadat.logic.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class KeyboardInput
	{
		protected var keysPressed:Dictionary;
		public var enabled:Boolean = true;
		
		public function KeyboardInput(keyEventSource:InteractiveObject) 
		{
			keysPressed = new Dictionary();
			
			keyEventSource.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			keyEventSource.addEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		
		protected function onKey(e:KeyboardEvent):void
		{
			if (e.target is TextField) return;
			
			if (e.type == KeyboardEvent.KEY_DOWN)
			{
				if (keysPressed[e.keyCode]) return;
				keysPressed[e.keyCode] = true;
				
				if (enabled)
				switch (e.keyCode)
				{
					case Key.SHIFT:
						Program.mbToP.newWalkingSpeedMultiplier = .2;
						break;
					
					case Key.LEFT:
						Program.mbToP.newWalkingSpeedMultiplier = e.shiftKey ? .2 : 1;
						Program.mbToP.leftStartRequested = true;
						break;
						
					case Key.RIGHT:
						Program.mbToP.newWalkingSpeedMultiplier = e.shiftKey ? .2 : 1;
						Program.mbToP.rightStartRequested = true;
						break;
						
					case Key.UP:
						Program.mbToP.upStartRequested = true;
						break;
						
					case Key.DOWN:
						Program.mbToP.downStartRequested = true;
						break;
					
					case Key.ENTER:
						Program.mbToP.special1StartRequested = true;
						break;
						
					case Key.SPACE:
						Program.mbToP.fire1StartRequested = true;
						break;
				}
			}
			else // Key up
			{
				delete keysPressed[e.keyCode];
				
				if (enabled)
				switch (e.keyCode)
				{
					case Key.SHIFT:
						Program.mbToP.newWalkingSpeedMultiplier = 1;
						break;
						
					case Key.LEFT:
						Program.mbToP.leftStopRequested = true;
						if (keysPressed[Key.RIGHT])
						{
							Program.mbToP.newWalkingSpeedMultiplier = e.shiftKey ? .2 : 1;
							Program.mbToP.rightStartRequested = true;
						}
						break;
						
					case Key.RIGHT:
						Program.mbToP.rightStopRequested = true;
						if (keysPressed[Key.LEFT])
						{
							Program.mbToP.newWalkingSpeedMultiplier = e.shiftKey ? .2 : 1;
							Program.mbToP.leftStartRequested = true;
						}
						break;
						
					case Key.UP:
						Program.mbToP.upStopRequested = true;
						if (keysPressed[Key.DOWN])
						{
							Program.mbToP.downStartRequested = true;
						}
						break;
						
					case Key.DOWN:
						Program.mbToP.downStopRequested = true;
						if (keysPressed[Key.UP])
						{
							Program.mbToP.upStartRequested = true;
						}
						break;
						
					case Key.ENTER:
						Program.mbToP.special1StopRequested = true;
						break;
						
					case Key.SPACE:
						Program.mbToP.fire1StopRequested = true;
						break;
						
					case Key.TAB:
						if (e.altKey || e.ctrlKey) break;
						if (e.shiftKey) Program.mbToP.switchMemberReverseRequested = true;
						else Program.mbToP.switchMemberRequested = true;
						break;
						
					case Key.BACKSPACE:
						Program.mbToP.endTurnRequested = true;
						break;
						
					case Key.NUMBER_0:
						Program.mbToP.newBounceCount = 0;
						break;
						
					case Key.NUMBER_1:
						Program.mbToP.newBounceCount = 1;
						break;
						
					case Key.NUMBER_2:
						Program.mbToP.newBounceCount = 2;
						break;
						
					case Key.NUMBER_3:
						Program.mbToP.newBounceCount = 3;
						break;
					
					case Key.NUMPAD_0:
						Program.mbToP.newBounceCount = 0;
						break;
						
					case Key.NUMPAD_1:
						Program.mbToP.newBounceCount = 1;
						break;
						
					case Key.NUMPAD_2:
						Program.mbToP.newBounceCount = 2;
						break;
						
					case Key.NUMPAD_3:
						Program.mbToP.newBounceCount = 3;
						break;
				}
			}
		}
	}
}