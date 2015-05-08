package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import flash.events.*;
	
	public class WalkDrag extends TrueSize
	{
		public var teamMember:TeamMember;
		
		public var dragSource:TrueSize;
		public var dragTarget:TrueSizeShape;
		
		public var mayBeDragged:Boolean;
		public var isDragged:Boolean;
		
		public var walkingDirection:int;
		public var isJumping:Boolean;
		
		public var radius:Number;
		
		public var dragTime:int;
		
		//public var prevMouseY:Number;
		
		public function WalkDrag(teamMember:TeamMember) 
		{
			super();
			
			this.teamMember = teamMember;
			radius = teamMember.radius * 2;
			
			dragSource = new TrueSize();
			addChild(dragSource);
			dragSource.graphics.beginFill(0, 0);
			dragSource.graphics.drawCircle(0, 0, teamMember.radius * 2);
			
			dragSource.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed);
			dragSource.addEventListener(MouseEvent.MOUSE_UP, onMouseReleasedOver);
			
			dragTarget = new TrueSizeShape();
			addChild(dragTarget);
			dragTarget.graphics.beginFill(0xffffff, 1);
			dragTarget.graphics.drawCircle(0, 0, 5);
			dragTarget.visible = false;
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function onMousePressed(e:MouseEvent):void
		{
			if (teamMember.team.controller != Team.CONTROLLER_HUMAN) return;
			
			if (teamMember.team.isSelected)
			{
				Program.mbToP.iAmHere = true;
				if (teamMember.isSelected)
				{
					dragTime = 0;
				}
				else
				{
					dragTime = 12;
					Program.mbToP.newSelectedTeamMember = teamMember;
				}
				e.stopPropagation();
			}
			
			//
			
			if (!mayBeDragged) return;
			
			isDragged = true;
			//prevMouseY = stage.mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseReleased, false, 0, true);
			
			dragTarget.visible = true;
			
			e.stopPropagation();
		}
		
		protected function onMouseReleased(e:MouseEvent = null):void
		{
			isDragged = false;
			
			if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseReleased);
			
			dragTarget.visible = false;
			
			Program.mbToP.leftStopRequested = true;
			Program.mbToP.rightStopRequested = true;
			Program.mbToP.upStopRequested = true;
			
			if (e) e.stopPropagation();
		}
		
		protected function onMouseReleasedOver(e:MouseEvent):void
		{
			if (dragTime < 12)
			{
				dispatchEvent(new Event(WorldWindow.EVENT_FOLLOW_AOI_REQUESTED, true));
			}
		}
		
		public function doDrag():void
		{
			if (Program.mbToUI.notSafeToDragMember)
			{
				dragTime = -12;
			}
			
			dragTime++;
			
			dragTarget.x = mouseX;
			dragTarget.y = mouseY;
			
			if (dragTime < 0) return;
			
			var dist:Number = Math.sqrt(mouseX * mouseX + mouseY * mouseY);
			Program.mbToP.newWalkingSpeedMultiplier = Math.max(0, Math.min(1, (Math.abs(mouseX) - radius) / 25));
			
			if (mouseX < -teamMember.radius) walkingDirection = -1;
			else if (mouseX > teamMember.radius) walkingDirection = 1;
			else walkingDirection = 0;
			
			if (dist <= radius
				|| walkingDirection == 0)
			{
				Program.mbToP.leftStopRequested = true;
				Program.mbToP.rightStopRequested = true;
			}
			else if (walkingDirection != prevWalkingDirection)
			{
				switch (walkingDirection)
				{
					case -1:
						Program.mbToP.leftStartRequested = true;
					break;
					case 1:
						Program.mbToP.rightStartRequested = true;
					break;
				}
				switch (prevWalkingDirection)
				{
					case -1:
						Program.mbToP.leftStopRequested = true;
					break;
					case 1:
						Program.mbToP.rightStopRequested = true;
					break;
				}
			}
			
			var prevWalkingDirection:int = walkingDirection;
			
			var wasJumping:Boolean = isJumping;
			isJumping = dist > radius && mouseY < -Math.abs(mouseX);
			//isJumping = isJumping || stage.mouseY - prevMouseY < -20;
			if (isJumping != wasJumping)
			{
				if (isJumping) Program.mbToP.upStartRequested = true;
				else Program.mbToP.upStopRequested = true;
			}
			
			//prevMouseY = stage.mouseY;
		}
		
		public function enableDragging():void
		{
			mayBeDragged = true;
		}
		
		public function disableDragging():void
		{
			mayBeDragged = false;
			
			if (isDragged)
			{
				onMouseReleased();
			}
		}
		
		protected function onRemoved(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseReleased);
		}
	}

}