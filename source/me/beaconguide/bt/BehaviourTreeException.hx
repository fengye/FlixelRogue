package me.beaconguide.bt;

class BehaviourTreeException
{
	public var errorMessage(default, null);

	public function new(message:String)
	{
		errorMessage = message;
	}
}
