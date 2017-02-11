﻿package {
	import flash.media.SoundChannel;
	import flash.media.SoundMixer; 
	import flash.media.SoundTransform;
	
		
		private var rock2:Array;
		
		private var heartIcons:Array;
		private var levelDisplay:TextField;
		private var destinationX:int;
		private var destinationY:int;
		private var Meter: Array;
			
			createHUD();
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			
			
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
			
			
		}
		
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
			scoreObjects.addChild(scoreDisplay);
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
		}
			if(gameScore<10){
				scoreDisplay.text=String("00000"+gameScore);
			}else if(gameScore<100){
				scoreDisplay.text=String("0000"+ gameScore);
			}else if(gameScore<1000){
				scoreDisplay.text=String("000"+gameScore);
			}else {
				scoreDisplay.text=String("00"+gameScore);
			}
			
		public function updateLevel(){
			levelDisplay.text=String(gameLevel);
		}
		public function removeHeartIcon() {
			scoreObjects.removeChild(heartIcons.pop());
		}
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
			}
			var trans:SoundTransform = new SoundTransform(0.3, 0);
			var channel:SoundChannel=(new Explosion()).play();
			channel.soundTransform=trans;
			var trans:SoundTransform = new SoundTransform(0.3, 0);
			var channel:SoundChannel=(new fire()).play();
			channel.soundTransform=trans;
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
					
					
					var dx:Number = rocks[j].rock.x - missiles[i].x;
					var dy:Number = rocks[j].rock.y - missiles[i].y;
					var dist:Number = Math.sqrt(dx*dx + dy*dy);
					if(dist<rocks[j].rockRadius){
						var dx:Number = rocks[j].rock.x - ship.x;
						var dy:Number = rocks[j].rock.y - ship.y;
						var dist:Number = Math.sqrt(dx*dx + dy*dy);
						if(dist<rocks[j].rockRadius){
				updateLevel();
		
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
	
			stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);