package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.logic.level.ILevel;
	import com.pirkadat.shapes.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	import flash.media.*;
	
	public class WorldAppearance extends TrueSize
	{
		public var background:TrueSizeShape;
		public var terrainAppearance:TrueSizeBitmap;
		public var backgroundAppearance:TrueSizeBitmap;
		public var distanceAppearance:TrueSizeBitmap;
		public var canvas:TrueSize;
		public var waterAppearance:WaterAppearance;
		public var objectAppearances:Vector.<WorldObjectAppearance> = new Vector.<WorldObjectAppearance>();
		
		public var visualObjects:Vector.<VisualObject> = new Vector.<VisualObject>();
		
		public var distanceMoveRatio:Number;
		
		public var minX:Number;
		public var maxX:Number;
		public var minY:Number;
		public var maxY:Number;
		
		public var soundRequests:Vector.<SoundRequest> = new <SoundRequest>[];
		public var origoPoint:Point = new Point();
		
		public function WorldAppearance() 
		{
			super();
			
			build();
		}
		
		protected function build():void
		{
			var level:ILevel = Program.game.level;
			
			//
			
			background = new Box(new FillStyle(0,0));
			addChild(background);
			sizeMask = background;
			
			distanceAppearance = new TrueSizeBitmap(level.getDistance());
			addChild(distanceAppearance);
			
			backgroundAppearance = new TrueSizeBitmap(level.getBackground());
			addChild(backgroundAppearance);
			
			terrainAppearance = new TrueSizeBitmap(level.getTerrain());
			addChild(terrainAppearance);
			
			backgroundAppearance.size = terrainAppearance.size;
			
			canvas = new TrueSize();
			addChild(canvas);
			canvas.blendMode = BlendMode.ADD;
			
			//
			
			waterAppearance = new WaterAppearance();
			addChild(waterAppearance);
			
			//
			
			onStageResized();
		}
		
		public function update():void
		{
			//Console.say("WorldAppearance.update()");
			
			if (Program.mbToUI.clearCanvas)
			{
				removeChild(canvas);
				canvas = new TrueSize();
				addChildAt(canvas, getChildIndex(terrainAppearance) + 1);
				canvas.blendMode = BlendMode.ADD;
			}
			
			var objectAppearance:WorldObjectAppearance;
			for each (var object:WorldObject in Program.mbToUI.newWorldObjects)
			{
				//if (object.hasFinishedWorking) continue;
				objectAppearance = object.createAppearance(this);
				
				objectAppearances.push(objectAppearance);
				addChild(objectAppearance);
			}
			
			var generatedVisualObjects:Vector.<VisualObject>;
			for (var i:int = objectAppearances.length - 1; i >= 0; i--)
			{
				objectAppearance = objectAppearances[i];
				
				objectAppearance.update();
				
				generatedVisualObjects = objectAppearance.generateVisualObjects();
				
				if (generatedVisualObjects)
				{
					for each (var visualObject:VisualObject in generatedVisualObjects)
					{
						addChild(visualObject);
					}
					visualObjects = visualObjects.concat(generatedVisualObjects);
				}
				
				if (objectAppearance.worldObject.hasFinishedWorking)
				{
					removeChild(objectAppearance);
					objectAppearances.splice(i, 1);
				}
			}
			
			for (i = visualObjects.length - 1; i >= 0; i--)
			{
				visualObject = visualObjects[i];
				visualObject.update();
				if (visualObject.hasFinishedWorking)
				{
					removeChild(visualObject);
					visualObjects.splice(i, 1);
				}
			}
			
			waterAppearance.updateReflection(this);
			
			distanceAppearance.xMiddle = background.xMiddle + (xMiddle - stage.stageWidth / 2) * distanceMoveRatio;
			distanceAppearance.yMiddle = background.yMiddle + (yMiddle - stage.stageHeight / 2) * distanceMoveRatio;
			
			for each (var sr:SoundRequest in Program.mbToUI.newSounds)
			{
				soundRequests.push(sr);
				playSoundRequest(sr);
			}
			
			for each (sr in soundRequests)
			{
				setPan(sr);
			}
		}
		
		public function onStageResized():void
		{
			background.width = stage.stageWidth / scaleX + terrainAppearance.width;
			background.height = stage.stageHeight / scaleY + terrainAppearance.height;
			background.x = -stage.stageWidth / scaleX / 2;
			background.y = -stage.stageHeight / scaleY / 2;
			
			minX = background.x;
			maxX = background.right;
			minY = background.y;
			maxY = background.bottom;
			
			waterAppearance.width = background.width;
			waterAppearance.height = stage.stageHeight / scaleY / 2;
			waterAppearance.left = background.left;
			waterAppearance.bottom = background.bottom;
			
			distanceAppearance.width = stage.stageWidth / scaleX * 1.5;
			distanceAppearance.height = stage.stageHeight / scaleY * 1.5;
			distanceAppearance.scaleX = distanceAppearance.scaleY = Math.max(distanceAppearance.scaleX, distanceAppearance.scaleY);
			
			//
			
			var windowEdgeToBGEdgeX:Number = (xSize - stage.stageWidth) / 2;
			var bgEdgeToDistanceEdgeX:Number = (distanceAppearance.width - background.width) / 2;
			var windowEdgeToBGEdgeY:Number = (ySize - stage.stageHeight) / 2;
			var bgEdgeToDistanceEdgeY:Number = (distanceAppearance.height - background.height) / 2;
			distanceMoveRatio = Math.min(bgEdgeToDistanceEdgeX / windowEdgeToBGEdgeX, bgEdgeToDistanceEdgeY / windowEdgeToBGEdgeY);
			
			//
			
			distanceAppearance.xMiddle = background.xMiddle + (xMiddle - stage.stageWidth / 2) * distanceMoveRatio;
			distanceAppearance.yMiddle = background.yMiddle + (yMiddle - stage.stageHeight / 2) * distanceMoveRatio;
		}
		
		public function playSoundRequest(sr:SoundRequest):void
		{
			var sound:Sound = Sound(Program.assetLoader.getAssetByID(sr.assetID));
			if (!sound)
			{
				Console.say("Sound unavailable:", sr.assetID);
				removeSoundRequest(sr);
				return;
			}
			sr.soundChannel = sound.play(0, sr.loop);
			if (!sr.soundChannel) 
			{
				Console.say("Could not play sound:",sr.assetID);
				removeSoundRequest(sr);
				return;
			}
			sr.soundChannel.soundTransform = new SoundTransform(sr.volume);
			sr.soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundPlaybackEnded, false, 0, true);
		}
		
		public function setPan(sr:SoundRequest):void
		{
			var halfStageWidth:Number = stage.stageWidth / 2;
			var st:SoundTransform = sr.soundChannel.soundTransform;
			if (sr.displayObject) st.pan = (sr.displayObject.localToGlobal(origoPoint).x - halfStageWidth) / halfStageWidth;
			else if (sr.location) st.pan = (localToGlobal(sr.location).x - halfStageWidth) / halfStageWidth;
			sr.soundChannel.soundTransform = st;
		}
		
		protected function onSoundPlaybackEnded(e:Event):void
		{
			for (var i:int = soundRequests.length - 1; i >= 0; i--)
			{
				if (e.target === soundRequests[i].soundChannel) break;
			}
			soundRequests[i].soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundPlaybackEnded);
			soundRequests[i].playbackIsOver = true;
			soundRequests.splice(i, 1);
		}
		
		protected function removeSoundRequest(sr:SoundRequest):void
		{
			for (var i:int = soundRequests.length - 1; i >= 0; i--)
			{
				if (sr === soundRequests[i]) break;
			}
			if (sr.soundChannel)
			{
				sr.soundChannel.stop();
				sr.soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundPlaybackEnded);
			}
			soundRequests.splice(i, 1);
		}
	}

}