package com.pirkadat.trans 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author András Parditka
	 */
	public interface ITransInfo
	{
		function execute():Boolean;
		
		function executeDoneFunc():void;
		
		function conflicts(info:ITransInfo):Boolean;
		
		function getParentObj():Object;
	}

}