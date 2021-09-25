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

class WeekInfoState extends MusicBeatState
{
	private var movedBack:Bool = false;
	public static var lastWeek:Int = 0;
	public static var lastDiff:Int = 0;
	public static var Rivals = [
		"gf" => "GF",
		"bf" => "You",
		"gf-christmas" => "GF",
		"bf-christmas" => "You",
		"bf-car" => "You",
		"dad" => "Daddy Dearest",
		"spooky" => "Skid & Pump",
		"mom" => "Mommy Mearest", // fnf wki
		"mom-car" => "Mommy Mearest",
		"whitty" => "Whitty",
		"monster" => "Monster",
		"haxeflixel" => "HaxeFlixel",
		"monster-christmas" => "Monster",
		"parents-christmas" => "GF's Parents",
		"pico" => "Pico",
		"bf-pixel" => "You (pixelated)",
		"senpai" => "Senpai",
		"senpai-angry" => "Senpai (angry)",
		"spirit" => "Spirit"
	];
	public static var WeekNames:Array<String> = [
		"Tutorial",
		"Week N",
		"Week N"
	];
	function Rate(r:Int)
	{
		return [
			"N/A",
			"SHIT",
			"BAD",
			"GOOD",
			"SICK",
			"SICK*"
		][r];
	}
	override function create(){
		Main.setstate("Checking week info", WeekNames[lastWeek]);
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		movedBack = false;
		
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBG-grn.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		
		var scoreBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 66, 0xFF000000);
		add(scoreBG);
		
		var InfoTxts:Array<FlxText> = [];
		var SwagCounter:Int = 0; // swag
		
		var Songs_Raw:Dynamic = StoryMenuState.weekData[lastWeek];
		var Songs:Array<String> = [];
		var PlaylistLength:Int = Songs_Raw.length;
		
		var Song_Entries:Array<Dynamic> = [];
		var DifficultyAffix:String = "";
		switch(lastDiff){
			case 0:
				DifficultyAffix = '-easy';
			case 2:
				DifficultyAffix = '-hard';
			case 3:
				DifficultyAffix = '-y';
		}
		
		var Diff:FlxText = new FlxText(10, 10, 0, '${WeekNames[lastWeek]} - ${["Easy", "Normal", "Hard", "Y"][lastDiff]}\n${StoryMenuState.weekNames[lastWeek]}', 18);
		Diff.setFormat("VCR OSD Mono", 24);
		// Diff.x -= Diff.width;
		add(Diff);
		
		var weekR:Array<Int> = Highscore.getWeekScore(lastWeek, lastDiff); // week rating
		
		var Diff2:FlxText = new FlxText(FlxG.width - 10, 10, 0, 'Score: ${PlayState.commafy(weekR[0])}\nWeek rating: ${Rate(weekR[1])}', 24);
		Diff2.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, RIGHT);
		Diff2.x -= Diff2.width;
		
		add(Diff2);
		
		for(i in 0...Songs_Raw.length){
			try {
				Song_Entries.push(Song.loadFromJson(Songs_Raw[i].toLowerCase() + DifficultyAffix, Songs_Raw[i].toLowerCase()));
				Songs.push(Songs_Raw[i]);
			} catch(_e) {
				PlaylistLength--;
				continue;
			}
		}
		
		for(i in 0...PlaylistLength){
			var n:String = Rivals[""+Song_Entries[i].player2];
			var N2:String = Song_Entries[i].song.toLowerCase();
			var Score:Dynamic = Highscore.getScore(N2, lastDiff);
			var NoteCount:Int = 0;
			var Notes:Dynamic = Song_Entries[i].notes;
			for(j in 0...Notes.length){
				if(Notes[j].mustHitSection)
					NoteCount += Notes[j].sectionNotes.filter(x -> x[1] < 5).length;
			}
			var TextItem:FlxText = new FlxText(10 + (SwagCounter * (FlxG.width / PlaylistLength)), 76, 0, '${Songs[i]}\n\nBPM: ' + 
																																													PlayState.commafy(Std.parseFloat(Song_Entries[i].bpm)) +
																																													'\n\nEnemy: ${n}\n\n' + 
																																													PlayState.commafy(NoteCount) + 
																																													' notes\n\nScore: ' +
																																													PlayState.commafy(Score[0]) + 
																																													'\nAverage rating: ${Rate(Score[1])}', 32); // I'm so sorry for Haxe crunching this
			var divider:FlxSprite = new FlxSprite((SwagCounter * (FlxG.width / PlaylistLength)) - 4, 66).makeGraphic(8, FlxG.height - 66, 0x7F000000);
			add(divider);
			TextItem.setFormat("VCR OSD Mono", Std.int(64 / PlaylistLength));
			add(TextItem);
			InfoTxts.push(TextItem);
			SwagCounter++;
		}
		super.create();
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (controls.BACK && !movedBack)
		{
			movedBack = true;
			FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
			FlxG.switchState(new StoryMenuState());
		}
	}
}
