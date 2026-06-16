package funkin.substates;

import haxe.ds.StringMap;

class CustomSubState extends ScriptSubState
{
    public var scriptName:String = '';

    public var arguments:Array<Dynamic>;
    public var variables:StringMap<Dynamic>;

    override public function new(script:String, ?arguments:Array<Dynamic>, ?variables:StringMap<Dynamic>)
    {
        super();

        scriptName = script;

        this.arguments = arguments;
        this.variables = variables;
    }

    override public function create()
    {        
        super.create();

        loadScript('scripts/substates/' + scriptName, arguments);
        
        loadScript('scripts/substates/global', arguments);

        if (variables != null)
            for (key in variables.keys())
                setOnScripts(key, map.get(key));

        openCallback = function() {
            scriptCallbackCall(ON, 'Open');

            scriptCallbackCall(POST, 'Open');
        };

        closeCallback = function() {
            scriptCallbackCall(ON, 'Close');

            scriptCallbackCall(POST, 'Close');
        };

        scriptCallbackCall(ON, 'Create');

        scriptCallbackCall(POST, 'Create');
    }

    override public function update(elapsed:Float)
    {
        if (scriptCallbackCall(ON, 'Update', [elapsed]))
        {
            super.update(elapsed);

            if (Controls.BACK && CoolVars.data.developerMode)
                close();
        }

        scriptCallbackCall(POST, 'Update', [elapsed]);
    }

    override public function destroy()
    {
        super.destroy();

        scriptCallbackCall(ON, 'Destroy');

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
}