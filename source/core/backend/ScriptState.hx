package core.backend;

#if HSCRIPT_ALLOWED
import ale.rulescript.RuleScriptGlobal;

import scripting.haxe.HScript;

import rulescript.Context;
#end

#if HSCRIPT_ALLOWED
import scripting.haxe.HScriptPresetBase;
#end

import core.enums.ScriptCallType;

import haxe.Exception;

import core.interfaces.IScriptState;

class ScriptState extends State implements IScriptState
{
    public static var instance:ScriptState;

    #if HSCRIPT_ALLOWED
    public var hScripts:Array<HScript> = [];

    public var hScriptsContext:Context;

    public var hsCustomCallbacks:Array<Class<HScriptPresetBase>> = [];
    #end

    public function new()
    {
        #if HSCRIPT_ALLOWED
        hScriptsContext = new Context();
        #end

        super();
    }

    override public function create()
    {
        instance = this;

        super.create();
    }

    override public function destroy()
    {
        instance = null;

        super.destroy();
    }

    public function loadScript(path:String, ?args:Array<Dynamic>)
    {
        #if HSCRIPT_ALLOWED
        if (Paths.exists(path + RuleScriptGlobal.SCRIPT_EXTENSION))
        {
            var script:HScript = new HScript(path, hScriptsContext, args, STATE, hsCustomCallbacks);

            if (!script.failedExecution)
            {
                hScripts.push(script);

                debugTrace('"' + path + '.hx" has been Successfully Loaded', HSCRIPT);
            }
        }
        #end
    }

    public function setOnScripts(name:String, value:Dynamic)
    {
        #if HSCRIPT_ALLOWED
        if (hScripts.length > 0)
            for (script in hScripts)
                script.set(name, value);
        #end
    }
    
    public function callOnScripts(callback:String, arguments:Array<Dynamic> = null):Array<Dynamic>
    {
        var results:Array<Dynamic> = [];

        #if HSCRIPT_ALLOWED
        if (hScripts.length > 0)
        {
            try
            {
                for (script in hScripts)
                {
                    if (script == null)
                        continue;

                    results.push(script.call(callback, arguments));
                }
            } catch(_) {}
        }
        #end

        return results;
    }
    
    public function scriptCallbackCall(type:ScriptCallType, id:String, ?args:Array<Dynamic>):Bool
        return !callOnScripts(Std.string(type) + id, args).contains(CoolVars.Function_Stop);
        
    public function destroyScripts()
    {
        #if HSCRIPT_ALLOWED
        if (hScripts.length > 0)
        {
            for (script in hScripts)
                hScripts.remove(script);
        }
        #end
    }
}