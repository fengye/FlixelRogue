package;

import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.FlxG;

class FogOfWar
{
	private var _player:Player;
	private var _map:TilemapEx;
	private var _clearTileIndices:Array<TileRecord> = new Array<TileRecord>();

	public function new(player:Player, map:TilemapEx)
	{
		_player = player;
		_map = map;
	}

	public function updateVisibility()
	{
		var occupiedTiles:Array<IntPoint> = _player.getOccupation(_map.widthInTiles, _map.heightInTiles);
		var visibleOccupiedTiles:Array<IntPoint> = [];

		// produce visibleOccupiedTiles and lit the visible tiles
		for(tile in occupiedTiles)
		{
			var hitPos:FlxPoint = new FlxPoint();
			var tilePos:FlxPoint = new FlxPoint();
			var x:Int;
			var y:Int;

			/*
			x = tile.x;
			y = tile.y;
			//FlxG.log.add('Hit tile $tile.x, $tile.y');
			*/

			tilePos.x = tile.x * 16;
			tilePos.y = tile.y * 16;

			if (!_map.ray(new FlxPoint(_player.x, _player.y), tilePos, hitPos))
			{
				x = Std.int(hitPos.x/16);//Std.int(_map.coordsToTileX(hitPos.x));
				y = Std.int(hitPos.y/16);//Std.int(_map.coordsToTileY(hitPos.y));
				//FlxG.log.add('Hit tile $x, $y');
			}
			else
			{
				x = tile.x;
				y = tile.y;
				//FlxG.log.add('Hit tile $x, $y');
			}
			
			var tileId = _map.getTile(x, y);
			if (tileId >= 2)
			{
				_map.setTile(x, y, tileId-2, true);
				// FlxG.log.add(tileId);
			}

			var found = false;
			for (vtile in visibleOccupiedTiles)
			{
				if (vtile.x == x &&
					vtile.y == y)
				{
					found = true;
					break;
				}
			}

			if (!found)
			{
				visibleOccupiedTiles.push(new IntPoint(x, y));
			}
		}

		// calculate timeout. if any tile is not visible for 3 seconds, then removed it from clear tile queue
		for( r in _clearTileIndices)
		{
			r.time -= FlxG.elapsed;
		}

		for( r in _clearTileIndices)
		{
			var removedOne = false;

			var x:Int = r.idx.x;
			var y:Int = r.idx.y;

			if (r.time <= 0)
			{
				for(tile in visibleOccupiedTiles)
				{
					if (tile.x != r.idx.x ||
						tile.y != r.idx.y)
					{
						if (_clearTileIndices.remove(r))
						{
							var tileId = _map.getTile(x, y);
							if (tileId < 2)
								_map.setTile(x, y, tileId + 2, true);
							
							//FlxG.log.add('Remove tile $x, $y to $tileId');

							removedOne = true;
							break;
						}
						else
						{
							//FlxG.log.add("Error not deleted");
						}
					}
					else
					{
						r.time = 3.0;
						//FlxG.log.add('Tile $x, $y renewed');
					}
				}
			}

			if (removedOne)
				break;
		}

		// add to clear tile queue for the current occupied tiles
		for(tile in visibleOccupiedTiles)
		{
			var found:Bool = false;
			// search if record already in queue
			for( r in _clearTileIndices)
			{
				if (r.idx.x == tile.x && r.idx.y == tile.y)
				{
					r.time = 3.0;
					found = true;
					break;
				}
			}

			if (!found)
			{
				var record:TileRecord = new TileRecord(new IntPoint(tile.x, tile.y), 3.0);
				_clearTileIndices.push(record);
			}

		}
	}
}