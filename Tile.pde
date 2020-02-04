class Tile extends MobF {
	Point w;

	Tile(float x, float y, float z, float w, float h, float d) {
		this.p = new Point(x,y,z);
		this.w = new Point(w,h,d);
	}

	void update() {
		super.update();
		w.update();
	}

	void render() {
		setDraw();
		translate(0,-w.p.y/2,0);
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

class Cube extends Mob {
	Tile[] tiles = new Tile[6];

	Cube(float x, float y, float z, float w) {
		this.p = new Point(x,y,z);
		this.w = w;
		for (int i = 0 ; i < tiles.length ; i ++) {
			tiles[i] = new Tile(0,0,0,w,w*0.15,w);
			tiles[i].r.reset(0,0,w/2);
			tiles[i].ang.reset(-PI/2,0,0);
		}
		tiles[1].rang.reset(PI/2,0,0);
		tiles[5].rang.reset(PI,0,0);
		tiles[2].rang.reset(-PI/2,0,0);
		tiles[3].rang.reset(0,PI/2,0);
		tiles[4].rang.reset(0,-PI/2,0);
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