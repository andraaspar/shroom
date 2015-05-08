package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	
	public class HTMLText3 extends TrueSize
	{
		protected const MARKER:String = '\u200b'; // Zero width space
		
		protected static var styleIndexes:Array = [];
		protected static var styleEntries:Array = [];
		
		protected static var bNodes:Array = [];
		protected static var bClasses:Array = [];
		protected static var bColors:Array = [];
		protected static var bWidths:Array = [];
		protected static var bHeights:Array = [];
		protected static var bXPositions:Array = [];
		
		public var textField:HTMLText;
		protected var bCont:TrueSize;
		
		public var style:int = 0;
		
		public function HTMLText3() 
		{
			
		}
		
		public function build(style:int = 0):void
		{
			this.style = style;
			
			//
			
			textField = new HTMLText();
			addChild(textField);
			
			//
			
			bCont = new TrueSize();
			addChild(bCont);
		}
		
		public static function createStyle():void
		{
			styleIndexes.push(bNodes.length);
			styleEntries.push(0);
		}
		
		public static function addNode(bNode:String, bClass:Class, bColor:ColorTransform, bWidth:Number = NaN, bHeight:Number = NaN, bXPosition:Number = NaN):void
		{
			styleEntries[styleEntries.length - 1]++;
			
			bNodes.push(bNode);
			bClasses.push(bClass);
			bColors.push(bColor);
			bWidths.push(bWidth);
			bHeights.push(bHeight);
			bXPositions.push(bXPosition);
		}
		
		public function updateBullets():void
		{
			// FP-1430 Workaround -> getCharBoundaries may return null.
			
			textField.width = textField.width;
			
			//
			
			clearBullets();
			
			// If no text, return.
			
			var textLength:int = textField.length;
			if (!textLength) return;
			
			// Check to see if rendering bulletpoints is necessary.
			
			var aNode:String;
			var found:Boolean = false;
			
			for each (aNode in bNodes)
			{
				if (textField.htmlText.indexOf('<' + aNode + '>') != -1)
				{
					found = true;
					break;
				}
			}
			if (!found) return;
			
			// Render bullets.
			
			var i:int = styleIndexes[style];
			var j:int = i + styleEntries[style];
			
			var aNodeRE:RegExp;
			var aBoundary:Rectangle;
			var aBullet:TrueSize;
			var position:int;
			var originalText:String = textField.htmlText;
			
			for (; i < j; i++)
			{
				aNode = '<' + bNodes[i] + '>';
				aNodeRE = new RegExp(aNode + MARKER + '?', 'g');
				
				textField.htmlText = originalText.replace(aNodeRE, aNode + MARKER);
				textLength = textField.text.length;
				
				for (position = 0; position < textLength; position += Math.max(1, textField.getParagraphLength(position)))
				{
					if (textField.getLineText(textField.getLineIndexOfChar(position)).charAt(0) != MARKER) continue;
					
					aBoundary = textField.getCharBoundaries(position + 1); // As the MARKER doesn't have a size.
					if (!aBoundary) 
					{
						throw new Error('Character boundary could not be found.');
					}
					
					aBullet = new (bClasses[i] as Class)() as TrueSize;
					bCont.addChild(aBullet);
					
					if (!isNaN(bWidths[i]))
					{
						aBullet.xSize = bWidths[i];
					}
					
					if (!isNaN(bHeights[i]))
					{
						aBullet.ySize = bHeights[i];
					}
					
					if (bColors[i])
					{
						aBullet.transform.colorTransform = bColors[i];
					}
					
					if (isNaN(bXPositions[i]))
					{
						aBullet.x = textField.x + (int(textField.getTextFormat(position).leftMargin) - aBullet.xSize) / 2;
					}
					else
					{
						aBullet.x = bXPositions[i];
					}
					aBullet.y = textField.y + aBoundary.y + (aBoundary.height - aBullet.ySize) / 2;
				}
			}
			
			textField.htmlText = originalText;
		}
		
		public function clearBullets():void
		{
			while (bCont.numChildren) bCont.removeChildAt(0);
		}
		
		override public function get width():Number { return textField.width };
		override public function set width(value:Number):void { textField.width = value };
		
		override public function get height():Number { return textField.height };
		override public function set height(value:Number):void { textField.height = value };
		
		public function get nonBreakWordMaxLength():int { return textField.nonBreakWordMaxLength };
		public function set nonBreakWordMaxLength(value:int):void { textField.nonBreakWordMaxLength = value };
		
		//
		
		/// When set to true and the text field is not in focus, Flash Player highlights the selection in the text field in gray.
		public function get alwaysShowSelection () : Boolean {return textField.alwaysShowSelection};
		public function set alwaysShowSelection (value:Boolean) : void {textField.alwaysShowSelection = value};

		/// The type of anti-aliasing used for this text field.
		public function get antiAliasType () : String {return textField.antiAliasType};
		public function set antiAliasType (antiAliasType:String) : void {textField.antiAliasType = antiAliasType};

		/// Controls automatic sizing and alignment of text fields.
		public function get autoSize () : String {return textField.autoSize};
		public function set autoSize (value:String) : void {textField.autoSize = value};

		/// Specifies whether the text field has a background fill.
		public function get background () : Boolean {return textField.background};
		public function set background (value:Boolean) : void {textField.background = value};

		/// The color of the text field background.
		public function get backgroundColor () : uint {return textField.backgroundColor};
		public function set backgroundColor (value:uint) : void {textField.backgroundColor = value};

		/// Specifies whether the text field has a border.
		public function get border () : Boolean {return textField.border};
		public function set border (value:Boolean) : void {textField.border = value};

		/// The color of the text field border.
		public function get borderColor () : uint {return textField.borderColor};
		public function set borderColor (value:uint) : void {textField.borderColor = value};

		/// An integer (1-based index) that indicates the bottommost line that is currently visible in the specified text field.
		public function get bottomScrollV () : int {return textField.bottomScrollV};

		/// The index of the insertion point (caret) position.
		public function get caretIndex () : int {return textField.caretIndex};

		/// A Boolean value that specifies whether extra white space (spaces, line breaks, and so on) in a text field with HTML text is removed.
		public function get condenseWhite () : Boolean {return textField.condenseWhite};
		public function set condenseWhite (value:Boolean) : void {textField.condenseWhite = value};

		/// Specifies the format applied to newly inserted text, such as text inserted with the replaceSelectedText() method or text entered by a user.
		public function get defaultTextFormat () : TextFormat { return textField.defaultTextFormat };
		public function set defaultTextFormat (format:TextFormat) : void { textField.defaultTextFormat = format };

		/// Specifies whether the text field is a password text field.
		public function get displayAsPassword () : Boolean { return textField.displayAsPassword };
		public function set displayAsPassword (value:Boolean) : void { textField.displayAsPassword = value };

		/// Specifies whether to render by using embedded font outlines.
		public function get embedFonts () : Boolean { return textField.embedFonts };
		public function set embedFonts (value:Boolean) : void { textField.embedFonts = value };

		/// The type of grid fitting used for this text field.
		public function get gridFitType () : String { return textField.gridFitType };
		public function set gridFitType (gridFitType:String) : void { textField.gridFitType = gridFitType };

		/// Contains the HTML representation of the text field contents.
		public function get htmlText () : String { return textField.htmlText };
		public function set htmlText (value:String) : void { textField.htmlText = value };

		/// The number of characters in a text field.
		public function get length () : int { return textField.length };

		/// The maximum number of characters that the text field can contain, as entered by a user.
		public function get maxChars () : int { return textField.maxChars };
		public function set maxChars (value:int) : void { textField.maxChars = value };

		/// The maximum value of scrollH.
		public function get maxScrollH () : int { return textField.maxScrollH };

		/// The maximum value of scrollV.
		public function get maxScrollV () : int { return textField.maxScrollV };

		/// A Boolean value that indicates whether Flash Player automatically scrolls multiline text fields when the user clicks a text field and rolls the mouse wheel.
		public function get mouseWheelEnabled () : Boolean { return textField.mouseWheelEnabled };
		public function set mouseWheelEnabled (value:Boolean) : void { textField.mouseWheelEnabled = value };

		/// Indicates whether field is a multiline text field.
		public function get multiline () : Boolean { return textField.multiline };
		public function set multiline (value:Boolean) : void { textField.multiline = value };

		/// Defines the number of text lines in a multiline text field.
		public function get numLines () : int { return textField.numLines };

		/// Indicates the set of characters that a user can enter into the text field.
		public function get restrict () : String { return textField.restrict };
		public function set restrict (value:String) : void { textField.restrict = value };

		/// The current horizontal scrolling position.
		public function get scrollH () : int { return textField.scrollH };
		public function set scrollH (value:int) : void { textField.scrollH = value };

		/// The vertical position of text in a text field.
		public function get scrollV () : int { return textField.scrollV };
		public function set scrollV (value:int) : void { textField.scrollV = value };

		/// A Boolean value that indicates whether the text field is selectable.
		public function get selectable () : Boolean { return textField.selectable };
		public function set selectable (value:Boolean) : void { textField.selectable = value };

		public function get selectedText () : String { return textField.selectedText };

		/// The zero-based character index value of the first character in the current selection.
		public function get selectionBeginIndex () : int { return textField.selectionBeginIndex };

		/// The zero-based character index value of the last character in the current selection.
		public function get selectionEndIndex () : int { return textField.selectionEndIndex };

		/// The sharpness of the glyph edges in this text field.
		public function get sharpness () : Number { return textField.sharpness };
		public function set sharpness (value:Number) : void { textField.sharpness = value };

		/// Attaches a style sheet to the text field.
		public function get styleSheet () : StyleSheet { return textField.styleSheet };
		public function set styleSheet (value:StyleSheet) : void { textField.styleSheet = value };

		/// A string that is the current text in the text field.
		public function get text () : String { return textField.text };
		public function set text (value:String) : void { textField.text = value };

		/// The color of the text in a text field, in hexadecimal format.
		public function get textColor () : uint { return textField.textColor };
		public function set textColor (value:uint) : void { textField.textColor = value };

		/// The height of the text in pixels.
		public function get textHeight () : Number { return textField.textHeight };

		/// The width of the text in pixels.
		public function get textWidth () : Number { return textField.textWidth };

		/// The thickness of the glyph edges in this text field.
		public function get thickness () : Number { return textField.thickness };
		public function set thickness (value:Number) : void { textField.thickness = value };

		/// The type of the text field.
		public function get type () : String { return textField.type };
		public function set type (value:String) : void { textField.type = value };

		/// Specifies whether to copy and paste the text formatting along with the text.
		public function get useRichTextClipboard () : Boolean { return textField.useRichTextClipboard };
		public function set useRichTextClipboard (value:Boolean) : void { textField.useRichTextClipboard = value };

		/// A Boolean value that indicates whether the text field has word wrap.
		public function get wordWrap () : Boolean { return textField.wordWrap };
		public function set wordWrap (value:Boolean) : void { textField.wordWrap = value };

		/// Appends text to the end of the existing text of the TextField.
		public function appendText (newText:String) : void { textField.appendText(newText) };

		/// Returns a rectangle that is the bounding box of the character.
		public function getCharBoundaries (charIndex:int) : Rectangle { return textField.getCharBoundaries(charIndex) };

		/// Returns the zero-based index value of the character.
		public function getCharIndexAtPoint (x:Number, y:Number) : int { return textField.getCharIndexAtPoint(x, y) };

		/// The zero-based index value of the character.
		public function getFirstCharInParagraph (charIndex:int) : int { return textField.getFirstCharInParagraph(charIndex) };

		/// Returns a DisplayObject reference for the given id, for an image or SWF file that has been added to an HTML-formatted text field by using an &lt;img&gt; tag.
		public function getImageReference (id:String) : DisplayObject { return textField.getImageReference(id) };

		/// The zero-based index value of the line at a specified point.
		public function getLineIndexAtPoint (x:Number, y:Number) : int { return textField.getLineIndexAtPoint(x, y) };

		/// The zero-based index value of the line containing the character that the the charIndex parameter specifies.
		public function getLineIndexOfChar (charIndex:int) : int { return textField.getLineIndexOfChar(charIndex) };

		/// Returns the number of characters in a specific text line.
		public function getLineLength (lineIndex:int) : int { return textField.getLineLength(lineIndex) };

		/// Returns metrics information about a given text line.
		public function getLineMetrics (lineIndex:int) : TextLineMetrics { return textField.getLineMetrics(lineIndex) };

		/// The zero-based index value of the first character in the line.
		public function getLineOffset (lineIndex:int) : int { return textField.getLineOffset(lineIndex) };

		/// The text string contained in the specified line.
		public function getLineText (lineIndex:int) : String { return textField.getLineText(lineIndex) };

		/// The zero-based index value of the character.
		public function getParagraphLength (charIndex:int) : int { return textField.getParagraphLength(charIndex) };

		public function getRawText () : String { return textField.getRawText() };

		/// Returns a TextFormat object.
		public function getTextFormat (beginIndex:int = -1, endIndex:int = -1) : TextFormat { return textField.getTextFormat(beginIndex, endIndex) };

		/// Replaces the current selection with the contents of the value parameter.
		public function replaceSelectedText (value:String) : void { textField.replaceSelectedText(value) };

		/// Replaces a range of characters.
		public function replaceText (beginIndex:int, endIndex:int, newText:String) : void { textField.replaceText(beginIndex, endIndex, newText) };

		/// Sets a new text selection.
		public function setSelection (beginIndex:int, endIndex:int) : void { textField.setSelection(beginIndex, endIndex) };

		/// Applies text formatting.
		public function setTextFormat (format:TextFormat = null, beginIndex:int = -1, endIndex:int = -1) : void { textField.setTextFormat(format, beginIndex, endIndex) };
	}
	
}