package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import openfl.filters.ColorMatrixFilter;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<String> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Dynamic = [0, 0];
	var Cam:FlxCamera;
	var def:FlxCamera;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	public static final BuiltinSongs:Array<String> = [
		'Four Note Test',
		'Six Note Test'
	];

	override function create()
	{
		Main.clear();
		Main.state.largeImageKey = "boyfriend";
		Main.setstate("Selecting song...", "<V1.0.1>");
		songs = []; // CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt'); [dupes.mpeg]

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			}
		 */

		var isDebug:Bool = true;

		#if debug
		isDebug = true;
		#end
		var c:Int = 0;
		for(i in StoryMenuState.weekUnlocked){
			if(i){
				if(StoryMenuState.weekData[c] == null)
					break;
				
				songs  = songs.concat(StoryMenuState.weekData[c]);
			}
			c++;
		}
		for(i in BuiltinSongs)
			songs.push(i);

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBGBlue.png');
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		
		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.5, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, CENTER);
		scoreText.updateHitbox();
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic('assets/music/title' + TitleState.soundExt, 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}
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

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore[0], 0.4));

		if (Math.abs(lerpScore - intendedScore[0]) <= 10)
			lerpScore = intendedScore[0];
		// trace(intendedScore[1]);
		scoreText.text = 'RATING: ${Rate(intendedScore[1])} | PERSONAL BEST: $lerpScore';
		scoreText.x = (FlxG.width - scoreText.width) / 2;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var mouseOver:Int = -1;
		var iC:Int = -1;
		for(i in grpSongs.members) {
			iC++;
			if(FlxG.mouse.x >= i.x && FlxG.mouse.x < i.x + i.width &&
				FlxG.mouse.y >= i.y && FlxG.mouse.y < i.y + i.height && FlxG.mouse.visible) {
					mouseOver = iC;
					i.color = 0xAAAAFF; // Almost resorted to using filters.
			} else
				i.color = 0xFFFFFF;
		}
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if(mouseOver >= 0 && FlxG.mouse.justPressed) {
			accepted = true;
			curSelected = mouseOver;
		}
			
		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), curDifficulty);

			trace(poop);
			try {
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase());
				PlayState.Bullshit = false;
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				FlxG.switchState(new PlayState());
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
			} catch(_e) {
				BugHandlerState.text = "LOADED NONEXISTENT JSON FILE";
				trace(_e);
				FlxG.switchState(new BugHandlerState());
			}
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		var difficultyCap = 2; // hard
		if(songs[curSelected].toLowerCase() == 'nick-a-pocalypse')
			difficultyCap = 3;
		if (curDifficulty < 0)
			curDifficulty = difficultyCap;
		if (curDifficulty > difficultyCap)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		#end
		var Difficulty = ["EASY", "NORMAL", "HARD", "HELL"][curDifficulty];
		diffText.text = '${songs[curSelected].toUpperCase()} - $Difficulty';
		diffText.x = (FlxG.width / 2) - (diffText.width / 2);
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		//NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);
		
		var difficultyCap = 2; // hard
		if(songs[curSelected].toLowerCase() == 'nick-a-pocalypse')
			difficultyCap = 3;
		

		curSelected += change;
		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
		if(songs[curSelected].toLowerCase() != 'nick-a-pocalypse' && curDifficulty > 2) // hard coding, my favourite
			curDifficulty = 2;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		// lerpScore = 0;
		#end

		var Difficulty = ["EASY", "NORMAL", "HARD", "HELL"][curDifficulty];
		diffText.text = '${songs[curSelected].toUpperCase()} - $Difficulty';
		diffText.x = (FlxG.width / 2) - (diffText.width / 2);

		FlxG.sound.playMusic('assets/music/' + songs[curSelected] + "_Inst" + TitleState.soundExt, 0);

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
