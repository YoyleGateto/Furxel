package core;

import flixel.util.typeLimit.NextState.InitialState;
import flixel.FlxGame;

import api.DesktopAPI;

import core.backend.SoundTray;

import funkin.substates.ModsMenuSubState;

import openfl.events.FullScreenEvent;

import lime.app.Application;

class Game extends FlxGame
{
	override public function new(initial:InitialState)
	{
		super(1280, 720, initial, 120, 120, true, false);

		_customSoundTray = SoundTray;
	}
	
	@:unreflective var visibleConsole:Bool = false;

	override public function update()
	{
		DesktopAPI.setWindowTitle();

		super.update();

		if (Controls.keyPressed('CONTROL') && Controls.keyPressed('SHIFT'))
		{
			if (CoolVars.data.developerMode)
			{
				if (Controls.keyJustPressed("R"))
					CoolUtil.resetGame();
			}

			if (Paths.assetsMode)
			{
				if (Controls.keyJustPressed("TAB"))
				{
					if (FlxG.state.subState != null)
						FlxG.state.subState.close();
	
					CoolUtil.openSubState(new funkin.substates.ModsMenuSubState());
				}
			}
		}

		#if WINDOWS_API
		if (Controls.keyJustPressed("F2"))
		{
			if (!visibleConsole)
				DesktopAPI.showConsole();

			visibleConsole = true;
		}
		#end
	}
}