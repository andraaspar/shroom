package com.pirkadat.ui 
{
	import com.pirkadat.logic.Program;
	import com.pirkadat.logic.User;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class LogoutWidget extends Row 
	{
		public var emailText:DynamicText;
		public var logoutButton:Button;
		public var user:User;
		
		public function LogoutWidget() 
		{
			super(true, 6);
			
			emailText = new DynamicText("");
			addChild(emailText);
			
			logoutButton = new Button(new DynamicText("Log out"));
			addChild(logoutButton);
			logoutButton.addEventListener(MouseEvent.CLICK, onLogoutButtonClicked);
		}
		
		override public function update():void 
		{
			if (Program.user !== user)
			{
				user = Program.user;
				emailText.text = "Logged in as " + user.email;
				sizeChanged = true;
			}
			
			super.update();
		}
		
		protected function onLogoutButtonClicked(e:Event):void
		{
			Program.mbToP.newEmail = "";
			Program.mbToP.saveCredentials = true;
		}
	}

}