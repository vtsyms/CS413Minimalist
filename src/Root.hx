import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;

class Root extends Sprite {

    public static var assets:AssetManager;
    public var ninja:Image;
    public var Circle_placeholder:Image;

    public function new() {
        super();
    }

    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/ninja.png");
        assets.enqueue("assets/Circle_placeholder.png");
        assets.loadQueue(function onProgress(ratio:Float) {

            if (ratio == 1) {

                Starling.juggler.tween(startup.loadingBitmap, 2.0, {
                    transition: Transitions.EASE_OUT,
                        delay: 1.0,
                        alpha: 0,
                        onComplete: function() {
                        startup.removeChild(startup.loadingBitmap);
                        ninja = new Image(Root.assets.getTexture("ninja"));
                        ninja.x = 100;
                        ninja.y = 0;
                        addChild(ninja);

                        Circle_placeholder = new Image(Root.assets.getTexture("Circle_placeholder"));
                        Circle_placeholder.x = 250;
                        Circle_placeholder.y = 250;
                        addChild(Circle_placeholder);

                        Starling.juggler.tween(ninja, 1.0, {
                            transition: Transitions.EASE_OUT_BOUNCE,
                                delay: 2.0,
                                y: 250
                                });

                    }

                });
            }

        });
    }

}