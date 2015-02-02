package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxVector;
import flixel.util.FlxRandom;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.tweens.*;
import flixel.tweens.motion.*;

class Enemy extends FlxSprite implements IntelligentAgent implements SteeringAgent
{
	public var _speed:Float = 60;
	public var tilePosition(get, never):IntPoint;
	public var senseInterval(default, default):Float;
	public var rerouteInterval(default, default):Float;

	var _senseElapsed:Float = 0;
	var _waypoints:Array<FlxPoint>;
	var _rerouteElapsed:Float = 0;
	var _counter:Int = 0; // debug usage
	var _waypointChanged:Bool = false;
	var _followPath:LinearPath;

	function get_tilePosition()
	{
		return new IntPoint(
			Std.int(this.x / _tileWidth), 
			Std.int(this.y / _tileHeight));
	}

	var _tileWidth = 16;
	var _tileHeight = 16;
	var _pursueTarget:FlxObject;
	var _missingPursueTarget:Float = 0;
	var _facingDir:FlxVector;
	var _eyeSight:Int;
	var _scene:Scene;


	static var LEFT_DIR = new FlxVector(-1, 0);
	static var RIGHT_DIR = new FlxVector(1, 0);
	static var UP_DIR = new FlxVector(0, -1);
	static var DOWN_DIR = new FlxVector(0, 1);


	public function new(scene:Scene, x:Float, y:Float, tileWidth:Int, tileHeight:Int, eyeSight:Int)
	{
		super(x, y);

		loadGraphic(AssetPaths.enemy__png, true, 16, 16);
		setSize(14, 14);

		animation.add("up", [0], 6, false);
		animation.add("down", [1], 6, false);
		animation.add("left", [3], 6, false);
		animation.add("right", [2], 6, false);

		_tileWidth = tileWidth;
		_tileHeight = tileHeight;
		_eyeSight = eyeSight;
		_scene = scene;

		// random facing
		// switch(FlxRandom.int() % 4)
		switch(1)
		{
			case 0:
				_facingDir = LEFT_DIR;
				facing = FlxObject.LEFT;
			case 1:
				_facingDir = RIGHT_DIR;
				facing = FlxObject.RIGHT;
			case 2:
				_facingDir = UP_DIR;
				facing = FlxObject.UP;
			case 3:
				_facingDir = DOWN_DIR;
				facing = FlxObject.DOWN;
			default:
		}
		FlxG.watch.add(this, "_facingDir", "Enemy facing");

		this.drag.x = this.drag.y = 1600;

		// default sense interval is 2 sec
		senseInterval = 0.5;
		_senseElapsed = 0;
		rerouteInterval = 0.3;
		_rerouteElapsed = senseInterval + 0.01;
	}

	override public function update():Void
	{
		super.update();

		syncDirection();

		_senseElapsed += FlxG.elapsed;
		if (_senseElapsed > senseInterval)
		{
			sense();
			_senseElapsed = 0;
		}

		think();
		react();

		_counter += 1;
	}

	function syncDirection()
	{
		if (_followPath != null)
		{
			var facingValue = _followPath.getCurrentDirection();
			if (facingValue >= 0)
				facing = facingValue;
		}

		switch(facing)
		{
			case FlxObject.LEFT:
				_facingDir = LEFT_DIR;
			case FlxObject.RIGHT:
				_facingDir = RIGHT_DIR;
			case FlxObject.UP:
				_facingDir = UP_DIR;
			case FlxObject.DOWN:
				_facingDir = DOWN_DIR;
			default:
		}

	}

	override public function draw():Void
	{
		switch(facing)
		{

			case FlxObject.LEFT:
			animation.play("left");
			case FlxObject.RIGHT:
			animation.play("right");
			case FlxObject.UP:
			animation.play("up");
			case FlxObject.DOWN:
			animation.play("down");

			default:

		}
		super.draw();
	}

	public function sense():Void
	{
		var foundAnything = false;

		var checkAngles = [0, -15, 15, -30, 30, -45, 45];
		for(angle in checkAngles)
		{
			var forward = (new FlxVector(_facingDir.x, _facingDir.y).scale(_eyeSight)).rotateByDegrees(angle);
			var targetInt:IntPoint = new IntPoint(Std.int(forward.x) + tilePosition.x, Std.int(forward.y) + tilePosition.y);

			//var reportedPosition:IntPoint = new IntPoint();

			// var shadeArray = GeomUtility.BresenhamLine(tilePosition, targetInt);
			// for(pt in shadeArray)
			// {
			// 	_scene.getTilemap().setTile(pt.x, pt.y, 1, true);
			// }
			if (GeomUtility.BresenhamLineCheck(tilePosition, targetInt, detectObject, determineObject))
			{
				// found something, check the position from scene
				
				foundAnything = true;
				break;
			}
		}

		if (foundAnything)
		{
			if (_pursueTarget != null)
			{
				if (_missingPursueTarget > 1.0)
				{
					// clear the target
					_pursueTarget = null;
					_missingPursueTarget = 0;
					//FlxG.log.add("I lost him, go back to normal.");
				}
				else
				{
					if (_missingPursueTarget > 0)
					{
						//FlxG.log.add("Can't see him, trying to recover...");
					}
					// missing time increment now is _senseElapsed
					_missingPursueTarget += _senseElapsed;
				}
			}
		}
	}

	function detectObject(x:Int, y:Int):Bool
	{
		// should introduce tilemap/scene representation
		var type:Scene.SceneObjectType = _scene.checkObjectOnTilemap(x, y);
		switch(type)
		{
			case Scene.SceneObjectType.Player:
				//FlxG.log.add('Saw player on $x, $y');
				return true;
			case Scene.SceneObjectType.Occluded:
				//FlxG.log.add('Cannot see through beyond $x, $y');
				return true;
			default:
				return false;
		}

		return false;
	}

	function determineObject(x:Int, y:Int):Void
	{

		var type:Scene.SceneObjectType = _scene.checkObjectOnTilemap(x, y);
		switch(type)
		{
			case Scene.SceneObjectType.Player:
				//FlxG.log.add('Saw player on $x, $y');
				_pursueTarget = _scene.getPlayer();
				_missingPursueTarget = 0; // reset timer
			case Scene.SceneObjectType.Occluded:
				//FlxG.log.add('Cannot see through beyond $x, $y');


			default:
		}
	}

	public function think():Void
	{
		// Mindless walk towards the target
		// Work out a path from current position to target position, from tile map
		if (_pursueTarget != null )
		{
			 if (_rerouteElapsed > rerouteInterval)
			{
				//_waypoints = _scene.findPath(new FlxPoint(this.x, this.y), new FlxPoint(16, 16));
				_waypoints = _scene.findPath(new FlxPoint(this.x, this.y), new FlxPoint(_pursueTarget.x, _pursueTarget.y));
				if (_waypoints != null )
				{
					if (_waypoints.length == 1)
					{
						// make it as least 2 elements
						_waypoints.push(_waypoints[0]);
					}
				}

				_rerouteElapsed = 0;
				
				_waypointChanged = true;
			}
			else
			{
				_rerouteElapsed += FlxG.elapsed;
			}
		}
	}

	public function follow(waypoints:Array<FlxPoint>):Void
	{
		if (_waypointChanged)
		{
			FlxG.log.add('following $_counter');

			stopFollowing();

			if (waypoints != null)
			{
				_followPath = FlxTween.linearPath(this, waypoints, _speed, false);
			}

			_waypointChanged = false;
			
		}
	}

	function stopFollowing():Void
	{
		if (_followPath != null)
		{
			_followPath.cancel();
			_followPath = null;
		}
	}

	public function react():Void
	{
		//velocity = _facingDir.scale(_speed);

		follow(_waypoints);
	}
}
