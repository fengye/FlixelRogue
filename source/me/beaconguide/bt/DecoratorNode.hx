package me.beaconguide.bt;

class DecoratorNode extends BehaviourNode
{
	override public function addChild(node:BehaviourNode):Void
	{
		super.addChild(node);

		if (_children.length > 1)
		{
			throw new BehaviourTreeException("Decorator node cannot have more than one child.");
		}
	}

	public function run():NodeStatus
	{
		if (_children.length > 0)
		{
			var onlyChild:BehaviourNode = getChild(0);

			var status = onlyChild.run();
			if (status == NodeStatus.RUNNING)
				return status;

			return decorate(status);
		}

		// should not let a dangling Decorator Node exists
		return NodeStatus.FAILURE;
	}
   
	private function decorate(status:NodeStatus):NodeStatus
	{
		// default is pass-through decoration
		return status;
	}
}
