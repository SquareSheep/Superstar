void addEvents() {
	events.add(new SetEntityDraw(0,ball,false));
	events.add(new SetTileObjectsDraw(0,light,false));
	events.add(new SetTilesDraw(0,dance,true));
	events.add(new PointReset(0,cam.ang, -PI/2,0,0));

	events.add(new PointReset(5,cam.av, 0.003,0,0));
	for (int i = 0 ; i < dance.length ; i ++) {
		events.add(new PVectorSet(5,dance[i].w.pm, 0,dance[i].w.p.x*0.002,0));
		events.add(new PointSetIndex(5, dance[i].w, i));
	}

	events.add(new PVectorSet(13,cam.ang.P, -0.1,0,0));
	events.add(new PointReset(13,cam.av, 0,0,0));

	events.add(new TilesFillStyleSetC(43,1000,dance,125,255,-10,10));
	events.add(new TileObjectsFillStyleSetC(43,1000,light,125,255,100, -10,10,5));
	events.add(new SetTileObjectsDraw(44,light,true));
	events.add(new SetEntityDraw(44,ball,true));
	events.add(new PVectorAdd(44,ball.p.p, 0,-1000,0));
	for (int i = 0 ; i < light.length ; i ++) {
		events.add(new PVectorAdd(44, light[i].r.p, 0,0,-500));
	}
	events.add(new LightsOnRandom(44,75,0.2));
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