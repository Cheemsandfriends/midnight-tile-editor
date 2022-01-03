package;

import haxe.Json;
import haxe.ds.StringMap;
import openfl.utils.Assets;
import sys.io.File;

using StringTools;

class Prefs
{
	public static inline var path:String = 'assets/data/prefs.json';

	public static var prefMap:StringMap<Dynamic>;

	public static function init()
	{
		prefMap = new StringMap<Dynamic>();

		var prefs = parsePrefs();

		prefMap.set("overwriteTiles", prefs.overwriteTiles);
	}

	public static function parsePrefs()
	{
		return Json.parse(File.getContent("assets/data/prefs.json")).preferences;
	}
}
