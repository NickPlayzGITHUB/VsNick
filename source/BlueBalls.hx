package;

import flixel.FlxG;
import flixel.util.FlxTimer;
/* Blueball detect plans
	* Blueball warn if any of the following (and their subconditions):
		* You're at a lower health
			* Too many breaking keystrokes happen in less than a fifth of a second
		* Too many notes missed in a second
		
*/
class BlueBalls
{
	public var play:PlayState;
	private var keyStrokes:Array<Array<Dynamic>>;
	private var keyRemove:Array<FlxTimer>;
	public function new(playstate:PlayState){
		play = playstate;
		keyStrokes = [];
		keyRemove = [];
	}
	public function defer(controls:Array<Bool>, songTime:Float){
		keyStrokes.push([controls, songTime]);
		var ind:Int = keyStrokes.length - 1;
		keyRemove.push(new FlxTimer().start(0.4, function(_:FlxTimer){
			keyStrokes.splice(ind, 1);
			keyRemove.splice(ind, 1);
		}));
	}
	public function update(elapsed:Float){
		var cball:Bool = true;
		if(play.blueballs_warn)
			return;
		if(keyStrokes.length > 6 && PlayState.healthj < 0.2){
			play.blueball(0.7);
			trace('blueball');
			cball = false;
		}
		if(cball){
			play.save_balls();
		}
	}
}
