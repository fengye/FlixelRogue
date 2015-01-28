package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;

class Player extends FlxSprite
{
	public var _speed:Float = 100;
	private var _mapIndex = new IntPoint(0, 0);
	private var _lastMapIndex = new IntPoint(0, 0);
	private var _moved = false;

	public function new(x:Float=0, y:Float=0)
	{
		super(x, y);

		loadGraphic(AssetPaths.spaceman__png, true, 8, 8);
		this.scale.set(2, 2);
		this.setSize(14,14);
		this.offset.set(-3,-3);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("walk", [0, 1, 2, 3], 6, false);

		this.drag.x = this.drag.y = 1600;

		FlxG.watch.add(this, "x");
		FlxG.watch.add(this, "y");
		FlxG.watch.add(this, "_mapIndex");
	}

	private function movement():Void
	{
		var ix:Int = Std.int(x / 16 + 0.5);
		var iy:Int = Std.int(y / 16 + 0.5);

		if (ix != _mapIndex.x ||
			iy != _mapIndex.y)
		{
			_lastMapIndex = _mapIndex;
			_moved = true;
		}
		else
		{
			_moved = false;
		}

		_mapIndex.x = ix;
		_mapIndex.y = iy;

		var left:Bool = FlxG.keys.anyPressed(["LEFT", "A"]);
		var right:Bool = FlxG.keys.anyPressed(["RIGHT", "D"]);
		var up:Bool = FlxG.keys.anyPressed(["UP", "W"]);
		var down:Bool = FlxG.keys.anyPressed(["DOWN", "S"]);

		
		FlxG.watch.addQuick("left", left);

		if (left && right)
		{
			left = right = false;
		}
		if (up && down)
		{
			up = down = false;
		}

		if (left || right || up || down)
		{
			var angle:Float = 0;

			if (left)
			{
				angle = -180;

				if (up)
				{
					angle = -135;
				}
				if (down)
				{
					angle = -225;
				}

				facing = FlxObject.LEFT;
			}
			else
			if (right)
			{
				angle = 0;

				if (up)
				{
					angle = -45;
				}
				if (down)
				{
					angle = 45;
				}

				facing = FlxObject.RIGHT;
			}
			else if(up)
			{
				angle = -90;
				facing = FlxObject.UP;
			}
			else if (down)
			{
				angle = 90;
				facing = FlxObject.DOWN;
			}

			FlxAngle.rotatePoint( _speed, 0, 0, 0, angle, velocity);
		}

		

	}

	override public function update():Void
	{
		movement();
		super.update();
	}

	override public function draw():Void
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
			animation.play("walk");
		}
		super.draw();
	}

	public function getMapIndex():IntPoint
	{
		if (_moved)
			return _mapIndex;
		else
			return null;
	}

	public function isMoved():Bool
	{
		return _moved;
	}

	public function getPlayerMapIndex():IntPoint
	{
		return _mapIndex;
	}

	private function clamp(v:Int, min:Int, max:Int):Int
	{
		if (v < min)
		{
			v = min;
		}
		if (v > max)
		{
			v = max;
		}
		return v;
	}

	public function getOccupation(width:Int, height:Int):Array<IntPoint>
	{
		var rightBound = clamp(_mapIndex.x + 2, 0, width);
		var upBound = clamp(_mapIndex.y - 2, 0, height);
		var downBound = clamp(_mapIndex.y + 2, 0, height);
		var leftBound = clamp(_mapIndex.x - 2, 0, width);

		var result:Array<IntPoint> = [];

		for(i in leftBound...rightBound+1)
		{
			for(j in upBound...downBound+1)
			{
				result.push(new IntPoint(i, j));
			}
		}

		return result;
	}
}