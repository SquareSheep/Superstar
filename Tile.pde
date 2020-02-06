float spotlightfAmp = 0.5;
float spotlightaAmp = 0.01;
class Spotlight extends TileObject {
	SpringValue tilt;
	IColor fillStyle = new IColor(255,255,255,150);
	boolean on = false;

	Spotlight(float x, float y, float z, float ax, float ay, float az, float w, float index) {
		super(x,y,z,ax,ay,az,w,9);
		for (int i = 0 ; i < 5 ; i ++) {
			tiles[i].r.reset(0,-w/2,0);
		}
		tiles[0].rang.reset(PI/2,0,0);
		tiles[4].rang.reset(PI,0,0);
		tiles[1].rang.reset(-PI/2,0,0);
		tiles[2].rang.reset(0,0,PI/2);
		tiles[3].rang.reset(0,0,-PI/2);

		tilt = new SpringValue(-0.5);
		tilt.xm = 0.001;
		for (int i = 5 ; i < 9 ; i ++) {
			tiles[i].p.reset(0,-w/2,0);
			tiles[i].r.reset(w/2,0,0);
			tiles[i].ang.reset(0,0,-tilt.x);
			tiles[i].rang.reset(0,(i-5)*PI/2,0);
		}
		setIndex(index);
	}

	Spotlight(float x, float y, float z, float w, float index) {
		this(x,y,z,0,0,0,w,index);
	}

	Spotlight(float x, float y, float z, float w) {
		this(x,y,z,0,0,0,w,-1);
	}

	void update() {
		super.update();
		tilt.update();
		fillStyle.update();
		for (int i = 5 ; i < 9 ; i ++) {
			tiles[i].ang.P.z = tilt.x;
		}
	}

	void render() {
		setDraw();
		for (Tile tile : tiles) {
			tile.render();
		}
		if (on) renderLight();
		pop();
	}

	void renderLight() {
		fillStyle.fillStyle();
		noStroke();
		translate(-w/2,-w/2,-w/2);
		float d = -de*20;
		float dx = tilt.x*w*5+w*2;
		beginShape();
		vertex(-0,0,0);
		vertex(-dx,d,-dx);
		vertex(w+dx,d,-dx);
		vertex(w,0,0);
		endShape();
		beginShape();
		vertex(w,0,0);
		vertex(w+dx,d,-dx);
		vertex(w+dx,d,w+dx);
		vertex(w,0,w);
		endShape();
		beginShape();
		vertex(w,0,w);
		vertex(w+dx,d,w+dx);
		vertex(-dx,d,w+dx);
		vertex(0,0,w);
		endShape();
		beginShape();
		vertex(0,0,w);
		vertex(-dx,d,w+dx);
		vertex(-dx,d,-dx);
		vertex(0,0,0);
		endShape();
	}

	void setIndex(float index) {
		super.setIndex(index);
		tilt.index = (int)index%binCount;
		fillStyle.index = (int)index%binCount;
	}
}
class Cube extends TileObject {
	Cube(float x, float y, float z, float w) {
		super(x,y,z,w,6);
		for (int i = 0 ; i < 6 ; i ++) {
			tiles[i].r.reset(0,-w/2,0);
		}
		tiles[1].rang.reset(PI/2,0,0);
		tiles[5].rang.reset(PI,0,0);
		tiles[2].rang.reset(-PI/2,0,0);
		tiles[3].rang.reset(0,0,PI/2);
		tiles[4].rang.reset(0,0,-PI/2);
	}
}

class Tail extends TileObject {
	Point p;
	float tick = 0;

	Tail(float x, float y, float z, float ax, float ay, float az, float w, int num) {
		super(x,y,z,ax,ay,az,w,num);
		p = new Point(x,y,z);
		for (int i = 0 ; i < num ; i ++) {
			tiles[i].p.reset(x,y+i*w,z);
			tiles[i].ang.reset(-PI/2,0,-PI/2);
			tiles[i].w.setM(0,w*0.01,0, (float)i/num*binCount);
			tiles[i].fillStyle.reset(random(75,155),random(75,155),random(75,155),255,(1-(float)i/num)*1,0.5,((float)i/num)*1,0,(float)i/num*binCount);
		}
	}

	Tail(float x, float y, float z, float w, int num) {
		this(x,y,z,0,0,0,w,num);
	}

	void update() {
		super.update();
		p.update();
		tick += avg/1000;
		if (timer.beat) tick = tick%PI+PI;
		tiles[0].p.P.set(p.p.x + sin(tick)*avg*6,p.p.y,p.p.z);
		for (int i = 1 ; i < tiles.length ; i ++) {
			if (i%10 == 0) {
				tiles[i].p.P.set(tiles[i-1].p.p.x + sin(tick+i/10*PI)*avg*6,p.p.y,p.p.z);
			} else {
				tiles[i].p.P.x = tiles[i-1].p.p.x;
			}
		}
	}
}

class TileObject extends Mob {
	Tile[] tiles;

	TileObject(float x, float y, float z, float ax, float ay, float az, float w, int num) {
		this.p = new Point(x,y,z);
		ang.reset(ax,ay,az);
		this.w = w;
		tiles = new Tile[num];
		for (int i = 0 ; i < num ; i ++) {
			tiles[i] = new Tile(0,0,0,w);
		}
	}

	TileObject(float x, float y, float z, float w, int num) {
		this(x,y,z,0,0,0,w,num);
	}

	void update() {
		super.update();
		for (int i = 0 ; i < tiles.length ; i ++) {
			tiles[i].update();
		}
	}

	void render() {
		setDraw();
		for (Tile tile : tiles) {
			tile.render();
		}
		pop();
	}

	void fillStyleSetC(float r, float g, float b, float a, float rr, float gg, float bb, float aa) {
		for (int i = 0 ; i < tiles.length ; i ++) {
			float t = ((float)i/tiles.length-0.5);
			tiles[i].fillStyle.setC(r+t*rr,g+t*gg,b+t*bb,a+t*aa);
		}
	}

	void fillStyleSetM(float r, float g, float b, float a, float rr, float gg, float bb, float aa) {
		for (int i = 0 ; i < tiles.length ; i ++) {
			float t = ((float)i/tiles.length-0.5);
			tiles[i].fillStyle.setM(r+t*rr,g+t*gg,b+t*bb,a+t*aa);
		}
	}

	void fillStyleSetC(float r, float g, float b, float a) {
		for (int i = 0 ; i < tiles.length ; i ++) {
			tiles[i].fillStyle.setC(r,g,b,a);
		}
	}

	void fillStyleSetM(float r, float g, float b, float a) {
		for (int i = 0 ; i < tiles.length ; i ++) {
			tiles[i].fillStyle.setM(r,g,b,a);
		}
	}

	void setIndex(float index) {
		for (int i = 0 ; i < tiles.length ; i ++) {
			tiles[i].setIndex(index+i);
		}
	}
}

float tileHMult = 0.15;
class Tile extends MobF {
	Point w;

	Tile(float x, float y, float z, float w, float h, float d) {
		this.p = new Point(x,y,z);
		this.w = new Point(w,h,d);
	}

	Tile(float x, float y, float z, float w) {
		this(x,y,z,w,w*tileHMult,w);
	}

	void update() {
		super.update();
		w.update();
	}

	void render() {
		setDraw();
		//translate(0,-w.p.y/2,0);
		box(w.p.x,w.p.y,w.p.z);
		pop();
	}

	void setIndex(float index) {
		int i = (int)index%binCount;
		fillStyle.index = i;
		sca.index = i;
		w.index = i;
	}
}