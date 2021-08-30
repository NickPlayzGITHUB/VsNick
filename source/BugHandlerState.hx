package;

import Section.SwagSection;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

class BugHandlerState extends MusicBeatState
{
	public static var text = "UNKNOWN REASON";
	override function create(){
		var A:Array<String> = [];
		
		var Phrase:String = "BUGS AND MORE BUGS AND YET MORE";
		
		for(i in 0...40){
			var NB:Array<String> = [Phrase.substr(i % Phrase.length)];
			for(j in 0...3)
				NB.push("BUGS AND MORE BUGS AND YET MORE");
			var Txt = new FlxText(-16, (i*32)-16, 0, NB.join(" "), 32);
			Txt.setFormat("VCR OSD Mono", 32, 0xFFFFFFFF);
			Txt.alpha = 0.23;
			add(Txt);
		}
		
		var bugworld:FlxText = new FlxText(0, FlxG.height * 0.1, 0, "WELCOME TO BUG WORLD", 48);
		
		bugworld.setFormat("VCR OSD Mono", 48, 0xFFFFAA77, CENTER);
		bugworld.screenCenter(X);
		
		var error:FlxText = new FlxText(0, FlxG.height / 2, 0, "AN ERROR HAS OCCURRED\nOF THE FOLLOWING\nDESCRIPTION", 32);
		
		error.setFormat("VCR OSD Mono", 36, 0xFF5555FF, CENTER);
		error.screenCenter(X);
		
		error.y -= error.height;
		
		var desc:FlxText = new FlxText(0, FlxG.height * 0.67, 0, text, 32);
		
		desc.setFormat("VCR OSD Mono", 36, 0xFFFF5555, CENTER);
		desc.screenCenter(X);
		
		add(bugworld);
		add(error);
		add(desc);
		
		super.create();
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
