package com.pirkadat.trans 
{
	import com.pirkadat.trans.ITransInfo;
	import com.pirkadat.logic.Util;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author András Parditka
	 */
	public class ScaleInfo implements ITransInfo
	{
		private var subject:DisplayObject;
		
		public var scaleXSteps:Vector.<Number>;
		public var scaleYSteps:Vector.<Number>;
		
		public var steps:uint;
		public var currentStep:uint;
		
		public var doneFunc:Function;
		public var doneFuncThis:Object;
		public var doneFuncArgs:Array;
		
		public function ScaleInfo(subject:DisplayObject, toScaleX:Number, toScaleY:Number, steps:uint = 1, ease:Number = .1, inAndOut:Boolean = false, doneFunc:Function = null, doneFuncThis:Object = null, doneFuncArgs:Array = null) 
		{
			this.subject = subject;
			
			if (isNaN(toScaleX)) toScaleX = subject.scaleX;
			if (isNaN(toScaleY)) toScaleY = subject.scaleY;
			
			if (subject.scaleX == toScaleX
			&& subject.scaleY == toScaleY)
			{
				steps = 1;
			}
			
			scaleXSteps = Util.smooth(subject.scaleX, toScaleX, steps, ease, inAndOut);
			scaleYSteps = Util.smooth(subject.scaleY, toScaleY, steps, ease, inAndOut);
			
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
			
			subject.scaleX = scaleXSteps[currentStep];
			subject.scaleY = scaleYSteps[currentStep];
			
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
			if (info is ScaleInfo && ScaleInfo(info).subject == subject) return true;
			else return false;
		}
		
		public function getParentObj():Object
		{
			return subject;
		}
		
	}

}