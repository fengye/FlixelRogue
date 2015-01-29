package;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;

enum SceneObjectType
{
	Unknown;
	Unoccluded;
	Occluded;
	Player;
	Item;
}

class LevelScene 
{
	private var _player:Player;
	private var _maploader:OgmoLoaderEx;
	private var _map:TilemapEx;
	private var _enemyList:Array<Enemy> = new Array<Enemy>();

	public function new()
	{
		_maploader = new OgmoLoaderEx(AssetPaths.level1__oel);
		
		_map = new TilemapEx();
		_maploader.loadTilemapInplace(_map, AssetPaths.empty_tiles__png,16,16,"tile");
		_map.setTileProperties(0, FlxObject.NONE); // for empty
		_map.setTileProperties(1, FlxObject.ANY);  // for tiles
		_map.setTileProperties(2, FlxObject.NONE); // for fog empty
		_map.setTileProperties(3, FlxObject.ANY); // for fog tiles

		for (i in 0..._map.widthInTiles)
		{
			for(j in 0..._map.heightInTiles)
			{
				var tile:Int = _map.getTile(i, j);
				_map.setTile(i, j, tile+2, true);
			}
		}

		_maploader.loadEntities(loadEntity, "entity");
	}

	function loadEntity( type:String, data:Xml ):Void 
	{ 
		switch (type.toLowerCase()) {
			case "player": 
				_player = new Player(
					Std.parseFloat(data.get("x")), 
					Std.parseFloat(data.get("y"))
					);

			case "enemy":
				var enemy = new Enemy(this, 
					Std.parseFloat(data.get("x")), 
					Std.parseFloat(data.get("y")), 
					_map.scaledTileWidth,
					_map.scaledTileHeight, 5);

				_enemyList.push(enemy);
				
			default: 
				throw "Unrecognized actor type '" + type + "' detected in level file."; 
		} 
	}
	

	public function checkObjectOnTilemap(x:Int, y:Int) : SceneObjectType
	{
		// sanity check
		if (x < 0 || y < 0 || x >= _map.widthInTiles || y >= _map.heightInTiles )
			return SceneObjectType.Unoccluded;

		// first check the player
		var playerPos = _player.getPlayerMapIndex();
		if (playerPos.x==x && playerPos.y==y)
			return SceneObjectType.Player;

		// then check tilemap
		if (_map.getTileCollisions(_map.getTile(x, y)) == FlxObject.ANY)
			return SceneObjectType.Occluded;

		return SceneObjectType.Unoccluded;
	}

	public function update()
	{
		FlxG.collide(_map, _player);
	}

	public function getPlayer():Player
	{
		return _player;
	}

	public function getTilemap():TilemapEx
	{
		return _map;
	}

	public function getSceneObjects():Array<FlxObject>
	{
		var arr:Array<FlxObject> = [ _player, _map];

		for(enemy in _enemyList)
		{
			arr.push(enemy);
		}
		return arr;
	}
}
