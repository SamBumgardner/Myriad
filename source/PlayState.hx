package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledObject;

class PlayState extends FlxState
{
	private var _level:TiledMap;

	private var _levelArr:Array<Int>;

	private var _player:FlxSprite;


	override public function create():Void
	{
		_level = new TiledMap(AssetPaths.level__tmx);
		_levelArr = cast(_level.getLayer("floor"), TiledTileLayer).tileArray;
		_player = new Player();

		var tmpLayer:TiledObjectLayer = cast _level.getLayer("entities");
		for (e in tmpLayer.objects)
		{
			placeEntities(e);
		}

		add(_player);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function placeEntities(e:TiledObject)
	{
		var x:Int = Std.parseInt(e.xmlData.x.get("x"));
		var y:Int = Std.parseInt(e.xmlData.x.get("y"));

		if (e.name == "player")
		{
			_player.x = x;
			_player.y = y;
		}
	}
}
