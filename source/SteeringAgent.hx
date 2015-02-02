package;

import flixel.util.FlxPoint;

interface SteeringAgent
{
	function follow(waypoints:Array<FlxPoint>):Void;
}
