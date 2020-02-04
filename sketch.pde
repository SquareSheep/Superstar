static float bpm = 128;
static float beatInc = 1;
static int threshold = 100;
static int offset = 270;
static int binCount = 144;
static float defaultMass = 10;
static float defaultVMult = 0.5;
static float fillMass = 10;
static float fillVMult = 0.5;
static float fftThreshold = 1;
static float fftPow = 1.8;
static float fftAmp = 5;
static float volumeGain = -10;
static String songName = "../Music/superstar.mp3";

IColor defaultFill = new IColor(222,125,222,255);
IColor defaultStroke = new IColor(255,255,255,255);

void render() {
	if (timer.beat) println(song.position() + "," + (int)currBeat);
	cam.ang.P.y += 0.002;
	if (timer.beat) {
		for (int i = 0 ; i < mobs.size() ; i ++) {
			Tile tile = (Tile) mobs.get(i);
			tile.fillStyle.setC(random(75,255),random(75,255),random(75,255),255); 
			tile.setIndex(tile.fillStyle.index+2);
			if ((i+currBeat) % 2 == 0) {
				tile.fillStyle.setM(0.5,0.5,0.5,0);
			} else {
				tile.fillStyle.setM(-0.5,-0.5,-0.5,0);
			}
		}
		if (currBeat > 43) {
			for (int i = 0 ; i < 250 ; i ++) {
				Tile tile = (Tile)mobs.get((int)random(mobs.size()));
				if (random(1) > 0.5) {
					tile.ang.P.x += PI;
				} else {
					tile.ang.P.x -= PI;
				}
			}
		}
	}
}

void setSketch() {
	front = new PVector(de*2,de,de*0.2);
	back = new PVector(-de*2,-de,-de*2);

	int x = 25; int y = 25;
	float w = 150; float h = 15;
	for (float i = 0 ; i < x ; i ++) {
		for (float k = 0 ; k < y ; k ++) {
			Tile tile = new Tile((i-x/2)*w,h,(k-y/2)*w, w,h,w);
			tile.setIndex(i*x+k);
			tile.w.pm.y = h*0.03;
			mobs.add(tile);
		}
	}
}