package;

import me.beaconguide.bt.*;

class IdleAction extends ActionNode
{
	override private function doAction():NodeStatus
	{
		var enemy:Enemy = _caller;
		return enemy.cmdIdle();
	}
}
