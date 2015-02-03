package me.beaconguide.bt;

class EnsureNode extends DecoratorNode
{
	private function decorate(status:NodeStatus):NodeStatus
	{
		if (status == NodeStatus.RUNNING)
			return NodeStatus.RUNNING;

		// no matter the result of child processing, we always return success
		return NodeStatus.SUCCESS;
	}
}