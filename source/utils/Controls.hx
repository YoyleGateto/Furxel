package utils;

import flixel.input.keyboard.FlxKey;

import api.MobileAPI;

class Controls
{
	public static function keyPressed(key:String):Bool
        return MobileAPI.checkKey(FlxKey.fromString(key), PRESSED) || FlxG.keys.anyPressed([FlxKey.fromString(key)]);
    
    public static function keyJustPressed(key:String):Bool
        return MobileAPI.checkKey(FlxKey.fromString(key), JUST_PRESSED) || FlxG.keys.anyJustPressed([FlxKey.fromString(key)]);
    
    public static function keyJustReleased(key:String):Bool
        return MobileAPI.checkKey(FlxKey.fromString(key), JUST_RELEASED) || FlxG.keys.anyJustReleased([FlxKey.fromString(key)]);
}