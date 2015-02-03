package;

import me.beaconguide.bt.*;

class WalkToPlayerLastPositionAction extends ActionNode
{
	override private function doAction():NodeStatus
	{
		var enemy:Enemy = cast _caller;
		var lastSeenPoint = enemy.getLastSeenPlayerPosition();

		return enemy.cmdGotoPosition(lastSeenPoint);
	}
}

