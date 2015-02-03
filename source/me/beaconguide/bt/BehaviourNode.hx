package me.beaconguide.bt;

class BehaviourNode
{
	var _children:Array<BehaviourNode> = new Array<BehaviourNode>();
	var _caller:Dynamic;
	var _context:Dynamic;
		
	public function setCaller(caller:Dynamic):Void
	{
		_caller = caller;
	}

	public function setContext(context:Dynamic):Void
	{
		_context = context;
	}

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

	public function getChildCount():Int
	{
		return _children.length;
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
