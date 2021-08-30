package;

import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

#if (haxe >= "4.0.0")
enum abstract Action(String) to String from String
{
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var L2 = "l2";
	var R2 = "r2";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var L2_P = "l2-press";
	var R2_P = "r2-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var RIGHT_R = "right-release";
	var L2_R = "l2-release";
	var R2_R = "r2-release";
	var DOWN_R = "down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	var CHEAT = "cheat";
	var K1_P = "k1-press";
	var K2_P = "k2-press";
	var K3_P = "k3-press";
	var K4_P = "k4-press";
	var K5_P = "k5-press";
	var K6_P = "k6-press";
	var K7_P = "k7-press";
	var K8_P = "k8-press";
	var K9_P = "k9-press";
	var K1 = "k1";
	var K2 = "k2";
	var K3 = "k3";
	var K4 = "k4";
	var K5 = "k5";
	var K6 = "k6";
	var K7 = "k7";
	var K8 = "k8";
	var K9 = "k9";
	var K1_R = "k1-release";
	var K2_R = "k2-release";
	var K3_R = "k3-release";
	var K4_R = "k4-release";
	var K5_R = "k5-release";
	var K6_R = "k6-release";
	var K7_R = "k7-release";
	var K8_R = "k8-release";
	var K9_R = "k9-release";
}
#else
@:enum
abstract Action(String) to String from String
{
	var UP = "up";
	var LEFT = "left";
	var RIGHT = "right";
	var L2 = "l2";
	var R2 = "r2";
	var DOWN = "down";
	var UP_P = "up-press";
	var LEFT_P = "left-press";
	var L2_P = "l2-press";
	var R2_P = "r2-press";
	var RIGHT_P = "right-press";
	var DOWN_P = "down-press";
	var UP_R = "up-release";
	var LEFT_R = "left-release";
	var L2_R = "l2-release";
	var R2_R = "r2-release";
	var RIGHT_R = "right-release";
	var DOWN_R = "down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";
	var CHEAT = "cheat";
	var K1_P = "k1-press";
	var K2_P = "k2-press";
	var K3_P = "k3-press";
	var K4_P = "k4-press";
	var K5_P = "k5-press";
	var K6_P = "k6-press";
	var K7_P = "k7-press";
	var K8_P = "k8-press";
	var K9_P = "k9-press";
	var K1 = "k1";
	var K2 = "k2";
	var K3 = "k3";
	var K4 = "k4";
	var K5 = "k5";
	var K6 = "k6";
	var K7 = "k7";
	var K8 = "k8";
	var K9 = "k9";
	var K1_R = "k1-release";
	var K2_R = "k2-release";
	var K3_R = "k3-release";
	var K4_R = "k4-release";
	var K5_R = "k5-release";
	var K6_R = "k6-release";
	var K7_R = "k7-release";
	var K8_R = "k8-release";
	var K9_R = "k9-release";
}
#end

enum Device
{
	Keys;
	Gamepad(id:Int);
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Control
{
	UP;
	LEFT;
	L2;
	R2;
	RIGHT;
	DOWN;
	RESET;
	ACCEPT;
	BACK;
	PAUSE;
	CHEAT;
	K1;
	K2;
	K3;
	K4;
	K5;
	K6;
	K7;
	K8;
	K9;
}

enum KeyboardScheme
{
	Solo;
	Duo(first:Bool);
	NineKeyBullshit;
	None;
	Custom;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 */
class Controls extends FlxActionSet
{
	var _up = new FlxActionDigital(Action.UP);
	var _left = new FlxActionDigital(Action.LEFT);
	var _right = new FlxActionDigital(Action.RIGHT);
	var _l2 = new FlxActionDigital(Action.L2);
	var _r2 = new FlxActionDigital(Action.R2);
	var _down = new FlxActionDigital(Action.DOWN);
	var _upP = new FlxActionDigital(Action.UP_P);
	var _leftP = new FlxActionDigital(Action.LEFT_P);
	var _l2P = new FlxActionDigital(Action.L2_P);
	var _r2P = new FlxActionDigital(Action.R2_P);
	var _rightP = new FlxActionDigital(Action.RIGHT_P);
	var _downP = new FlxActionDigital(Action.DOWN_P);
	var _upR = new FlxActionDigital(Action.UP_R);
	var _leftR = new FlxActionDigital(Action.LEFT_R);
	var _rightR = new FlxActionDigital(Action.RIGHT_R);
	var _l2R = new FlxActionDigital(Action.L2_R);
	var _r2R = new FlxActionDigital(Action.R2_R);
	var _downR = new FlxActionDigital(Action.DOWN_R);
	var _accept = new FlxActionDigital(Action.ACCEPT);
	var _back = new FlxActionDigital(Action.BACK);
	var _pause = new FlxActionDigital(Action.PAUSE);
	var _reset = new FlxActionDigital(Action.RESET);
	var _cheat = new FlxActionDigital(Action.CHEAT);
	var _k1 = new FlxActionDigital(Action.K1);
	var _k2 = new FlxActionDigital(Action.K2);
	var _k3 = new FlxActionDigital(Action.K3);
	var _k4 = new FlxActionDigital(Action.K4);
	var _k5 = new FlxActionDigital(Action.K5);
	var _k6 = new FlxActionDigital(Action.K6);
	var _k7 = new FlxActionDigital(Action.K7);
	var _k8 = new FlxActionDigital(Action.K8);
	var _k9 = new FlxActionDigital(Action.K9);
	var _k1P = new FlxActionDigital(Action.K1_P);
	var _k2P = new FlxActionDigital(Action.K2_P);
	var _k3P = new FlxActionDigital(Action.K3_P);
	var _k4P = new FlxActionDigital(Action.K4_P);
	var _k5P = new FlxActionDigital(Action.K5_P);
	var _k6P = new FlxActionDigital(Action.K6_P);
	var _k7P = new FlxActionDigital(Action.K7_P);
	var _k8P = new FlxActionDigital(Action.K8_P);
	var _k9P = new FlxActionDigital(Action.K9_P);
	var _k1R = new FlxActionDigital(Action.K1_R);
	var _k2R = new FlxActionDigital(Action.K2_R);
	var _k3R = new FlxActionDigital(Action.K3_R);
	var _k4R = new FlxActionDigital(Action.K4_R);
	var _k5R = new FlxActionDigital(Action.K5_R);
	var _k6R = new FlxActionDigital(Action.K6_R);
	var _k7R = new FlxActionDigital(Action.K7_R);
	var _k8R = new FlxActionDigital(Action.K8_R);
	var _k9R = new FlxActionDigital(Action.K9_R);

	#if (haxe >= "4.0.0")
	var byName:Map<String, FlxActionDigital> = [];
	#else
	var byName:Map<String, FlxActionDigital> = new Map<String, FlxActionDigital>();
	#end

	public var gamepadsAdded:Array<Int> = [];
	public var keyboardScheme = KeyboardScheme.Solo;

	public var UP(get, never):Bool;

	inline function get_UP()
		return _up.check();

	public var LEFT(get, never):Bool;

	inline function get_LEFT()
		return _left.check();
		
	public var L2(get, never):Bool;
	inline function get_L2()
		return _l2.check();
		
	public var R2(get, never):Bool;
	inline function get_R2()
		return _r2.check();

	public var RIGHT(get, never):Bool;

	inline function get_RIGHT()
		return _right.check();

	public var DOWN(get, never):Bool;

	inline function get_DOWN()
		return _down.check();

	public var UP_P(get, never):Bool;

	inline function get_UP_P()
		return _upP.check();

	public var LEFT_P(get, never):Bool;

	inline function get_LEFT_P()
		return _leftP.check();
		
	public var L2_P(get, never):Bool;
		
	inline function get_L2_P()
		return _l2P.check();
		
	public var R2_P(get, never):Bool;
	
	inline function get_R2_P()
		return _r2P.check();

	public var RIGHT_P(get, never):Bool;

	inline function get_RIGHT_P()
		return _rightP.check();

	public var DOWN_P(get, never):Bool;

	inline function get_DOWN_P()
		return _downP.check();

	public var UP_R(get, never):Bool;

	inline function get_UP_R()
		return _upR.check();

	public var LEFT_R(get, never):Bool;

	inline function get_LEFT_R()
		return _leftR.check();

	public var L2_R(get, never):Bool;

	inline function get_L2_R()
		return _l2R.check();

	public var R2_R(get, never):Bool;

	inline function get_R2_R()
		return _r2R.check();

	public var RIGHT_R(get, never):Bool;

	inline function get_RIGHT_R()
		return _rightR.check();

	public var DOWN_R(get, never):Bool;

	inline function get_DOWN_R()
		return _downR.check();

	public var ACCEPT(get, never):Bool;

	inline function get_ACCEPT()
		return _accept.check();

	public var BACK(get, never):Bool;

	inline function get_BACK()
		return _back.check();

	public var PAUSE(get, never):Bool;

	inline function get_PAUSE()
		return _pause.check();

	public var RESET(get, never):Bool;

	inline function get_RESET()
		return _reset.check();

	public var CHEAT(get, never):Bool;

	inline function get_CHEAT()
		return _cheat.check();

	public var K1(get, never):Bool;

	inline function get_K1()
		return _k1.check();

	public var K2(get, never):Bool;

	inline function get_K2()
		return _k2.check();

	public var K3(get, never):Bool;

	inline function get_K3()
		return _k3.check();

	public var K4(get, never):Bool;

	inline function get_K4()
		return _k4.check();

	public var K5(get, never):Bool;

	inline function get_K5()
		return _k5.check();

	public var K6(get, never):Bool;

	inline function get_K6()
		return _k6.check();

	public var K7(get, never):Bool;

	inline function get_K7()
		return _k7.check();

	public var K8(get, never):Bool;

	inline function get_K8()
		return _k8.check();

	public var K9(get, never):Bool;

	inline function get_K9()
		return _k9.check();

	public var K1_P(get, never):Bool;

	inline function get_K1_P()
		return _k1P.check();

	public var K2_P(get, never):Bool;

	inline function get_K2_P()
		return _k2P.check();

	public var K3_P(get, never):Bool;

	inline function get_K3_P()
		return _k3P.check();

	public var K4_P(get, never):Bool;

	inline function get_K4_P()
		return _k4P.check();

	public var K5_P(get, never):Bool;

	inline function get_K5_P()
		return _k5P.check();

	public var K6_P(get, never):Bool;

	inline function get_K6_P()
		return _k6P.check();

	public var K7_P(get, never):Bool;

	inline function get_K7_P()
		return _k7P.check();

	public var K8_P(get, never):Bool;

	inline function get_K8_P()
		return _k8P.check();

	public var K9_P(get, never):Bool;

	inline function get_K9_P()
		return _k9P.check();

	public var K1_R(get, never):Bool;

	inline function get_K1_R()
		return _k1R.check();

	public var K2_R(get, never):Bool;

	inline function get_K2_R()
		return _k2R.check();

	public var K3_R(get, never):Bool;

	inline function get_K3_R()
		return _k3R.check();

	public var K4_R(get, never):Bool;

	inline function get_K4_R()
		return _k4R.check();

	public var K5_R(get, never):Bool;

	inline function get_K5_R()
		return _k5R.check();

	public var K6_R(get, never):Bool;

	inline function get_K6_R()
		return _k6R.check();

	public var K7_R(get, never):Bool;

	inline function get_K7_R()
		return _k7R.check();

	public var K8_R(get, never):Bool;

	inline function get_K8_R()
		return _k8R.check();

	public var K9_R(get, never):Bool;

	inline function get_K9_R()
		return _k9R.check();

	#if (haxe >= "4.0.0")
	public function new(name, scheme = None)
	{
		super(name);

		add(_up);
		add(_left);
		add(_right);
		add(_l2);
		add(_r2);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_l2P);
		add(_r2P);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);
		add(_l2R);
		add(_r2R);
		add(_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		add(_cheat);
		add(_k1);
		add(_k2);
		add(_k3);
		add(_k4);
		add(_k5);
		add(_k6);
		add(_k7);
		add(_k8);
		add(_k9);
		add(_k1P);
		add(_k2P);
		add(_k3P);
		add(_k4P);
		add(_k5P);
		add(_k6P);
		add(_k7P);
		add(_k8P);
		add(_k9P);
		add(_k1R);
		add(_k2R);
		add(_k3R);
		add(_k4R);
		add(_k5R);
		add(_k6R);
		add(_k7R);
		add(_k8R);
		add(_k9R);

		for (action in digitalActions)
			byName[action.name] = action;

		setKeyboardScheme(scheme, false);
	}
	#else
	public function new(name, scheme:KeyboardScheme = null)
	{
		super(name);

		add(_up);
		add(_left);
		add(_right);
		add(_l2);
		add(_r2);
		add(_down);
		add(_upP);
		add(_leftP);
		add(_rightP);
		add(_l2P);
		add(_r2P);
		add(_downP);
		add(_upR);
		add(_leftR);
		add(_rightR);
		add(_l2R);
		add(_r2R);
		add(_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);
		add(_cheat);
		add(_k1);
		add(_k2);
		add(_k3);
		add(_k4);
		add(_k5);
		add(_k6);
		add(_k7);
		add(_k8);
		add(_k9);
		add(_k1P);
		add(_k2P);
		add(_k3P);
		add(_k4P);
		add(_k5P);
		add(_k6P);
		add(_k7P);
		add(_k8P);
		add(_k9P);
		add(_k1R);
		add(_k2R);
		add(_k3R);
		add(_k4R);
		add(_k5R);
		add(_k6R);
		add(_k7R);
		add(_k8R);
		add(_k9R);

		for (action in digitalActions)
			byName[action.name] = action;
			
		if (scheme == null)
			scheme = None;
		setKeyboardScheme(scheme, false);
	}
	#end

	override function update()
	{
		super.update();
	}

	// inline
	public function checkByName(name:Action):Bool
	{
		#if debug
		if (!byName.exists(name))
			throw 'Invalid name: $name';
		#end
		return byName[name].check();
	}

	public function getDialogueName(action:FlxActionDigital):String
	{
		var input = action.inputs[0];
		return switch input.device
		{
			case KEYBOARD: return '[${(input.inputID : FlxKey)}]';
			case GAMEPAD: return '(${(input.inputID : FlxGamepadInputID)})';
			case device: throw 'unhandled device: $device';
		}
	}

	public function getDialogueNameFromToken(token:String):String
	{
		return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
	}

	function getActionFromControl(control:Control):FlxActionDigital
	{
		return switch (control)
		{
			case UP: _up;
			case DOWN: _down;
			case LEFT: _left;
			case L2: _l2;
			case RIGHT: _right;
			case R2: _r2;
			case ACCEPT: _accept;
			case BACK: _back;
			case PAUSE: _pause;
			case RESET: _reset;
			case CHEAT: _cheat;
			case K1: _k1;
			case K2: _k2;
			case K3: _k3;
			case K4: _k4;
			case K5: _k5;
			case K6: _k6;
			case K7: _k7;
			case K8: _k8;
			case K9: _k9;
		}
	}

	static function init():Void
	{
		var actions = new FlxActionManager();
		FlxG.inputs.add(actions);
	}

	/**
	 * Calls a function passing each action bound by the specified control
	 * @param control
	 * @param func
	 * @return ->Void)
	 */
	function forEachBound(control:Control, func:FlxActionDigital->FlxInputState->Void)
	{
		switch (control)
		{
			case UP:
				func(_up, PRESSED);
				func(_upP, JUST_PRESSED);
				func(_upR, JUST_RELEASED);
			case LEFT:
				func(_left, PRESSED);
				func(_leftP, JUST_PRESSED);
				func(_leftR, JUST_RELEASED);
			case L2:
				func(_l2, PRESSED);
				func(_l2P, JUST_PRESSED);
				func(_l2R, JUST_RELEASED);
			case R2:
				func(_r2, PRESSED);
				func(_r2P, JUST_PRESSED);
				func(_r2R, JUST_RELEASED);
			case RIGHT:
				func(_right, PRESSED);
				func(_rightP, JUST_PRESSED);
				func(_rightR, JUST_RELEASED);
			case DOWN:
				func(_down, PRESSED);
				func(_downP, JUST_PRESSED);
				func(_downR, JUST_RELEASED);
			case ACCEPT:
				func(_accept, JUST_PRESSED);
			case BACK:
				func(_back, JUST_PRESSED);
			case PAUSE:
				func(_pause, JUST_PRESSED);
			case RESET:
				func(_reset, JUST_PRESSED);
			case CHEAT:
				func(_cheat, PRESSED);
			case K1:
				func(_k1, PRESSED);
				func(_k1P, JUST_PRESSED);
				func(_k1R, JUST_RELEASED);
			case K2:
				func(_k2, PRESSED);
				func(_k2P, JUST_PRESSED);
				func(_k2R, JUST_RELEASED);
			case K3:
				func(_k3, PRESSED);
				func(_k3P, JUST_PRESSED);
				func(_k3R, JUST_RELEASED);
			case K4:
				func(_k4, PRESSED);
				func(_k4P, JUST_PRESSED);
				func(_k4R, JUST_RELEASED);
			case K5:
				func(_k5, PRESSED);
				func(_k5P, JUST_PRESSED);
				func(_k5R, JUST_RELEASED);
			case K6:
				func(_k6, PRESSED);
				func(_k6P, JUST_PRESSED);
				func(_k6R, JUST_RELEASED);
			case K7:
				func(_k7, PRESSED);
				func(_k7P, JUST_PRESSED);
				func(_k7R, JUST_RELEASED);
			case K8:
				func(_k8, PRESSED);
				func(_k8P, JUST_PRESSED);
				func(_k8R, JUST_RELEASED);
			case K9:
				func(_k9, PRESSED);
				func(_k9P, JUST_PRESSED);
				func(_k9R, JUST_RELEASED);
		}
	}

	public function replaceBinding(control:Control, device:Device, ?toAdd:Int, ?toRemove:Int)
	{
		if (toAdd == toRemove)
			return;

		switch (device)
		{
			case Keys:
				if (toRemove != null)
					unbindKeys(control, [toRemove]);
				if (toAdd != null)
					bindKeys(control, [toAdd]);

			case Gamepad(id):
				if (toRemove != null)
					unbindButtons(control, id, [toRemove]);
				if (toAdd != null)
					bindButtons(control, id, [toAdd]);
		}
	}

	public function copyFrom(controls:Controls, ?device:Device)
	{
		#if (haxe >= "4.0.0")
		for (name => action in controls.byName)
		{
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
					byName[name].add(cast input);
			}
		}
		#else
		for (name in controls.byName.keys())
		{
			var action = controls.byName[name];
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
				byName[name].add(cast input);
			}
		}
		#end

		switch (device)
		{
			case null:
				// add all
				#if (haxe >= "4.0.0")
				for (gamepad in controls.gamepadsAdded)
					if (!gamepadsAdded.contains(gamepad))
						gamepadsAdded.push(gamepad);
				#else
				for (gamepad in controls.gamepadsAdded)
					if (gamepadsAdded.indexOf(gamepad) == -1)
					  gamepadsAdded.push(gamepad);
				#end

				mergeKeyboardScheme(controls.keyboardScheme);

			case Gamepad(id):
				gamepadsAdded.push(id);
			case Keys:
				mergeKeyboardScheme(controls.keyboardScheme);
		}
	}

	inline public function copyTo(controls:Controls, ?device:Device)
	{
		controls.copyFrom(this, device);
	}

	function mergeKeyboardScheme(scheme:KeyboardScheme):Void
	{
		if (scheme != None)
		{
			switch (keyboardScheme)
			{
				case None:
					keyboardScheme = scheme;
				default:
					keyboardScheme = Custom;
			}
		}
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addKeys(action, keys, state));
		#else
		forEachBound(control, function(action, state) addKeys(action, keys, state));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindKeys(control:Control, keys:Array<FlxKey>)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeKeys(action, keys));
		#else
		forEachBound(control, function(action, _) removeKeys(action, keys));
		#end
	}

	inline static function addKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState)
	{
		for (key in keys)
			action.addKey(key, state);
	}

	static function removeKeys(action:FlxActionDigital, keys:Array<FlxKey>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (input.device == KEYBOARD && keys.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function setKeyboardScheme(scheme:KeyboardScheme, reset = true)
	{
		if (reset)
			removeKeyboard();

		keyboardScheme = scheme;
		
		#if (haxe >= "4.0.0")
		switch (scheme)
		{
			case Solo:
				inline bindKeys(Control.UP, [W, FlxKey.UP, B]);
				inline bindKeys(Control.DOWN, [S, FlxKey.DOWN, X]);
				inline bindKeys(Control.LEFT, [A, FlxKey.LEFT, Z]);
				inline bindKeys(Control.RIGHT, [D, FlxKey.RIGHT, N]);
				inline bindKeys(Control.L2, [Q, V]);
				inline bindKeys(Control.R2, [E, C]);
				inline bindKeys(Control.ACCEPT, [Z, SPACE, ENTER]);
				inline bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
				inline bindKeys(Control.PAUSE, [P, ENTER, ESCAPE]);
				inline bindKeys(Control.RESET, [R]);
				// inline bindKeys(Control.CHEAT, [G]);
			case Duo(true):
				inline bindKeys(Control.UP, [W]);
				inline bindKeys(Control.DOWN, [S]);
				inline bindKeys(Control.LEFT, [A]);
				inline bindKeys(Control.RIGHT, [D]);
				inline bindKeys(Control.L2, [Q]);
				inline bindKeys(Control.R2, [E]);
				inline bindKeys(Control.ACCEPT, [G, Z]);
				inline bindKeys(Control.BACK, [H, X]);
				inline bindKeys(Control.PAUSE, [ONE]);
				inline bindKeys(Control.RESET, [R]);
			case Duo(false):
				inline bindKeys(Control.UP, [FlxKey.UP]);
				inline bindKeys(Control.DOWN, [FlxKey.DOWN]);
				inline bindKeys(Control.LEFT, [FlxKey.LEFT]);
				inline bindKeys(Control.RIGHT, [FlxKey.RIGHT]);
				inline bindKeys(Control.ACCEPT, [O]);
				inline bindKeys(Control.BACK, [P]);
				inline bindKeys(Control.PAUSE, [ENTER]);
				inline bindKeys(Control.RESET, [BACKSPACE]);
			case NineKeyBullshit:
				inline bindKeys(Control.K1, [A]);
				inline bindKeys(Control.K2, [S]);
				inline bindKeys(Control.K3, [D]);
				inline bindKeys(Control.K4, [F]);
				inline bindKeys(Control.K5, [G,SPACE]);
				inline bindKeys(Control.K6, [H]);
				inline bindKeys(Control.K7, [J]);
				inline bindKeys(Control.K8, [K]);
				inline bindKeys(Control.K9, [L]);
				inline bindKeys(Control.ACCEPT, [A, Z, SPACE, ENTER]);
				inline bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
				inline bindKeys(Control.PAUSE, [P, ENTER, ESCAPE]);
				inline bindKeys(Control.RESET, [T]);
			case None: // nothing
			case Custom: // nothing
		}
		#else
		switch (scheme)
		{
			case Solo:
				bindKeys(Control.UP, [W, FlxKey.UP]);
				bindKeys(Control.DOWN, [S, FlxKey.DOWN]);
				bindKeys(Control.LEFT, [A, FlxKey.LEFT]);
				bindKeys(Control.RIGHT, [D, FlxKey.RIGHT]);
				bindKeys(Control.L2, [Q]);
				bindKeys(Control.R2, [E]);
				bindKeys(Control.ACCEPT, [Z, SPACE, ENTER]);
				bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
				bindKeys(Control.PAUSE, [P, ENTER, ESCAPE]);
				bindKeys(Control.RESET, [R]);
			case Duo(true):
				bindKeys(Control.UP, [W]);
				bindKeys(Control.DOWN, [S]);
				bindKeys(Control.LEFT, [A]);
				bindKeys(Control.RIGHT, [D]);
				bindKeys(Control.L2, [Q]);
				bindKeys(Control.R2, [E]);
				bindKeys(Control.ACCEPT, [G, Z]);
				bindKeys(Control.BACK, [H, X]);
				bindKeys(Control.PAUSE, [ONE]);
				bindKeys(Control.RESET, [R]);
			case Duo(false):
				bindKeys(Control.UP, [FlxKey.UP]);
				bindKeys(Control.DOWN, [FlxKey.DOWN]);
				bindKeys(Control.LEFT, [FlxKey.LEFT]);
				bindKeys(Control.RIGHT, [FlxKey.RIGHT]);
				bindKeys(Control.ACCEPT, [O]);
				bindKeys(Control.BACK, [P]);
				bindKeys(Control.PAUSE, [ENTER]);
				bindKeys(Control.RESET, [BACKSPACE]);
			case None: // nothing
			case Custom: // nothing
		}
		#end
	}

	function removeKeyboard()
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == KEYBOARD)
					action.remove(input);
			}
		}
	}

	public function addGamepad(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);
		
		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	inline function addGamepadLiteral(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	public function removeGamepad(deviceID:Int = FlxInputDeviceID.ALL):Void
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID))
					action.remove(input);
			}
		}

		gamepadsAdded.remove(deviceID);
	}

	public function addDefaultGamepad(id):Void
	{
		#if !switch
		addGamepadLiteral(id, [
			Control.ACCEPT => [A],
			Control.BACK => [B],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			Control.RESET => [Y]
		]);
		#else
		addGamepadLiteral(id, [
			//Swap A and B for switch
			Control.ACCEPT => [B],
			Control.BACK => [A],
			Control.UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP],
			Control.DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN],
			Control.LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT],
			Control.RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT],
			Control.PAUSE => [START],
			//Swap Y and X for switch
			Control.RESET => [Y],
			Control.CHEAT => [X]
		]);
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindButtons(control:Control, id, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addButtons(action, buttons, state, id));
		#else
		forEachBound(control, function(action, state) addButtons(action, buttons, state, id));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindButtons(control:Control, gamepadID:Int, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeButtons(action, gamepadID, buttons));
		#else
		forEachBound(control, function(action, _) removeButtons(action, gamepadID, buttons));
		#end
	}

	inline static function addButtons(action:FlxActionDigital, buttons:Array<FlxGamepadInputID>, state, id)
	{
		for (button in buttons)
			action.addGamepad(button, state, id);
	}

	static function removeButtons(action:FlxActionDigital, gamepadID:Int, buttons:Array<FlxGamepadInputID>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (isGamepad(input, gamepadID) && buttons.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function getInputsFor(control:Control, device:Device, ?list:Array<Int>):Array<Int>
	{
		if (list == null)
			list = [];

		switch (device)
		{
			case Keys:
				for (input in getActionFromControl(control).inputs)
				{
					if (input.device == KEYBOARD)
						list.push(input.inputID);
				}
			case Gamepad(id):
				for (input in getActionFromControl(control).inputs)
				{
					if (input.deviceID == id)
						list.push(input.inputID);
				}
		}
		return list;
	}

	public function removeDevice(device:Device)
	{
		switch (device)
		{
			case Keys:
				setKeyboardScheme(None);
			case Gamepad(id):
				removeGamepad(id);
		}
	}

	static function isDevice(input:FlxActionInput, device:Device)
	{
		return switch device
		{
			case Keys: input.device == KEYBOARD;
			case Gamepad(id): isGamepad(input, id);
		}
	}

	inline static function isGamepad(input:FlxActionInput, deviceID:Int)
	{
		return input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID);
	}
}
