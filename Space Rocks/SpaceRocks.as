package {	import flash.display.*;	import flash.events.*;	import flash.text.*;	import flash.utils.getTimer;	import flash.utils.Timer;	import flash.geom.Point;	import com.adobe.tvsdk.mediacore.TextFormat;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer; 
	import flash.media.SoundTransform;
		public class SpaceRocks extends MovieClip {		static const shipRotationSpeed:Number = .1;		static const rockSpeedStart:Number = .03;		static const rockSpeedIncrease:Number = .02;		static const missileSpeed:Number = .2;		static const thrustPower:Number = .15;		static const shipRadius:Number = 20;		static const startingShips:uint = 3;
					// game objects		private var ship:Ship;		private var rocks:Array;		private var missiles:Array;		private var rock1:Array;
		private var rock2:Array;		// animation timer		private var lastTime:uint;				// arrow keys		private var rightArrow:Boolean = false;		private var leftArrow:Boolean = false;		private var upArrow:Boolean = false;				// ship velocity		private var shipMoveX:Number;		private var shipMoveY:Number;		private var playerSpeed:Number = 10;
				// timers		private var delayTimer:Timer;		private var shieldTimer:Timer;				// game mode		private var gameMode:String;		private var shieldOn:Boolean;				// ships and shields		private var shipsLeft:uint;		private var shieldsLeft:uint;		private var shipIcons:Array;
		private var heartIcons:Array;		private var shieldIcons:Array;		private var scoreDisplay:TextField;
		private var levelDisplay:TextField;
		private var destinationX:int;
		private var destinationY:int;		// score and level		private var gameScore:Number;		private var gameLevel:uint;
		private var Meter: Array;		// sprites		private var gameObjects:Sprite;		private var scoreObjects:Sprite;						// start the game		public function startSpaceRocks() {			// set up sprites			gameObjects = new Sprite();			addChild(gameObjects);			scoreObjects = new Sprite();			addChild(scoreObjects);						// reset score objects			gameLevel = 1;			shipsLeft = startingShips;			gameScore = 0;			//createShipIcons();
			
			createHUD();									// set up listeners
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			
						addEventListener(Event.ENTER_FRAME,moveGameObjects);			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpFunction);						// start 			gameMode = "delay";			shieldOn = false;			missiles = new Array();			nextRockWave(null);			newShip(null);		}						// SCORE OBJECTS		
		public function createHUD(){
			createHeartIcons();
			createScoreDisplay();
			createLevelDisplay();
			createMeter();
		}
		public function createHeartIcons() {
			heartIcons = new Array();
			for(var i:uint=0;i<shipsLeft;i++) {
				var newHeart:Heart = new Heart();
				newHeart.x=180+i*15;
				newHeart.y=15;
				scoreObjects.addChild(newHeart);
				heartIcons.push(newHeart);
			}
		}
		public function createMeter(){
			Meter = new Array();
			var newMeter:gameMeter=new gameMeter();
			newMeter.x=131;
			newMeter.y=50;
			scoreObjects.addChild(newMeter);
			
			
		}				// draw number of shields left		public function createShieldIcons() {			shieldIcons = new Array();			for(var i:uint=0;i<shieldsLeft;i++) {				var newShield:ShieldIcon = new ShieldIcon();				newShield.x = 200-i*15;				newShield.y = 80;				scoreObjects.addChild(newShield);				shieldIcons.push(newShield);			}		}
						// put the numerical score at the upper right		public function createScoreDisplay() {
			scoreDisplay = new TextField();
			scoreDisplay.x = 105;
			scoreDisplay.y = 25;
			scoreDisplay.width = 120.5;
			scoreDisplay.height=35;
			scoreDisplay.selectable = false;
			var scoreDisplayFormat = new TextFormat();
			scoreDisplayFormat.color = 0xFFFFFF;
			scoreDisplayFormat.font = "Century Gothic";
			scoreDisplayFormat.align = "center";
			scoreDisplayFormat.size=30;
			scoreDisplay.defaultTextFormat = scoreDisplayFormat;
			scoreObjects.addChild(scoreDisplay);			updateScore();		}
		public function createLevelDisplay() {
			levelDisplay=new TextField();
			levelDisplay.x= 38;
			levelDisplay.y= 23;
			levelDisplay.width= 20;
			levelDisplay.height=35;
			levelDisplay.selectable=false;
			var levelDisplayFormat=new TextFormat();
			levelDisplayFormat.color = 0xFFFFFF;
			levelDisplayFormat.font = "Century Gothic";
			levelDisplayFormat.align = "center";
			levelDisplayFormat.size=30;
			levelDisplay.defaultTextFormat=levelDisplayFormat;
			scoreObjects.addChild(levelDisplay);
			updateLevel();
		}				// new score to show		public function updateScore() {
			if(gameScore<10){
				scoreDisplay.text=String("00000"+gameScore);
			}else if(gameScore<100){
				scoreDisplay.text=String("0000"+ gameScore);
			}else if(gameScore<1000){
				scoreDisplay.text=String("000"+gameScore);
			}else {
				scoreDisplay.text=String("00"+gameScore);
			}
					}
		public function updateLevel(){
			levelDisplay.text=String(gameLevel);
		}				// remove a ship icon		public function removeShipIcon() {			scoreObjects.removeChild(shipIcons.pop());		}
		public function removeHeartIcon() {
			scoreObjects.removeChild(heartIcons.pop());
		}				// remove a shield icon		public function removeShieldIcon() {			scoreObjects.removeChild(shieldIcons.pop());		}				// remove the rest of the ship icons		public function removeAllShipIcons() {			while (shipIcons.length > 0) {				removeHeartIcon();			}		}				// remove the rest of the shield icons		public function removeAllShieldIcons() {			while (shieldIcons.length > 0) {				removeShieldIcon();			}		}						// SHIP CREATION AND MOVEMENT				// create a new ship		public function newShip(event:TimerEvent) {			// if ship exists, remove it			if (ship != null) {				gameObjects.removeChild(ship);				ship = null;			}						// no more ships			if (shipsLeft < 1) {				endGame();				return;			}						// create, position, and add new ship			ship = new Ship();			ship.gotoAndStop(1);			ship.x = 275;			ship.y = 200;			ship.rotation = -90;			ship.shield.visible = false;			gameObjects.addChild(ship);						// set up ship properties			shipMoveX = 0.0;			shipMoveY = 0.0;			gameMode = "play";						// set up shields			shieldsLeft = 3;			createShieldIcons();						// all lives but the first start with a free shield			if (shipsLeft != startingShips) {				startShield(true);			}		}
		public function enterFrameHandler(event:Event){
			rotatechar();
			
			destinationX = stage.mouseX;
			destinationY = stage.mouseY;
 
			ship.x += (destinationX - (ship.x+15)) / playerSpeed;
			ship.y += (destinationY - (ship.y+15)) / playerSpeed;
 
			
			}
		public function rotatechar() {
			var radians:Number = Math.atan2(destinationY - ship.y, destinationX - ship.x);
			var degrees:Number = radians / (Math.PI / 180) + 90;
			ship.rotation = degrees;
			ship.rotation=Math.atan2(mouseY - (ship.y+10), mouseX - (ship.x+10)) * 180 / Math.PI;
			}				// register key presses		public function keyDownFunction(event:KeyboardEvent) {			if (event.keyCode == 37) {					leftArrow = true;			} else if (event.keyCode == 39) {					rightArrow = true;			} else if (event.keyCode == 38) {					upArrow = true;					// show thruster					if (gameMode == "play") ship.gotoAndStop(2);			} else if (event.keyCode == 32) { // space					newMissile();			} else if (event.keyCode == 90) { // z					startShield(false);			}		}					// register key ups		public function keyUpFunction(event:KeyboardEvent) {			if (event.keyCode == 37) {				leftArrow = false;			} else if (event.keyCode == 39) {				rightArrow = false;			} else if (event.keyCode == 38) {				upArrow = false;				// remove thruster				if (gameMode == "play") ship.gotoAndStop(1);			}		}				// animate ship		public function moveShip(timeDiff:uint) {						// rotate and thrust			if (leftArrow) {				ship.rotation -= shipRotationSpeed*timeDiff;			} else if (rightArrow) {				ship.rotation += shipRotationSpeed*timeDiff;			} else if (upArrow) {				shipMoveX += Math.cos(Math.PI*ship.rotation/180)*thrustPower;				shipMoveY += Math.sin(Math.PI*ship.rotation/180)*thrustPower;			}						// move			ship.x += shipMoveX;			ship.y += shipMoveY;						// wrap around screen			if ((shipMoveX > 0) && (ship.x > 570)) {				ship.x -= 590;			}			if ((shipMoveX < 0) && (ship.x < -20)) {				ship.x += 590;			}			if ((shipMoveY > 0) && (ship.y > 420)) {				ship.y -= 440;			}			if ((shipMoveY < 0) && (ship.y < -20)) {				ship.y += 440;			}		}				// remove ship		public function shipHit() {			gameMode = "delay";			ship.gotoAndPlay("explode");			removeAllShieldIcons();			delayTimer = new Timer(2000,1);			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,newShip);			delayTimer.start();			removeHeartIcon();			shipsLeft--;		}				// turn on shield for 3 seconds		public function startShield(freeShield:Boolean) {			if (shieldsLeft < 1) return; // no shields left			if (shieldOn) return; // shield already on						// turn on shield and set timer to turn off			ship.shield.visible = true;			shieldTimer = new Timer(3000,1);			shieldTimer.addEventListener(TimerEvent.TIMER_COMPLETE,endShield);			shieldTimer.start();						// update shields remaining			if (!freeShield) {				removeShieldIcon();				shieldsLeft--;			}			shieldOn = true;		}				// turn off shield		public function endShield(event:TimerEvent) {			ship.shield.visible = false;			shieldOn = false;		}				// ROCKS						// create a single rock of a specific size		public function newRock(x,y:int, rockType:String) {						// create appropriate new class			var newRock:MovieClip;			var rockRadius:Number;			if (rockType == "Big") {				newRock = new Rock_Big();				rockRadius = 35;			} else if (rockType == "Medium") {				newRock = new Rock_Medium();				rockRadius = 20;			} else if (rockType == "Small") {				newRock = new Rock_Small();				rockRadius = 10;			}						// Here is an alternate way to do the above, without a case statement			// Need to import flash.utils.getDefinitionByName to use			/*			var rockClass:Object = getDefinitionByName("Rock_"+rockType);			var newRock:MovieClip = new rockClass();			*/						// choose a random look			newRock.gotoAndStop(Math.ceil(Math.random()*3));						// set start position			newRock.x = x;			newRock.y = y;						// set random movement and rotation			var dx:Number = Math.random()*2.0-1.0;			var dy:Number = Math.random()*2.0-1.0;			var dr:Number = Math.random();						// add to stage and to rocks list			gameObjects.addChild(newRock);			rocks.push({rock:newRock, dx:dx, dy:dy, dr:dr, rockType:rockType, rockRadius: rockRadius});		}				// create four rocks		public function nextRockWave(event:TimerEvent) {			rocks = new Array();			newRock(100,100,"Big");			newRock(100,300,"Big");			newRock(450,100,"Big");			newRock(450,300,"Big");			gameMode = "play";		}				// animate all rocks		public function moveRocks(timeDiff:uint) {			for(var i:int=rocks.length-1;i>=0;i--) {								// move the rocks				var rockSpeed:Number = rockSpeedStart + rockSpeedIncrease*gameLevel;				rocks[i].rock.x += rocks[i].dx*timeDiff*rockSpeed;				rocks[i].rock.y += rocks[i].dy*timeDiff*rockSpeed;								// rotate rocks				rocks[i].rock.rotation += rocks[i].dr*timeDiff*rockSpeed;								// wrap rocks				if ((rocks[i].dx > 0) && (rocks[i].rock.x > 570)) {					rocks[i].rock.x -= 590;				}				if ((rocks[i].dx < 0) && (rocks[i].rock.x < -20)) {					rocks[i].rock.x += 590;				}				if ((rocks[i].dy > 0) && (rocks[i].rock.y > 420)) {					rocks[i].rock.y -= 440;				}				if ((rocks[i].dy < 0) && (rocks[i].rock.y < -20)) {					rocks[i].rock.y += 440;				}			}		}				public function rockHit(rockNum:uint) {			// create two smaller rocks
			var trans:SoundTransform = new SoundTransform(0.3, 0);
			var channel:SoundChannel=(new Explosion()).play();
			channel.soundTransform=trans;			if (rocks[rockNum].rockType == "Big") {				newRock(rocks[rockNum].rock.x,rocks[rockNum].rock.y,"Medium");				newRock(rocks[rockNum].rock.x,rocks[rockNum].rock.y,"Medium");			} else if (rocks[rockNum].rockType == "Medium") {				newRock(rocks[rockNum].rock.x,rocks[rockNum].rock.y,"Small");				newRock(rocks[rockNum].rock.x,rocks[rockNum].rock.y,"Small");			}			// remove original rock			gameObjects.removeChild(rocks[rockNum].rock);			rocks.splice(rockNum,1);		}				// MISSILES				// create a new Missile		public function newMissile() {			// create			var newMissile:Missile = new Missile();						// set direction			newMissile.dx = Math.cos(Math.PI*ship.rotation/180);			newMissile.dy = Math.sin(Math.PI*ship.rotation/180);						// placement			newMissile.x = ship.x + newMissile.dx*shipRadius;			newMissile.y = ship.y + newMissile.dy*shipRadius;				// add to stage and array			gameObjects.addChild(newMissile);			missiles.push(newMissile);
			var trans:SoundTransform = new SoundTransform(0.3, 0);
			var channel:SoundChannel=(new fire()).play();
			channel.soundTransform=trans;		}				// animate missiles		public function moveMissiles(timeDiff:uint) {			for(var i:int=missiles.length-1;i>=0;i--) {				// move				missiles[i].x += missiles[i].dx*missileSpeed*timeDiff;				missiles[i].y += missiles[i].dy*missileSpeed*timeDiff;				// moved off screen				if ((missiles[i].x < 0) || (missiles[i].x > 550) || (missiles[i].y < 0) || (missiles[i].y > 400)) {					gameObjects.removeChild(missiles[i]);					delete missiles[i];					missiles.splice(i,1);				}			}		}					// remove a missile		public function missileHit(missileNum:uint) {			gameObjects.removeChild(missiles[missileNum]);			missiles.splice(missileNum,1);		}				// GAME INTERACTION AND CONTROL				public function moveGameObjects(event:Event) {			// get timer difference and animate			var timePassed:uint = getTimer() - lastTime;			lastTime += timePassed;			moveRocks(timePassed);			if (gameMode != "delay") {				moveShip(timePassed);			}			moveMissiles(timePassed);			checkCollisions();		}				// look for missiles colliding with rocks		public function checkCollisions() {			// loop through rocks
			//rockBounce();
			/*rockloop1: for(var j:int=rocks.length-1;j>=0;j--){
				rockloop2: for(var i:int=j-1;i>=0;i--){
					rock1.x += rocks[j].rock.x;
					rock1.y += rocks[j].rock.y;
					rock2.x += rocks[i].rock.x;
					rock2.y += rocks[i].rock.y;
					rockBounce(rock1, rock2);
				}
			}*/
								rockloop: for(var j:int=rocks.length-1;j>=0;j--) {				// loop through missiles				missileloop: for(var i:int=missiles.length-1;i>=0;i--) {					// collision detection 
					
					var dx:Number = rocks[j].rock.x - missiles[i].x;
					var dy:Number = rocks[j].rock.y - missiles[i].y;
					var dist:Number = Math.sqrt(dx*dx + dy*dy);					/*if (Point.distance(new Point(rocks[j].rock.x,rocks[j].rock.y),							new Point(missiles[i].x,missiles[i].y))								< rocks[j].rockRadius)*/ 
					if(dist<rocks[j].rockRadius){												// remove rock and missile						rockHit(j);						missileHit(i);												// add score						gameScore += 10;						updateScore();												// break out of this loop and continue next one						continue rockloop;					}				}								// check for rock hitting ship				if (gameMode == "play") {					if (shieldOn == false) { // only if shield is off						/*if (Point.distance(new Point(rocks[j].rock.x,rocks[j].rock.y),								new Point(ship.x,ship.y))									< rocks[j].rockRadius+shipRadius)*/ 
						var dx:Number = rocks[j].rock.x - ship.x;
						var dy:Number = rocks[j].rock.y - ship.y;
						var dist:Number = Math.sqrt(dx*dx + dy*dy);
						if(dist<rocks[j].rockRadius){														// remove ship and rock							shipHit();							rockHit(j);						}					}				}			}						// all out of rocks, change game mode and trigger more			if ((rocks.length == 0) && (gameMode == "play")) {				gameMode = "betweenlevels";				gameLevel++; // advance a level
				updateLevel();				delayTimer = new Timer(2000,1);				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,nextRockWave);				delayTimer.start();			}		}
		
		//private function rockBounce(rock1:Array, rock2:Array):void
		//{
		//	var dx:Number = rock2.x - rock1.x;
		//	var dy:Number = rock2.y - rock1.y;
		//	var dist:Number = Math.sqrt(dx*dx + dy*dy);
		//	if(dist < rock1.width / 2 + rock2.width / 2)
		//	{
		//		// calculate angle, sine and cosine
		//		var angle:Number = Math.atan2(dy, dx);
		//		var sin:Number = Math.sin(angle);
		//		var cos:Number = Math.cos(angle);
		//		
		//		// rotate rock1's position
		//		var pos0:Point = new Point(0, 0);
		//		
		//		// rotate rock2's position
		//		var pos1:Point = rotate(dx, dy, sin, cos, true);
		//		
		//		// rotate rock1's velocity
		//		var vel0:Point = rotate(rock1.vx,
		//								rock1.vy,
		//								sin,
		//								cos,
		//								true);
		//		
		//		// rotate rock2's velocity
		//		var vel1:Point = rotate(rock2.vx,
		//								rock2.vy,
		//								sin,
		//								cos,
		//								true);
		//		
		//		// collision reaction
		//		var vxTotal:Number = vel0.x - vel1.x;
		//		vel0.x = ((rock1.mass - rock2.mass) * vel0.x + 
		//		          2 * rock2.mass * vel1.x) / 
		//		          (rock1.mass + rock2.mass);
		//		vel1.x = vxTotal + vel0.x;

		//		// update position
		//		pos0.x += vel0.x;
		//		pos1.x += vel1.x;
		//		
		//		// rotate positions back
		//		var pos0F:Object = rotate(pos0.x,
		//								  pos0.y,
		//								  sin,
		//								  cos,
		//								  false);
		//								  
		//		var pos1F:Object = rotate(pos1.x,
		//								  pos1.y,
		//								  sin,
		//								  cos,
		//								  false);

		//		// adjust positions to actual screen positions
		//		rock2.x = rock1.x + pos1F.x;
		//		rock2.y = rock1.y + pos1F.y;
		//		rock1.x = rock1.x + pos0F.x;
		//		rock1.y = rock1.y + pos0F.y;
		//		
		//		// rotate velocities back
		//		var vel0F:Object = rotate(vel0.x,
		//								  vel0.y,
		//								  sin,
		//								  cos,
		//								  false);
		//		var vel1F:Object = rotate(vel1.x,
		//								  vel1.y,
		//								  sin,
		//								  cos,
		//								  false);
		//		rock1.vx = vel0F.x;
		//		rock1.vy = vel0F.y;
		//		rock2.vx = vel1F.x;
		//		rock2.vy = vel1F.y;
		//	}
		//}
		//
		////coordinate rotation
		//private function rotate(x:Number,
		//						y:Number,
		//						sin:Number,
		//						cos:Number,
		//						reverse:Boolean):Point
		//{
		//	var result:Point = new Point();
		//	if(reverse)
		//	{
		//		result.x = x * cos + y * sin;
		//		result.y = y * cos - x * sin;
		//	}
		//	else
		//	{
		//		result.x = x * cos - y * sin;
		//		result.y = y * cos + x * sin;
		//	}
		//	return result;
		//}		
				public function endGame() {			// remove all objects and listeners			removeChild(gameObjects);			removeChild(scoreObjects);			gameObjects = null;			scoreObjects = null;			removeEventListener(Event.ENTER_FRAME,moveGameObjects);
			stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpFunction);						gotoAndStop("gameover");		}			}}			