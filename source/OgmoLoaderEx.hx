package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;

class OgmoLoaderEx extends FlxOgmoLoader
{
	public function loadTilemapInplace(tileMap:FlxTilemap, TileGraphic:Dynamic, TileWidth:Int = 16, TileHeight:Int = 16, TileLayer:String = "tiles"):Void
	{
		tileMap.loadMap(_fastXml.node.resolve(TileLayer).innerData, TileGraphic, TileWidth, TileHeight);
	}
}

