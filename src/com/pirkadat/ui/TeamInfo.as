package com.pirkadat.ui 
{
	import com.pirkadat.display.ITrueSize;
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.AnimationRange;
	import com.pirkadat.logic.Program;
	import com.pirkadat.logic.Team;
	public class TeamInfo extends Button 
	{
		public var team:Team;
		public var appearance:BitmapAnimation;
		public var nameLabel:DynamicText;
		
		public function TeamInfo(team:Team) 
		{
			this.team = team;
			super(createContent());
			frame.transform.colorTransform = new MultiplierColorTransform(team.characterAppearance.color);
		}
		
		protected function createContent():ITrueSize
		{
			var mainRow:Row = new Row(true, 6);
			
			appearance = new BitmapAnimation();
			mainRow.addChild(appearance);
			appearance.addLayer(Program.assetLoader.getAssetByID(1), new MultiplierColorTransform(team.characterAppearance.color));
			appearance.addLayer(Program.assetLoader.getAssetByID(0));
			appearance.playRange(new AnimationRange(team.characterAppearance.characterID, team.characterAppearance.characterID), false);
			
			nameLabel = new DynamicText(team.name);
			mainRow.addChild(nameLabel);
			
			return mainRow;
		}
		
		override public function update():void 
		{
			if (team.isSelected != this.isSelected) setSelected(team.isSelected);
			
			super.update();
		}
	}

}