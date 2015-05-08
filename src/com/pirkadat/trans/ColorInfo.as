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
	public class ColorInfo implements ITransInfo
	{
		public var subject:DisplayObject;
		
		public var redMSteps:Vector.<Number>;
		public var greenMSteps:Vector.<Number>;
		public var blueMSteps:Vector.<Number>;
		
		public var redOSteps:Vector.<Number>;
		public var greenOSteps:Vector.<Number>;
		public var blueOSteps:Vector.<Number>;
		
		public var steps:uint;
		public var currentStep:uint;
		
		public var doneFunc:Function;
		public var doneFuncThis:Object;
		public var doneFuncArgs:Array;
		
		public function ColorInfo(subject:DisplayObject, toColorTransform:ColorTransform, steps:uint = 1, doneFunc:Function = null, doneFuncThis:Object = null, doneFuncArgs:Array = null) 
		{
			this.subject = subject;
			
			if (subject.transform.colorTransform.redMultiplier == toColorTransform.redMultiplier
			&& subject.transform.colorTransform.greenMultiplier == toColorTransform.greenMultiplier
			&& subject.transform.colorTransform.blueMultiplier == toColorTransform.blueMultiplier
			
			&& subject.transform.colorTransform.redOffset == toColorTransform.redOffset
			&& subject.transform.colorTransform.greenOffset == toColorTransform.greenOffset
			&& subject.transform.colorTransform.blueOffset == toColorTransform.blueOffset)
			{
				steps = 1;
			}
			
			redMSteps = Util.smooth(subject.transform.colorTransform.redMultiplier, toColorTransform.redMultiplier, steps);
			greenMSteps = Util.smooth(subject.transform.colorTransform.greenMultiplier, toColorTransform.greenMultiplier, steps);
			blueMSteps = Util.smooth(subject.transform.colorTransform.blueMultiplier, toColorTransform.blueMultiplier, steps);
			
			redOSteps = Util.smooth(subject.transform.colorTransform.redOffset, toColorTransform.redOffset, steps);
			greenOSteps = Util.smooth(subject.transform.colorTransform.greenOffset, toColorTransform.greenOffset, steps);
			blueOSteps = Util.smooth(subject.transform.colorTransform.blueOffset, toColorTransform.blueOffset, steps);
			
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
				redMSteps[currentStep]
				, greenMSteps[currentStep]
				, blueMSteps[currentStep]
				, subject.transform.colorTransform.alphaMultiplier
				
				, redOSteps[currentStep]
				, greenOSteps[currentStep]
				, blueOSteps[currentStep]
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
			if (info is ColorInfo && ColorInfo(info).subject == subject) return true;
			else return false;
		}
		
		public function getParentObj():Object
		{
			return subject;
		}
		
	}

}