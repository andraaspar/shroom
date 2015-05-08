package com.pirkadat.trans 
{
	import com.pirkadat.trans.ITransInfo;
	import com.pirkadat.util.Util;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author András Parditka
	 */
	public class FlyInfo implements ITransInfo
	{
		public var subject:DisplayObject;
		
		public var xSteps:Array;
		public var ySteps:Array;
		
		public var steps:uint;
		public var currentStep:uint;
		
		public var doneFunc:Function;
		public var doneFuncThis:Object;
		public var doneFuncArgs:Array;
		
		public function FlyInfo(subject:DisplayObject, toX:Number, toY:Number, steps:uint = 1, ease:Number = .1, inAndOut:Boolean = false, doneFunc:Function = null, doneFuncThis:Object = null, doneFuncArgs:Array = null) 
		{
			this.subject = subject;
			
			if (isNaN(toX)) toX = subject.x;
			if (isNaN(toY)) toY = subject.y;
			
			if (subject.x == toX
			&& subject.y == toY)
			{
				steps = 1;
			}
			
			xSteps = Util.smooth(subject.x, toX, steps, ease, inAndOut);
			ySteps = Util.smooth(subject.y, toY, steps, ease, inAndOut);
			
			this.steps = steps;
			
			this.doneFunc = doneFunc;
			this.doneFuncThis = doneFuncThis;
			this.doneFuncArgs = doneFuncArgs;
		}
		
		/* INTERFACE com.pirkadat.trans.ITransInfo */
		
		public function execute():Boolean
		{
			if (!subject.parent)
			{
				doneFunc = null;
				return false;
			}
			
			currentStep++;
			
			subject.x = xSteps[currentStep];
			subject.y = ySteps[currentStep];
			
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
			if (info is FlyInfo && FlyInfo(info).subject == subject) return true;
			else return false;
		}
		
		public function getParentObj():Object
		{
			return subject;
		}
		
	}

}