package funkin.visuals.plugins;

import flixel.input.keyboard.FlxKey;
import api.MobileAPI;
import core.interfaces.ITactileButton;

class MobileButton extends FlxSpriteGroup implements ITactileButton
{
    public var key:FlxKey;

    public var bg:FlxSprite;
    public var label:FlxText;

    public function new(?X:Float = 0, ?Y:Float = 0, keyStr:String, labelText:String)
    {
        super(X, Y);

		key = FlxKey.fromString(keyStr) ?? FlxKey.NONE;

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image("ui/button"), true, 44, 45);
        bg.animation.add('idle', [0], 1, true);
        bg.animation.add('press', [1], 1, true);
        add(bg);
        bg.animation.play('idle');
        bg.scale.set(4,4);
        bg.updateHitbox();
        bg.active = false;

        label = new FlxText(0, 0, 0, labelText, 60);
        add(label);
        label.font = Paths.font('poppins.ttf');
        label.color = FlxColor.BLACK;
        label.x = bg.x + bg.width / 2 - label.width / 2;
        label.y = bg.y + bg.height / 2 - label.height / 2;
        label.active = false;

        alpha = 0.75;
    }

    public var pressed:Bool = false;

    public var justPressed:Bool = false;
    
    public var justReleased:Bool = false;

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        label.y = (bg.y + (pressed ? 0.0 : -10.0)) + bg.height / 2 - label.height / 2;
        
        if (justPressed)
            justPressed = false;

        if (justReleased)
            justReleased = false;

        if (FlxG.mouse.justPressed)
        {
            if (FlxG.mouse.overlaps(bg, cameras[0]))
            {
                pressed = justPressed = true;

                alpha = 1;
                
                bg.animation.play('press');
            }
        }

        if (pressed && !FlxG.mouse.pressed)
        {
            pressed = false;
    
            justReleased = true;
    
            alpha = 0.75;
            
            bg.animation.play('idle');
        }
    }
    
    public function restart()
    {
        pressed = justPressed = justReleased = false;
        
        alpha = 0.75;
    }
}
