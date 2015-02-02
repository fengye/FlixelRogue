package;

import flixel.util.*;
import flixel.tweens.motion.*;
import flixel.tweens.*

class LinearPathEx extends LinearPath
{
	static var UP:FlxVector = new FlxVector(0, -1);
	static var DOWN:FlxVector = new FlxVector(0, 1);
	static var LEFT:FlxVector = new FlxVector(-1, 0);
	static var RIGHT:FlxVector = new FlxVector(1, 0);

	public function getCurrentPoint():FlxPoint
	{
		return points[_index];
	}

	public function getNextPoint():FlxPoint
	{
		if (backward)
		{
			var idx = _index-1;
			if (idx < 0)
				idx = 0;

			return points[idx];
		}
		else
		{
			var idx = _index+1;
			if (idx > points.length)
				idx = points.length;

			return points[idx];
		}
	}

	public function getPrevPoint():FlxPoint
	{
		if (backward)
		{
			var idx = _index+1;
			if (idx > points.length)
				idx = points.length;

			return points[idx];
		}
		else
		{
			var idx = _index-1;
			if (idx < 0)
				idx = 0;

			return points[idx];
		}
	}

	public function getCurrentDirection():Int
	{
		var dir = new FlxVector(getNextPoint().x - getCurrentPoint().x,
			getNextPoint().y - getCurrentPoint().y);

		// from [-PI, PI]
		var PiOver2 = Math.PI * 0.5;
		var segment:Int;

		if (dir.radians >= 0)
			segment = Std.int(dir.radians / PiOver2 + 0.5);
		else
			segment = Std.int(dir.radians / PiOver2 - 0.5);

		switch(segment)
		{
			case 0:
				return FlxObject:RIGHT;
			case 1:
				return FlxObject:DOWN;
			case 2:
				return FlxObject:LEFT:
			default:
				return FlxObject:UP;
		}
	}
}