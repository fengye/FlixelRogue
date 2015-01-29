package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

// import flixel.tile.FlxTilemap;
import flixel.FlxCamera;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

	
	private var _scene:LevelScene;
	private var _data:Float = 10.0;

	private var _player:Player;
	private var _map:TilemapEx;
	private var _fow:FogOfWar;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		FlxG.watch.add(this, "_clearTileIndices");

		_scene = new LevelScene();

		for(obj in _scene.getSceneObjects())
		{
			add(obj);
		}

		_player = _scene.getPlayer();
		_map = _scene.getTilemap();

		_fow = new FogOfWar(_player, _map);

		FlxG.camera.follow(_scene.getPlayer(), FlxCamera.STYLE_TOPDOWN, 1);
	}

	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		_fow.updateVisibility();

		_scene.update();
	}	
}

