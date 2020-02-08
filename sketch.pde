static float bpm = 128;
static float beatInc = 1;
static int threshold = 100;
static int offset = 270;
static int binCount = 144;
static float defaultMass = 5;
static float defaultVMult = 0.1;
static float fillMass = 10;
static float fillVMult = 0.5;
static float fftThreshold = 0.7;
static float fftPow = 1.9;
static float fftAmp = 3;
static float volumeGain = -10;
static String songName = "../Music/superstar.mp3";

IColor defaultFill = new IColor(222,125,222,255);
IColor defaultStroke = new IColor(255,255,255,255);

Spotlight[] lights;
Tile[] tiles;
DiscoBall ball;
Tail[] tails;

void render() {
	if (timer.beat) println(song.position() + "," + (int)currBeat);
	cam.ang.P.add(0.0002*cos((float)frameCount/100-PI/2),0.0003*sin((float)frameCount/100-PI/2),0);
	
	if (timer.beat) {
		cam.ang.p.x += 0.005;
		for (int i = 0 ; i < lights.length ; i ++) {
			lights[i].fillStyleSetC(125,255,25);
			lights[i].fillStyleSetM(0,0,5);
			lights[i].setIndex(random(binCount));
			if (random(1) < 0.2) {
				lights[i].on = true;
				lights[i].fillStyle.setC(225,255);
				lights[i].av.P.set(random(-0.01,0.01),random(-0.01,0.01),0);
				lights[i].ang.P.add(random(-0.5,0),0,random(-0.3,0.3));
			} else {
				lights[i].on = false;
				lights[i].homePosition();
				lights[i].av.reset(0,0,0);
			}
		}

		for (int i = 0 ; i < tiles.length ; i ++) {
			tiles[i].fillStyle.setC(125,200);
			tiles[i].fillStyle.setM(-10,10,random(binCount));
		}
	}
}

void setSketch() {
	sphereDetail(12);
	front = new PVector(de*2,de,de*0.2);
	back = new PVector(-de*2,-de*1.2,-de);
	
	int num = 10;
	float d = de*0.4;

	int row = 12;
	float W = 250;
	tiles = new Tile[row*row];
	for (int i = 0 ; i < row ; i ++) {
		for (int k = 0 ; k < row ; k ++) {
			tiles[i*row+k] = new Tile(((float)i-0.5*row)*W+W/2,0,((float)k-0.5*row)*W+W/2, W);
			tiles[i*row+k].w.setM(0,W*0.003,0,i*row+k);
			mobs.add(tiles[i*row+k]);
		}
	}

	row = 7;
	float angX = -0.3;
	float w2 = 140;
	float D = 420;
	lights = new Spotlight[row*3];
	for (int i = 0 ; i < row ; i ++) {
		lights[i] = new Spotlight(((float)i-0.5*row)*D+D/2,back.y,-row*W, angX,0,0, w2);
		lights[i].rang.reset(-PI/2,0,0);
		//lights[i+row] = new Spotlight(((float)i-0.5*row)*D+D/2,back.y,row*W, angX,0,0, w2);
		//lights[i+row].rang.reset(-PI/2,0,PI);
		lights[i+row] = new Spotlight(-row*W,back.y,((float)i-0.5*row)*D+D/2, angX,0,0, w2);
		lights[i+row].rang.reset(-PI/2,0,PI/2);
		lights[i+row*2] = new Spotlight(row*W,back.y,((float)i-0.5*row)*D+D/2, angX,0,0, w2);
		lights[i+row*2].rang.reset(-PI/2,0,-PI/2);
		mobs.add(lights[i]);
		mobs.add(lights[i+row]);
		mobs.add(lights[i+row+row]);
	}

	for (int i = 0 ; i < row ; i ++) {
		
	}

	ball = new DiscoBall(0,back.y*1.1,0,200);
	mobs.add(ball);
}