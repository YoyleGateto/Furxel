package api;

#if mobile
import extension.eightsines.EsOrientation;
#end

import flixel.input.keyboard.FlxKey;

import core.enums.ScreenOrientation;
import core.enums.StateType;
import core.enums.KeyCheck;

import core.Main;

import funkin.visuals.plugins.MobileButton;

class MobileAPI
{
    public static var orientation:ScreenOrientation = LANDSCAPE;

    public static function setOrientation(type:ScreenOrientation)
    {
        #if mobile
        EsOrientation.setScreenOrientation(type.toEsOrientation());
        #end

        orientation = type;
    }
    
    public static function checkKey(key:FlxKey, checkType:KeyCheck):Bool {
    	var grp = null;
    
    	if (FlxG.state != null) {
    		grp = FlxG.state;
    		if (FlxG.state.subState != null) {
    			grp = FlxG.state.subState;
    		}
    	}
    
    	if (grp != null) {
    		for (obj in grp.members) {
    			if (obj is MobileButton) {
    				if (((checkType == PRESSED && obj.pressed) || (checkType == JUST_PRESSED && obj.justPessed) || (checkType == JUST_RELEASED && obj.justReleased)) && obj.key == key) {
						return true;
					}
    			}
    		}
    	}
    
    	return false;
    }
}