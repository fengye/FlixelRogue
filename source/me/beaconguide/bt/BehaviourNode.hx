package me.beaconguide.bt;

enum NodeStatus
{
	FAILURE;
	SUCCESS;
	RUNNING;
}

class BehaviourNode
{
	var _children:Array<BehaviourNode> = new Array<BehaviourNode>();

	public function addChild(node:BehaviourNode):Void
	{
		_children.push(node);
	}

	public function insertChild(node:BehaviourNode, pos:Int):Void
	{
		_children.insert(pos, node);
	}

	public function removeChild(node:BehaviourNode):Bool
	{
		return false;
	}

	public function getChild(pos:Int):BehaviourNode
	{
		return _children[pos];
	}

	public function run():NodeStatus
	{
		return NodeStatus.FAILURE;
	}
}
