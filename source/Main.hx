package;

import flixel.FlxGame;
import flixel.util.FlxTimer;
import openfl.display.FPS;
import openfl.display.Application;
import openfl.display.Window;
import openfl.display.Sprite;
#if windows
import discord_rpc.DiscordRpc;
#end

class Main extends Sprite
{
	public static var fcount:FPS;
	public static var addedf = true;
	public static var shutdown = false;
	private var addfps = true;
	public static var state:Dynamic = {
		details: "<V1.0>",
		state: "Title Screen",
		largeImageKey: "boyfriend",
		largeImageText: "Vs Nick LOL",
		smallImageKey: null,
		startTimestamp: null,
		endTimestamp: null
	};
	public static var self:Main;
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));
		if(addfps)
		{
			fcount = new FPS(10, 3, 0xFFFFFF);
			addedf = true;
			addChild(fcount);
		}
		#if windows
        DiscordRpc.start({
            clientID: "863284430218592267",
            onReady: pupdate,
            onError: errorout,
            onDisconnected: dsc
        });
		#end
		self = this;
	}
	public static function cease()
	{
		if(shutdown)
			return;
		#if windows
		DiscordRpc.shutdown();
		#end
		shutdown = true;
	}
	public static function resume()
	{
		if(!shutdown)
			return;
		#if windows
		DiscordRpc.start({
            clientID: "863284430218592267",
            onReady: pupdate,
            onError: errorout,
            onDisconnected: dsc
        });
		#end
		shutdown = false;
	}
	public static function pupdate()
	{
		if(shutdown)
			return;
		#if windows
		DiscordRpc.presence(state);
		#end
	}
	public static function play()
	{
		if(shutdown)
			return;
		state.smallImageKey = "play";
		pupdate();
	}
	public static function pause()
	{
		if(shutdown)
			return;
		state.smallImageKey = "pause";
		pupdate();
	}
	public static function clear()
	{
		if(shutdown)
			return;
		state.smallImageKey = null;
		pupdate();
	}
	public static function setstate(?u:String, ?p:String)
	{
		if(shutdown)
			return;
		if(u != null)
			state.state = u;
		if(p != null)
			state.details = p;
		pupdate();
	}
	public static function timestamp(?remaining:Float, offset:Float = 0)
	{
		if(remaining == null)
		{
			state.startTimestamp = state.endTimestamp = null;
			pupdate();
			return;
		}
		state.startTimestamp = Date.now().getTime() + offset;
		state.endTimestamp = Date.now().getTime()+(remaining*1000);
		pupdate();
	}
	public static function errorout(?a:Int, ?b:String)
	{
		return;
	}
	public static function dsc(?a:Int, ?b:String)
	{
		return;
	}
	public static function aF(?child:Dynamic):Void
	{
		if(fcount == null) return;
		fcount.visible = Main.addedf = true;
	}
	public static function rF(?child:Dynamic):Void
	{
		if(fcount == null) return;
		fcount.visible = Main.addedf = false;
	}
}
