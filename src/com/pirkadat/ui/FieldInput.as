package com.pirkadat.ui 
{
	import com.pirkadat.display.ITrueSize;
	import com.pirkadat.shapes.FillStyle;
	import com.pirkadat.shapes.RoundedBoxComplex;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	public class FieldInput extends Extender 
	{
		public var field:InputText;
		
		public function FieldInput(height:Number, minWidth:Number = 100) 
		{
			super(field = new InputText(), 5, 10, 5, 5);
			field.defaultTextFormat.color = Colors.BLACK;
			field.defaultTextFormat = new TextFormat(field.defaultTextFormat.font, field.defaultTextFormat.size, Colors.BLACK);
			field.width = minWidth;
			field.height = height;
			field.multiline = false;
			
			spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
		}
		
		override protected function createExtension():ITrueSize 
		{
			return new RoundedBoxComplex(0, Button.CORNER_RADIUS, 0, Button.CORNER_RADIUS, new FillStyle(Colors.WHITE));
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void 
		{
			field.width = xSpace - extensionLeft - extensionRight;
			super.fitToSpace(xSpace, ySpace);
		}
	}

}