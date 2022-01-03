package ui;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class FlxSwitchThingy extends FlxSpriteGroup
{
	var prevButton:FlxButton;
	var nextButton:FlxButton;

	var displayText:FlxText;

	var data:Array<String>;

	var index:Int = 0;

	public function new(x:Float = 0, y:Float = 0, data:Array<String>, state:FlxState)
	{
		super(x, y);
		this.data = data;

		generateUI();
	}

	public function setCorrectYs(y:Float)
	{
		prevButton.y = y;
		displayText.y = y;
		nextButton.y = y;
		this.y = y;
	}

	public function setCorrectXs(x:Float)
	{
		prevButton.x = x;
		displayText.x = prevButton.x + prevButton.width + 25;
		nextButton.x = displayText.x + displayText.width + 25;
		this.x = x;
	}

	public function generateUI()
	{
		prevButton = new FlxButton(x, y, "Prev", function()
		{
			index--;

			if (index < 0)
			{
				index = data.length - 1;
			}
		});

		displayText = new FlxText(prevButton.x + prevButton.width + 25, y, 0, data[index], 24);

		nextButton = new FlxButton(displayText.x + displayText.width + 25, y, "Next", function()
		{
			index++;

			if (index > data.length - 1)
			{
				index = 0;
			}
		});

		nextButton.y = displayText.height / 2;
		prevButton.y = displayText.height / 2;

		add(displayText);
		add(prevButton);
		add(nextButton);
	}
}
