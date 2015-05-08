package com.pirkadat.trans
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.*;
	
	/**
	 * Object to manage transitions of displayobjects.
	 * @author András Parditka
	 */
	public class Trans
	{
		protected static var transformList:Vector.<ITransInfo> = new Vector.<ITransInfo>();
		protected static var transformListLength:int = 0;
		
		public static function add(info:ITransInfo):void
		{
			var otherInfo:ITransInfo;
			
			for (var i:int = transformListLength - 1; i >= 0; i--)
			{
				otherInfo = transformList[i];
				
				if (info.conflicts(otherInfo))
				{
					transformList.splice(i, 1);
					transformListLength--;
				}
			}
			
			if (info.execute())
			{
				transformList.push(info);
				transformListLength++;
			}
			else
			{
				info.executeDoneFunc();
			}
		}
		
		public static function removeFromParent(parent:Object, infoClass:Class = null):void
		{
			var info:ITransInfo;
			
			for (var i:int = transformListLength - 1; i >= 0; i--)
			{
				info = transformList[i];
				
				if (info.getParentObj() == parent && (!infoClass || info is infoClass))
				{
					transformList.splice(i, 1);
					transformListLength--;
				}
			}
		}
		
		public static function execute():void
		{
			var info:ITransInfo;
			
			for (var i:int = transformListLength - 1; i >= 0; i--)
			{
				info = transformList[i];
				
				if (!info.execute())
				{
					transformList.splice(i, 1);
					transformListLength--;
					
					info.executeDoneFunc();
				}
			}
		}
	}
}