package funkin.states;

import haxe.ds.StringMap;

#if cpp
import sys.FileSystem;
#end

class CustomState extends ScriptState
{
    public var scriptName:String = '';

    #if cpp
    @:unreflective private var reloadThread:Bool = CoolVars.data.developerMode && CoolVars.data.scriptsHotReloading;
    #end

    public var arguments:Array<Dynamic>;
    public var variables:StringMap<Dynamic>;

    override public function new(script:String, ?arguments:Array<Dynamic>, ?variables:StringMap<Dynamic>)
    {
        super();

        scriptName = script;

        this.arguments = arguments;
        this.variables = variables;
    }

    @:unreflective var watchFiles:Array<String> = [];

    override public function create()
    {        
        super.create();

        loadScript('scripts/states/' + scriptName, arguments);
        
        loadScript('scripts/states/global', arguments);

        if (variables != null)
            for (key in variables.keys())
            	setOnScripts(key, variables.get(key));

        #if cpp
        FlxG.autoPause = !CoolVars.data.developerMode || !CoolVars.data.scriptsHotReloading;

        if (CoolVars.data.scriptsHotReloading && CoolVars.data.developerMode)
        {
            for (file in [scriptName, 'global'])
            	addHotReloadingFile('scripts/states/' + file + '.hx');

            callOnScripts('onHotReloadingConfig');

            CoolUtil.createSafeThread(() -> {
                var lastTimes:Map<String, Float> = [];

                for (f in watchFiles)
                    lastTimes.set(f, FileSystem.stat(f).mtime.getTime());

                while (reloadThread)
                {
                    for (f in watchFiles)
                    {
                        var newTime = FileSystem.stat(f).mtime.getTime();

                        if (lastTimes.exists(f) && newTime != lastTimes.get(f))
                        {
                            lastTimes.set(f, newTime);

                            resetCustomState();
                        }
                    }

                    Sys.sleep(0.1);
                }
            });
        }
        #end

        scriptCallbackCall(ON, 'Create');
        
        scriptCallbackCall(POST, 'Create');
    }

    public function addHotReloadingFile(path:String)
        if (Paths.exists(path))
            watchFiles.push(Paths.getPath(path));

    override public function update(elapsed:Float)
    {
        if (scriptCallbackCall(ON, 'Update', [elapsed]))
        {
            super.update(elapsed);

            if (Controls.RESET && CoolVars.data.developerMode)
                resetCustomState();
        }

        scriptCallbackCall(POST, 'Update', [elapsed]);
    }

    override public function destroy()
    {
        scriptCallbackCall(ON, 'Destroy');

        super.destroy();

        #if cpp
        if (CoolVars.data.scriptsHotReloading && CoolVars.data.developerMode)
            reloadThread = false;
        #end

        FlxG.autoPause = true;

        scriptCallbackCall(POST, 'Destroy');

        destroyScripts();
    }

    override public function onFocus()
    {
        if (scriptCallbackCall(ON, 'OnFocus'))
            super.onFocus();

        scriptCallbackCall(POST, 'OnFocus');
    }

    override public function onFocusLost()
    {
        if (scriptCallbackCall(ON, 'OnFocusLost'))
            super.onFocusLost();

        scriptCallbackCall(POST, 'OnFocusLost');
    }

    override public function openSubState(substate:flixel.FlxSubState):Void
    {
        if (scriptCallbackCall(ON, 'OpenSubState', null, [substate], [Type.getClassName(Type.getClass(substate))]))
            super.openSubState(substate);

        scriptCallbackCall(POST, 'OpenSubState', null, [substate], [Type.getClassName(Type.getClass(substate))]);
    }

    override public function closeSubState():Void
    {
        if (scriptCallbackCall(ON, 'CloseSubState'))
            super.closeSubState();

        scriptCallbackCall(POST, 'CloseSubState');
    }

    public function resetCustomState()
    {
        shouldClearMemory = false;

        CoolUtil.switchState(new CustomState(scriptName, arguments, variables), true, true);

        #if cpp
        if (CoolVars.data.scriptsHotReloading && CoolVars.data.developerMode)
            reloadThread = false;
        #end

        debugTrace('Current State: ' + scriptName, RESET_STATE);
    }
}