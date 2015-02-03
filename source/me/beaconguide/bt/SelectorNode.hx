package me.beaconguide.bt;

class SelectorNode extends BehaviourNode
{
	public function run():NodeStatus
	{
		for(child in _children)
		{
			var status = child.run();
			switch (status) {
				case NodeStatus.SUCCESS:
					return NodeStatus.SUCCESS;
				case NodeStatus.RUNNING:
					return NodeStatus.RUNNING;
			}
		}

		// ALL FAILURE, THEN CONSIDERED RETURN FAILURE
		return NodeStatus.FAILURE;
	}
}
