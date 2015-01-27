import starling.display.Sprite;
import starling.utils.AssetManager;

import starling.display.Image;
import starling.display.DisplayObject;
import starling.core.Starling;
import starling.animation.Transitions;

import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;

class Root extends Sprite {

    public static var assets:AssetManager;
    public var ninja:Image;
    public var Circle_placeholder:Image;
    public var Paddle:Image;

    public function new() {
        super();
    }

    public static function deg2rad(deg:Int){
        return deg / 180.0 * Math.PI;
    }

    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/ninja.png");
        assets.enqueue("assets/Circle_placeholder.png");
        assets.enqueue("assets/Paddle.png");
        assets.loadQueue(function onProgress(ratio:Float) {

            if (ratio == 1) {

                Starling.juggler.tween(startup.loadingBitmap, 2.0, {
                    transition: Transitions.EASE_OUT,
                        delay: 1.0,
                        alpha: 0,
                        onComplete: function() {
                        startup.removeChild(startup.loadingBitmap);
                        // ninja = new Image(Root.assets.getTexture("ninja"));
                        // ninja.x = 100;
                        // ninja.y = 0;
                        // addChild(ninja);

                        Circle_placeholder = new Image(Root.assets.getTexture("Circle_placeholder"));
                        Circle_placeholder.x = 250;
                        Circle_placeholder.y = 250;
                        addChild(Circle_placeholder);

                        Paddle = new Image(Root.assets.getTexture("Paddle"));
                        Paddle.alignPivot();
                        Paddle.rotation = deg2rad(0);
                        Paddle.x = 325;
                        Paddle.y = 325;
                        addChild(Paddle);

                        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN,
                            function(event:KeyboardEvent) {
                                if (event.keyCode == Keyboard.LEFT) {
                                    var position = Paddle.rotation - deg2rad(6);
                                    Starling.juggler.tween(Paddle, 0.06, {
                                        transition: Transitions.LINEAR,
                                        rotation: position
                                        });
                                }
                                if (event.keyCode == Keyboard.RIGHT) {
                                    var position = Paddle.rotation + deg2rad(6);
                                    Starling.juggler.tween(Paddle, 0.06, {
                                        transition: Transitions.LINEAR,
                                        rotation: position
                                        });
                                }
                                // if (event.keyCode == Keyboard.LEFT) {
                                //     var position = Paddle.x - 1;
                                //     Starling.juggler.tween(Paddle, 0.06, {
                                //         transition: Transitions.LINEAR,
                                //         x: position
                                //         });   
                                // }  
                                // if (event.keyCode == Keyboard.RIGHT) {
                                //     var position = Paddle.x + 1;
                                //     Starling.juggler.tween(Paddle, 0.06, {
                                //         transition: Transitions.LINEAR,
                                //         x: position
                                //         });  
                                // }
                                // if (event.keyCode == Keyboard.DOWN) {
                                //     var position = Paddle.y + 1;
                                //     Starling.juggler.tween(Paddle, 0.06, {
                                //         transition: Transitions.LINEAR,
                                //         y: position
                                //         });    
                                // }
                                // if (event.keyCode == Keyboard.UP) {
                                //     var position = Paddle.y - 1;
                                //     Starling.juggler.tween(Paddle, 0.06, {
                                //         transition: Transitions.LINEAR,
                                //         y: position
                                //         });  
                                // }
                                // trace(Paddle.x);
                                // trace(Paddle.y);
                            }

                        // ninja.addEventListener(TouchEvent.TOUCH,
                        //     function(e:TouchEvent) {
                        //         var touch = e.getTouch(stage, TouchPhase.BEGAN);
                        //         if (touch == null) return;
                        //         });

                        // Starling.juggler.tween(ninja, 1.0, {
                        //     transition: Transitions.EASE_OUT_BOUNCE,
                        //         delay: 2.0,
                        //         y: 250
                        //         });

                        );

                    }
                    }
                    );
                }

        });
    }

}