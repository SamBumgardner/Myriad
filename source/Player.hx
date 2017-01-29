package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	// PROPERTIES //

	/**
	 * speed:
	 *
	 * Scalar factor for how many pixels position should be
	 * updated by.
	 */
	public var speed:Float = 4;

	/**
	 * _isMoving:
	 *
	 * Used in conditionals relating to the player's current
	 * movement status.
	 */
	private var _isMoving:Bool;

	/**
	 * (_up|_down|_left|_rght)Priority
	 *
	 * Counters incremented so long as the cooresponding key
	 * is held. Used in determining which direction the player
	 * should step in case of multiple key presses.
	 */
	private var _upPriority:Int   = 0;
	private var _downPriority:Int = 0;
	private var _leftPriority:Int = 0;
	private var _rghtPriority:Int = 0;

	/**
	 * _movementQ:
	 *
	 * If another direction is requested while the player is
	 * still moving, it is added to the queue to be handled after
	 * the current move is complete.
	 */
	private var _movementQ:Array<UInt> = new Array<UInt>();

	/**
	 * _framesLeftUntilPoll
	 *
	 * ...
	 */
	 private var _framesLeftUntilPoll:Int;


	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);

		makeGraphic(32, 32, FlxColor.BLUE);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		movement();
	}


	// MOVEMENT //

	private function movement():Void
	{
		var up:Bool   = FlxG.keys.anyPressed([UP, W]);
		var down:Bool = FlxG.keys.anyPressed([DOWN, S]);
		var left:Bool = FlxG.keys.anyPressed([LEFT, A]);
		var rght:Bool = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
		{
			up = down = false;
		}

		if (left && rght)
		{
			left = rght = false;
		}

		updatePriorities(up, down, left, rght);

		if (up)
		{
			if (left)
			{
				if (_upPriority > _leftPriority)
				{
					pollMovement(FlxObject.LEFT);
				}
			}

			if (rght)
			{
				if (_upPriority > _rghtPriority)
				{
					pollMovement(FlxObject.RIGHT);
				}
			}

			pollMovement(FlxObject.UP);
		}
		else if (down)
		{
			if (left)
			{
				if (_downPriority > _leftPriority)
				{
					pollMovement(FlxObject.LEFT);
				}
			}

			if (rght)
			{
				if (_downPriority > _rghtPriority)
				{
					pollMovement(FlxObject.RIGHT);
				}
			}

			pollMovement(FlxObject.DOWN);
		}
		else if (left)
		{
			pollMovement(FlxObject.LEFT);
		}
		else if (rght)
		{
			pollMovement(FlxObject.RIGHT);
		}

		if (_isMoving)
		{
			switch (facing) {
				case FlxObject.UP:
					y -= speed;

				case FlxObject.DOWN:
					y += speed;

				case FlxObject.LEFT:
					x -= speed;

				case FlxObject.RIGHT:
					x += speed;
			}
		}

		if (inTile())
		{
			if (_movementQ.length == 0)
			{
				_isMoving = false;
			}

			facing = _movementQ[1];
			_movementQ = _movementQ.splice(1, _movementQ.length - 1);
		}
	}

	private function updatePriorities(up, down, left, rght):Void
	{
		_upPriority   = up   ? _upPriority   + 1 : 0;
		_downPriority = down ? _downPriority + 1 : 0;
		_leftPriority = left ? _leftPriority + 1 : 0;
		_rghtPriority = rght ? _rghtPriority + 1 : 0;
	}

	private function pollMovement(candidateDirection:UInt):Void
	{
		if (!_isMoving)
		{
			_isMoving = true;
			facing = candidateDirection;
		}

		if (_framesLeftUntilPoll == 0)
		{
			_movementQ.push(candidateDirection);

			_framesLeftUntilPoll = 4;
		}
		else if (_framesLeftUntilPoll > 0)
		{
			_framesLeftUntilPoll -= 1;
		}
	}

	private function inTile():Bool
	{
		return (x % 32 == 0) && (y % 32 == 0);
	}
}