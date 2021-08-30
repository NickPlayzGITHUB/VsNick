package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Dynamic> = new Map();
	public static var Dynamix:Map<String,  Dynamic> = new Map();
	#else
	public static var songScores:Map<String,  Dynamic> = new Map<String,  Dynamic>();
	public static var Dynamix:Map<String,  Dynamic> = new Map<String,  Dynamic>();
	#end


	public static function saveScore(song:String, score:Int = 0, finalrating:Int = 3, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);


		#if !switch
		NGio.postScore(score, song);
		#end

		var daSong:String = formatSong(song, diff);
		if (songScores.exists(daSong))
		{
			var N:Dynamic = songScores.get(daSong);
			if (N[0] < score || N[1] < finalrating)
				setScore(daSong, score, finalrating);
		}
		else
			setScore(daSong, score, finalrating);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, finalrating:Int = 3, ?diff:Int = 0):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			var N:Dynamic = songScores.get(daWeek);
			if (N[0] < score || N[1] < finalrating)
				setScore(daWeek, score, finalrating);
		}
		else
			setScore(daWeek, score, finalrating);
	}

	public static function setRaw(key:String, info:Dynamic):Void
	{
		Dynamix.set(key, info);
		FlxG.save.data.misc = Dynamix;
		FlxG.save.flush();
	}

	public static function getRaw(key:String):Dynamic
	{
		return Dynamix.get(key);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int, rate:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, [score, rate]);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';
		else if (diff == 3)
			daSong += '-hell';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Array<Int>
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0, 0);
		var O:Dynamic = songScores.get(formatSong(song, diff));
		if(Std.isOfType(O, Array))
			return O;
		else {
			setScore(formatSong(song, diff), O, 0);
			return [O, 0];
		}
	}

	public static function getWeekScore(week:Int, diff:Int):Array<Int>
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0, 0);
		
		var O:Dynamic = songScores.get(formatSong('week' + week, diff));
		if(Std.isOfType(O, Array))
			return O;
		else {
			setScore(formatSong('week' + week, diff), O, 0);
			return [O, 0];
		}
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.misc != null)
		{
			Dynamix = FlxG.save.data.misc;
		}
		OptionsMenu.bind(false);
	}
}
