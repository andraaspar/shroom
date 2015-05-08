package com.pirkadat.logic 
{
	import com.pirkadat.events.*;
	import com.pirkadat.ui.Console;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class World
	{
		public var terrain:BitmapData;
		public var background:BitmapData;
		public var distance:BitmapData;
		
		public var forces:Vector.<WorldForce>;
		public var objects:Vector.<WorldObject>;
		
		public var currentTime:Number = 0;
		public var playhead:Number = 0;
		
		public var isExecuting:Boolean;
		
		public function World() 
		{
			forces = new Vector.<WorldForce>();
			objects = new Vector.<WorldObject>();
		}
		
		
		
		
		public function execute():void
		{
			currentTime += .04;
			
			//Console.say("World.execute():",currentTime);
			
			var object:WorldObject;
			var generatedWorldObjects:Vector.<WorldObject>;
			var generatedWorldObject:WorldObject;
			while (objects.length)
			{
				objects.sort(objectSorter);
				if (objects[0].timeToNotify > currentTime)
				{
					playhead = currentTime;
					break;
				}
				object = objects[0];
				if (!object.hasBeenNotified) Program.mbToUI.newWorldObjects.push(object);
				playhead = Math.max(playhead, object.timeToNotify);
				object.notify(playhead);
				if (object.hasFinishedWorking)
				{
					removeWorldObject(objects.indexOf(object));
				}
				generatedWorldObjects = object.generateWorldObjects();
				if (generatedWorldObjects)
				{
					for each (generatedWorldObject in generatedWorldObjects)
					{
						addWorldObject(generatedWorldObject);
					}
				}
			}
		}
		
		public function objectSorter(a:WorldObject, b:WorldObject):Number
		{
			if (a.timeToNotify == b.timeToNotify) return 0;
			else if (a.timeToNotify < b.timeToNotify) return -1;
			else return 1;
		}
		
		public function addWorldObject(object:WorldObject):void
		{
			objects.push(object);
		}
		
		public function removeWorldObject(index:int):void
		{
			objects.splice(index, 1);
		}
		
		public function checkIfSleeping():Boolean
		{
			for each (var object:WorldObject in objects)
			{
				if (!object.isSleeping()) return false;
			}
			return true;
		}
	}
}