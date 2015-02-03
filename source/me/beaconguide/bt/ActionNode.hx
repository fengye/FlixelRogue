package me.beaconguide.bt;

class ActionNode extends BehaviourNode
{
	public function run():NodeStatus
	{
		return doAction();
	}

	private function doAction():NodeStatus
	{
		return NodeStatus.FAILURE;
	}
}
