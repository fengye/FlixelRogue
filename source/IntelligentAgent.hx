package;

interface IntelligentAgent
{
	var senseInterval(default, default):Float;

	function sense():Void;
	function think():Void;
	function react():Void;
}
