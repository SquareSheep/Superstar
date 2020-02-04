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