package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Top10BestScreens extends MusicBeatState
{
  //i love cum
  var bgcum:FlxSprite;
  var text:FlxSprite;
  override function create()
  {
    super.create();
    
    bgcum = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
    bgcum.screenCenter(XY);
    
    // coisas mt xd
    text = new FlxSprite().loadGraphic(Paths.image('text'));
    text.screenCenter(XY);
    
    add(bgcum);
    add(text);
  }
  override function update(elapsed:Float)
  {
    if (controls.ACCEPT) 
    {
      FlxG.sound.play(Paths.sound('confirmManu'));
      FlxFlicker.flicker(text, 1, 0.1, false, true);
      
      FlxTimer().start(0.90, function(tmr:FlxTimer)
      {
        MusicBeatState.switchState(new TitleState());
      });
    }
    super.update(elapsed);
  }
}
