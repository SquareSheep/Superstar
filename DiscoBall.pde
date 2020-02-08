class DiscoBall extends Mob {
	ArrayList<Beam> ar = new ArrayList<Beam>();
	int arm = 0;
	IColor fillStyle = new IColor(200,200,200,150);
	IColor strokeStyle = new IColor(255,255,255,255);
	boolean beat = true;

	DiscoBall(float x, float y, float z, float w) {
		this.p = new Point(x,y,z);
		this.w = w;
		av.reset(0,0.01,0);
	}

	void update() {
		super.update();
		fillStyle.update();
		if (timer.beat && beat) {
			sca.x += 0.1;
			fillStyle.setx(255,255,255,255);
		}
		for (Beam mob : ar) {
			if (mob.lifeSpan != 0) {
				mob.fillStyle.update();
				mob.lifeSpan --;
			}
		}
	}

	void render() {
		setDraw();
		fillStyle.fillStyle();
		strokeStyle.strokeStyle();
		sphere(w);
		for (Beam mob : ar) {
			if (mob.lifeSpan != 0) mob.render();
		}
		translate(0,-de*0.5,0);
		box(w*0.1,de,w*0.1);
		pop();
	}

	void beam(float x, float y, int lifeSpan) {
		int i = 0;
		while (i < ar.size() && ar.get(i).lifeSpan != 0) {
			i ++;
		}
		if (i == ar.size()) {
			ar.add(new Beam(x,y,lifeSpan));
		} else {
			ar.get(i).set(x,y,lifeSpan);
		}
	}

	class Beam {
		float x = 0;
		float y = 0;
		int lifeSpan = 0;
		IColor fillStyle = new IColor(random(125,255),random(125,255),random(125,255),125);

		Beam(float x, float y, int lifeSpan) {
			set(x,y,lifeSpan);
		}

		void set(float x, float y, int lifeSpan) {
			this.x = x;
			this.y = y;
			this.lifeSpan = lifeSpan;
		}

		void render() {
			push();
			rotateY(y);
			rotateX(x);
			fillStyle.fillStyle();
			beginShape();
			vertex(0,0,0);
			vertex(-de,0,de*10);
			vertex(de,0,de*10);
			pop();
		}
	}
}