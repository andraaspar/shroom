package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.ui.*;
	public class MultiProgressWindow extends Window 
	{
		public var progressBars:Vector.<ProgressBar> = new Vector.<ProgressBar>();
		
		public function MultiProgressWindow(labels:Array) 
		{
			super(getContent(labels), null);
		}
		
		protected function getContent(labels:Array):ITrueSize
		{
			var mainRow:Row = new Row(false, 12);
			
			for each (var label:String in labels)
			{
				var progressBar:ProgressBar = new ProgressBar();
				progressBar.setLabel(label);
				progressBars.push(progressBar);
				mainRow.addChild(progressBar);
			}
			
			var extender:Extender = new Extender(mainRow);
			return extender;
		}
		
		public function setProgress(barIndex:int, progress:Number):void
		{
			progressBars[barIndex].setProgress(progress);
		}
	}

}