package;

import flixel.FlxSprite;

class Tile extends FlxSprite
{
	public var sprite(default, set):String;
	public var collide:Bool;
	public var bouncy:Bool;
	public var slippery:Bool;
	public var climable:Bool;
	public var type:String;
	public var layer:String;

	public var tileData:TileData;

	public function new(?_tileData:TileData)
	{
		super();

		tileData = _tileData;

		if (tileData == null)
		{
			tileData = {
				sprite: "assets/images/default.png",
				x: 0,
				y: 0,
				immovable: true,
				collide: false,
				bouncy: false,
				slippery: false,
				climbable: false,
				type: "normal",
				layer: "midground"
			}
		}

		this.sprite = tileData.sprite;
		this.x = tileData.x;
		this.y = tileData.y;
		this.immovable = tileData.immovable;
		this.collide = tileData.collide;
		this.bouncy = tileData.bouncy;
		this.slippery = tileData.slippery;
		this.climable = tileData.climbable;
		this.type = tileData.type;
		this.layer = tileData.layer;

		updateGraphic();
	}

	public function updateGraphic()
	{
		loadGraphic(sprite);
	}

	function set_sprite(newSprite:String)
	{
		sprite = newSprite;
		updateGraphic();
		return sprite;
	}
}
