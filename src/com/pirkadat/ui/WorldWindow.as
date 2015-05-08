package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.shapes.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class WorldWindow extends TrueSize
	{
		public static const EVENT_FOLLOW_AOI_REQUESTED:String = "WorldWindow.Follow.AOI.Requested";
		
		public var worldAppearance:WorldAppearance;
		
		public var isDragged:Boolean;
		public var dragSourceX:Number;
		public var dragSourceY:Number;
		public var dragContentSourceX:Number;
		public var dragContentSourceY:Number;
		public var dragContentSourceScale:Number;
		
		public var waitToFollowAOI:int;
		public var playerControlsScale:Boolean;
		
		public var firstUpdate:Boolean = true;
		
		public var targetScale:Number = 1;
		public var scaleSpeed:Number = 16;
		public var minScale:Number = .15;
		public var maxScale:Number = 2;
		public var targetX:Number;
		public var targetY:Number;
		
		public var state:int;
		
		public var aoiMinX:Number;
		public var aoiMaxX:Number;
		public var aoiMinY:Number;
		public var aoiMaxY:Number;
		
		public var interestingObjects:Dictionary;
		
		public var selectedMember:TeamMember;
		
		public function WorldWindow()
		{
			super();
			
			//
			
			worldAppearance = new WorldAppearance();
			addChild(worldAppearance);
			worldAppearance.scaleX = worldAppearance.scaleY = .01;
			worldAppearance.xMiddle = stage.stageWidth / 2;
			worldAppearance.yMiddle = stage.stageHeight / 2;
			
			//
			
			interestingObjects = new Dictionary(true);
			
			//
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(EVENT_FOLLOW_AOI_REQUESTED, onFollowAOIRequested);
		}
		
		protected function onMouseDown(e:MouseEvent):void 
		{
			isDragged = true;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			targetX = dragContentSourceX = worldAppearance.x;
			targetY = dragContentSourceY = worldAppearance.y;
			dragContentSourceScale = worldAppearance.scaleX;
			dragSourceX = mouseX;
			dragSourceY = mouseY;
			
			e.stopPropagation();
		}
		
		protected function onMouseUp(e:MouseEvent):void 
		{
			isDragged = false;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			switch (state)
			{
				case MBToUI.STATE_FOCUS:
				case MBToUI.STATE_SHOOT:
					waitToFollowAOI = 25;
				break;
				case MBToUI.STATE_OVERVIEW:
				case MBToUI.STATE_AIM:
				case MBToUI.STATE_MOVE:
				case MBToUI.STATE_SHUNPO:
					waitToFollowAOI = -1;
				break;
			}
		}
		
		protected function onMouseWheel(e:MouseEvent):void
		{
			var diff:Number = .02 * targetScale;
			targetScale += e.delta * diff;
			if (targetScale < minScale) targetScale = minScale;
			if (targetScale > maxScale) targetScale = maxScale;
			playerControlsScale = true;
			
			e.stopPropagation();
		}
		
		public function onFollowAOIRequested(e:Event = null):void
		{
			waitToFollowAOI = 0;
			playerControlsScale = false;
		}
		
		public function correctPositions():void
		{
			if (worldAppearance.left > 0) worldAppearance.left = 0;
			else if (worldAppearance.right < stage.stageWidth) worldAppearance.right = stage.stageWidth;
			
			if (worldAppearance.top > 0) worldAppearance.top = 0;
			else if (worldAppearance.bottom < stage.stageHeight) worldAppearance.bottom = stage.stageHeight;
		}
		
		public function update():void
		{
			if (Program.mbToUI.newState)
			{
				state = Program.mbToUI.newState;
				if (waitToFollowAOI < 0) waitToFollowAOI = 0;
				playerControlsScale = false;
				
				switch (state)
				{
					case MBToUI.STATE_OVERVIEW:
					case MBToUI.STATE_FOCUS:
					case MBToUI.STATE_SHOOT:
						scaleSpeed = 16;
					break;
					case MBToUI.STATE_MOVE:
					case MBToUI.STATE_AIM:
					case MBToUI.STATE_SHUNPO:
						scaleSpeed = 8;
					break;
				}
			}
			
			if (Program.mbToUI.memberSelectionChanged
				&& Program.mbToUI.newSelectedMember != selectedMember)
			{
				if (selectedMember && selectedMember.hasFinishedWorking)
				{
					waitToFollowAOI = 25;
				}
				selectedMember = Program.mbToUI.newSelectedMember;
				Program.mbToUI.notSafeToDragMember = !isDragged && waitToFollowAOI == 0;
			}
			
			var nextScale:Number = worldAppearance.scaleX + (targetScale - worldAppearance.scaleX) / scaleSpeed;
			
			if (isDragged)
			{
				var scaleDiff:Number = nextScale / dragContentSourceScale;
				var dragDiffX:Number = mouseX - dragSourceX * scaleDiff;
				var dragDiffY:Number = mouseY - dragSourceY * scaleDiff;
				
				worldAppearance.x = dragContentSourceX * scaleDiff + dragDiffX;
				worldAppearance.y = dragContentSourceY * scaleDiff + dragDiffY;
				
				correctPositions();
			}
			else
			{
				if (waitToFollowAOI == 0)
				{
					calculateAreaOfInterest();
					
					var aoiXRadius:Number = (aoiMaxX - aoiMinX) / 2;
					var aoiYRadius:Number = (aoiMaxY - aoiMinY) / 2;
					var aoiXMiddle:Number = aoiMinX + aoiXRadius;
					var aoiYMiddle:Number = aoiMinY + aoiYRadius;
					
					targetX = -(aoiXMiddle * worldAppearance.scaleX - stage.stageWidth / 2);
					targetY = -(aoiYMiddle * worldAppearance.scaleY - stage.stageHeight / 2);
					
					worldAppearance.x += (targetX - worldAppearance.x) / 8;
					worldAppearance.y += (targetY - worldAppearance.y) / 8;
					
					correctPositions();
					
					if (!playerControlsScale)
					{
						targetScale = Math.min(stage.stageWidth / 2 / aoiXRadius, stage.stageHeight / 2 / aoiYRadius) * .8;
						if (targetScale < minScale) targetScale = minScale;
						if (targetScale > 1) targetScale = 1;
					}
				}
				else if (waitToFollowAOI > 0)
				{
					waitToFollowAOI--;
					if (waitToFollowAOI == 0) playerControlsScale = false;
				}
				else
				{
					if (selectedMember
						&& (selectedMember.hasBeenFlying
							|| selectedMember.isWalking
							|| Program.mbToUI.memberSelectionChanged)
						&& (selectedMember.location.x - selectedMember.radius * 2 < -worldAppearance.x / worldAppearance.scaleX
							|| selectedMember.location.x + selectedMember.radius * 2 > -worldAppearance.x / worldAppearance.scaleX + stage.stageWidth / worldAppearance.scaleX
							|| selectedMember.location.y - selectedMember.radius * 2 < -worldAppearance.y / worldAppearance.scaleY
							|| selectedMember.location.y + selectedMember.radius * 2 > -worldAppearance.y / worldAppearance.scaleY + stage.stageHeight / worldAppearance.scaleY))
					{
						waitToFollowAOI = 0;
					}
				}
			}
			
			applyScale(nextScale);
			
			worldAppearance.update();
		}
		
		public function applyScale(scale:Number):void
		{
			var centerPointX:Number = stage.stageWidth / 2 - worldAppearance.x;
			var centerPointY:Number = stage.stageHeight / 2 - worldAppearance.y;
			worldAppearance.x = stage.stageWidth / 2 - (centerPointX * (scale / worldAppearance.scaleX));
			worldAppearance.y = stage.stageHeight / 2 - (centerPointY * (scale / worldAppearance.scaleY));
			worldAppearance.scaleX = worldAppearance.scaleY = scale;
			
			worldAppearance.onStageResized();
			
			correctPositions();
		}
		
		public function onStageResized():void
		{
			worldAppearance.onStageResized();
			
			correctPositions();
			
			minScale = Math.min(stage.stageWidth / worldAppearance.terrainAppearance.width, stage.stageHeight / worldAppearance.terrainAppearance.height) * .8;
			if (targetScale < minScale) targetScale = minScale;
			if (worldAppearance.scaleX < minScale) applyScale(minScale);
		}
		
		public function calculateAreaOfInterest():void
		{
			var objectAppearance:WorldObjectAppearance;
			var worldObject:WorldObject;
			var found:Boolean;
			
			aoiMinX = NaN;
			aoiMaxX = NaN;
			aoiMinY = NaN;
			aoiMaxY = NaN;
			
			for each (objectAppearance in worldAppearance.objectAppearances)
			{
				if (selectedMember
					&& objectAppearance.worldObject == selectedMember)
				{
					aoiMinX = objectAppearance.worldObject.location.x;
					aoiMaxX = objectAppearance.worldObject.location.x;
					aoiMinY = objectAppearance.worldObject.location.y;
					aoiMaxY = objectAppearance.worldObject.location.y;
					
					found = true;
				}
				
				if (objectAppearance.worldObject.velocity.x || objectAppearance.worldObject.velocity.y)
				{
					interestingObjects[objectAppearance.worldObject] = 25;
				}
			}
			
			for (var o:Object in interestingObjects)
			{
				worldObject = WorldObject(o);
				
				if (!found)
				{
					if (isNaN(aoiMinX))
					{
						aoiMinX = worldObject.location.x;
						aoiMaxX = worldObject.location.x;
						aoiMinY = worldObject.location.y;
						aoiMaxY = worldObject.location.y;
					}
					else
					{
						aoiMinX = Math.max(worldAppearance.minX, Math.min(aoiMinX, worldObject.location.x));
						aoiMaxX = Math.min(worldAppearance.maxX, Math.max(aoiMaxX, worldObject.location.x));
						aoiMinY = Math.max(worldAppearance.minY, Math.min(aoiMinY, worldObject.location.y));
						aoiMaxY = Math.min(worldAppearance.maxY, Math.max(aoiMaxY, worldObject.location.y));
					}
				}
				
				interestingObjects[o]--;
				if (interestingObjects[o] < 0) delete interestingObjects[o];
			}
			
			if (!isNaN(aoiMinX)) return;
			
			for each (objectAppearance in worldAppearance.objectAppearances)
			{
				if (!objectAppearance is TeamMemberAppearance) continue;
				
				if (isNaN(aoiMinX))
				{
					aoiMinX = objectAppearance.worldObject.location.x;
					aoiMaxX = objectAppearance.worldObject.location.x;
					aoiMinY = objectAppearance.worldObject.location.y;
					aoiMaxY = objectAppearance.worldObject.location.y;
				}
				else
				{
					aoiMinX = Math.max(worldAppearance.minX, Math.min(aoiMinX, objectAppearance.worldObject.location.x));
					aoiMaxX = Math.min(worldAppearance.maxX, Math.max(aoiMaxX, objectAppearance.worldObject.location.x));
					aoiMinY = Math.max(worldAppearance.minY, Math.min(aoiMinY, objectAppearance.worldObject.location.y));
					aoiMaxY = Math.min(worldAppearance.maxY, Math.max(aoiMaxY, objectAppearance.worldObject.location.y));
				}
			}
			
			if (!isNaN(aoiMinX)) return;
			
			aoiMinX = 0;
			aoiMaxX = worldAppearance.terrainAppearance.width;
			aoiMinY = 0;
			aoiMaxY = worldAppearance.terrainAppearance.height;
		}
	}

}