package com.pirkadat.trans 
{
	import com.pirkadat.trans.ITransInfo;
	import com.pirkadat.util.Util;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author András Parditka
	 */
	public class RotateInfo implements ITransInfo
	{
		public var subject:DisplayObject;
		
		public var rotationSteps:Array;
		
		public var steps:uint;
		public var currentStep:uint;
		
		public var doneFunc:Function;
		public var doneFuncThis:Object;
		public var doneFuncArgs:Array;
		
		public function RotateInfo(subject:DisplayObject, toRotation:Number, steps:uint = 1, ease:Number = .1, inAndOut:Boolean = false, doneFunc:Function = null, doneFuncThis:Object = null, doneFuncArgs:Array = null) 
		{
			this.subject = subject;
			
			toRotation %= 360;
			if (toRotation > 180)
			{
				toRotation -= 360;
			}
			else if (toRotation < -180)
			{
				toRotation += 360;
			}
			if (subject.rotation == toRotation)
			{
				steps = 1;
			}
			
			// Examining if it is shorter in the other direction
			
			if (toRotation >= 0) {
				if (Math.abs(subject.rotation - toRotation) > Math.abs(subject.rotation + 360 - toRotation)) {
					toRotation -= 360;
				}
			} else if (toRotation < 0) {
				if (Math.abs(subject.rotation - toRotation) > Math.abs(subject.rotation + 360 + toRotation)) {
					toRotation += 360;
				}
			}
			
			rotationSteps = Util.smooth(subject.rotation, toRotation, steps, ease, inAndOut);
			
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
			
			subject.rotation = rotationSteps[currentStep];
			
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
			if (info is RotateInfo && RotateInfo(info).subject == subject) return true;
			else return false;
		}
		
		public function getParentObj():Object
		{
			return subject;
		}
		
	}

}