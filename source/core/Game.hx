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

		if (Controls.pressed('CONTROL') && Controls.pressed('SHIFT'))
		{
			if (CoolVars.data.developerMode)
			{
				if (Controls.justPressed("R"))
					CoolUtil.resetGame();
			}

			if (Paths.UNIQUE_MOD == null)
			{
				if (Controls.justPressed("TAB"))
				{
					if (FlxG.state.subState != null)
						FlxG.state.subState.close();
	
					CoolUtil.openSubState(new funkin.substates.ModsMenuSubState());
				}
			}
		}

		#if WINDOWS_API
		if (Controls.justPressed("F2"))
		{
			if (!visibleConsole)
				DesktopAPI.showConsole();

			visibleConsole = true;
		}
		#end
	}
}