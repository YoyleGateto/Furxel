package funkin.substates;

import funkin.visuals.objects.Alphabet;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxSave;

import sys.FileSystem;
import sys.io.File;

import api.MobileAPI;

import openfl.display3D.textures.RectangleTexture;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import lime.graphics.Image;
import lime.utils.Bytes;

@:unreflective class ModsMenuSubState extends SubState
{
    var sprites:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	var icons:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	
	var selInt:Int = 0;
	
	var holdElapsed:Float = 0.0;
	
	var camPos = {x: 0.0, y: 0.0};
	
	var options:Array<String> = [];
	
	final DISABLE_ID:String = 'Example';
	
	function getModIcon(name:String, ?gpuCache:Bool = false) {
		var path = Paths.mods + '/' + name + '/icon.png';
		
		if (!FileSystem.exists(path)) return null;
		
		final bytes:Bytes = File.getBytes(path);
	    final image:Image = Image.fromBytes(bytes);
	    final bitmap:BitmapData = BitmapData.fromImage(image);
	    
	    if (gpuCache)
	    {
	        final texture:RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmap.width, bitmap.height, BGRA, true);
	        texture.uploadFromBitmapData(bitmap);
	    }
	    
	    final graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, path);
	    graphic.persist = true;
	    graphic.destroyOnNoUse = false;
	    
	    return graphic;
	}
	
	function reverseMin(v:Float, max:Float) {
		if(v > max) {
			return max + (max - v);
		} else {
			return v;
		}
	}
	
	override function create()
	{
	    super.create();
	
	    if (FileSystem.exists(Paths.mods))
	        if (FileSystem.isDirectory(Paths.mods))
	            for (folder in FileSystem.readDirectory(Paths.mods))
	                if (FileSystem.isDirectory(Paths.mods + '/' + folder) && folder != '.git')
	                    options.push(folder);
	
	    options.push(DISABLE_ID);
	
	    var bg:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFF003015, 0xFF004020));
	    add(bg);
	    bg.scrollFactor.set();
	    bg.alpha = 0;
	    FlxTween.tween(bg, {alpha: 0.6}, 0.25, {ease: FlxEase.cubeOut});
	    bg.cameras = [subCamera];
	    bg.velocity.x = bg.velocity.y = 100;
	
	    add(sprites);
	    add(icons);
	
	    for (option in options)
	    {
	        var sprite = new FlxText(-1280, 125*options.indexOf(option), 0, option);
	        sprite.setFormat(Paths.font('jetbrains.ttf'), 60, FlxColor.WHITE, 'left');
	        sprites.add(sprite);
	        sprite.cameras = [subCamera];
	        
	        var graphic = getModIcon(option) ?? Paths.image('unknownIcon');
	        var icon = new FlxSprite(-150, -150).loadGraphic(graphic);
	        icon.setGraphicSize(100,100);
	        icon.updateHitbox();
	        icon.antialiasing = false;
			icons.add(icon);
	        icon.cameras = [subCamera];
	    }
	
	    changeShit();
	
		MobileAPI.toggleButtons(false, false);
	
	    MobileAPI.createButton(FlxG.width - 100, FlxG.height - 100, 'ENTER', 'A');
		MobileAPI.createButton(50, FlxG.height - 200, 'UP', 'U');
		MobileAPI.createButton(50, FlxG.height - 100, 'DOWN', 'D');
	}
	
	override function update(elapsed:Float)
	{
	    super.update(elapsed);
	    
	    for (sprite in sprites)
	    {
	    	var offset = sprites.members.indexOf(sprite) - selInt;
	    	sprite.x = CoolUtil.fpsLerp(sprite.x, 300.0 + reverseMin(20.0*(offset*(offset*0.5)), 0.0), 0.2);
	    	var icon = icons.members[sprites.members.indexOf(sprite)];
	    	icon.x = sprite.x - 125;
	    	icon.y = sprite.y - 12;
			icon.alpha = sprite.alpha;
		}
		
	    subCamera.scroll.x = CoolUtil.fpsLerp(subCamera.scroll.x, camPos.x, 0.2);
	    subCamera.scroll.y = CoolUtil.fpsLerp(subCamera.scroll.y, camPos.y, 0.2);
	
	    if (Controls.keyJustPressed("ENTER"))
	    { 
	        var save:FlxSave = new FlxSave();
	        save.bind('ALEEngineData', CoolUtil.getSavePath(false));
	        save.data.currentMod = options[selInt] == DISABLE_ID ? null : options[selInt];
	        save.flush();
	
	        close();
	
	        CoolUtil.resetGame();
	    }
	    
	    if (Controls.keyPressed("DOWN") || Controls.keyPressed("UP"))
	    {
	    	if (holdElapsed < 0.5) {
	    		holdElapsed += elapsed;
	    	} else {
	    		holdElapsed = 0.45;
	    		
	    		if (Controls.keyPressed("DOWN"))
		        {
		            if (selInt >= sprites.members.length - 1)
		                selInt = 0;
		            else
		                selInt++;
		        }
		    
		        if (Controls.keyPressed("UP"))
		        {
		            if (selInt == 0)
		                selInt = sprites.members.length - 1;
		            else
		                selInt--;
		        }
		
				changeShit();
	     	   FlxG.sound.play(Paths.sound('click'));
			}
	    } else {
	    	holdElapsed = 0.0;
	    }
	
	    if (Controls.keyJustPressed("UP") || Controls.keyJustPressed("UP")  || FlxG.mouse.wheel != 0)
	    {
	        if (Controls.keyJustPressed("DOWN") || FlxG.mouse.wheel > 0)
	        {
	            if (selInt >= sprites.members.length - 1)
	                selInt = 0;
	            else
	                selInt++;
	        }
	    
	        if (Controls.keyJustPressed("UP") || FlxG.mouse.wheel < 0)
	        {
	            if (selInt == 0)
	                selInt = sprites.members.length - 1;
	            else
	                selInt--;
	        }
	        
	        changeShit();
	
	        FlxG.sound.play(Paths.sound('click'));
	    }
	}
	
	function changeShit()
	{
	    for (sprite in sprites)
	    {
	        if (sprites.members.indexOf(sprite) == selInt)
	        {
	            sprite.alpha = 1;
	            
	            camPos.y = sprite.y - 300;
	        } else {
	            sprite.alpha = 0.4;
	        }
	    }
	}
}
