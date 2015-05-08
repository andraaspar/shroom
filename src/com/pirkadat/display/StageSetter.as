package com.pirkadat.display 
{
	import flash.display.*;
	
	public class StageSetter extends MovieClip
	{
		public function StageSetter() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			//stage.quality = StageQuality.LOW;
		}
	}
}