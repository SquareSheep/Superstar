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

abstract class ObjectPool<T extends Entity> extends Entity {
  int arm;
  ArrayList<T> ar;

  ObjectPool() {
    arm = 0;
    ar = new ArrayList<T>();
  }

  // void set(Obj obj, [args]);

  // void add(Obj obj, [args]) {
  //   if (arm == ar.size()) {
  //     ar.add(new Mob(p));
  //   } else {
  //     Mob mob = (Mob)ar.get(arm);
  //   }
  //   reset mob
  //   arm ++;
  // }

  T getLast() {
    return ar.get(0);
  }

  void remove(int i) {
    ar.add(ar.remove(i));
    arm --;
  }

  T get(int i) {
    return ar.get(i);
  }

  void render() {
    for (int i = 0 ; i < arm ; i ++) {
      ar.get(i).render();
    }
  }

  void update() {
    for (int i = 0 ; i < arm ; i ++) {
      ar.get(i).update();
    }
    for (int i = 0 ; i < arm ; i ++) {
      if (ar.get(i).finished) remove(i);
    }
  }
}

abstract class MobF extends Mob {
  IColor fillStyle = defaultFill.copy();
  IColor strokeStyle = defaultStroke.copy();

  void updatePoints() {
    super.updatePoints();
    fillStyle.update();
    strokeStyle.update();
  }

  void setDraw() {
    push();
    fillStyle.fillStyle();
    strokeStyle.strokeStyle();
    translate(p.p.x, p.p.y, p.p.z);
    rotateX(rang.p.x);
    rotateY(rang.p.y);
    rotateZ(rang.p.z);
    translate(r.p.x,r.p.y,r.p.z);
    rotateX(ang.p.x);
    rotateY(ang.p.y);
    rotateZ(ang.p.z);
    if (sca.x != 1) scale(sca.x);
  }
}

abstract class Mob extends Entity {
  Point p;
  Point pv = new Point(0,0,0);
  Point r = new Point(0,0,0);
  SpringValue sca = new SpringValue(1);
  Point ang;
  Point rang = new Point(0,0,0);
  Point av = new Point(0,0,0);
  float w = 0;
  int lifeSpan = -1;
  
  void updatePoints() {
    p.P.add(pv.p);
    ang.P.add(av.p);
    p.update();
    pv.update();
    r.update();
    ang.update();
    rang.update();
    av.update();
    sca.update();
  }

  void setDraw() {
    push();
    translate(p.p.x, p.p.y, p.p.z);
    rotateX(rang.p.x);
    rotateY(rang.p.y);
    rotateZ(rang.p.z);
    translate(r.p.x,r.p.y,r.p.z);
    rotateX(ang.p.x);
    rotateY(ang.p.y);
    rotateZ(ang.p.z);
    if (sca.x != 1) scale(sca.x);
  }

  void update() {
    updatePoints();
  }

  abstract void render();
}

abstract class Entity {
  boolean finished = false;
  boolean draw = true;
  abstract void render();
  abstract void update();
}

class Point {
  PVector p;
  PVector P;
  PVector pm = new PVector(0,0,0);
  PVector v = new PVector(0,0,0);
  float vMult;
  float mass;
  int index;

  Point(PVector p, float vMult, float mass) {
    this.p = p;
    this.P = p.copy();
    this.vMult = vMult;
    this.mass = mass;
    this.index = -1;
  }

  Point() {
    this(new PVector(0,0,0), defaultVMult, defaultMass);
  }

  Point(PVector p) {
    this(p, defaultVMult, defaultMass);
  }

  Point(float x, float y, float z) {
    this(new PVector(x, y, z), defaultVMult, defaultMass);
  }

  Point(float x, float y, float z, float vMult, float mass) {
    this(new PVector(x, y, z), vMult, mass);
  }

  void update() {
    v.mult(vMult);
    if (index != -1) {
      v.x += (P.x + pm.x * av[index] - p.x) / mass;
      v.y += (P.y + pm.y * av[index] - p.y) / mass;
      v.z += (P.z + pm.z * av[index] - p.z) / mass;
    } else {
      v.add(PVector.sub(P,p).div(mass));
    }
    p.add(v);
  }

  Point copy() {
    return new Point(p.copy(), vMult, mass);
  }

  void setM(float x, float y, float z) {
    pm.set(x, y, z);
  }

  void setM(float x, float y, float z, float index) {
    pm.set(x, y, z);
    this.index = (int)index;
  }

  void reset(Point other) {
    reset(other.p.x,other.p.y,other.p.z);
  }

  void reset(float x, float y, float z) {
    p.set(x,y,z);
    P.set(x,y,z);
    v.set(0,0,0);
  }

  void reset(float x, float y, float z, float X, float Y, float Z) {
    p.set(x,y,z);
    P.set(X,Y,Z);
    v.set(0,0,0);
  }

  void reset(float x, float y, float z, float xm, float ym, float zm, float index) {
    p.set(x,y,z);
    P.set(x,y,z);
    v.set(0,0,0);
    pm.set(xm,ym,zm);
    this.index = (int)index;
  }

  void reset(float x, float y, float z, float X, float Y, float Z, float xm, float ym, float zm, float index) {
    p.set(x,y,z);
    P.set(X,Y,Z);
    v.set(0,0,0);
    pm.set(xm,ym,zm);
    this.index = (int)index;
  }
}

class SpringValue {
  float x;
  float X;
  float xm = 0;
  float v = 0;
  float vMult;
  float mass;
  int index = -1;

  SpringValue(float x, float vMult, float mass) {
    this.x = x;
    this.X = x;
    this.vMult = vMult;
    this.mass = mass;
  }

  SpringValue(float x) {
    this(x, defaultVMult, defaultMass);
  }

  SpringValue() {
    this(1,defaultVMult, defaultMass);
  }

  void update() {
    v *= vMult;
    if (index != -1) {
      v += (X + xm*av[index] - x)/mass;
    } else {
      v += (X - x)/mass;
    }
    x += v;
  }

  void setM(float xm, float index) {
    this.xm = xm;
    this.index = (int)index;
  }
}

class IColor extends AColor {
  float rm;
  float gm;
  float bm;
  float am;
  int rc;
  int gc;
  int bc;
  int ac;
  int index;

  IColor(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am, float index) {
    super(rc, gc, bc, ac);
    this.rm = rm; this.gm = gm; this.bm = bm; this.am = am;
    this.rc = (int)rc; this.gc = (int)gc; this.bc = (int)bc; this.ac = (int)ac;
    this.index = (int)index;
  }

  IColor(float rc, float gc, float bc, float ac) {
    this(rc,gc,bc,ac, 0,0,0,0, 0);
  }

  IColor() {
    this(0,0,0,0, 0,0,0,0, -1);
  }

  IColor copy() {
    return new IColor(rc, gc, bc, ac, rm, gm, bm, am, index);
  }

  void copySettings(IColor other) {
    rc = other.rc; bc = other.bc; gc = other.gc; ac = other.ac;
    rm = other.rm; bm = other.bm; gm = other.gm; am = other.am;
    index = other.index;
    r.x = other.r.x; r.X = other.r.X; r.mass = other.r.mass; r.vMult = other.r.vMult;
    g.x = other.g.x; g.X = other.g.X; g.mass = other.g.mass; g.vMult = other.g.vMult;
    b.x = other.b.x; b.X = other.b.X; b.mass = other.b.mass; b.vMult = other.b.vMult;
    a.x = other.a.x; a.X = other.a.X; a.mass = other.a.mass; a.vMult = other.a.vMult;
  }

  void update() {
    if (index != -1) {
      r.X = rm * av[index] + rc;
      g.X = gm * av[index] + gc;
      b.X = bm * av[index] + bc;
      a.X = am * av[index] + ac;
    }
    r.update();
    g.update();
    b.update();
    a.update();
  }

  void setVMult(float vMult) {
    this.r.vMult = vMult;
    this.g.vMult = vMult;
    this.b.vMult = vMult;
    this.a.vMult = vMult;
  }

  void setMass(float mass) {
    this.r.mass = mass;
    this.g.mass = mass;
    this.b.mass = mass;
    this.a.mass = mass;
  }

  void setM(float rm, float gm, float bm, float am) {
    this.rm = rm;
    this.gm = gm;
    this.bm = bm;
    this.am = am;
  }

  void setM(float r, float g, float b, float a, float i) {
    this.setM(r,g,b,a);
    this.index = (int)i;
  }

  void setC(float rc, float gc, float bc, float ac) {
    this.rc = (int)rc; r.X = rc;
    this.gc = (int)gc; g.X = gc;
    this.bc = (int)bc; b.X = bc;
    this.ac = (int)ac; a.X = ac;
  }

  void set(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am, float index) {
    setC(rc,gc,bc,ac);
    setM(rm,gm,bm,am);
    this.index = (int)index;
  }

  void set(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am) {
    set(rc,gc,bc,ac,rm,gm,bm,am,index);
  }

  void reset(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am, float index) {
    set(rc,gc,bc,ac,rm,gm,bm,am,index);
    r.x = rc; g.x = gc; b.x = bc; a.x = ac;
  }

  void reset(IColor other) {
    reset(other.r.x, other.g.x, other.b.x, other.a.x, other.rm, other.gm, other.bm, other.am, other.index);
  }
}

class AColor {
  SpringValue r;
  SpringValue g;
  SpringValue b;
  SpringValue a;
  AColor(float R, float G, float B, float A, float vMult, float mass) {
    this.r = new SpringValue(R, vMult, mass);
    this.g = new SpringValue(G, vMult, mass);
    this.b = new SpringValue(B, vMult, mass);
    this.a = new SpringValue(A, vMult, mass);
  }

  AColor(float R, float G, float B, float A) {
    this(R, G, B, A, fillVMult, fillMass);
  }

  AColor copy() {
    return new AColor(r.X, g.X, b.X, a.X, r.vMult, r.mass);
  }
  void update() {
    r.update();
    g.update();
    b.update();
    a.update();
  }

  void fillStyle() {
    fill(r.x, g.x, b.x, a.x);
  }

  void strokeStyle() {
    stroke(r.x, g.x, b.x, a.x);
  }

  void setx(float r, float g, float b, float a) {
    this.r.x = r;
    this.g.x = g;
    this.b.x = b;
    this.a.x = a;
  }

  void setX(float r, float g, float b, float a) {
    this.r.X = r;
    this.g.X = g;
    this.b.X = b;
    this.a.X = a;
  }

  void setMass(float mass) {
    this.r.mass = mass;
    this.g.mass = mass;
    this.b.mass = mass;
    this.a.mass = mass;
  }

  void setVMult(float vMult) {
    this.r.vMult = vMult;
    this.g.vMult = vMult;
    this.b.vMult = vMult;
    this.a.vMult = vMult;
  }
}

class BeatTimer {
  int offset;
  float bpm;
  float sec;
  int threshold;
  boolean beat = false;
  boolean beatAlready = false;
  int tick = 1;

  BeatTimer(int threshold, int offset, float bpm) {
    this.bpm = bpm;
    this.sec = sec;
    this.offset = offset;
    this.threshold = threshold;
  }

  void update() {
    float currMil = (currTime + offset) % (60000.0/bpm);
    if (!beatAlready && currMil < threshold) {
      beat = true;
      beatAlready = true;
      tick ++;
      if (tick > 4) tick = 1;
    } else {
      beat = false;
    }
    if (currMil > threshold) {
      beatAlready = false;
    }
  }

  void resetBooleans() {
    beat = true;
    beatAlready = true;
  }
}

class Camera {
  Point p;
  Point ang;
  Point av = new Point();
  PVector dp;
  PVector dang;
  boolean lock = true;

  Camera(float x, float y, float z, float ax, float ay, float az) {
    this.p = new Point(x, y, z);
    this.dp = this.p.p.copy();
    this.ang = new Point(ax, ay, az);
    this.dang = new PVector(ax, ay, az);
    this.ang.mass = 10;
    this.ang.vMult = 0.5;
    this.av = new Point();
  }

  Camera(float x, float y, float z) {
    this(x,y,z,0,0,0);
  }

  void update() {
  if (!lock) {
    cam.ang.P.y = (float)mouseX/width*2*PI - PI;
    cam.ang.P.x = -(float)mouseY/height*2*PI - PI;
  } else {
    cam.ang.P.add(av.p);
  }
    p.update();
    ang.P.add(av.p);
    ang.update();
    av.update();
  }

  void render() {
    camera();
    translate(p.p.x,p.p.y,p.p.z);
    rotateX(ang.p.x);
    rotateY(ang.p.y);
    rotateZ(ang.p.z);
  }
}