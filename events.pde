class LightsOnRandom extends Event {
	Spotlight[] ar;
	float chance;
	float ax,ay,avx,avy;

	LightsOnRandom(float time, float timeEnd, Spotlight[] ar, float chance, float ax, float ay, float avx, float avy) {
		super(time,timeEnd);
		this.ar = ar;
		this.chance = chance;
		this.ax = ax; this.ay = ay; this.avx = avx; this.avy = avy;
	}

	LightsOnRandom(float time, float timeEnd, float chance) {
		this(time,timeEnd,light,chance, 1,1, 0.003,0.003);
	}

	void update() {
		if (timer.beat) {
			for (int i = 0 ; i < ar.length ; i ++) {
				if (random(1) < chance) {
					ar[i].on = true;
					ar[i].av.P.set(random(-avx,avx),random(-avy,avy),0);
			 		ar[i].ang.P.add(random(-ax,ax),0,random(-ay,ay));
				} else {
					ar[i].on = false;
					ar[i].homePosition();
			 		ar[i].av.reset(0,0,0);
				}
			}
		}
	}

	void end() {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].on = false;
			ar[i].homePosition();
			ar[i].av.reset(0,0,0);
		}
	}
}

class TilesFillStyleSetC extends TilesFillStyleR {

	TilesFillStyleSetC(float time, float timeEnd, Tile[] ar, float minC, float maxC) {
		super(time,timeEnd,ar,minC,maxC);
	}

	TilesFillStyleSetC(float time, float timeEnd, Tile[] ar, float minC, float maxC, float minM, float maxM) {
		super(time,timeEnd,ar,minC,maxC,minM,maxM);
	}

	void update() {
		if (timer.beat) {
			for (int i = 0 ; i < ar.length ; i ++) {
				ar[i].fillStyle.setC(minC,maxC);
				if (minM != -100) ar[i].fillStyle.setM(minM,maxM,random(binCount));
			}
		}
	}
}

class TileObjectsFillStyleSetC extends TileObjectsFillStyleR {

	TileObjectsFillStyleSetC(float time, float timeEnd, TileObject[] ar, float minC, float maxC, float rangeC) {
		super(time,timeEnd,ar,minC,maxC,rangeC);
	}

	TileObjectsFillStyleSetC(float time, float timeEnd, TileObject[] ar, float minC, float maxC, float rangeC, float minM, float maxM, float rangeM) {
		super(time,timeEnd,ar,minC,maxC,rangeC,minM,maxM,rangeM);
	}

	void update() {
		if (timer.beat) {
			for (int i = 0 ; i < ar.length ; i ++) {
				ar[i].fillStyleSetC(minC,maxC,rangeC);
				if (minM != -100) {
					ar[i].fillStyleSetM(minM,maxM,rangeM);
					ar[i].setIndex(random(binCount));
				}
			}
		}
	}
}

class SetTileObjectsDraw extends Event {
	TileObject[] ar;
	boolean draw;

	SetTileObjectsDraw(float time, TileObject[] ar, boolean draw) {
		super(time,time+1);
		this.ar = ar;
		this.draw = draw;
	}

	void spawn() {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].draw = draw;
		}
	}
}

class SetTilesDraw extends Event {
	Tile[] ar;
	boolean draw;

	SetTilesDraw(float time, Tile[] ar, boolean draw) {
		super(time,time+1);
		this.ar = ar;
		this.draw = draw;
	}

	void spawn() {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].draw = draw;
		}
	}
}

abstract class TileObjectsFillStyleR extends Event {
	TileObject[] ar;
	float minC,maxC,rangeC;
	float minM = -100;
	float maxM,rangeM;

	TileObjectsFillStyleR(float time, float timeEnd, TileObject[] ar, float minC, float maxC, float rangeC, float minM, float maxM, float rangeM) {
		this(time,timeEnd,ar,minC,maxC,rangeC);
		this.minM = minM; this.rangeM = rangeM; this.maxM = maxM;
	}

	TileObjectsFillStyleR(float time, float timeEnd, TileObject[] ar, float minC, float maxC, float rangeC) {
		super(time,timeEnd);
		this.ar = ar; this.minC = minC; this.maxC = maxC; this.rangeC = rangeC;
	}
}

abstract class TilesFillStyleR extends Event {
	Tile[] ar;
	float minC,maxC;
	float minM = -100;
	float maxM = -100;

	TilesFillStyleR(float time, float timeEnd, Tile[] ar, float minC, float maxC, float minM, float maxM) {
		this(time,timeEnd,ar,minC,maxC);
		this.minM = minM; this.maxM = maxM;
	}

	TilesFillStyleR(float time, float timeEnd, Tile[] ar, float minC, float maxC) {
		super(time,timeEnd);
		this.ar = ar; this.minC = minC; this.maxC = maxC;
	}
}

abstract class TilesFillStyle extends Event {
	Tile[] ar;
	float r,g,b,a, rr,gg,bb,aa;
	float rm,gm,bm,am, rrm,ggm,bbm,aam;
	int index;

	TilesFillStyle(float time, float timeEnd, Tile[] ar, float r, float g, float b, float a, float rr, float gg, float bb, float aa,
		float rm, float gm, float bm, float am, float rrm, float ggm, float bbm, float aam) {
		this(time,timeEnd,ar,r,g,b,a,rr,gg,bb,aa);
		this.rm = rm; this.gm = gm; this.bm = bm; this.am = am; this.rrm = rrm; this.ggm = ggm; this.bbm = bbm; this.aam = aam;
	}

	TilesFillStyle(float time, float timeEnd, Tile[] ar, float r, float g, float b, float a, float rr, float gg, float bb, float aa) {
		super(time,timeEnd);
		this.ar = ar;
		this.r = r; this.g = g; this.b = b; this.a = a;
	}
}

//BASE EVENTS
class PointReset extends Event {
	Point p;
	float x,y,z,X,Y,Z;

	PointReset(float time, Point p, float x, float y, float z, float X, float Y, float Z) {
		super(time,time+1);
		this.p = p;
		this.x = x; this.y = y; this.z = z;
		this.X = X; this.Y = Y; this.Z = Z;
	}

	PointReset(float time, Point p, float x, float y, float z) {
		this(time,p,x,y,z,x,y,z);
	}

	void spawn() {
		p.reset(x,y,z,X,Y,Z);
	}
}

class PointSetMass extends Event {
	Point p;
	float mass;

	PointSetMass(float time, Point p, float mass) {
		super(time,time+1);
		this.p = p;
		this.mass = mass;
	}

	void spawn() {
		p.mass = mass;
	}
}

class PointSetVMult extends Event {
	Point p;
	float vMult;

	PointSetVMult(float time, Point p, float vMult) {
		super(time,time+1);
		this.p = p;
		this.vMult = vMult;
	}

	void spawn() {
		p.vMult = vMult;
	}
}

class PointSetIndex extends Event {
	Point p;
	int index;

	PointSetIndex(float time, Point p, float index) {
		super(time,time+1);
		this.p = p;
		this.index = (int)index;
	}

	void spawn() {
		p.index = index;
	}
}

class SpringValueSetX extends Event {
	SpringValue spr;
	float x;

	SpringValueSetX(float time, SpringValue spr, float x) {
		super(time,time+1);
		this.spr = spr;
		this.x = x;
	}

	void spawn() {
		spr.X = x;
	}
}

class SpringValueSetx extends Event {
	SpringValue spr;
	float x;

	SpringValueSetx(float time, SpringValue spr, float x) {
		super(time,time+1);
		this.spr = spr;
		this.x = x;
	}

	void spawn() {
		spr.x = x;
	}
}

class PVectorSet extends Event {
	PVector p;
	float x,y,z;

	PVectorSet(float time, PVector p, float x, float y, float z) {
		super(time,time+1);
		this.p = p;
		this.x = x; this.y = y; this.z = z;
	}

	void spawn() {
		p.set(x,y,z);
	}
}

class PVectorAdd extends Event {
	PVector p;
	float x,y,z;

	PVectorAdd(float time, PVector p, float x, float y, float z) {
		super(time,time+1);
		this.p = p;
		this.x = x; this.y = y; this.z = z;
	}

	void spawn() {
		p.add(x,y,z);
	}
}

class FillStyleSetC extends Event {
	IColor fillStyle;
	float r,g,b,a;

	FillStyleSetC(float time, IColor fillStyle, float r, float g, float b, float a) {
		super(time, time+1);
		this.fillStyle = fillStyle;
		this.r = r; this.g = g; this.b = b; this.a = a;
	}

	void spawn() {
		fillStyle.setC(r,g,b,a);
	}
}

class FillStyleSetM extends Event {
	IColor fillStyle;
	float r,g,b,a;

	FillStyleSetM(float time, IColor fillStyle, float r, float g, float b, float a) {
		super(time, time+1);
		this.fillStyle = fillStyle;
		this.r = r; this.g = g; this.b = b; this.a = a;
	}

	void spawn() {
		fillStyle.setM(r,g,b,a);
	}
}

class FillStyleSetMass extends Event {
	IColor fillStyle;
	float mass;

	FillStyleSetMass(float time, IColor fillStyle, float mass) {
		super(time, time+1);
		this.fillStyle = fillStyle;
		this.mass = mass;
	}

	void spawn() {
		fillStyle.setMass(mass);
	}
}

class FillStyleSetVMult extends Event {
	IColor fillStyle;
	float vMult;

	FillStyleSetVMult(float time, IColor fillStyle, float vMult) {
		super(time, time+1);
		this.fillStyle = fillStyle;
		this.vMult = vMult;
	}

	void spawn() {
		fillStyle.setMass(vMult);
	}
}

class SetEntityDraw extends Event {
	Entity mob;
	boolean draw;

	SetEntityDraw(float time, Entity mob, boolean draw) {
		super(time,time+1);
		this.mob = mob;
		this.draw = draw;
	}

	void spawn() {
		mob.draw = draw;
	}
}

class Event {
  boolean finished = false;
  boolean ending = false;
  boolean spawned = false;
  float time;
  float timeEnd;
  float timeEnding;

  Event() {}

  Event(float time, float timeEnd) {
    this.time = time;
    this.timeEnd = timeEnd;
    this.timeEnding = timeEnd;
  }

  Event (float time, float timeEnding, float timeEnd) {
    this.time = time;
    this.timeEnding = timeEnding;
    this.timeEnd = timeEnd;
  }

  void spawn() {}
  
  void update() {}

  void render() {}

  void ending() {}

  void end() {}
}