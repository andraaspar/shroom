package com.pirkadat.logic 
{
	import com.pirkadat.ui.Console;
	import flash.display.Stage;
	public class FakeThread
	{
		protected var tasks:Vector.<Function>;
		protected var callbacks:Vector.<Function>;
		protected var stopAfter:Number;
		protected var limit:Number;
		
		public var hasTasks:Boolean;
		
		public function FakeThread(limit:Number = 40) 
		{
			tasks = new Vector.<Function>();
			callbacks = new Vector.<Function>();
			this.limit = limit;
		}
		
		public function execute():void
		{
			Console.say(".");
			stopAfter = new Date().time + limit;
			
			do
			{
				var i:int = tasks.length;
				if (i == 0)
				{
					hasTasks = false;
					break;
				}
				for (i--; i >= 0; i--)
				{
					if (!tasks[i]())
					{
						tasks.splice(i, 1);
						callbacks.splice(i, 1)[0]();
					}
				}
			}
			while (new Date().time < stopAfter);
		}
		
		public function add(task:Function, callback:Function):void
		{
			tasks.push(task);
			callbacks.push(callback);
			
			hasTasks = true;
		}
	}

}