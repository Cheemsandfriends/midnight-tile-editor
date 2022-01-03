package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.ds.Vector;
import haxe.zip.Reader;
import openfl.events.Event;
import openfl.net.FileReference;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;
import ui.FlxSwitchThingy;

class MainState extends FlxState
{
	var BottomUI:FlxSprite;

	var RightUI:FlxSprite;

	var UIObjects:FlxSpriteGroup;

	var tiles:FlxTypedGroup<Tile>;

	var previousTileShitButton:FlxButton;
	var tileShitDisplayText:FlxText;
	var nextTileShitButton:FlxButton;

	var tileShitIndex:Int = 0;

	var tileShitData:Array<String> = ['Basic', 'Furn.', 'Pipes', 'NPCs'];

	// var dummyTile:Tile;
	// * Variables for tile placement, modified by the player
	var intendedSprite:String = "assets/images/tiles/default.png";
	var griddedX:Float = 0;
	var griddedY:Float = 0;
	var shouldCollide:Bool = false;
	var shouldBeImmovable:Bool = true;
	var isBouncy:Bool = false;
	var isSlippery:Bool = false;
	var isClimbable:Bool = false;
	var intendedType:String = "default";
	var intendedLayer:String = "midground";

	var confirmMakeNewProject:Bool = false;

	// * End
	static inline var GRID_SIZE:Float = 32;

	override public function create()
	{
		super.create();

		tiles = new FlxTypedGroup<Tile>();

		add(tiles);

		UIObjects = new FlxSpriteGroup();

		add(UIObjects);

		BottomUI = new FlxSprite(0,
			(FlxG.height / 2) + (FlxG.height / 3.5) - 75).makeGraphic(FlxG.width, Std.int((FlxG.height / 2) - (FlxG.height / 3.5) + 75), 0xff1f1b24);

		RightUI = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width / 4), Std.int(FlxG.height - BottomUI.height), 0xff1f1b24);

		RightUI.x = FlxG.width - RightUI.width;

		UIObjects.add(BottomUI);
		UIObjects.add(RightUI);

		previousTileShitButton = new FlxButton(RightUI.x + 12, 44 + 9, "Prev.", function()
		{
			tileShitIndex--;

			if (tileShitIndex < 0)
			{
				tileShitIndex = tileShitData.length - 1;
			}

			tileShitDisplayText.text = tileShitData[tileShitIndex];
		});

		tileShitDisplayText = new FlxText(previousTileShitButton.x + previousTileShitButton.width + 12, 44, 0, tileShitData[0], 18);

		nextTileShitButton = new FlxButton(tileShitDisplayText.x + tileShitDisplayText.width + 12, 44 + 9, "Next", function()
		{
			tileShitIndex++;

			if (tileShitIndex > tileShitData.length - 1)
			{
				tileShitIndex = 0;
			}

			tileShitDisplayText.text = tileShitData[tileShitIndex];
		});

		UIObjects.add(tileShitDisplayText);
		UIObjects.add(previousTileShitButton);
		UIObjects.add(nextTileShitButton);

		for (i in UIObjects.members)
		{
			i.scrollFactor.set();
		}
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		griddedX = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;
		griddedY = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;

		if (FlxG.keys.justPressed.A)
		{
			trace(Prefs.parsePrefs());
		}

		performAddTile();

		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S)
			save();
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.L && !searchingForPath)
			initLoad();

		if (FlxG.keys.justPressed.ENTER && searchingForPath && coolText != null)
		{
			trace(completeLoad());
			if (completeLoad() != null)
			{
				UIObjects.remove(coolText);
				searchingForPath = false;
			}
		}

		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.N)
		{
			for (i in tiles)
			{
				tiles.remove(i);
			}
		}
	}

	function performAddTile()
	{
		if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(UIObjects))
		{
			for (i in tiles)
			{
				if (FlxG.mouse.overlaps(i))
				{
					deleteTile(i);
					trace("OVERWRITTEN TILE");
				}
			}
			addTile({
				sprite: intendedSprite,
				x: griddedX,
				y: griddedY,
				collide: shouldCollide,
				immovable: shouldBeImmovable,
				bouncy: isBouncy,
				slippery: isSlippery,
				climbable: isClimbable,
				type: intendedType,
				layer: intendedLayer
			});
		}
	}

	function addTile(tileData:TileData):Tile
	{
		var tile = new Tile({
			sprite: tileData.sprite,
			x: tileData.x,
			y: tileData.y,
			collide: tileData.collide,
			immovable: tileData.immovable,
			bouncy: tileData.bouncy,
			slippery: tileData.slippery,
			climbable: tileData.climbable,
			type: tileData.type,
			layer: tileData.layer
		});

		trace("ADDED TILE");

		return tiles.add(tile);
	}

	function deleteTile(tile:Tile):Tile
	{
		tiles.remove(tile, true);
		return tile;
	}

	function canModifyTilesWithMouse():Bool
	{
		if (FlxG.mouse.overlaps(UIObjects))
			return false;
		return true;
	}

	var searchingForPath:Bool = false;

	var coolText:FlxInputText;

	function initLoad()
	{
		if (coolText == null)
			coolText = new FlxInputText(0, 0, 400, "", 18, FlxColor.WHITE, 0xff1f1b24);
		UIObjects.add(coolText);
		coolText.screenCenter();
		searchingForPath = true;
	}

	var canShowErrorText:Bool = true;

	function completeLoad()
	{
		if (FileSystem.exists(coolText.text))
		{
			var content = File.getContent(coolText.text);
			tiles.forEachExists(function(t:Tile)
			{
				tiles.remove(t);
			});

			for (i in Reader.ReadTilemapData(content))
			{
				tiles.add(new Tile(i));
			};

			return coolText.text;
		}
		else
		{
			if (canShowErrorText)
			{
				var errorTxt = new FlxText(coolText.x + coolText.width / 2, coolText.y + coolText.height - 32, "Invalid Path!", 18);
				errorTxt.color = FlxColor.RED;
				canShowErrorText = false;
				add(errorTxt);
				new FlxTimer().start(0.5, _ ->
				{
					remove(errorTxt);
					canShowErrorText = true;
				});
				trace("Error! Path Not Found - Showing text");
			}

			trace("Error! Path not found!");
		}
		return null;
	}

	function save(path:String = 'assets/data/lol.json')
	{
		var tileDataArray:Array<TileData> = [];

		for (i in tiles)
		{
			tileDataArray.push(i.tileData);
		}

		Writer.WriteTilemapData(tileDataArray, path);
	}

	function makeTileUIAndSettingsUI() {}
}
