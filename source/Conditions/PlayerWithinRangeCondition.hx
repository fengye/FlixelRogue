package;

import me.beaconguide.bt.*;

class PlayerWithinRangeCondition extends ConditionNode
{
	override private function doJudgement():NodeStatus
	{
		var enemy:Enemy = cast _caller;
		if (enemy.getPlayerDistance() <= 80)
		{
			return NodeStatus.SUCCESS;
		}
		return NodeStatus.FAILURE;
	}
}

