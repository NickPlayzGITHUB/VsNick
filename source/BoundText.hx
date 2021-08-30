package;

import flixel.FlxSprite;
import flixel.text.FlxText;

class BoundText extends FlxText
{ // class for FlxTexts that move to match a parent object
	public var parent:Dynamic;
	private var offsetx:Float = 0;
	private var offsety:Float = 0;
	public var linkedID:Int = 0;
	public function new(osx:Float = 0, osy:Float = 0, fieldwidth:Float = 0, text:String = "", Size:Int = 8, ?ParentObject:Dynamic)
	{
		super(0, 0, fieldwidth, text, Size);
		offsetx = osx;
		offsety = osy;
		parent = ParentObject;
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(parent == null)
		{
			x = offsetx;
			y = offsety;
		} else {
			x = parent.x + offsetx;
			y = parent.y + offsety;
		}
	}
}
