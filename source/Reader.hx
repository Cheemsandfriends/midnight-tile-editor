package;

import haxe.Json;
import openfl.utils.Assets;
import sys.io.File;

class Reader
{
	public static function ReadTilemapData(file:String)
	{
		var jsonData = Json.parse(file);

		var tiledataArray:Array<TileData> = new Array<TileData>();

		for (i in 0...jsonData.tiles.length)
		{
			var tile:TileData = {
				sprite: jsonData.tiles[i].sprite,
				x: jsonData.tiles[i].x,
				y: jsonData.tiles[i].y,
				collide: jsonData.tiles[i].collider,
				immovable: jsonData.tiles[i].immovable,
				bouncy: jsonData.tiles[i].bouncy,
				slippery: jsonData.tiles[i].slippery,
				climbable: jsonData.tiles[i].climbable,
				type: jsonData.tiles[i].type,
				layer: jsonData.tiles[i].layer
			};

			tiledataArray.push(tile);
		}

		return tiledataArray;
	}
}
