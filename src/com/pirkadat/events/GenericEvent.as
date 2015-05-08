package com.pirkadat.events 
{
	import flash.events.Event;
	
	public class GenericEvent extends Event 
	{
		public var data:*;
		
		public function GenericEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null) 
		{ 
			super(type, bubbles, cancelable);
			this.data = data;
		} 
		
		public override function clone():Event 
		{ 
			return new GenericEvent(type, bubbles, cancelable, data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GenericEvent", "type", "bubbles", "cancelable", "eventPhase", "data"); 
		}
	}
}