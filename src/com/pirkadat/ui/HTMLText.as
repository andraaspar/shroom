package com.pirkadat.ui
{
	import com.pirkadat.display.TrueSizeText;
	import flash.events.Event;
	import flash.text.*;
	
	public class HTMLText extends TextDefaults
	{
		public var nonBreakWordMaxLength:int = 3;
		
		public function HTMLText(htmlText:String = "")
		{
			antiAliasType = AntiAliasType.ADVANCED;
			autoSize = TextFieldAutoSize.LEFT;
			embedFonts = globalEmbedFonts;
			gridFitType = GridFitType.SUBPIXEL;
			multiline = true;
			selectable = false;
			styleSheet = globalStyleSheet;
			wordWrap = false;
			mouseWheelEnabled = false;
			condenseWhite = true;
			this.htmlText = htmlText;
		}
		
		/*override public function set htmlText(value:String):void
		{
			var regExp:RegExp;
			
			if (nonBreakWordMaxLength > 0)
			{
				// Replacing spaces with non-breaking spaces
				regExp = new RegExp('((\\s|\u00a0)\\S{1,' + nonBreakWordMaxLength + '}) ', 'gm');
				while (regExp.test(value))
				{
					value = value.replace(regExp, '$1\u00a0');
					regExp.lastIndex = 0;
				}
				
				// Undoing the above inside tags
				regExp = new RegExp('(<[^>]*)\u00a0([^>]*>)', 'gm');
				while (regExp.test(value))
				{
					value = value.replace(regExp, '$1 $2');
					regExp.lastIndex = 0;
				}
			}
			
			value = value.replace(new RegExp('\{space\}','g'), ' ');
			value = value.replace(new RegExp('\{nbsp\}','g'), '\u00a0');
			value = value.replace(new RegExp('\{tup\}','g'), '\u25b2');
			value = value.replace(new RegExp('\{tright\}','g'), '\u25ba');
			value = value.replace(new RegExp('\{tdown\}','g'), '\u25bc');
			value = value.replace(new RegExp('\{tleft\}','g'), '\u25c4');
			
			//
			
			super.htmlText = value;
		}*/
	}
}