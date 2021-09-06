package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import polymod.format.ParseRules.TargetSignatureElement;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var Category6key:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;
	public var openHold:FlxSprite;
	public var cOpenHold:Bool = false;
	public var previousHeld:Bool = false;
	public var isSustainHold:Bool = false;
	private var ig:Bool = false;
	private var pixel:Bool = false;
	public static var IsPrecision:Bool = false;
	
	public static var AllNoteTickets:Array<FlxTimer> = [];
	public static var swagWidth:Float = 160 * 0.7;
	public static var ogSwagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var OPEN_NOTE:Int = 4;
	public var m:Bool = false;
	public var ii:Bool = false;
	public var LastWasDark:Bool = false;
	public var IsDark:Bool = false;
	public var RewindOnMiss:Bool = false;
	override function kill(){
		for(i in MultispriteBuffs){
			i.kill();
		}
		MultispriteBuffs=[];
		if(RewindOnMiss && (tooLate || !wasGoodHit) && mustPress)
			PlayState.rewind(5);
		active = visible = false;
		//super.kill();
	}
	public var MultispriteBuffs:Array<FlxSprite> = [];
	public var actor:Int = 0;
	/* 6-fret
	*** duplicate left and right
	*** strumline notes, place in middle
	***** apply color matrix to modify l2 and r2 to be yellow and blue
	******* (saves space on unnecessary atlas frames)
	*** l2 and r1 offset down and r2 by 2 notes
	*** attribute "6fret" for songs with 6fret enabledPlugin
	*/
	// The control code for 6fret is the equivalent of a floppy drive twist that accomplishes nothing but make you sad.
	public function initOpenHold()
	{
		openHold = new FlxSprite(0, 0);
		openHold.frames = frames;
		openHold.animation.addByPrefix('openhold', 'open hold piece');
		openHold.animation.play('openhold');
		openHold.alpha = 0.6;
		openHold.scrollFactor.set();
	   /* Amount of times I have failed to fix open hold or get open hold accurate: 38
		*  This thing is so stubborn when it comes to scale:
		* Target width: 244.5px
		* Result: <Globals.num_Yes>px
		*/
		openHold.scale.x *= 0.69; // please work im begging you
		openHold.scale.y *= 2;
		openHold.antialiasing = true;
	}
	public function new(strumTime:Float, noteData:Int, category:Int = 0, ?prevNote:Note, ?sustainNote:Bool = false, ?ingame:Bool = true, ?RewindNote:Bool = false, ?actorVal:Int = 0)
	{
		Category6key = category;
		actor = actorVal;
		RewindOnMiss = RewindNote;
		ig = ingame;
		if(!PlayState.sixfret)
			noteData %= 5;
		if(noteData == 4){
			RewindOnMiss = false;
			Category6key = 0;
		}
		noteData += category * 5;
		if(PlayState.ninefret && ingame)
			swagWidth = 160 * 0.3;
		else if(PlayState.sixfret && ingame)
			swagWidth = 160 * 0.55;
		else
			swagWidth = 160 * 0.7;
		if(Highscore.Dynamix.get("prec") != null)
			IsPrecision = Highscore.Dynamix.get("prec");
		super();
		IsDark = FlxG.random.bool(0.0001); // 1 in a million
		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		
		if((prevNote.openHold != null || prevNote.previousHeld) && noteData == 4)
			this.previousHeld = true;
		if(prevNote.IsDark)
			LastWasDark = true;
		if(prevNote.animation.curAnim != null)
		{
			if(prevNote.animation.curAnim.name.substr(-3) == "end")
				LastWasDark = false;
		}

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				pixel = true;
				loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);

				animation.add('greenScroll', [8]);
				animation.add('redScroll', [9]);
				animation.add('blueScroll', [7]);
				animation.add('purpleScroll', [6]);
				animation.add('rebScroll', [11]);
				animation.add('purplbScroll', [10]);
				
				animation.add('greenScroll-R', [36]);
				animation.add('redScroll-R', [37]);
				animation.add('blueScroll-R', [35]);
				animation.add('purpleScroll-R', [34]); // wtf
				animation.add('rebScroll-R', [39]);
				animation.add('purplbScroll-R', [38]);
				for(i in 1...5) // short
					animation.add('openScroll$i', [i+28]);

				if (isSustainNote)
				{
					loadGraphic('assets/images/weeb/pixelUI/arrowEnds.png', true, 7, 6);

					animation.add('purpleholdend', [6]);
					animation.add('greenholdend', [8]);
					animation.add('redholdend', [9]);
					animation.add('rebholdend', [11]);
					animation.add('purplbholdend', [10]);
					animation.add('blueholdend', [7]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('rebhold', [5]);
					animation.add('purplbhold', [4]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				if(isSustainNote)
				{
					// trace(IsDark, LastWasDark);
					if(IsDark && !LastWasDark)
						IsDark = false;
					else if(!IsDark && LastWasDark)
						IsDark = true;
					IsDark = IsDark || LastWasDark;
				}
				frames = FlxAtlasFrames.fromSparrow(
				PlayState.ninefret && noteData != 4 ? 
				'assets/images/jic/NOTE_assets.png' :
				PlayState.ninefret && noteData == 4 ? 
				'assets/images/NOTE_assets.png' :
				(IsDark || LastWasDark) ?
				'assets/images/dark.png' :
				IsPrecision ? 
				'assets/images/precision.png' :
				'assets/images/NOTE_assets.png',
				PlayState.ninefret && noteData != 4 ? 
				'assets/images/jic/NOTE_assets.xml' : 
				'assets/images/NOTE_assets.xml'
				);
				
				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				animation.addByPrefix('darkScroll', 'white0');
				animation.addByPrefix('blbScroll', 'violet0');
				animation.addByPrefix('grbScroll', 'black0');
				animation.addByPrefix('rebScroll', 'redB0');
				animation.addByPrefix('greenScroll-R', 'green rew0');
				animation.addByPrefix('redScroll-R', 'red rew0');
				animation.addByPrefix('blueScroll-R', 'blue rew0');
				animation.addByPrefix('purpleScroll-R', 'purple rew0');
				animation.addByPrefix('darkScroll-R', 'white rew0');
				animation.addByPrefix('blbScroll-R', 'violet rew0');
				animation.addByPrefix('grbScroll-R', 'black rew0');
				animation.addByPrefix('purplbScroll', 'purpleB0');
				animation.addByPrefix('purplbScroll-R', 'purpleB rew0');
				animation.addByPrefix('rebScroll-R', 'redB rew0');
				animation.addByPrefix('openScroll', 'open0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
				animation.addByPrefix('darkholdend', 'white hold end');
				animation.addByPrefix('rebholdend', 'redb hold end');
				animation.addByPrefix('blbholdend', 'violet hold end');
				animation.addByPrefix('grbholdend', 'black hold end');
				animation.addByPrefix('purplbholdend', 'purpleb hold end');
				animation.addByPrefix('openholdend', 'open end hold');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				animation.addByPrefix('darkhold', 'white hold piece');
				animation.addByPrefix('purplbhold', 'purpleb hold piece');
				animation.addByPrefix('blbhold', 'violet hold piece');
				animation.addByPrefix('grbhold', 'black hold piece');
				animation.addByPrefix('rebhold', 'redb hold piece');
				animation.addByPrefix('openhold', 'open hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
		}
		var help = ['purple','blue','green','red','open','dark','purplb','blb','grb','dieinafireyoustupidfuckingidiotstopmessingwiththecodenow','reb'][noteData];
		var sf = PlayState.sixfret;
		var ReFlag:String = RewindOnMiss ? "-R" : "";
		if(PlayState.ninefret && noteData != 4){
			animation.play('${help}Scroll$ReFlag');
			x += swagWidth * (noteData - category);
		}
		else
			switch (noteData)
			{
				case 0:
					animation.play('purpleScroll$ReFlag');
				case 1:
					x += swagWidth * 1;
					animation.play(sf ? 'greenScroll$ReFlag' : 'blueScroll$ReFlag');
				case 2:
					x += swagWidth * 2;
					animation.play(sf ? 'redScroll$ReFlag' : 'greenScroll$ReFlag');
				case 3:
					x += swagWidth * 3;
					animation.play(sf ? 'purplbScroll$ReFlag' : 'redScroll$ReFlag');
					//trace('Y7HUIJKM,');
				case 4:
					x += swagWidth * (sf ? 0.75 : 0.25);
					animation.play(pixel ? 'openScroll1' : 'openScroll');
					if(pixel){
						var w:Float = x;
						for(i in 2...5){
							w += swagWidth;
							var spr:FlxSprite = new FlxSprite(w, y);
							spr.animation = animation;
							spr.animation.play('openScroll$i');
							spr.cameras = [camera];
							MultispriteBuffs.push(spr);
						}
					}
					if(!pixel && isSustainNote && openHold == null && !prevNote.previousHeld){
						if(prevNote != null){
							if(prevNote.openHold == null) // very conditional, talk to distay
								initOpenHold();
						} else // no previous note
							initOpenHold();
					}
				case 5:
					x += swagWidth * 4;
					animation.play('blueScroll$ReFlag');
				case 6:
					x += swagWidth * 5;
					animation.play('rebScroll$ReFlag');
			}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			ii = true;
			flipY = PlayState.downscroll;
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;
			if(PlayState.ninefret && noteData != 4)
				animation.play('${help}holdend');
			else
				switch (noteData)
				{
					case 2:
						animation.play(sf ? 'redholdend' : 'greenholdend');
					case 3:
						animation.play(sf ? 'purplbholdend' : 'redholdend');
					case 1:
						animation.play(sf ? 'greenholdend' : 'blueholdend');
					case 0:
						animation.play('purpleholdend');
					case 4:
						previousHeld = false;
						x += swagWidth * 1.25;
						if(pixel)
							animation.play('purpleholdend');
						else
							animation.play('openholdend');
					case 5:
						animation.play('blueholdend');
					case 6:
						animation.play('rebholdend');
				}
			isSustainHold = true;
			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;
			if (prevNote.isSustainNote)
			{
				// ii = true;
				if(PlayState.ninefret && noteData != 4)
					animation.play('${help}hold');
				else
					switch (prevNote.noteData)
					{
						case 0:
							prevNote.animation.play('purplehold');
						case 1:
							prevNote.animation.play(sf ? 'greenhold' : 'bluehold');
						case 2:
							prevNote.animation.play(sf ? 'redhold' : 'greenhold');
						case 3:
							prevNote.animation.play(sf ? 'purplbhold' : 'redhold');
						case 4:
							previousHeld = true;
							if(pixel) // placeholder
								prevNote.animation.play('purplehold');
							else
								prevNote.animation.play('openhold');
						case 5:
							prevNote.animation.play('bluehold');
						case 6:
							prevNote.animation.play('rebhold');
					}
				prevNote.isSustainHold = true;
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}
	public function KillMe() {
		if(mustPress && ig) {
			//trace('fix', strumTime / 1000);
			PlayState.enqueue(noteData, strumTime / 1000);
		}
		active = false;
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(openHold != null){
			openHold.y = y - 96;
		}
		if(PlayState.ninefret && !m && ig && !pixel){
			if(noteData != 4) setGraphicSize(Std.int(width * (0.55 / 0.7)));
			x -= 14;
			m = true;
		}
		if(MultispriteBuffs.length > 0){
			var osX:Float = x;
			for(i in 0...MultispriteBuffs.length){
				osX += swagWidth;
				MultispriteBuffs[i].x = osX;
				MultispriteBuffs[i].y = y;
			}
		}
		if (mustPress)
		{
			// The * 0.5 us so that its easier to hit them too late, instead of too early
			
			if(strumTime <= Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
			{
				if(PlayState.bot && PlayState.botType == 0 && ig)
				{
					PlayState.enqueue(noteData);
				}
				if(!ii)
				{
					// trace('what the fuck are you doing');
					AllNoteTickets.push(new FlxTimer().start((Conductor.safeZoneOffset * 0.5) / 1000, // this is a stupid way of doing this
					function(tmr:FlxTimer){
						AllNoteTickets.pop();
						PlayState.NPS++;
						AllNoteTickets.push(new FlxTimer().start(1,
						function(tmr:FlxTimer){
							PlayState.NPS--;
							AllNoteTickets.pop();
						}));
					}));
					ii = true;
				}
			}
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
			{
				canBeHit = true;
			}
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				wasGoodHit = true;
			}
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
