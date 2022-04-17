package;

#if desktop
import Discord.DiscordClient;
#end
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		/*#if ACHIEVEMENTS_ALLOWED 'awards', #end*/
		'credits',
		#if !switch 'youtube', #end
		'options'
	];

	var curioso:FlxSprite;
	var menubg:FlxSprite;
	var bfmenu:FlxSprite;
	var thomasmenu:FlxSprite;
	var thomasfrango:FlxSprite;
	var gatomenu:FlxSprite;
	
	var bluefundo:FlxSprite;
	var bluestuff:FlxSprite;
	
	var bg:FlxSprite;
	var bg2:FlxSprite;
	var magenta:FlxSprite;
	var brilhomenu:FlxSprite;
	
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var curmenuchar:Int;
	var switchMC:Bool = true;
	var spinvalue:Float = 0;
	
	var easterEggEnabled:Bool = true; // Tira se vc não quiser musicas secretas :(
	var uselessKeyCombination:Array<FlxKey> = [FlxKey.G, FlxKey.R, FlxKey.O, FlxKey.U, FlxKey.P]; // grupito :D
	var drunkKeyCombination:Array<FlxKey> = [FlxKey.D, FlxKey.R, FlxKey.U, FlxKey.N, FlxKey.K]; // cachaça :Fearful:
	var catKeyCombination:Array<FlxKey> = [FlxKey.G, FlxKey.A, FlxKey.T, FlxKey.O, FlxKey.S]; // O MAIOR SEGREDO >:]
	var lastKeysPressed:Array<FlxKey> = [];
	//var lastKeysPressed2:Array<FlxKey> = [];
	
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		
		bg = new FlxSprite(-200, -750).loadGraphic(Paths.image('huecat/bolarodante'));
		bg.scrollFactor.set(0, yScroll);
		//bg.angle = spinvalue;
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-200, -750).loadGraphic(Paths.image('huecat/bolarodantecinza'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.updateHitbox();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFF7f22e3;
		add(magenta);
		// magenta.scrollFactor.set();
		
		brilhomenu = new FlxSprite(-80).loadGraphic(Paths.image('huecat/brilholol'));
		brilhomenu.scrollFactor.set();
		brilhomenu.updateHitbox();
		brilhomenu.screenCenter();
		brilhomenu.antialiasing = ClientPrefs.globalAntialiasing;
		add(brilhomenu);
		
		/*bluefundo = new FlxSprite(500, 0).loadGraphic(Paths.image('huecat/bluefundo'));
		bluefundo.antialiasing = ClientPrefs.globalAntialiasing;
		bluefundo.scrollFactor.set();
		bluefundo.updateHitbox();
		add(bluefundo);*/
		//não usa essa merda aqui era só um placeholder tabom :thumbsup:
		
		bfmenu = new FlxSprite(750, 800);
		bfmenu.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
		bfmenu.antialiasing = ClientPrefs.globalAntialiasing;
		bfmenu.scrollFactor.set();
		bfmenu.animation.addByPrefix('idle', 'BF idle dance', 24);
		bfmenu.animation.addByPrefix('hey', 'BF HEY', 18);
		bfmenu.animation.addByPrefix('sing-1', 'BF NOTE LEFT0', 24);
		bfmenu.animation.addByPrefix('sing-2', 'BF NOTE DOWN0', 24);
		bfmenu.animation.addByPrefix('sing-3', 'BF NOTE UP0', 24);
		bfmenu.animation.addByPrefix('sing-4', 'BF NOTE RIGHT0', 24);
		bfmenu.animation.play('idle');
		bfmenu.updateHitbox();
		bfmenu.visible = false;
		add(bfmenu);
		
		thomasmenu = new FlxSprite(600, 1030);
		thomasmenu.frames = Paths.getSparrowAtlas('huecat/menuchar/thomasmenu');
		thomasmenu.antialiasing = ClientPrefs.globalAntialiasing;
		thomasmenu.scrollFactor.set();
		thomasmenu.animation.addByPrefix('idle', 'thomasmenu', 24);
		thomasmenu.animation.addByPrefix('hey', 'thomasmenu', 24);
		thomasmenu.animation.play('idle');
		thomasmenu.updateHitbox();
		thomasmenu.visible = false;
		add(thomasmenu);
		
		thomasfrango = new FlxSprite(620, 240);
		thomasfrango.frames = Paths.getSparrowAtlas('huecat/menuchar/thomasfrango');
		thomasfrango.antialiasing = ClientPrefs.globalAntialiasing;
		thomasfrango.scrollFactor.set();
		thomasfrango.animation.addByPrefix('idle', 'thomasfrango', 24);
		thomasfrango.animation.addByPrefix('hey', 'thomasfrango', 24);
		thomasfrango.animation.play('idle');
		thomasfrango.updateHitbox();
		thomasfrango.visible = false;
		add(thomasfrango);
		
		gatomenu = new FlxSprite(630, 307);
		gatomenu.frames = Paths.getSparrowAtlas('huecat/menuchar/gatomenu');
		gatomenu.antialiasing = ClientPrefs.globalAntialiasing;
		gatomenu.scrollFactor.set();
		gatomenu.animation.addByPrefix('idle', 'gatomenu', 24);
		gatomenu.animation.addByPrefix('hey', 'gatomenu', 24);
		gatomenu.animation.play('idle');
		gatomenu.updateHitbox();
		gatomenu.visible = false;
		add(gatomenu);
		
		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
			curmenuchar = FlxG.random.int( 0, 2);
			FlxTween.tween(thomasmenu, {y: 240}, 3, {ease: FlxEase.expoOut});
			FlxTween.tween(bfmenu, {y: 390}, 3, {ease: FlxEase.expoOut});
		});

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		curioso = new FlxSprite(-198, -118).loadGraphic(Paths.image('huecat/bobscreen'));
		curioso.scrollFactor.set();
		curioso.updateHitbox();
		curioso.antialiasing = ClientPrefs.globalAntialiasing;
		curioso.visible = false;
		add(curioso);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.scale.set(0.85, 0.85);
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItem.x += 50;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "NNM Engine (PE " + psychEngineVersion + ")", 12);
		versionShit.scrollFactor.set();
		/*var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();*/
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Não abra o .txt na pasta do mod, não é nada :)", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}
	
	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('huecat/confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	
	override function beatHit()
	{
		super.beatHit();
		//FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	override function update(elapsed:Float)
	{
		var spinSpeed:Float = 24;
	
		//descobri como fazer o fundo rodar pra sempre AEEEEEEE
		if(bg.angle == 0 || magenta.angle == 0)
			{
				FlxTween.tween(bg, {angle: 360}, spinSpeed, {
					onComplete: function(twn:FlxTween)
					{
						bg.angle = 0;
					}
				});
				
				FlxTween.tween(magenta, {angle: 360}, spinSpeed, {
					onComplete: function(twn:FlxTween)
					{
						magenta.angle = 0;
					}
				});
			}
			
	
		function shakescreen()
		{
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				Lib.application.window.move(Lib.application.window.x + FlxG.random.int( -10, 10),Lib.application.window.y + FlxG.random.int( -8, 8));
			}, 50);
		}
		
		function barulhao()
		{
			FlxG.sound.play(Paths.sound('huecat/peidao'));
		}
		
		function zoiogarai()
		{
			curioso.visible = true;
			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
			curioso.visible = false;
			});
		}
		
		function jumpscare()
		{
			shakescreen();
			barulhao();
			zoiogarai();
		}
		
		if(easterEggEnabled)
			{
				var finalKey:FlxKey = FlxG.keys.firstJustPressed();
				if(finalKey != FlxKey.NONE) {
					lastKeysPressed.push(finalKey); //Convert int to FlxKey
					if(lastKeysPressed.length > uselessKeyCombination.length)
					{
						lastKeysPressed.shift();
					} else if (lastKeysPressed.length > drunkKeyCombination.length)
					{
						lastKeysPressed.shift();
					} else if (lastKeysPressed.length > catKeyCombination.length)
					{
						lastKeysPressed.shift();
					}
					
					if(lastKeysPressed.length == uselessKeyCombination.length)
					{
						var isDifferent:Bool = false;
						for (i in 0...lastKeysPressed.length) {
							if(lastKeysPressed[i] != uselessKeyCombination[i]) {
								isDifferent = true;
								break;
							}
						}

						if(!isDifferent) { //COLOCA AQUI OQ ACONTECE QUANDO TU ACERTA UAU
							if (!PreloadState.unlockedSongs[0])
							{
								FlxG.camera.flash(FlxColor.WHITE, 1.4);
								FlxG.sound.music.volume = 0;
								FlxG.sound.play(Paths.sound('huecat/confirmMenu'));
								selectedSomethin = true;
								new FlxTimer().start(0.8, function(tmr:FlxTimer) {
									PlayState.SONG = Song.loadFromJson('useless/Useless');
									PlayState.isStoryMode = false;
									PlayState.storyDifficulty = 0;
									LoadingState.loadAndSwitchState(new PlayState());
								});
							} else {
								FlxG.sound.play(Paths.sound('huecat/deniedMOMENT'));
								camera.shake(0.01, 0.1);
							}
						}
					}
					
					if(lastKeysPressed.length == drunkKeyCombination.length)
					{
						var isDifferent:Bool = false;
						for (i in 0...lastKeysPressed.length) {
							if(lastKeysPressed[i] != drunkKeyCombination[i]) {
								isDifferent = true;
								break;
							}
						}

						if(!isDifferent) { //COLOCA AQUI OQ ACONTECE QUANDO TU ACERTA UAU
							if (!PreloadState.unlockedSongs[1]) {
								FlxG.camera.flash(FlxColor.WHITE, 1.4);
								FlxG.sound.music.volume = 0;
								FlxG.sound.play(Paths.sound('huecat/confirmMenu'));
								selectedSomethin = true;
								new FlxTimer().start(0.8, function(tmr:FlxTimer) {
									PlayState.SONG = Song.loadFromJson('drunk/Drunk');
									PlayState.isStoryMode = false;
									PlayState.storyDifficulty = 0;
									LoadingState.loadAndSwitchState(new PlayState());
							});
							} else {
								FlxG.sound.play(Paths.sound('huecat/deniedMOMENT'));
								camera.shake(0.01, 0.1);
								//Sys.command('echo ja ta desbloqueado doido');
							}
						}
					}
					
					if(lastKeysPressed.length == catKeyCombination.length)
					{
						var isDifferent:Bool = false;
						for (i in 0...lastKeysPressed.length) {
							if(lastKeysPressed[i] != catKeyCombination[i]) {
								isDifferent = true;
								break;
							}
						}

						if(!isDifferent) { //COLOCA AQUI OQ ACONTECE QUANDO TU ACERTA UAU
							if (switchMC) {
								FlxG.camera.flash(FlxColor.WHITE, 1.4);
								FlxG.sound.play(Paths.sound('huecat/confirmMenu'));
								curmenuchar = 69;
								switchMC = false;
							}
						}
					}
				}
			}
			
		/*
		listinha de personagem
		
		bf
		hu3cat
		hu3cat frango frito
		hu3cat live action (SECRETO)
		carlinhos
		papai noel
		amiga online do hu3cat
		irmãs do hu3cat
		coelho
		
		*/
		
		//personagens do menu AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		if (curmenuchar == 0) {
			bfmenu.visible = true;
		} else {
			bfmenu.visible = false;
		}
		
		if (curmenuchar == 1) {
			thomasmenu.visible = true;
		} else {
			thomasmenu.visible = false;
		}
		
		if (curmenuchar == 2) {
			thomasfrango.visible = true;
		} else {
			thomasfrango.visible = false;
		}
		
		if (curmenuchar == 69) {
			gatomenu.visible = true;
		} else {
			gatomenu.visible = false;
		}
		
		
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			
			if(bfmenu.visible)
			{
				if (FlxG.keys.justPressed.I)
				{
					FlxG.sound.play(Paths.sound('huecat/bfMenu/beep-' + FlxG.random.int( 1, 4)));
					bfmenu.animation.play('sing-' + FlxG.random.int( 1, 4));
					switch(bfmenu.animation.curAnim.name)
						{
							case 'sing-1': //LEFT
								bfmenu.offset.x = 5;
								bfmenu.offset.y = -6;
				
							case 'sing-2': //DOWN
								bfmenu.offset.x = -10;
								bfmenu.offset.y = -50;
				
							case 'sing-3': //UP
								bfmenu.offset.x = -29;
								bfmenu.offset.y = 27;
				
							case 'sing-4': //RIGHT
								bfmenu.offset.x = -48;
								bfmenu.offset.y = -7;
						}
					
					if(bfmenu.animation.curAnim.name != 'hey')
					{
						new FlxTimer().start(0.3, function(tmr:FlxTimer) {
							bfmenu.animation.play('idle');
							bfmenu.offset.x = 0;
							bfmenu.offset.y = 0;
						});
					}
				}
			}
		
		
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('huecat/scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('huecat/scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('huecat/cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'youtube')
				{
					CoolUtil.browserLoad('https://www.youtube.com/hu3cat');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('huecat/confirmMenu'));
					if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.WHITE, 0.7);
					bfmenu.animation.play('hey');
					bfmenu.offset.x = -3;
					bfmenu.offset.y = 5;
					
					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(FlxG.camera, {zoom: 5}, 1.8, {ease: FlxEase.expoIn});
							FlxTween.tween(bfmenu, {x: 2500}, 1.8, {ease: FlxEase.expoIn});
							FlxTween.tween(thomasmenu, {x: 2500}, 1.8, {ease: FlxEase.expoIn});
							FlxTween.tween(thomasfrango, {x: 2500}, 1.8, {ease: FlxEase.expoIn});
							FlxTween.tween(gatomenu, {x: 2500}, 1.8, {ease: FlxEase.expoIn});
							FlxTween.tween(spr, {x: -1300}, 0.6, {
								ease: FlxEase.expoIn,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
							/*
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
							*/
						}
						else
						{
							//FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							FlxTween.tween(spr, {x: spr.x - -100}, 0.4, {
								ease: FlxEase.expoOut,
								onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(spr, {alpha: 0}, 0.6, {
										ease: FlxEase.expoIn,
										onComplete: function(twn:FlxTween)
										{
											var daChoice:String = optionShit[curSelected];
											switch (daChoice)
											{
												case 'story_mode':
													MusicBeatState.switchState(new StoryMenuState());
												case 'freeplay':
													MusicBeatState.switchState(new FreeplayChoiceState());
												case 'credits':
													MusicBeatState.switchState(new CreditsState());
												case 'options':
													MusicBeatState.switchState(new options.OptionsState());
											}
										}
									});
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.offset.y = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				spr.offset.x = 0.15 * (spr.frameWidth / 2 + 20);
				spr.offset.y = 0.15 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
}