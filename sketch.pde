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

IColor defaultFill = new IColor(26,26,26,255);
IColor defaultStroke = new IColor(255,255,255,255);

Spotlight[] light;
Tile[] dance;
DiscoBall ball;
Tail[] tail;
Cube[] cube;

Tile[] tailTile;
Tile[] lightTile;
Tile[] cubeTile;

void render() {
	if (timer.beat) println(song.position() + "," + (int)(currBeat+1));
}

void setSketch() {
	sphereDetail(12);
	front = new PVector(de*2,de,de*0.2);
	back = new PVector(-de*2,-de*1.2,-de);
	cam.ang.mass = 120;

	int row = 8;
	cube = new Cube[row*row];
	for (int i = 0 ; i < row*row ; ) {
		
	}

	row = 12;
	float W = 250;

	tail = new Tail[row];
	for (int i = 0 ; i < row ; i ++) {
		tail[i] = new Tail(((float)i-0.5*row)*W+W/2,-row*W/2,0, PI/2,0,0,100,30);
		for (int k = 0 ; k < tail[i].ar.length ; k ++) {
			tailTile[i*30+k] = tail[i].ar[k];
		}
		mobs.add(tail[i]);
	}

	dance = new Tile[row*row];

	for (int i = 0 ; i < row ; i ++) {
		for (int k = 0 ; k < row ; k ++) {
			dance[j] = new Tile(((float)i-0.5*row)*W+W/2,0,((float)k-0.5*row)*W+W/2, W);
			mobs.add(dance[j]);
		}
	}

	row = 7;
	float angX = -0.3;
	float w2 = 140;
	float D = 420;
	light = new Spotlight[row*3];
	lightTile = new Tile[row*3*9];
	int l = 0;

	for (int i = 0 ; i < row ; i ++) {
		light[l] = new Spotlight(((float)i-0.5*row)*D+D/2,back.y,-row*W, angX,0,0, w2);
		light[l].rang.reset(-PI/2,0,0);
		mobs.add(light[l]);
		for (int o = 0 ; o < 9 ; o ++) {
			lightTile[l*9+o] = light[l].ar[o];
		}
		l ++;
	}
	for (int i = 0 ; i < row ; i ++) {
		light[l] = new Spotlight(-row*W,back.y,((float)i-0.5*row)*D+D/2, angX,0,0, w2);
		light[l].rang.reset(-PI/2,0,PI/2);
		mobs.add(light[l]);
		for (int o = 0 ; o < 9 ; o ++) {
			lightTile[l*9+o] = light[l].ar[o];
		}
		l ++;
	}
	for (int i = 0 ; i < row ; i ++) {
		light[l] = new Spotlight(row*W,back.y,((float)i-0.5*row)*D+D/2, angX,0,0, w2);
		light[l].rang.reset(-PI/2,0,-PI/2);
		mobs.add(light[l]);
		for (int o = 0 ; o < 9 ; o ++) {
			lightTile[l*9+o] = light[l].ar[o];
		}
		l ++;
	}

	ball = new DiscoBall(0,back.y*1.1,0,200);
	mobs.add(ball);
}