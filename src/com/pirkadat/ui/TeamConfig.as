package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.events.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.windows.*;
	import flash.events.*;
	import flash.text.*;
	
	public class TeamConfig extends Row
	{
		public var teamList:Row;
		public var teamListWindow:Window;
		public var addTeamButton:Button;
		public var removeTeamButton:Button;
		
		public var teamListItems:Vector.<TeamListItem2> = new Vector.<TeamListItem2>();
		
		public var memberCountInput:InputField;
		public var addMemberButton:Button;
		public var removeMemberButton:Button;
		
		public var characterAppearancePicker:Window;
		public var controllerPicker:Window;
		
		public function TeamConfig() 
		{
			super(false, 12);
			
			build();
		}
		
		protected function build():void
		{
			addChild(new HTMLText("<p><l>Teams</l></p>"));
			
			//
			
			teamList = new Row(false, 6);
			teamList.alignmentY = -1;
			teamList.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			teamList.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			
			var teamListExtender:Extender = new Extender(teamList, 6, 18, 6, 18);
			
			teamListWindow = new Window(teamListExtender);
			addChild(teamListWindow);
			teamListWindow.spaceRuleY = SPACE_RULE_TOP_DOWN_MAXIMUM;
			teamListWindow.contentsMinSizeX = 500;
			teamListWindow.contentsMinSizeY = 400;
			
			//
			
			var toolStrip:Row = new Row(true, 6);
			addChild(toolStrip);
			
			addTeamButton = new Button(new DynamicText("Add new team"));
			toolStrip.addChild(addTeamButton);
			addTeamButton.addEventListener(MouseEvent.CLICK, onAddTeamButtonClicked);
			addTeamButton.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			
			removeTeamButton = new Button(new DynamicText("Remove selected team"));
			toolStrip.addChild(removeTeamButton);
			removeTeamButton.addEventListener(MouseEvent.CLICK, onRemoveTeamButtonClicked);
			removeTeamButton.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			
			//
			
			var membersToolStrip:Row = new Row(true, 6);
			addChild(membersToolStrip);
			
			memberCountInput = new InputField("Members in each team:");
			membersToolStrip.addChild(memberCountInput);
			memberCountInput.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			memberCountInput.input.field.width = 50;
			memberCountInput.input.field.text = Program.game.membersPerTeam.toString();
			memberCountInput.input.field.restrict = "0-9";
			memberCountInput.input.field.addEventListener(Event.CHANGE, onMemberCountInputChanged);
			memberCountInput.input.field.addEventListener(FocusEvent.FOCUS_OUT, onMemberCountInputBlurred);
			
			removeMemberButton = new Button(new HTMLText("<p><l>-</l></p>"));
			membersToolStrip.addChild(removeMemberButton);
			removeMemberButton.insetY = 5;
			removeMemberButton.addEventListener(MouseEvent.CLICK, onRemoveMemberButtonClicked);
			
			addMemberButton = new Button(new HTMLText("<p><l>+</l></p>"));
			membersToolStrip.addChild(addMemberButton);
			addMemberButton.insetY = 5;
			addMemberButton.addEventListener(MouseEvent.CLICK, onAddMemberButtonClicked);
			
			addEventListener(TeamListItem2.EVENT_APPEARANCE_CHANGE_REQUESTED, onTeamAppearanceChangeRequested);
			addEventListener(TeamListItem2.EVENT_CONTROLLER_CHANGE_REQUESTED, onTeamControllerChangeRequested);
		}
		
		override public function update():void 
		{
			var diff:int = teamListItems.length - Program.game.teams.length;
			var i:int;
			if (diff > 0)
			{
				for (i = diff; i > 0; i--)
				{
					teamList.removeChildAt(teamList.numChildren - 1);
					teamListItems.pop();
				}
			}
			else if (diff < 0)
			{
				var newTeamListItem:TeamListItem2;
				for (; diff < 0; diff++)
				{
					newTeamListItem = new TeamListItem2();
					teamListItems.push(newTeamListItem);
					teamList.addChild(newTeamListItem);
					newTeamListItem.addEventListener(MouseEvent.MOUSE_DOWN, onListItemPressed);
				}
			}
			
			for (i = teamListItems.length - 1; i >= 0; i--)
			{
				teamListItems[i].useData(Program.game.teams[i], Program.game.editedTeam == Program.game.teams[i]);
			}
			
			//
			
			if (Program.mbToUI.membersPerTeam)
			{
				memberCountInput.input.field.text = Program.mbToUI.membersPerTeam.toString();
			}
			
			super.update();
		}
		
		protected function onListItemPressed(e:MouseEvent):void
		{
			var id:int = teamListItems.indexOf(e.currentTarget);
			if (id == -1) return;
			Program.mbToP.newEditTeamID = id;
		}
		
		protected function onAddTeamButtonClicked(e:MouseEvent):void
		{
			Program.mbToP.addTeamRequested = true;
		}
		
		protected function onRemoveTeamButtonClicked(e:MouseEvent):void
		{
			Program.mbToP.removeTeamRequested = true;
		}
		
		protected function onTeamAppearanceChangeRequested(e:Event):void
		{
			if (!characterAppearancePicker) characterAppearancePicker = new AppearancePicker();
			
			Gui.modalWindowManager.addWindow(characterAppearancePicker);
		}
		
		protected function onTeamControllerChangeRequested(e:Event):void
		{
			if (!controllerPicker) controllerPicker = new ControllerPicker();
			
			Gui.modalWindowManager.addWindow(controllerPicker);
		}
		
		protected function onMemberCountInputChanged(e:Event):void
		{
			var value:Number = Number(memberCountInput.input.field.text);
			if (isNaN(value)) {
				memberCountInput.input.field.text = Program.game.membersPerTeam.toString();
				return;
			}
			Program.mbToP.membersPerTeam = Math.round(value);
		}
		
		protected function onMemberCountInputBlurred(e:Event):void
		{
			var value:Number = Number(memberCountInput.input.field.text);
			if (isNaN(value) || value == 0) {
				memberCountInput.input.field.text = Program.game.membersPerTeam.toString();
			}
		}
		
		protected function onAddMemberButtonClicked(e:Event):void
		{
			Program.mbToP.membersPerTeam = Program.game.membersPerTeam + 1;
		}
		
		protected function onRemoveMemberButtonClicked(e:Event):void
		{
			Program.mbToP.membersPerTeam = Program.game.membersPerTeam - 1;
		}
	}

}