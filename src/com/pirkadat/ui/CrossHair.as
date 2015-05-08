package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.Program;
	import com.pirkadat.logic.Team;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class CrossHair extends TrueSize
	{
		public const HALF_PI:Number = 1.570796326794897;
		
		public var cross:TrueSize;
		//public var angleHint:TrueSizeShape;
		public var powerHint:TrueSizeShape;
		
		public var radius:Number;
		public var maxPowerDistance:Number = 100;
		public var crossRadius:Number = 15;
		
		public var angle:Number;
		public var facing:int;
		public var powerMultiplier:Number;
		
		public var isDragged:Boolean;
		public var crossDragXDiff:Number;
		public var crossDragYDiff:Number;
		
		public var isShown:Boolean;
		
		public function CrossHair(radius:Number) 
		{
			super();
			
			this.radius = radius;
			
			cross = new TrueSize();
			//angleHint = new TrueSizeShape();
			powerHint = new TrueSizeShape();
			
			//addChild(angleHint);
			addChild(powerHint);
			addChild(cross);
			
			cross.addEventListener(MouseEvent.MOUSE_DOWN, crossPressed);
			
			mouseEnabled = false;
			
			redraw();
			setAngleAndPower(0, 1, 0);
		}
		
		public function redraw():void
		{
			var g:Graphics = cross.graphics;
			g.clear();
			g.lineStyle(3, 0xffffff, .6, false);
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(crossRadius * 2, crossRadius * 2, 0, -crossRadius, -crossRadius);
			g.beginGradientFill(GradientType.RADIAL, [0xffffff, 0xffffff], [.6, 0], [10, 245], gradientMatrix);
			g.drawCircle(0, 0, crossRadius);
			g.endFill();
			
			g.lineStyle(1, 0xffffff, .6, false);
			g.beginFill(0x000000, .6);
			g.drawCircle(0, 0, 2);
			g.endFill();
		}
		
		public function setAngleAndPower(angle:Number, facing:int, powerMultiplier:Number):void
		{
			if (angle == this.angle && facing == this.facing && powerMultiplier == this.powerMultiplier) return;
			
			this.angle = angle;
			this.facing = facing;
			this.powerMultiplier = powerMultiplier;
			
			var crossDistance:Number = radius + powerMultiplier * maxPowerDistance;
			
			cross.location = Point.polar(crossDistance, angle);
			cross.x *= facing;
			
			drawHints();
		}
		
		protected function drawHints():void
		{
			var minPowerPoint:Point = Point.polar(radius, angle);
			minPowerPoint.x *= facing;
			
			/* = angleHint.graphics*/;
			//g.clear();
			//g.lineStyle(1);
			
			//gradientMatrix.createGradientBox(radius * 2, radius * 2, 0, -radius, -radius);
			//g.lineGradientStyle(GradientType.RADIAL, [0xffffff, 0xffffff, 0xffffff], [0, .4, 0], [64, 180, 255], gradientMatrix);
			//g.moveTo(0, 0);
			//g.lineTo(minPowerPoint.x, minPowerPoint.y);
			
			var g:Graphics = powerHint.graphics;
			g.clear();
			g.lineStyle(5);
			var maxPowerDistanceFromZero:Number = radius + maxPowerDistance;
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(maxPowerDistanceFromZero * 2, maxPowerDistanceFromZero * 2, 0, -maxPowerDistanceFromZero, -maxPowerDistanceFromZero);
			var maxPowerRatio:int = 255;
			var minPowerRatio:int = Math.round(maxPowerRatio * (radius / maxPowerDistanceFromZero));
			var midPowerRatio:int = minPowerRatio + Math.round((maxPowerRatio - minPowerRatio) / 2);
			g.lineGradientStyle(GradientType.RADIAL, [0x00ffff, 0xffffaa, 0xff5500], [1, 1, 1], [minPowerRatio, midPowerRatio, maxPowerRatio], gradientMatrix);
			g.moveTo(minPowerPoint.x, minPowerPoint.y);
			g.lineTo(cross.x, cross.y);
		}
		
		protected function crossPressed(e:MouseEvent):void
		{
			if (Program.game.currentRound.selectedTeam.controller == Team.CONTROLLER_AI) return;
			
			isDragged = true;
			
			crossDragXDiff = cross.x - mouseX;
			crossDragYDiff = cross.y - mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, crossReleased);
			
			e.stopPropagation();
		}
		
		protected function crossReleased(e:MouseEvent):void
		{
			isDragged = false;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, crossReleased);
			
			e.stopPropagation();
		}
		
		public function crossDrag():void
		{
			if (Program.game.currentRound.selectedTeam.controller == Team.CONTROLLER_AI) return;
			
			cross.x = mouseX + crossDragXDiff;
			cross.y = mouseY + crossDragYDiff;
			
			if (cross.x > 0) facing = 1;
			else facing = -1;
			
			angle = Math.atan2(cross.y, cross.x * facing);
			
			var dist:Number = Math.sqrt(cross.x * cross.x + cross.y * cross.y);
			if (dist < radius)
			{
				cross.location = Point.polar(radius, angle);
				cross.x *= facing;
				powerMultiplier = 0;
			}
			else if (dist > radius + maxPowerDistance)
			{
				cross.location = Point.polar(radius + maxPowerDistance, angle);
				cross.x *= facing;
				powerMultiplier = 1;
			}
			else
			{
				powerMultiplier = (dist - radius) / (maxPowerDistance - radius );
			}
			
			drawHints();
			
			Program.mbToP.newAim = angle;
			Program.mbToP.newPowerMultiplier = powerMultiplier;
			Program.mbToP.newFacing = facing;
		}
	}

}