package com.pirkadat.ui 
{
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.Program;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class Ghost extends VisualObject
	{
		public var animation:BitmapAnimation;
		public var radius:Number = 40;
		
		public var aniAssetID:int;
		public var colourAssetID:int;
		public var colour:int;
		
		public function Ghost(aniAssetID:int, colourAssetID:int, colour:int, worldAppearance:WorldAppearance = null) 
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
			
			var m:Matrix = new Matrix();
			m.createGradientBox(radius * 2, radius * 2, 0, -radius, -radius);
			graphics.beginGradientFill(GradientType.RADIAL, [0xffffff, 0xffffff], [1, 0], [0, 255], m);
			graphics.drawRect(-radius, -radius, radius * 2, radius * 2);
			
			animation = new BitmapAnimation();
			animation.addLayer(Program.assetLoader.getAssetByID(colourAssetID), new MultiplierColorTransform(colour));
			animation.addLayer(Program.assetLoader.getAssetByID(aniAssetID));
			addChild(animation);
			animation.xMiddle = animation.yMiddle = 0;
			animation.playRange(Program.assetLoader.getAssetAnimationRangesByID(aniAssetID)["ghost"], false);
			
			alpha = .5;
			
			blendMode = BlendMode.ADD;
		}
		
		override public function update():void 
		{
			y -= 3;
			
			if (bottom < worldAppearance.minY) hasFinishedWorking = true;
		}
	}

}