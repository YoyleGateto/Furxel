package core.structures;

typedef Metadata =
{
    var developerMode:Bool;
    var mobileDebug:Bool;
    var scriptsHotReloading:Bool;

    var verbose:Bool;
    var allowDebugPrint:Bool;
    
    var transition:String;

    var title:String;
    var icon:String;
    var width:Int;
    var height:Int;

    var windowColor:Array<Int>;

    var bpm:Float;

    var discordID:String;

    var discordButtons:Array<DiscordButton>;

    var modID:Null<String>;
}