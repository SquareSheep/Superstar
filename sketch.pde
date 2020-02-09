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

Spotlight[] light;
Tile[] floor;
DiscoBall ball;
Tail[] tails;

Tile[] tiles;
Tile[] lightTiles;

void render() {
	if (timer.beat) println(song.position() + "," + (int)currBeat);
	cam.ang.P.add(0.0002*cos((float)frameCount/100-PI/2),0.0003*sin((float)frameCount/100-PI/2),0);
	
	if (timer.beat) {
		cam.ang.p.x += 0.005;
		for (int i = 0 ; i < light.length ; i ++) {
			light[i].fillStyleSetC(125,255,25);
			light[i].fillStyleSetM(0,0,5);
			light[i].setIndex(random(binCount));
			if (random(1) < 0.2) {
				light[i].on = true;
				light[i].fillStyle.setC(225,255);
				light[i].av.P.set(random(-0.01,0.01),random(-0.01,0.01),0);
				light[i].ang.P.add(random(-0.5,0),0,random(-0.3,0.3));
			} else {
				light[i].on = false;
				light[i].homePosition();
				light[i].av.reset(0,0,0);
			}
		}

		for (int i = 0 ; i < floor.length ; i ++) {
			floor[i].fillStyle.setC(125,200);
			floor[i].fillStyle.setM(-10,10,random(binCount));
		}

		ball.beams(10);
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

	tiles = new Tile[row*row+7*3*9];
	floor = new Tile[row*row];

	int j = 0;
	for (int i = 0 ; i < row ; i ++) {
		for (int k = 0 ; k < row ; k ++) {
			floor[j] = new Tile(((float)i-0.5*row)*W+W/2,0,((float)k-0.5*row)*W+W/2, W);
			floor[j].w.setM(0,W*0.003,0,i*row+k);
			mobs.add(floor[j]);
			tiles[j] = floor[j];
			j++;
		}
	}

	row = 7;
	float angX = -0.3;
	float w2 = 140;
	float D = 420;
	light = new Spotlight[row*3];
	lightTiles = new Tile[row*3*9];
	int l = 0;

	for (int i = 0 ; i < row ; i ++) {
		light[l] = new Spotlight(((float)i-0.5*row)*D+D/2,back.y,-row*W, angX,0,0, w2);
		light[l].rang.reset(-PI/2,0,0);
		mobs.add(light[l]);
		for (int o = 0 ; o < 9 ; o ++) {
			lightTiles[l*9+o] = light[l].ar[o];
			tiles[j] = light[l].ar[o];
			j ++;
		}
		l ++;
	}
	for (int i = 0 ; i < row ; i ++) {
		light[l] = new Spotlight(-row*W,back.y,((float)i-0.5*row)*D+D/2, angX,0,0, w2);
		light[l].rang.reset(-PI/2,0,PI/2);
		mobs.add(light[l]);
		for (int o = 0 ; o < 9 ; o ++) {
			lightTiles[l*9+o] = light[l].ar[o];
			tiles[j] = light[l].ar[o];
			j ++;
		}
		l ++;
	}
	for (int i = 0 ; i < row ; i ++) {
		light[l] = new Spotlight(row*W,back.y,((float)i-0.5*row)*D+D/2, angX,0,0, w2);
		light[l].rang.reset(-PI/2,0,-PI/2);
		mobs.add(light[l]);
		for (int o = 0 ; o < 9 ; o ++) {
			lightTiles[l*9+o] = light[l].ar[o];
			tiles[j] = light[l].ar[o];
			j ++;
		}
		l ++;
	}

	ball = new DiscoBall(0,back.y*1.1,0,200);
	mobs.add(ball);
}