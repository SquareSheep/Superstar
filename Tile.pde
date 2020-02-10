float spotlightfAmp = 0.5;
float spotlightaAmp = 0.01;
class Spotlight extends TileObject {
	SpringValue tilt;
	IColor fillStyle = new IColor(255,255,255,125);
	boolean on = false;

	Spotlight(float x, float y, float z, float ax, float ay, float az, float w, float index) {
		super(x,y,z,ax,ay,az,w,9);
		for (int i = 0 ; i < 5 ; i ++) {
			ar[i].r.reset(0,-w/2,0);
		}
		ar[0].rang.reset(PI/2,0,0);
		ar[4].rang.reset(PI,0,0);
		ar[1].rang.reset(-PI/2,0,0);
		ar[2].rang.reset(0,0,PI/2);
		ar[3].rang.reset(0,0,-PI/2);

		tilt = new SpringValue(-0.5);
		tilt.xm = 0.001;
		for (int i = 5 ; i < 9 ; i ++) {
			ar[i].p.reset(0,-w/2,0);
			ar[i].r.reset(w/2,0,0);
			ar[i].ang.reset(0,0,-tilt.x);
			ar[i].rang.reset(0,(i-5)*PI/2,0);
		}
		setIndex(index);
	}

	Spotlight(float x, float y, float z, float ax, float ay, float az, float w) {
		this(x,y,z,ax,ay,az,w,-1);
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
			ar[i].ang.P.z = tilt.x;
		}
	}

	void render() {
		setDraw();
		for (Tile tile : ar) {
			tile.render();
		}
		if (on) renderLight();
		pop();
	}

	void renderLight() {
		fillStyle.fillStyle();
		noStroke();
		translate(-w/2,-w/2,-w/2);
		float d = -de*6;
		float dx = tilt.x*w*5+w*4;
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

	void fillStyleSetC(float minC, float maxC, float mRange) {
		super.fillStyleSetC(minC,maxC,mRange);
		fillStyle.setC(random(minC,maxC),random(minC,maxC),random(minC,maxC),fillStyle.a.x);
	}
}
class Cube extends TileObject {
	Cube(float x, float y, float z, float w) {
		super(x,y,z,w,6);
		for (int i = 0 ; i < 6 ; i ++) {
			ar[i].r.reset(0,-w/2,0);
		}
		ar[1].rang.reset(PI/2,0,0);
		ar[5].rang.reset(PI,0,0);
		ar[2].rang.reset(-PI/2,0,0);
		ar[3].rang.reset(0,0,PI/2);
		ar[4].rang.reset(0,0,-PI/2);
	}
}

class Tail extends TileObject {
	Point p;
	float tick = 0;

	Tail(float x, float y, float z, float ax, float ay, float az, float w, int num) {
		super(x,y,z,ax,ay,az,w,num);
		p = new Point(x,y,z);
		for (int i = 0 ; i < num ; i ++) {
			ar[i].p.reset(x,y+i*w,z);
			ar[i].ang.reset(-PI/2,0,-PI/2);
			ar[i].w.setM(0,w*0.01,0, (float)i/num*binCount);
			ar[i].fillStyle.reset(random(75,155),random(75,155),random(75,155),255,(1-(float)i/num)*1,0.5,((float)i/num)*1,0,(float)i/num*binCount);
		}
	}

	Tail(float x, float y, float z, float w, int num) {
		this(x,y,z,0,0,0,w,num);
	}

	void update() {
		super.update();
		p.update();
		tick += avg/1500;
		if (timer.beat) tick = tick%PI+PI;
		ar[0].p.P.set(p.p.x + sin(tick)*avg*3,p.p.y,p.p.z);
		for (int i = 1 ; i < ar.length ; i ++) {
			if (i%10 == 0) {
				ar[i].p.P.set(ar[i-1].p.p.x + sin(tick+i/10*PI)*avg*3, ar[i].p.p.y, ar[i-1].p.p.z);
			} else {
				ar[i].p.P.x = ar[i-1].p.p.x;
			}
		}
	}
}

class TileObject extends Mob {
	Tile[] ar;
	PVector ph; // Home position
	PVector ah;

	TileObject(float x, float y, float z, float ax, float ay, float az, float w, int num) {
		this.p = new Point(x,y,z);
		this.ph = new PVector(x,y,z);
		this.ah = new PVector(ax,ay,az);
		ang.reset(ax,ay,az);
		this.w = w;
		ar = new Tile[num];
		for (int i = 0 ; i < num ; i ++) {
			ar[i] = new Tile(0,0,0,w);
		}
	}

	TileObject(float x, float y, float z, float w, int num) {
		this(x,y,z,0,0,0,w,num);
	}

	void update() {
		super.update();
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].update();
		}
	}

	void render() {
		setDraw();
		for (Tile tile : ar) {
			if (tile.draw) tile.render();
		}
		pop();
	}

	void fillStyleSetC(float r, float g, float b, float a, float rr, float gg, float bb, float aa) {
		for (int i = 0 ; i < ar.length ; i ++) {
			float t = ((float)i/ar.length-0.5);
			ar[i].fillStyle.setC(r+t*rr,g+t*gg,b+t*bb,a+t*aa);
		}
	}

	void fillStyleSetM(float r, float g, float b, float a, float rr, float gg, float bb, float aa) {
		for (int i = 0 ; i < ar.length ; i ++) {
			float t = ((float)i/ar.length-0.5);
			ar[i].fillStyle.setM(r+t*rr,g+t*gg,b+t*bb,a+t*aa);
		}
	}

	void fillStyleSetC(float r, float g, float b, float a) {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].fillStyle.setC(r,g,b,a);
		}
	}

	void fillStyleSetM(float r, float g, float b, float a) {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].fillStyle.setM(r,g,b,a);
		}
	}

	void fillStyleSetC(float minC, float maxC, float mRange) {
		fillStyleSetC(random(minC,maxC),random(minC,maxC),random(minC,maxC),255, 
			random(-mRange,mRange),random(-mRange,mRange),random(-mRange,mRange),0);
	}

	void fillStyleSetM(float minC, float maxC, float mRange) {
		fillStyleSetM(random(minC,maxC),random(minC,maxC),random(minC,maxC),255, 
			random(-mRange,mRange),random(-mRange,mRange),random(-mRange,mRange),0);
	}

	void setIndex(float index) {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].setIndex(index+i);
		}
	}

	void homePosition() {
		p.P.set(ph);
		ang.P.set(ah);
	}
}

float tileHMult = 0.15;
class Tile extends MobF {
	Point w;
	PVector ph;

	Tile(float x, float y, float z, float w, float h, float d) {
		this.p = new Point(x,y,z);
		this.ph = new PVector(x,y,z);
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