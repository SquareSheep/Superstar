void addEvents() {
	//5, 13
	events.add(new SetEntityDraw(0,ball,false));
	events.add(new SetTileObjectsDraw(0,light,false));
	events.add(new SetTilesDraw(0,dance,true));
	events.add(new PointReset(0,cam.ang, -PI/2,0,0));
	events.add(new TilesFillStyleSetC(0,43,dance,0,25,0,0.1));
	events.add(new PointReset(33,cam.av, 0.003,0,0));
	for (int i = 0 ; i < dance.length ; i ++) {
		events.add(new PVectorSet(33,dance[i].w.pm, 0,dance[i].w.p.x*0.002,0));
		events.add(new PointSetIndex(33, dance[i].w, i));
	}

	for (int i = 0 ; i < 10 ; i ++) {
		events.add(new TilesFillStyleSetC(33+i,43,dance,0,25,0,0.1+i*0.2));
	}

	events.add(new PVectorSet(41,cam.ang.P, -0.1,0,0));
	events.add(new PointReset(41,cam.av, 0,0,0));

	events.add(new TilesFillStyleSetC(44,1000,dance,125,255,-10,10));
	events.add(new TileObjectsFillStyleSetC(44,1000,light,125,255,100, -10,10,5));
	events.add(new BeamsOn(44,1000,10));
	events.add(new SetTileObjectsDraw(44,light,true));
	events.add(new SetEntityDraw(44,ball,true));
	events.add(new SetTileObjectsDraw(44,tail,false));
	events.add(new PVectorAdd(44,ball.p.p, 0,-1000,0));
	for (int i = 0 ; i < light.length ; i ++) {
		events.add(new PVectorAdd(44, light[i].r.p, 0,0,-500));
	}
	events.add(new LightsOnRandom(44,75,0.1));
}

void keyboardInput() {
	switch(key) {
		case '1':
		setTime(0,0);
		break;
		case '2':
		setTime(15209,31);
		break;
		case '3':
		setTime(19899,41);
		break;
		case '4':
		setTime(55983,118);
		break;
		case '5':
		setTime(0,0);
		break;
		case '6':
		setTime(0,0);
		break;
	}
}