package;

typedef TileData =
{
	var sprite:String;
	var x:Float;
	var y:Float;
	var collide:Bool;
	var immovable:Bool;
	var ?bouncy:Bool;
	var ?slippery:Bool;
	var ?climbable:Bool;
	var ?type:String;
	var ?layer:String;
}
