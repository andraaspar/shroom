package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.*;
	import com.pirkadat.logic.level.GeneratedLevel;
	import com.pirkadat.logic.level.PaintedLevel;
	import com.pirkadat.ui.windows.*;
	import flash.events.*;
	
	public class LevelSelector extends Row
	{
		public var generateButton:Button;
		public var levelList:Row;
		public var levelListWindow:Window;
		public var levelPreview:UIElement;
		
		public var levelListItems:Vector.<LevelListItem> = new Vector.<LevelListItem>();
		public var selectedListItem:LevelListItem;
		
		protected var forceUpdate:Boolean = true;
		
		public function LevelSelector() 
		{
			super(false, 12);
			
			build();
		}
		
		protected function build():void
		{
			addChild(new HTMLText("<p><l>Selected level</l></p>"));
			
			//
			
			var levelColumns:Row = new Row(true, 18);
			addChild(levelColumns);
			levelColumns.spaceRuleY = SPACE_RULE_TOP_DOWN_MAXIMUM;
			
			var levelCol1:Row = new Row(false, 12);
			levelColumns.addChild(levelCol1);
			levelCol1.spaceRuleY = SPACE_RULE_TOP_DOWN_MAXIMUM;
			levelCol1.alignmentY = -1;
			
			levelCol1.addChild(new HTMLText("<p><l>Handmade levels</l></p>"));
			
			levelList = new Row(false, 6);
			levelList.alignmentY = -1;
			levelList.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			levelList.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			
			var levelListExtender:Extender = new Extender(levelList, 6, 18, 6, 18);
			
			levelListWindow = new Window(levelListExtender);
			levelCol1.addChild(levelListWindow);
			levelListWindow.spaceRuleY = SPACE_RULE_TOP_DOWN_MAXIMUM;
			levelListWindow.contentsMinSizeX = 400;
			levelListWindow.contentsMinSizeY = 200;
			
			levelColumns.addChild(new Separator());
			
			var levelCol2:Row = new Row(false, 12);
			levelColumns.addChild(levelCol2);
			levelCol2.alignmentY = -1;
			levelCol2.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			
			levelCol2.addChild(new HTMLText("<p><l><c>Random generated<br/>levels</c></l></p>"));
			
			generateButton = new Button(new HTMLText("<p>Generate new</p>"));
			levelCol2.addChild(generateButton);
			generateButton.addEventListener(MouseEvent.CLICK, onGenerateButtonClicked);
			
			var levelNodes:XMLList = Program.assetLoader.assetInfo.l;
			var newListItem:LevelListItem;
			for each (var levelNode:XML in levelNodes)
			{
				newListItem = new LevelListItem(levelNode);
				levelList.addChild(newListItem);
				levelListItems.push(newListItem);
				newListItem.addEventListener(MouseEvent.CLICK, onListItemClicked);
			}
			
			forceUpdate = true;
		}
		
		override public function update():void 
		{
			if (Program.mbToUI.newLevel || forceUpdate)
			{
				if (selectedListItem)
				{
					selectedListItem.setSelected(false);
					selectedListItem = null;
				}
				generateButton.setSelected(false);
				
				if (Program.game.level is PaintedLevel)
				{
					for (var i:int = levelListItems.length - 1; i >= 0; i--)
					{
						selectedListItem = levelListItems[i];
						if (selectedListItem.levelNode.@id == PaintedLevel(Program.game.level).id) break;
					}
					selectedListItem.setSelected(true);
				}
				else if (Program.game.level is GeneratedLevel)
				{
					generateButton.setSelected(true);
				}
			}
			
			if (Program.mbToUI.levelPreviewDownloaded
				|| (forceUpdate && !Program.game.level.getIsLoadingPreview())) {
				if (levelPreview)
				{
					removeChild(levelPreview);
				}
				levelPreview = new LoadedImage(Program.game.level.getPreview(), false);
				levelPreview.width = levelPreview.height = 300;
				addChildAt(levelPreview, 1);
			}
			
			forceUpdate = false;
			
			super.update();
		}
		
		protected function onListItemClicked(e:MouseEvent):void
		{
			Program.mbToP.newSelectedLevel = LevelListItem(e.currentTarget).levelNode;
		}
		
		protected function onGenerateButtonClicked(e:MouseEvent):void
		{
			Program.mbToP.newRandomLevelRequested = true;
		}
	}

}