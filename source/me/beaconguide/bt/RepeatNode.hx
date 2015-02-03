package me.beaconguide.bt;

class RepeatNode extends DecoratorNode
{
	public var repeatCount(default, default):Int;
	var _runCount:Int;

	public function new(count:Int)
	{
		repeatCount = count;
		_runCount = 0;
	}

	private function decorate(status:NodeStatus):NodeStatus
	{
		if (status == NodeStatus.FAILURE)
		{
			// reset run count
			_runCount = 0;
			return NodeStatus.FAILURE;
		}

		if (status == NodeStatus.SUCCESS)
		{
			_runCount++;
			if (_runCount >= repeatCount)
			{
				// reset run count
				_runCount = 0;
				return NodeStatus.SUCCESS;
			}
		}

		return NodeStatus.RUNNING;
	}
}