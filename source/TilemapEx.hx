package;

import flixel.tile.FlxTilemap;

class TilemapEx extends FlxTilemap
{
	public var scaledTileWidth(get, never):Int;
	public var scaledTileHeight(get, never):Int;

	function get_scaledTileWidth():Int
	{
		return Std.int(_scaledTileWidth);
	}

	function get_scaledTileHeight():Int
	{
		return Std.int(_scaledTileHeight);
	}

	public function getTileIndex(x:Int, y:Int):Int
	{
		return y * widthInTiles + x;
	}
}
