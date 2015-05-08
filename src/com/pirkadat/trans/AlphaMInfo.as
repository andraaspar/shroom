package com.pirkadat.trans 
{
	import com.pirkadat.logic.*;
	import com.pirkadat.trans.*;
	import flash.display.*;
	import flash.geom.*;
	
	/**
	 * ...
	 * @author András Parditka
	 */
	public class AlphaMInfo implements ITransInfo
	{
		public var subject:DisplayObject;
		
		public var alphaMSteps:Vector.<Number>;
		
		public var steps:uint;
		public var currentStep:uint;
		
		public var doneFunc:Function;
		public var doneFuncThis:Object;
		public var doneFuncArgs:Array;
		
		public function AlphaMInfo(subject:DisplayObject, toAlphaMult:Number = 1, steps:uint = 1, doneFunc:Function = null, doneFuncThis:Object = null, doneFuncArgs:Array = null) 
		{
			this.subject = subject;
			
			if (subject.transform.colorTransform.alphaMultiplier == toAlphaMult) steps = 1;
			alphaMSteps = Util.smooth(subject.transform.colorTransform.alphaMultiplier, toAlphaMult, steps);
			
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
			
			subject.transform.colorTransform = new ColorTransform(
				subject.transform.colorTransform.redMultiplier
				, subject.transform.colorTransform.greenMultiplier
				, subject.transform.colorTransform.blueMultiplier
				, alphaMSteps[currentStep]
				
				, subject.transform.colorTransform.redOffset
				, subject.transform.colorTransform.greenOffset
				, subject.transform.colorTransform.blueOffset
				, subject.transform.colorTransform.alphaOffset
			);
			
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
			if (info is AlphaMInfo && AlphaMInfo(info).subject == subject) return true;
			else return false;
		}
		
		public function getParentObj():Object
		{
			return subject;
		}
		
	}

}