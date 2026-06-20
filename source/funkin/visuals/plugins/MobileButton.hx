package funkin.visuals.plugins;

import flixel.input.keyboard.FlxKey;
import api.MobileAPI;
import core.interfaces.ITactileButton;

class MobileButton extends FlxSpriteGroup implements ITactileButton 
{
	public var justPressed:Bool = false;
	public var pressed:Bool = false;
	public var justReleased:Bool = false;
	
	public var spr:FlxSprite;
	public var label:FlxText;
	
	public var key:FlxKey;
	
	var padAnims:Map<String, Dynamic> = [
		"a" => {
			idle: 0,
			press: 1,
		},
		"y" => {
			idle: 2,
			press: 3,
		},
		"left" => {
			idle: 4,
			press: 5,
		},
		"b" => {
			idle: 6,
			press: 7,
		},
		"z" => {
			idle: 8,
			press: 9,
		},
		"up" => {
			idle: 10,
			press: 11,
		},
		"c" => {
			idle: 12,
			press: 13,
		},
		"m" => {
			idle: 14,
			press: 15,
		},
		"right" => {
			idle: 16,
			press: 17,
		},
		"x" => {
			idle: 18,
			press: 19,
		},
		"e" => {
			idle: 20,
			press: 21,
		},
		"down" => {
			idle: 22,
			press: 23,
		},
		"none" => {
			idle: 24,
			press: 25,
		},
	];
	
	public function new(?X:Float = 0, ?Y:Float = 0, keyStr:String, labelText:String)
    {
        super(X, Y);

		key = FlxKey.fromString(keyStr.toUpperCase()) ?? FlxKey.NONE;

		var id:String = labelText.toLowerCase() ??  "none";
		if (!padAnims.exists(id))
			id = "none";
		var a:Dynamic = padAnims.get(id);
		
		spr = new FlxSprite(0, 0).loadGraphic(Paths.image("ui/virtualPad/buttons"), true, 256, 262);
		spr.animation.add("idle", [a.idle]);
		spr.animation.add("press", [a.press]);
		
		spr.scale.x = spr.scale.y = 0.5;
		spr.updateHitbox();
		
		spr.active = false;
		
		add(spr);
		
		label = new FlxText(0, 0, 0, id == "none" ? labelText : "", 70);
        label.font = Paths.font('poppins.ttf');
        label.color = 0xFF444444;
        label.active = false;
        
        add(label);
		
		alpha = 0.75;
	}
	
	override function update(elapsed:Float)
    {
        super.update(elapsed);
        
		label.x = spr.x + spr.width / 2 - label.width / 2;
        label.y = (spr.y - (pressed ? 0.0 : 12.0)) + spr.height / 2 - label.height / 2;
		
		var isPressing = false;
		for (touch in FlxG.touches.list) {
			var p = touch.getScreenPosition(cameras[0]);
			if (p.x > this.x && p.x < (this.x + this.width) && p.y > this.y && p.y < (this.y + this.height) && touch.pressed)
				isPressing = true;
		}
		
		if (justPressed)
			justPressed = false;
		
		if (justReleased)
			justReleased = false;
		
		if (pressed) {
			if (!isPressing) {
				pressed = false;
				justReleased = true;
			}
			spr.animation.play("press", true);
		} else {
			if (isPressing) {
				justPressed = true;
				pressed = true;
			}
			spr.animation.play("idle", true);
		}
	}
	
	public function restart()
    {
        pressed = justPressed = justReleased = false;
        
        alpha = 0.75;
    }
}