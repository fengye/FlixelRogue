package me.beaconguide.bt;

class ActionNode extends BehaviourNode
{
	override public function run():NodeStatus
	{
		return doAction();
	}

	private function doAction():NodeStatus
	{
		return NodeStatus.FAILURE;
	}
}
