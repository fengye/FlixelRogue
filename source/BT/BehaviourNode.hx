package me.beaconguide.bt;

enum NodeStatus
{
	FAILURE;
	SUCCESS;
	RUNNING;
}

class BehaviourNode
{
	public var Array<BehaviourNode> children = new Array<BehaviourNode>();

	public function addChild(node:BehaviourNode):Void
	{
		children.push(node);
	}

	public function insertChild(node:BehaviourNode, pos:Int):Void
	{
		children.insert(pos, node);
	}

	public function removeChild(node:BehaviourNode):Bool
	{

	}

	public function run():NodeStatus
	{
		return NodeStatus.FAILURE;
	}
}
