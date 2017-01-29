package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	private var _btnPlay:FlxButton;

	override public function create():Void
	{
		_btnPlay = new FlxButton(0, 0, "Play", btnPlayCallback);
		_btnPlay.screenCenter();
		add(_btnPlay);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function btnPlayCallback():Void
	{
		FlxG.switchState(new PlayState());
	}
}
