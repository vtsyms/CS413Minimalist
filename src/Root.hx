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

import starling.events.Event;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;


class Root extends Sprite {

    public static var assets:AssetManager;
    public var background:Image;
    public var paddle:Image;
    public var dart:Image;
    public var target:Image;
    public var middle:Image;
    public var gameover:Image;
    public var startTime:Float; //used for scoring system
    public var currentTime:Float; //stores current time
    public var previousTime:Float; //used for dart creation
    public var timer = haxe.Timer;
    public var scoreField:TextField; 
    public var paddleAngle:Float = 0;
    public var moveSpeed:Int = 20;
    public var paddleX:Float;
    public var paddleY:Float;
    public var butt:Image;
    public var ran = Math.random();
    public function new() {
        super();
    }

    public static function deg2rad(deg:Int){
        return deg / 180.0 * Math.PI;
    }

    public function findAng(posx:Float, posy:Float){
        if (posy == 0 && posx != 0) {
            if (posx > 325){
                return -1.0 * Math.atan(325.0/(posx-325.0));       
            }
            else if (posx < 325){
                return deg2rad(-180) + (1.0 * Math.atan(325.0/(325.0-posx)));
            }
            else {
                return 1.0 * deg2rad(-90);
            }
        }
        else if (posy == 650 && posx != 0) {
            if (posx > 325){
                return (1.0 * Math.atan(325.0/(posx-325.0)));
            }
            else if (posx < 325){
                return deg2rad(180) - (1.0 * Math.atan(325.0/(325.0-posx)));
            }
            else {
                return 1.0 * deg2rad(90);
            }
        }
        else if (posy != 0 && posx == 0) {
            if (posy > 325){
                return deg2rad(90) + (1.0 * Math.atan(325.0/(posy - 325.0)));
            }
            else if (posy < 325){
                return deg2rad(-90) - (1.0 * Math.atan(325.0/(325.0-posy)));          
            }
            else {
                return deg2rad(180);
            }
        }
        else if (posy != 0 && posx == 650) {
            if (posy > 325){
                return deg2rad(90) - (1.0 * Math.atan(325.0/(posy - 325.0)));      
            }
            else if (posy < 325){
                return deg2rad(-90) + (1.0 * Math.atan(325.0/(325.0-posy)));      
            }
            else {
                return deg2rad(0);
            }
        }
        else {
            return 0;
        }
    }

    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/background.png");
        assets.enqueue("assets/paddle.png");
        assets.enqueue("assets/dart1.png");
        assets.enqueue("assets/dart2.png");
        assets.enqueue("assets/dart3.png");
        assets.enqueue("assets/target.png");
        assets.enqueue("assets/gameover.png");
        assets.enqueue("assets/middle.png");
        assets.enqueue("assets/ready.png");
        assets.loadQueue(function onProgress(ratio:Float) {

            if (ratio == 1) {

                Starling.juggler.tween(startup.loadingBitmap, 2.0, {
                    transition: Transitions.EASE_OUT,
                        delay: 1.0,
                        alpha: 0,
                        onComplete: function() {
                        startup.removeChild(startup.loadingBitmap);

                        background = new Image(Root.assets.getTexture("background"));
                        background.x = 0;
                        background.y = 0;
                        addChild(background);

                        target = new Image(Root.assets.getTexture("target"));
                        target.x = 275;
                        target.y = 275;
                        addChild(target);

                        middle = new Image(Root.assets.getTexture("middle"));
                        middle.x = 325;
                        middle.y = 325;
                        addChild(middle);

                        //trace(ran);
                         butt = new Image(Root.assets.getTexture("ready"));
                        butt.x = -25;
                        butt.y = -90;
                        addChild(butt);

                        // The button listner is looking for the READY? button to be pressed. Once pressed it deletes
                        // itself and then runs the rest of the games code.
                        butt.addEventListener(TouchEvent.TOUCH,
                                function(e:TouchEvent){
                                    
                                    var touch = e.getTouch(stage, TouchPhase.BEGAN);
                                    // checkis if the button hovered over or if it was clicked.
                                    if (touch == null) return;
                                    //trace("Game Start");
                                    // removes the button from the screen.
                                    removeChild(butt);


                        paddle = new Image(Root.assets.getTexture("paddle"));
                        paddle.alignPivot();
                        paddle.rotation = deg2rad(-90);
                        paddle.x = 325 - 70*Math.cos(paddleAngle);
                        paddle.y = 325 - 70*Math.sin(paddleAngle);
                        addChild(paddle);

                        scoreField = new TextField(100, 100, "Score: 0");
                        scoreField.hAlign = HAlign.LEFT;
                        scoreField.vAlign = VAlign.TOP;
                        addChild(scoreField);

                        previousTime = timer.stamp();
                        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN,
                            function(event:KeyboardEvent) {
                                if (event.keyCode == Keyboard.LEFT) {
                                    paddleAngle -= deg2rad(1)*moveSpeed;                             
                                    paddleX =325 - 70*Math.cos(paddleAngle);
                                    paddleY =325 - 70*Math.sin(paddleAngle);                                    
                                    var position = paddle.rotation - deg2rad(moveSpeed);
                                    Starling.juggler.tween(paddle, 0.00, {
                                        transition: Transitions.LINEAR,
                                        rotation: position,
                                        x: paddleX,
                                        y: paddleY
                                        });
                                }
                                if (event.keyCode == Keyboard.RIGHT) {
                                    paddleAngle += deg2rad(1)*moveSpeed;
                                    paddleX =325 - 70*Math.cos(paddleAngle);
                                    paddleY = 325 - 70*Math.sin(paddleAngle);
                                    var position = paddle.rotation + deg2rad(moveSpeed);
                                    Starling.juggler.tween(paddle, 0.00, {
                                        transition: Transitions.LINEAR,
                                        rotation: position,
                                        x: paddleX,
                                        y: paddleY
                                        });
                                }

                            }

                        );

                    startTime = timer.stamp();

                    Starling.current.stage.addEventListener(Event.ENTER_FRAME, function(event:Event){
                    
                        currentTime = timer.stamp();
                        var score = Std.int((currentTime-startTime)*100);
                        scoreField.text = "Score: " + score;

                        if(currentTime-previousTime >= 3){  //if enough time has passed between darts, will spawn a new dart

                            ran = Math.random();
                            ran = ran*10;

                            //trace(ran);
                            // This section randomly assigns an image to dart
                            // this allows for a variety of darts to fly at the player
                            if ( ran < 4)                         dart = new Image(Root.assets.getTexture("dart1"));
                            else if (ran > 3 && ran < 7)          dart = new Image(Root.assets.getTexture("dart2"));
                            else if ( ran > 6)                    dart = new Image(Root.assets.getTexture("dart3"));
                            //dart = new Image(Root.asset.getTexture("dart"));
                            
                            var startingWall = Math.random(); //determines if which wall the dart shows up at
                            if(startingWall < .25){  //spawns dart on left wall
                                dart.x = 0;
                                dart.y = Math.random() * 650;
                            }
                            else if(startingWall < .50){ //spawns dart on right wall
                                dart.x = 650;
                                dart.y = Math.random() * 650;
                            }
                            else if (startingWall < .75){ //spawns dart on top wall
                                dart.x = Math.random() * 650;
                                dart.y = 0;
                            }
                            else{
                                dart.x = Math.random() * 650; //spawns dart on bottom wall
                                dart.y = 650;
                            }
                            dart.pivotY = dart.width / 2;
                            dart.rotation = findAng(dart.x, dart.y);
                            addChild(dart);
                            previousTime = currentTime;

                            Starling.juggler.tween(dart, 2, {
                                delay: 1.0,
                                transition: Transitions.LINEAR,
                                y: 325,
                                x: 325
                            });
                           
                        }

                      

                    Starling.current.stage.addEventListener(Event.ENTER_FRAME, function(event:Event){
                    	if (dart != null){
	                        var bounds1 = dart.bounds;
	                        var bounds2 = paddle.bounds;
	                        var bounds3 = middle.bounds;
	                        if(bounds1.intersects(bounds2)){
	                            removeChild(dart);
	                        }
	                        else if(bounds1.intersects(bounds3)){
	                            gameover = new Image(Root.assets.getTexture("gameover"));
	                            gameover.x = 0;
	                            gameover.y = 0;
	                            removeChildren();
	                            addChild(gameover);
	                            addChild(scoreField);
	                            Starling.current.stage.removeEventListeners(Event.ENTER_FRAME);
	                            Starling.current.stage.removeEventListeners(KeyboardEvent.KEY_DOWN);
	                        }
	                    }
                    }); 

                        }); 

             }); // ending to the start game Event listener.                    

                }

                });

            }

        });
    } 

           

}