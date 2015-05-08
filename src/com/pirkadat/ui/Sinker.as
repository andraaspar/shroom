package com.pirkadat.ui 
{
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.*;
	import flash.events.*;
	import flash.filters.*;
	
	public class Sinker extends VisualObject
	{
		public var animation:BitmapAnimation;
		
		public var aniAssetID:int;
		public var colourAssetID:int;
		public var colour:int;
		
		public function Sinker(aniAssetID:int, colourAssetID:int, colour:int, worldAppearance:WorldAppearance = null) 
		{
			super(worldAppearance);
			
			this.aniAssetID = aniAssetID;
			this.colourAssetID = colourAssetID;
			this.colour = colour;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			animation = new BitmapAnimation();
			if (colourAssetID) animation.addLayer(Program.assetLoader.getAssetByID(colourAssetID), new MultiplierColorTransform(colour));
			animation.addLayer(Program.assetLoader.getAssetByID(aniAssetID));
			addChild(animation);
			animation.scaleY = -1;
			animation.xMiddle = animation.yMiddle = 0;
			animation.playRange(Program.assetLoader.getAssetAnimationRangesByID(aniAssetID)["sink"], false);
			
			alpha = .5;
			filters = [new BlurFilter()];
		}
		
		override public function update():void 
		{
			y += 2;
			
			if (top > worldAppearance.maxY) hasFinishedWorking = true;
		}
	}

}