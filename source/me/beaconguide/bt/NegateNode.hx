package me.beaconguide.bt;

class NegateNode extends DecoratorNode
{
	private function decorate(status:NodeStatus):NodeStatus
	{
		// default is pass-through decoration
		switch(status)
		{
			case NodeStatus.FAILURE:
				return NodeStatus.SUCCESS;

			case NodeStatus.SUCCESS:
				return NodeStatus.FAILURE;

			default:
				return NodeStatus.RUNNING;
		}
	}
}
