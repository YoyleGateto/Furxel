var thing:FlxSprite;
var t:Float = 0;

function onCreate() {
	thing = new FlxSprite().loadGraphic(Paths.image("appIcon"));
	thing.scale.set(0.3,0.3);
	thing.updateHitbox();
	thing.screenCenter();
	add(thing);
}

function onUpdate(elapsed) {
	t += elapsed * 5;
	thing.x += Math.cos(t) * 5;
	thing.y += Math.cos(-t+90) * 5;
	thing.angle = t * 10;
}