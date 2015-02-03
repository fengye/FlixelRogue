package me.beaconguide.bt;

class SequenceNode extends BehaviourNode
{
	override public function run():NodeStatus
	{
		for(child in _children)
		{
			var status = child.run();
			switch (status) {
				case NodeStatus.FAILURE:
					return NodeStatus.FAILURE;
				case NodeStatus.RUNNING:
					return NodeStatus.RUNNING;
				default:
			}
		}

		// ALL SUCCESS, THEN CONSIDERED RETURN SUCCESS
		return NodeStatus.SUCCESS;
	}
}
