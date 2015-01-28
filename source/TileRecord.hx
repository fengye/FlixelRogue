package;

import flixel.util.FlxPoint;

class TileRecord
{
	public var idx:IntPoint;
	public var time:Float;

	public function new(pt:IntPoint, tm:Float)
	{
		idx = pt;
		time = tm;
	}
}