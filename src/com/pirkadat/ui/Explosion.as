package com.pirkadat.ui 
{
	import com.pirkadat.logic.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class Explosion extends VisualObject
	{
		public var bitmapAnimation:BitmapAnimation;
		
		public var firstUpdate:Boolean = true;
		public var colour:uint;
		
		public var aniAssetID:int;
		
		public function Explosion(aniAssetID:int, worldAppearance:WorldAppearance = null) 
		{
			super(worldAppearance);
			this.aniAssetID = aniAssetID;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			bitmapAnimation = new BitmapAnimation();
			bitmapAnimation.addLayer(Program.assetLoader.getAssetByID(aniAssetID));
			addChild(bitmapAnimation);
			bitmapAnimation.xMiddle = bitmapAnimation.yMiddle = 0;
			
			bitmapAnimation.playRange(Program.assetLoader.getAssetAnimationRangesByID(aniAssetID)["once"], false);
		}
		
		override public function update():void 
		{
			if (bitmapAnimation.currentFrame == bitmapAnimation.playTo)
			{
				hasFinishedWorking = true;
			}
		}
	}

}