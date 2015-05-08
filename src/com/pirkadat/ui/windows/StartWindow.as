package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.shapes.LogoWrapper;
	import com.pirkadat.ui.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	public class StartWindow extends Window 
	{
		private var centralRow:Row;
		private var forumButton:Button;
		
		public var setupWindow:Window;
		public var accountManagementWindow:Window;
		
		public function StartWindow() 
		{
			super(createContent(), new DynamicText("Welcome"), true, false, true, true);
		}
		
		protected function createContent():ITrueSize
		{
			var mainRow:Row = new Row(false, 36);
			
			var logo:LogoWrapper = new LogoWrapper();
			mainRow.addChild(logo);
			logo.scaleX = logo.scaleY = 1.5;
			
			mainRow.addChild(new Separator());
			
			var hRow:Row = new Row(true, 18);
			mainRow.addChild(hRow);
			
			var startButton:Button = new Button(new HTMLText("<p><c><l>Start</l></c></p><p><f>a quick game</f></p>"));
			hRow.addChild(startButton);
			startButton.frame.transform.colorTransform = new MultiplierColorTransform(0x00cc00);
			startButton.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			startButton.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			startButton.alignmentY = -1;
			startButton.addEventListener(MouseEvent.CLICK, onStartButtonClicked);
			
			var helpButton:Button = new Button(new DynamicText("Help"));
			hRow.addChild(helpButton);
			helpButton.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			helpButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {Program.game.getHelpSection("")} );
			
			var configureButton:Button = new Button(new HTMLText("<p><c><l>Start</l></c></p><p><f>a custom game</f></p>"));
			hRow.addChild(configureButton);
			configureButton.addEventListener(MouseEvent.CLICK, onConfigureButtonClicked);
			configureButton.frame.transform.colorTransform = new MultiplierColorTransform(Colors.BLUE);
			configureButton.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			configureButton.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			configureButton.alignmentY = -1;
			
			mainRow.addChild(new Separator());
			
			var credits:HTMLText = new HTMLText("<s><f><c><b>Created by András Parditka &amp; Andrásné Parditka.</b><br/><br/>"
				+"Special thanks to the following people for the sound effects they shared on <a href='http://www.freesound.org'>freesound.org</a>: SoundCollectah (multi low hits.aiff), Halleck (JacobsLadderSingle2.flac), WIM (fireworks.wav), FreqMan (concrete block hit 5x.wav), dude3966 (footsteps 1.wav), HerbertBorland (MouthPop.wav), ERH (tension.wav), digifishmusic (Ploppy_4.wav), timdrussell (GongBinaural.wav), SpeedY (welder 2.wav) and Charel Sytze (applause 3.mp3).</c></f></s>"
			);
			credits.embedFonts = false;
			credits.wordWrap = true;
			credits.width = 600;
			mainRow.addChild(credits);
			
			return new Extender(mainRow, 50, 50, 50, 50);
		}
		
		protected function onStartButtonClicked(e:Event):void
		{
			Program.mbToP.gameStartRequested = true;
		}
		
		protected function onConfigureButtonClicked(e:Event):void
		{
			if (setupWindow) Gui.windowManager.removeWindow(setupWindow);
			setupWindow = new GameSetupWindow();
			Gui.windowManager.addWindow(setupWindow);
		}
	}

}