package com.pirkadat.trans 
{
	import com.pirkadat.trans.ITransInfo;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author András Parditka
	 */
	public class WaitInfo implements ITransInfo
	{
		public var steps:uint;
		public var currentStep:uint;
		
		public var doneFunc:Function;
		public var doneFuncThis:Object;
		public var doneFuncArgs:Array;
		
		public function WaitInfo(steps:uint = 1, doneFunc:Function = null, doneFuncThis:Object = null, doneFuncArgs:Array = null) 
		{
			this.steps = steps;
			
			this.doneFunc = doneFunc;
			this.doneFuncThis = doneFuncThis;
			this.doneFuncArgs = doneFuncArgs;
		}
		
		/* INTERFACE com.pirkadat.trans.ITransInfo */
		
		public function execute():Boolean
		{
			currentStep++;
			
			if (currentStep >= steps)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function executeDoneFunc():void
		{
			if (doneFunc != null && doneFuncThis) doneFunc.apply(doneFuncThis, doneFuncArgs);
		}
		
		public function conflicts(info:ITransInfo):Boolean
		{
			return false;
		}
		
		public function getParentObj():Object
		{
			return doneFuncThis;
		}
		
	}

}