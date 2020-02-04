class Tile extends MobF {
	Point w;

	Tile(float x, float y, float z, float w, float h, float d) {
		this.p = new Point(x,y,z);
		this.w = new Point(w,h,d);
		this.ang = new Point();
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