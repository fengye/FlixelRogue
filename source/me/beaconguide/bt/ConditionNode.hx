package me.beaconguide.bt;

class ConditionNode extends BehaviourNode
{
	public function run():NodeStatus
	{
		return doJudgement();
	}

	private function doJudgement():NodeStatus
	{
		return NodeStatus.FAILURE;
	}
}