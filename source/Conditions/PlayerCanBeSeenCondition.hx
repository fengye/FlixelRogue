package;

import me.beaconguide.bt.*;
import flixel.FlxG;

class PlayerCanBeSeenCondition extends ConditionNode
{
	override private function doJudgement():NodeStatus
	{
		var enemy:Enemy = cast _caller;
		if (enemy.canSensePlayer())
		{
			FlxG.log.add('Can now see player');
			return NodeStatus.SUCCESS;
		}
		return NodeStatus.FAILURE;
	}
}
