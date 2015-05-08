package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.shapes.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class LevelListItem extends Button
	{
		public var levelNode:XML;
		
		public function LevelListItem(levelNode:XML) 
		{
			super(new DynamicText(levelNode.@n.toString()));
			
			this.levelNode = levelNode;
			spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			if (levelNode.@t == "1") frame.transform.colorTransform = new MultiplierColorTransform(0xffcc00);
		}
	}

}