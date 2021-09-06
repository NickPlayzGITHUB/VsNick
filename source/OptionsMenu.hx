package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	public var menuBG:FlxSprite;
	public static var warned:Bool = false;
	public static var ceased:Bool = false;
	public static var controlsStrings:Array<Dynamic> = [
		{
			type: "cb",
			name: "downscroll",
			saveas: "downscroll",
			def: false
		},
		{
			type: "cb",
			name: "show fps?",
			saveas: "fps",
			def: true
		},
		{
			type: "int",
			name: "framerate",
			saveas: "fps-b",
			def: 64,
			min: 10
		},
		{
			type: "cb",
			name: "precision",
			saveas: "prec",
			def: false
		},
		{
			type: "cb",
			name: "hell mode",
			saveas: "hell",
			def: false
		},
		{
			type: "ienum",
			name: "screen size",
			def: 1,
			indexers: [
				"480p",
				"720p",
				"900p",
				"1080p",
				"1440p"
			],
			saveas: "sr"
		},
		{
			type: "ienum",
			name: "mash protection",
			def: 0,
			grey: false, // not implemented yet
			indexers: [
				"none",   	  // No protection against combo breaks
				"medium",   // Protected from combo breaks in sections without notes
				"maximum" // Can't break combo unless you miss a note
			],
			saveas: "mash-prot"
		},
		{
			type: "ienum",
			name: "bot",
			saveas: "bt",
			def: 0,
			indexers: [
				"off",
				"speed (conservative)",
				"precision (naïve)"
			]
		},
		{
			type: "ienum",
			name: "n-a-p Vocals",
			saveas: "vocale",
			def: 0,
			indexers: [
				"new",
				"old"
			]
		},
		{
			type: "cb",
			name: "rich presence",
			saveas: "rpres",
			def: true
		},
		{
			type: "cb",
			name: "show haxeflixel cursor",
			saveas: "cursor",
			def: false
		},
		{
			type: "cb",
			grey: true, // Grey it out. Nobody should ever be allowed to access this.
			name: "kademode",
			saveas: "km",
			def: false
		}
	];
	private var RepeatTimer:FlxTimer;
	private var PooledTxts:Array<BoundText> = [];
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var self:OptionsMenu;
	public static function bind(redo:Bool = true)
	{
		if(Highscore.Dynamix.get("cursor") != null)
		{
			FlxG.mouse.visible = Highscore.Dynamix.get("cursor");
		}
		if(Highscore.Dynamix.get("fps") != null)
		{
			if(Highscore.Dynamix.get("fps") && !Main.addedf)
				Main.aF();
			else if(!Highscore.Dynamix.get("fps") && Main.addedf)
				Main.rF();
		} else if(Main.addedf)
			Main.rF();
		
		if(Highscore.Dynamix.get("fps-b") != null)
			FlxG.drawFramerate = FlxG.updateFramerate = Highscore.Dynamix.get("fps-b");
		
		if(Highscore.Dynamix.get("fps-b") != null)
			FlxG.drawFramerate = FlxG.updateFramerate = Highscore.Dynamix.get("fps-b");
		
		if(Highscore.Dynamix.get("sr") != null)
		{
			var res:Array<Int> = [
				480,
				720,
				900,
				1080,
				1440
			];
			var ri:Int = Highscore.Dynamix.get("sr");
			FlxG.resizeGame(Std.int(res[ri] * (16 / 9)), res[ri]);
			FlxG.resizeWindow(Std.int(res[ri] * (16 / 9)), res[ri]);
		}
		
		if(Highscore.Dynamix.get("rpres") != null)
		{
			if(!Highscore.Dynamix.get("rpres"))
			{
				Main.cease();
				ceased = true;
			}
			else
			{
				// Main.resume();
				if(!warned && ceased)
				{
					controlsStrings.push({
						type: "ct",
						name: "restart game"
					});
					warned = true;
				}
			}
		}
		
		if(redo && self != null)
		{
			self.menuBG.screenCenter();
			
			var b:Array<Array<Float>> = [];
			for(i in self.grpControls.members)
				b.push([i.x, i.y]);
			self.reinit(b);
		}
	}
	function bti(w:Dynamic):Int
	{
		if(Std.isOfType(w, Array))
			return 1;
		if(Std.isOfType(w, Bool))
			return w ? 1 : 0;
		if(Std.isOfType(w, Int))
			return w;
		return -1;
	}
	function repeatb(dir:Int)
	{
		RepeatTimer = new FlxTimer().start(0.1, function(_:FlxTimer)
		{
			if(controls.LEFT && dir == -1)
			{
				dec();
				repeatb(dir);
			} else if(controls.RIGHT && dir == 1)
			{
				inc();
				repeatb(dir);
			}
		});
	}
	function reinit(?Values:Array<Array<Float>>){
		if(grpControls != null)
			remove(grpControls);
		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);
		for(i in PooledTxts)
		{
			remove(i);
		}
		PooledTxts = [];
		for (i in 0...controlsStrings.length)
		{
			var offset:Float = (70 * i) + 30;
			var offsx:Float = 0;
			if(Values != null)
			{
				if(i < Values.length)
				{
					offsx = Values[i][0];
					offset = Values[i][1];
				}
			}
			var c = controlsStrings[i];
			switch(c.type)
			{
				case "cb":
					var m:Dynamic = Highscore.getRaw(c.saveas);
					if(m == null)
						if(bti(c.def) > -1)
						{
							m = c.def;
							Highscore.setRaw(c.saveas, c.def);
						}
					var ox = (m != null ?
						(m ?
						"o" :
						"x") : "x");
					var controlLabel:Alphabet = new Alphabet(0, offset, ox + " " + c.name, true, false);
					controlLabel.ix = offsx;
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i - curSelected;
					grpControls.add(controlLabel);
				case "int":
					var m:Dynamic = Highscore.getRaw(c.saveas);
					var ox = (m != null ? m : 0);
					if(m == null)
					{
						if(bti(c.def) > -1)
						{
							ox = c.def;
							Highscore.setRaw(c.saveas, c.def);
						}
					}
					var controlLabel:Alphabet = new Alphabet(0, offset, c.name, true, false);
					controlLabel.ix = offsx;
					var FT:BoundText = new BoundText(c.name.length * 55, 0, 0, '< ${Std.string(ox)} >', 32, controlLabel);
					FT.setFormat("assets/fonts/vcr.ttf", 72, FlxColor.WHITE);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i - curSelected;
					grpControls.add(controlLabel);
					FT.linkedID = i;
					PooledTxts.push(FT);
					add(FT);
				case "ienum":
					var m:Dynamic = Highscore.getRaw(c.saveas);
					var ox = (m != null ? m : 0);
					if(m == null)
					{
						if(bti(c.def) > -1)
						{
							ox = c.def;
							Highscore.setRaw(c.saveas, c.def);
						}
					}
					var controlLabel:Alphabet = new Alphabet(0, offset, c.name, true, false);
					controlLabel.ix = offsx;
					// trace(ox, c.indexers);
					var FT:BoundText = new BoundText(c.name.length * 55, 0, 0, '< ${Std.string(c.indexers[ox])} >', 32, controlLabel);
					FT.setFormat("assets/fonts/vcr.ttf", 72, FlxColor.WHITE);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i - curSelected;
					grpControls.add(controlLabel);
					FT.linkedID = i;
					PooledTxts.push(FT);
					add(FT);
				case "ct":
					var controlLabel:Alphabet = new Alphabet(0, offset, c.name, true, false);
					controlLabel.ix = offsx;
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i - curSelected;
					grpControls.add(controlLabel);
			}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		// bind();
		changeSelection();
	}
	override function create()
	{
		Main.setstate("Changing options");
		menuBG = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		// controlsStrings = CoolUtil.coolTextFile('assets/data/controls.txt');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
		reinit();
		super.create();
		self = this;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			changeBinding();
		}

		if (isSettingControl)
			waitingInput();
		else
		{
			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			switch(controlsStrings[curSelected].type)
			{
				case "int" | "ienum":
					if(controls.LEFT_P)
					{
						dec();
						RepeatTimer = new FlxTimer().start(0.4, function(_:FlxTimer)
						{
							repeatb(-1);
						});
					}
					if(controls.RIGHT_P)
					{
						inc();
						RepeatTimer = new FlxTimer().start(0.4, function(_:FlxTimer)
						{
							repeatb(1);
						});
					}
			}
		}
	}

	function waitingInput():Void
	{
		if (FlxG.keys.getIsDown().length > 0)
		{
			PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	var isSettingControl:Bool = false;
	function dec()
	{
		var m = controlsStrings[curSelected];
		if(bti(m.grey) > 0)
			return;
		if(m.type == "ienum")
		{
			var d:Int = Std.int(Highscore.getRaw(m.saveas) - 1);
			if(bti(m.indexers) > -1)
				while(d < 0)
					d += m.indexers.length;
			Highscore.setRaw(m.saveas, d);
		}
		else
		{
			var d:Int = Std.int(Highscore.getRaw(m.saveas) - 1);
			if(d < m.min)
				d = m.min;
			Highscore.setRaw(m.saveas, d);
		}
		bind();
	}
	function inc()
	{
		var m = controlsStrings[curSelected];
		if(bti(m.grey) > 0)
			return;
		if(m.type == "ienum")
		{
			if(bti(m.indexers) > -1)
			{
			var d:Int = Std.int(Highscore.getRaw(m.saveas) + 1) % m.indexers.length;
			Highscore.setRaw(m.saveas, d);
			}
		}
		else
		{
			var d:Int = Std.int(Highscore.getRaw(m.saveas) + 1);
			Highscore.setRaw(m.saveas, d);
		}
		bind();
	}
	function changeBinding():Void
	{
		var i = curSelected;
		var shouldret:Bool = false;
		switch(controlsStrings[i].type)
		{
			case "cb":
				if(bti(controlsStrings[i].grey) > 0)
					shouldret = true;
				else
					if(Highscore.getRaw(controlsStrings[i].saveas) == null)
						Highscore.setRaw(controlsStrings[i].saveas, true);
					else
						Highscore.setRaw(controlsStrings[i].saveas,
						!Highscore.getRaw(controlsStrings[i].saveas));
				if(controlsStrings[i].saveas == 'prec')
					if(Highscore.getRaw(controlsStrings[i].saveas) != null){
						if(bti(Highscore.getRaw(controlsStrings[i].saveas)) == 0)
							Highscore.setRaw(controlsStrings[4].saveas, false);
						controlsStrings[4].grey = !Highscore.getRaw(controlsStrings[i].saveas);
					}
			case "ct":
				shouldret = true;
		}
		if(shouldret)
			return;
		bind();
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		trace('Fresh');
		// what
		#end

		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;
		for(i in 0...PooledTxts.length)
		{
			PooledTxts[i].alpha = 0.6 + (PooledTxts[i].linkedID == curSelected ? 0.4 : 0) - (bti(controlsStrings[i].grey) > 0 ? 0.3 : 0);
		}
		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6 - (bti(controlsStrings[bullShit - 1].grey) > 0 ? 0.3 : 0);
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1 - (bti(controlsStrings[bullShit - 1].grey) > 0 ? 0.3 : 0);
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
