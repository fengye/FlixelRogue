package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxVector;
import flixel.util.FlxRandom;
import flixel.util.FlxColor;

class Enemy extends FlxSprite implements IntelligentAgent
{
	public var _speed:Float = 80;
	public var tilePosition(get, never):IntPoint;
	public var senseInterval(default, default):Float;

	var _senseElapsed:Float = 0;
	var _senseInterval:Float;

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
	var _scene:LevelScene;


	static var LEFT_DIR = new FlxVector(-1, 0);
	static var RIGHT_DIR = new FlxVector(1, 0);
	static var UP_DIR = new FlxVector(0, -1);
	static var DOWN_DIR = new FlxVector(0, 1);


	public function new(scene:LevelScene, x:Float, y:Float, tileWidth:Int, tileHeight:Int, eyeSight:Int)
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
		switch(FlxRandom.int() % 4)
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
		senseInterval = 2.0;
	}

	override public function update():Void
	{
		super.update();

		_senseElapsed += FlxG.elapsed;
		if (_senseElapsed > senseInterval)
		{
			sense();
			_senseElapsed = 0;
		}

		think();
		react();
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
				if (_missingPursueTarget >= 3.0)
				{
					// clear the target
					_pursueTarget = null;
					_missingPursueTarget = 0;
					FlxG.log.add("I lost him, go back to normal.");
				}
				else
				{
					if (_missingPursueTarget > 0)
					{
						FlxG.log.add("Can't see him, trying to recover...");
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
		var type:LevelScene.SceneObjectType = _scene.checkObjectOnTilemap(x, y);
		switch(type)
		{
			case LevelScene.SceneObjectType.Player:
				//FlxG.log.add('Saw player on $x, $y');
				return true;
			case LevelScene.SceneObjectType.Occluded:
				//FlxG.log.add('Cannot see through beyond $x, $y');
				return true;
			default:
				return false;
		}

		return false;
	}

	function determineObject(x:Int, y:Int):Void
	{

		var type:LevelScene.SceneObjectType = _scene.checkObjectOnTilemap(x, y);
		switch(type)
		{
			case LevelScene.SceneObjectType.Player:
				FlxG.log.add('Saw player on $x, $y');
				_pursueTarget = _scene.getPlayer();
				_missingPursueTarget = 0; // reset timer
			case LevelScene.SceneObjectType.Occluded:
				FlxG.log.add('Cannot see through beyond $x, $y');


			default:
		}
	}

	public function think():Void
	{

	}

	public function react():Void
	{
		//velocity = _facingDir.scale(_speed);
	}
}
