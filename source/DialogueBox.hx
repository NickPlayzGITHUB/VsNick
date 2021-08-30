package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	// Even morer stuipdi hardcodig
	var Lookups:Array<Dynamic> = [
		["boyfriend", "boyfriendPortrait.png", "portrait.xml"],
		["bf", "weeb/bfPortrait.png", "weeb/bfPortrait.xml"],
		["dad", "weeb/senpaiPortrait.png", "weeb/senpaiPortrait.xml"],
		["spirit", "weeb/spiritFaceForward.png", "weeb/Spirit.xml"],
		["dearest", "dadPortrait.png", "portrait.xml"],
		["mom", "momPortrait.png", "portrait.xml"],
		["parentsDad", "parentsDadPortrait.png", "portrait.xml"],
		["parentsMom", "parentsMomPortrait.png", "portrait.xml"],
		["pico", "picoPortrait.png", "portrait.xml"],
		["pico-angry", "picoAngryPortrait.png", "portrait.xml"],
		["christmasLemon", "christmasLemonPortrait.png", "portrait.xml"],
		["skid", "skidPortrait.png", "portrait.xml"],
		["pump", "pumpPortrait.png", "portrait.xml"],
		["parents", "parentsPortrait.png", "portrait.xml"],
		["girlfriend", "gfPortrait.png", "portrait.xml"],
		["gf", "gfPortrait.png", "portrait.xml"],
		["girlfriend-cheer", "gfCheerPortrait.png", "portrait.xml"],
		["gf-cheer", "gfCheerPortrait.png", "portrait.xml"],
		["whitty", "whittyPortrait.png", "wportrait.xml"],
		["whittyagit", "whittyPortrait.png", "wportraitb.xml"],
		["whittycrazy", "whittyPortrait.png", "wportraitc.xml", true],
		["qbby", "qbPortrait.png", "qbPortrait-n.xml"],
		["qbbymad", "qbPortrait.png", "qbPortrait-m.xml"],
		["qbbyshock", "qbPortrait.png", "qbPortrait-s.xml"],
		["qbbyhadit", "qbPortrait.png", "qbPortrait-h.xml"],
		["jobski", "jobPortrait.png", "jobPortrait-n.xml", true],
		["jobski~shock", "jobPortrait.png", "jobPortrait-s.xml", true],
		["jobski~struggle", "jobPortrait.png", "jobPortrait-p.xml", true],
		["nick", "niccPortrait.png", "portrait.xml"],
	    ["psycho-nick", "psychoNickPortrait.png", "portrait.xml"],
		 ["spirit-n", "spiritframe.png", "portrait.xml"]
	];
	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;

	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	public function UpdatePortrait(whoistalk:String = ""){
		if(portraitLeft != null)
			remove(portraitLeft);
		var Entry:Array<Dynamic> = [];
		for(i in Lookups){
			if(i[0] == whoistalk){ // I probably should use Array Access tables like I did in
												  // the Week Info, but I don't want to torture myself by
												  // reworking this mess.
				Entry = i;
				break;
			}
		}
		var E:Bool = false;
		if(Entry[3] != null){
			E = Entry[3];
		}
		if(whoistalk.indexOf("qbby") == 0) /* hardcoded offsets because im beyond an idiot
																			qbbysona distray */
			portraitLeft = new FlxSprite(130, 250);
		else if(whoistalk.indexOf("jobski") == 0) // jobski (Part Time UFO)
			portraitLeft = new FlxSprite(130, 200);
		else if(whoistalk.indexOf("whitty") == 0) // Whitty dialogue
			portraitLeft = new FlxSprite(120, 140);
		else if(whoistalk == "spirit")
			portraitLeft = new FlxSprite(120, 40);
		else
			portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/'+Entry[1], 'assets/images/'+Entry[2]);
		portraitLeft.animation.addByPrefix('enter', 'Portrait Enter', 24, E);
		if(whoistalk.indexOf(".qbby") == 0)
			portraitLeft.setGraphicSize(Std.int((portraitLeft.width * PlayState.daPixelZoom * 0.9) / 2));
		else if(Entry[2] == "portrait.xml" || whoistalk.indexOf("whitty") == 0)
			portraitLeft.setGraphicSize(Std.int((portraitLeft.width * PlayState.daPixelZoom * 0.9) / 6)); // Restored portraits are 6x bigger
		else
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible=false;
	}
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic('assets/music/Lunchbox' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic('assets/music/LunchboxScary' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);
		UpdatePortrait("dad");
		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPortrait.png', 'assets/images/weeb/bfPortrait.xml');
		portraitRight.animation.addByPrefix('enter', 'Portrait Enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		box = new FlxSprite(-20, 45);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-pixel.png',
					'assets/images/weeb/pixelUI/dialogueBox-pixel.xml');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				FlxG.sound.play('assets/sounds/ANGRY_TEXT_BOX' + TitleState.soundExt);

				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-senpaiMad.png',
					'assets/images/weeb/pixelUI/dialogueBox-senpaiMad.xml');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-evil.png', 'assets/images/weeb/pixelUI/dialogueBox-evil.xml');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			default:
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/dialogueBox-lazy.png',
					'assets/images/weeb/pixelUI/dialogueBox-pixel.xml');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
		}

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic('assets/images/weeb/pixelUI/hand_textbox.png');
		add(handSelect);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		if(PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
			dropText.color = 0x052A5155;
		else
			dropText.color = 0x13595980;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		if(PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
			swagDialogue.color = 0xFFFCFCFC;
		else
			swagDialogue.color = 0xFFFFFF;
		swagDialogue.sounds = [FlxG.sound.load('assets/sounds/pixelText' + TitleState.soundExt, 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);

		this.dialogueList = dialogueList;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			//portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				// box.animation.play('normal');
				// Fuck issuing.
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	public var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		// 
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		UpdatePortrait(curCharacter);
		if(curCharacter.indexOf("qbby") == 0 || // Nintendo characters have specific fonts, so I decided to put them in the 3DS UI font.
		    curCharacter.indexOf("jobski") == 0){
			dropText.font = 'FOT-RodinBokutoh Pro DB';
			swagDialogue.font = 'FOT-RodinBokutoh Pro DB';
		}else{
			dropText.font = 'Pixel Arial 11 Bold';
			swagDialogue.font = 'Pixel Arial 11 Bold';
		}
		portraitLeft.visible = true;
		portraitLeft.animation.play('enter');
		// switch (curCharacter)
		// {
		// 	case 'dad':
		// 		portraitRight.visible = false;
		// 		if (!portraitLeft.visible)
		//		{
		// 			portraitLeft.visible = true;
		// 			portraitLeft.animation.play('enter');
		// 		}
		// 	case 'bf':
		// 		portraitLeft.visible = false;
		// 		if (!portraitRight.visible)
		// 		{
		// 			portraitRight.visible = true;
		// 			portraitRight.animation.play('enter');
		// 		}
		// }
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
