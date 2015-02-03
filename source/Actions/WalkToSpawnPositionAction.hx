package;

import me.beaconguide.bt.*;

class WalkToSpawnPositionAction extends ActionNode
{
	override private function doAction():NodeStatus
	{
		var enemy:Enemy = cast _caller;

		return enemy.cmdGotoPosition(enemy.getSpawnPoint());
	}
}
