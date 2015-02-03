package;

import flixel.util.FlxPoint;
import me.beaconguide.bt.*;

class WalkToPlayerPositionAction extends ActionNode
{
	override private function doAction():NodeStatus
	{
		var enemy:Enemy = cast _caller;
		var scene:Scene = cast _context;
		var player:Player = scene.getPlayer();

		return enemy.cmdGotoPosition(new FlxPoint(player.x, player.y));
	}
}
