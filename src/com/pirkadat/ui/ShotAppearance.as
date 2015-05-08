package com.pirkadat.ui 
{
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	
	public class ShotAppearance extends WorldObjectAppearance
	{
		public var bitmapAnimation:BitmapAnimation;
		public var decorations:Sprite;
		
		public var aniAssetID:int;
		public var explosionAniAssetID:int;
		public var explosionScale:Number;
		
		public var dawnBall:DawnBall;
		public var doughnut:Doughnut;
		public var teslaBall:TeslaBall;
		
		public function ShotAppearance(aniAssetID:int, explosionAniAssetID:int, explosionScale:Number = 1, worldObject:WorldObject = null, worldAppearance:WorldAppearance = null) 
		{
			super(worldObject, worldAppearance);
			
			dawnBall = worldObject as DawnBall;
			doughnut = worldObject as Doughnut;
			teslaBall = worldObject as TeslaBall;
			
			this.aniAssetID = aniAssetID;
			this.explosionAniAssetID = explosionAniAssetID;
			this.explosionScale = explosionScale;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (teslaBall)
			{
				decorations = new Sprite();
				addChild(decorations);
				//decorations.filters = [new GlowFilter(0x0000ff, 1, 12, 12, 4)];
				//decorations.blendMode = BlendMode.ADD;
			}
			
			bitmapAnimation = new BitmapAnimation();
			bitmapAnimation.addLayer(Program.assetLoader.getAssetByID(aniAssetID));
			addChild(bitmapAnimation);
			bitmapAnimation.xMiddle = bitmapAnimation.yMiddle = 0;
			
			bitmapAnimation.playRange(AnimationRange(Program.assetLoader.getAssetAnimationRangesByID(aniAssetID)["loop"]).randomizeStartOffset(), true);
			
			moveAndDraw(worldObject.wayPoints, worldObject.radius * 2, .25, true);
		}
		
		override public function update():void 
		{
			moveAndDraw(worldObject.wayPoints, worldObject.radius * 2, .25);
			if (teslaBall)
			{
				decorations.graphics.clear();
				decorations.graphics.lineStyle(3, 0xffffff);
				
				var length:Number;
				for each (var pt:Point in teslaBall.damageCoords)
				{
					length = pt.length;
					decorations.graphics.curveTo(pt.x / 2 + length * Math.random() - length / 2, pt.y / 2 + length * Math.random() - length / 2, pt.x, pt.y);
					decorations.graphics.moveTo(0, 0);
				}
			}
		}
		
		override public function generateVisualObjects():Vector.<VisualObject> 
		{
			if (worldObject.hasFinishedWorking)
			{
				if (worldObject.location.y < worldAppearance.terrainAppearance.height)
				{
					var explosion:Explosion = new Explosion(explosionAniAssetID, worldAppearance);
					explosion.x = x;
					explosion.y = y;
					explosion.scaleX = explosion.scaleY = explosionScale;
					explosion.filters = filters;
					
					var m:Matrix;
					var mx:Number;
					var my:Number
					
					if (dawnBall)
					{
						for each (var pt:Point in dawnBall.damageCoords)
						{
							worldAppearance.canvas.graphics.lineStyle(1, dawnBall.team.characterAppearance.color, .5);
							worldAppearance.canvas.graphics.moveTo(x, y);
							worldAppearance.canvas.graphics.lineTo(x + pt.x, y + pt.y);
						}
					}
					else if (doughnut)
					{
						m = new Matrix();
						var dOuterRadius:Number = doughnut.effectRadius + doughnut.doughnutRadius;
						mx = x - dOuterRadius;
						my = y - dOuterRadius;
						
						m.createGradientBox(dOuterRadius * 2, dOuterRadius * 2, 0, mx, my);
						worldAppearance.canvas.graphics.lineStyle();
						worldAppearance.canvas.graphics.beginGradientFill(GradientType.RADIAL, [worldObject.team.characterAppearance.color, worldObject.team.characterAppearance.color, worldObject.team.characterAppearance.color], [0, .5, 0], [(dOuterRadius - doughnut.doughnutRadius * 2) / dOuterRadius * 255, (dOuterRadius - doughnut.doughnutRadius) / dOuterRadius * 255, 255], m);
						worldAppearance.canvas.graphics.drawRect(mx, my, dOuterRadius * 2, dOuterRadius * 2);
						worldAppearance.canvas.graphics.endFill();
					}
					else if (teslaBall)
					{
						
					}
					else
					{
						m = new Matrix();
						var phr:Number = Shot(worldObject).punchHoleRadius;
						mx = x - phr;
						my = y - phr;
						phr *= 2;
						
						m.createGradientBox(phr, phr, 0, mx, my);
						worldAppearance.canvas.graphics.lineStyle();
						worldAppearance.canvas.graphics.beginGradientFill(GradientType.RADIAL, [worldObject.team.characterAppearance.color, worldObject.team.characterAppearance.color, worldObject.team.characterAppearance.color], [.5, .4, 0], [0, 128, 255], m);
						worldAppearance.canvas.graphics.drawRect(mx, my, phr, phr);
						worldAppearance.canvas.graphics.endFill();
					}
					
					return new <VisualObject>[explosion];
				}
				else
				{
					var sinker:Sinker = new Sinker(aniAssetID, 0, 0, worldAppearance);
					sinker.x = x;
					sinker.y = worldAppearance.terrainAppearance.height + worldObject.radius;
					
					return new <VisualObject>[sinker];
				}
			}
			else
			{
				return null;
			}
		}
	}

}