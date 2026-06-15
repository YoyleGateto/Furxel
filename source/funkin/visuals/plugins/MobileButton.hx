package funkin.visuals.plugins;

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.input.keyboard.FlxKey;

import core.interfaces.ITactileButton;

class MobileButton extends FlxSpriteGroup implements ITactileButton
{
    public var keys:Array<FlxKey>;

    public var bg:FlxShapeCircle;
    public var label:FlxText;

    public function new(keys:Array<FlxKey>, labelText:String, ?radius:Int)
    {
        super();

        this.keys = keys;

        radius ??= 50;

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image("ui/button"), true, 44, 45);
        bg.animation.add('idle', [0], 1, true);
        bg.animation.add('press', [1], 1, true);
        add(bg);
        bg.animation.play('idle');
        bg.active = false;

        label = new FlxText(0, 0, 0, labelText, Std.int(radius * 1.25));
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
        
        if (justPressed)
            justPressed = false;

        if (justReleased)
            justReleased = false;

        if (Controls.MOUSE_P)
        {
            if (FlxG.mouse.overlaps(bg, cameras[0]))
            {
                pressed = justPressed = true;

                alpha = 1;
                
                bg.animation.play('press');
            }
        }

        if (pressed && !Controls.MOUSE)
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