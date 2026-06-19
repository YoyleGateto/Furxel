package core.plugins;

import haxe.ds.IntMap;

import core.interfaces.ITactileButton;
import core.enums.KeyCheck;

import flixel.input.keyboard.FlxKey;
import flixel.FlxBasic;

import funkin.visuals.plugins.MobileButton;

class MobileControlsPlugin extends FlxTypedGroup<FlxBasic>
{
    override public function new()
    {
        super();
        
        FlxG.signals.preStateCreate.add(clean);
    }
    
    override function destroy()
    {
        super.destroy();
        
        FlxG.signals.preStateCreate.remove(clean);
    }
    
    public var stateButtons:IntMap<Array<ITactileButton>> = new IntMap();
    public var subStateButtons:IntMap<Array<ITactileButton>> = new IntMap();
    
    public function checkKey(key:Int, prop:KeyCheck):Bool
    {
        if (key != null || key > 0) {
	        final group:Array<ITactileButton> = subStateButtons.get(key) ?? stateButtons.get(key);
	
	        if (group != null) {
		        for (obj in group)
		        {
		            if (obj != null) {
			            final property:Bool = switch(prop)
			            {
			                case KeyCheck.PRESSED:
			                    obj.pressed;
			                case KeyCheck.JUST_PRESSED:
			                    obj.justPressed;
			                case KeyCheck.JUST_RELEASED:
			                    obj.justReleased;
			            }
			            
			            if (obj.exists && property)
			                return true;
					}
		        }
	        }
        }
        return false;
    }
    
    public function clean(?_)
    {
        for (group in [stateButtons, subStateButtons])
            destroyButtons(group);
    }

    public function restartButtons(group:IntMap<Array<ITactileButton>>)
    {
        for (key in group.keys())
            for (obj in group.get(key))
                obj.restart();
    }
    
    public function destroyButtons(group:IntMap<Array<ITactileButton>>)
    {
        for (key in group.keys())
        {
            for (obj in group.get(key))
            {
                obj.destroy();
                
                remove(cast obj, true);
            }
        }
        
        group.clear();
    }
    
    public function toggleButtons(group:IntMap<Array<ITactileButton>>, show:Bool)
    {
        for (key in group.keys())
        {
            for (obj in group.get(key))
            {
                obj.restart();
                
                obj.exists = show;
            }
        }
    }
    
    public function createButton(x:Float = 0, y:Float = 0, label:String, key:String, subState:Bool = false)
    {
        final group:IntMap<Array<ITactileButton>> = subState ? subStateButtons : stateButtons;
        
		final button:MobileButton = new MobileButton(x, y, key, label);
        add(button);
    	button.cameras = cameras;
		addToMap(button, group, button.key);
    }

    public function addToMap(obj:ITactileButton, map:IntMap<Array<ITactileButton>>, key:FlxKey)
	{
        if (!map.exists(key))
            map.set(key, []);

        if (!map.get(key).contains(obj))
            map.get(key).push(obj);
    }
}