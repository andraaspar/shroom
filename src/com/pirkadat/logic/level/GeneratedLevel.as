package com.pirkadat.logic.level 
{
	import com.pirkadat.logic.level.gen.*;
	import com.pirkadat.logic.Program;
	import com.pirkadat.shapes.*;
	import com.pirkadat.ui.*;
	import com.pirkadat.ui.windows.*;
	import flash.display.*;
	public class GeneratedLevel implements ILevel
	{
		public static var levelStyles:Vector.<LevelStyle>;
		private var levelStyle:LevelStyle;
		
		private var generatedTerrain:BitmapData;
		private var generatedBackground:BitmapData;
		private var generatedDistance:BitmapData;
		private var generatedPreview:BitmapData;
		
		private var generator:LevelGenerator;
		public static var templates:Vector.<ILevelTemplate> = new <ILevelTemplate>[new Template01(), new Template02(), new Template03(), new Template04(), new Template05(), new Template06(), new Template07(), new Template08(), new Template09(), new Template10(), new Template11()];
		
		public function GeneratedLevel() 
		{
			var randomTemplateID:int = int(templates.length * Math.random());
			generator = new LevelGenerator(templates[randomTemplateID]);
			
			if (!levelStyles) generateLevelStyles();
			levelStyle = levelStyles[int(Math.random() * levelStyles.length)];
			
			Program.mbToUI.levelPreviewDownloaded = true;
		}
		
		public static function generateLevelStyles():void
		{
			levelStyles = new Vector.<LevelStyle>();
			for each (var node:XML in Program.assetLoader.assetInfo.ls)
			{
				levelStyles.push(new LevelStyle(node));
			}
		}
		
		public function getRequiredAssetIDs():Vector.<int>
		{
			return levelStyle.getRequiredAssetIDs();
		}
		
		public function getTerrain():BitmapData
		{
			if (!generatedTerrain) generatedTerrain = generator.getTerrain(levelStyle);
			return generatedTerrain;
		}
		
		public function getBackground():BitmapData
		{
			if (!generatedBackground) generatedBackground = generator.getBackground(levelStyle);
			return generatedBackground;
		}
		
		public function getDistance():BitmapData
		{
			if (!generatedDistance) generatedDistance = levelStyle.getDistanceBmd();
			return generatedDistance;
		}
		
		public function getPreview():BitmapData
		{
			if (!generatedPreview) generatedPreview = generator.getPreview();
			return generatedPreview;
		}
		
		public function onDestroy():void
		{
			if (generatedTerrain) generatedTerrain.dispose();
			if (generatedBackground) generatedBackground.dispose();
			if (generatedDistance) generatedDistance.dispose();
			if (generatedPreview) generatedPreview.dispose();
			levelStyle.unloadAssets();
		}
		
		public function getWaterColorGradient():Box
		{
			var result:Box = new Box(null, levelStyle.getWaterColorGradientStyle());
			return result;
		}
		
		public function getIsLoadingPreview():Boolean 
		{
			return false;
		}
		
		public function onPreviewDownloaded():void 
		{
			
		}
	}
}