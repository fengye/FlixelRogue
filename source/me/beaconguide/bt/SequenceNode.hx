package me.beaconguide.bt;

class SequenceNode extends BehaviourNode
{
	public function run():NodeStatus
	{
		for(child in _children)
		{
			var status = child.run();
			switch (status) {
				case NodeStatus.FAILURE:
					return NodeStatus.FAILURE;
				case NodeStatus.RUNNING:
					return NodeStatus.RUNNING;
			}
		}

		// ALL SUCCESS, THEN CONSIDERED RETURN SUCCESS
		return NodeStatus.SUCCESS;
	}
}
