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

float W = 150;
int R = 5;
float amp = 0.1;
void render() {
	noFill();
	defaultStroke.strokeStyle();
	box(W*R*2+W,W*R*2+W,W*R*2+W);
	if (timer.beat) println(song.position() + "," + (int)currBeat);
	cam.ang.P.y -= 0.003;
	if (timer.beat) {
		float sc = 200;
		for (int i = 0 ; i < mobs.size() ; i ++) {
			Cube cube = (Cube) mobs.get(i);
			cube.sca.x += 0.1;
			if (random(1) < 0.2) cube.p.P.set(W*(int)random(-R,R),W*(int)random(-R,R),W*(int)random(-R,R));
			if (random(1) < 0.2) cube.ang.P.set(((int)random(3))*PI/2,((int)random(3))*PI/2,((int)random(3))*PI/2);
			cube.fillStyleSetC(random(75,255),random(75,255),random(75,255),255, 
				random(-sc,sc),random(-sc,sc),random(-sc,sc),0); 
			for (int k = 0 ; k < cube.tiles.length ; k ++) {
				cube.tiles[k].w.p.y += cube.tiles[k].w.p.x*0.1;
			}
			if ((i+currBeat) % 2 == 0) {
				cube.fillStyleSetM(amp,amp,amp,-0.25,random(-amp,amp),random(-amp,amp),random(-amp,amp),0);
			} else {
				cube.fillStyleSetM(-amp,-amp,-amp,-0.25,random(-amp,amp),random(-amp,amp),random(-amp,amp),0);
			}
			if (currBeat % 2 == 0) {
				if (cube.p.p.x < 0) {
					if (cube.p.P.y < W*R) cube.p.P.y += cube.w;
				} else {
					if (cube.p.P.y > -W*R) cube.p.P.y -= cube.w;
				}
			} else {
				if (cube.p.p.x < 0) {
					if (cube.p.P.y > -W*R) cube.p.P.y -= cube.w;
				} else {
					if (cube.p.P.y < W*R) cube.p.P.y += cube.w;
				}
			}
		}
		// for (int i = 0 ; i < mobs.size() ; i ++) {
		// 	Tile tile = (Tile) mobs.get(i);
		// 	tile.fillStyle.setC(random(75,255),random(75,255),random(75,255),255); 
		// 	tile.setIndex(tile.fillStyle.index+2);
		// 	if ((i+currBeat) % 2 == 0) {
		// 		tile.fillStyle.setM(0.5,0.5,0.5,0);
		// 	} else {
		// 		tile.fillStyle.setM(-0.5,-0.5,-0.5,0);
		// 	}
		// }
		// if (currBeat > 43) {
		// 	for (int i = 0 ; i < 250 ; i ++) {
		// 		Tile tile = (Tile)mobs.get((int)random(mobs.size()));
		// 		if (random(1) > 0.5) {
		// 			tile.ang.P.x += PI;
		// 		} else {
		// 			tile.ang.P.x -= PI;
		// 		}
		// 	}
		// }
	}
}

void setSketch() {
	front = new PVector(de*2,de,de*0.2);
	back = new PVector(-de*2,-de,-de*2);

	// int x = 25; int y = 25;
	// float w = 150; float h = 15;
	// for (float i = 0 ; i < x ; i ++) {
	// 	for (float k = 0 ; k < y ; k ++) {
	// 		Tile tile = new Tile((i-x/2)*w,h,(k-y/2)*w, w,h,w);
	// 		tile.setIndex(i*x+k);
	// 		tile.w.pm.y = h*0.03;
	// 		mobs.add(tile);
	// 	}
	// }
	for (int i = 0 ; i < 35 ; i ++) {
		Cube cube = new Cube(random(-R,R)*W,random(-R,R)*W,random(-R,R)*W,W);
		for (int k = 0 ; k < cube.tiles.length ; k ++) {
			cube.tiles[k].w.pm.y = W*0.005;
			cube.tiles[k].w.mass = 15;
		}
		cube.setIndex((float)i/50*binCount);
		mobs.add(cube);
	}
}