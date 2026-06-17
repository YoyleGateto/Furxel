package core.interfaces;

import flixel.FlxState;
import flixel.FlxBasic;

#if HSCRIPT_ALLOWED
import scripting.haxe.HScript;

import rulescript.Context;

import scripting.haxe.HScriptPresetBase;
#end

import core.enums.ScriptCallType;

interface IScriptState
{
    public var members(default, null):Array<FlxBasic>;

    #if HSCRIPT_ALLOWED
    public var hScripts:Array<HScript>;
    
    public var hScriptsContext:Context;

    public var hsCustomCallbacks:Array<Class<HScriptPresetBase>>;
    #end

    public function loadScript(path:String, ?args:Array<Dynamic>):Void;
    
    public function setOnScripts(name:String, value:Dynamic):Void;
    
    public function callOnScripts(callback:String, ?arguments:Array<Dynamic> = null):Array<Dynamic>;
    
    public function scriptCallbackCall(type:ScriptCallType, id:String, ?args:Array<Dynamic>):Bool;

    public function destroyScripts():Void;
    
    public function add(obj:FlxBasic):FlxBasic;
    public function insert(index:Int, obj:FlxBasic):FlxBasic;
    public function remove(obj:FlxBasic, destroy:Bool = false):FlxBasic;
}