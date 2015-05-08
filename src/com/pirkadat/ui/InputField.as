package com.pirkadat.ui 
{
	public class InputField extends Row 
	{
		public var title:FieldTitle;
		public var input:FieldInput;
		
		public function InputField(titleStr:String) 
		{
			super(true, 0);
			
			title = new FieldTitle(titleStr);
			addChild(title);
			
			input = new FieldInput(title.field.height);
			addChild(input);
		}
	}

}