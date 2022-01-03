package;

import openfl.net.FileReference;
import openfl.utils.Assets;

class Writer
{
	public static function WriteTilemapData(tiledataArray:Array<TileData>, path:String)
	{
		var jsonForFile:String;

		jsonForFile = '{\n
            "tiles": [';

		for (i in 0...tiledataArray.length)
		{
			jsonForFile += '{
                "sprite": "${tiledataArray[i].sprite}",
                "x": ${tiledataArray[i].x},
                "y": ${tiledataArray[i].y},
                "collider": ${tiledataArray[i].collide},
                "immovable": ${tiledataArray[i].immovable},
                "bouncy": ${tiledataArray[i].bouncy},
                "slippery": ${tiledataArray[i].slippery},
                "climbable": ${tiledataArray[i].climbable},
                "type": "${tiledataArray[i].type}",
                "layer": "${tiledataArray[i].layer}"
            }';

			if (i != tiledataArray.length - 1)
			{
				jsonForFile += ',';
			}
		}

		jsonForFile += ']\n}';

		var fileReference = new FileReference();

		fileReference.save(jsonForFile, path);
	}
}
