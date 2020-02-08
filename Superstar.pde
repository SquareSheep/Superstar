import ddf.minim.analysis.*;
import ddf.minim.*;

Minim mim;
AudioPlayer song;
ddf.minim.analysis.FFT fft;
float[] av = new float[binCount];
float max;
float avg;

// Events initialize and store all of their own mobs
ArrayList<Event> events = new ArrayList<Event>();

// Used to store global animation entities
ArrayList<Entity> mobs = new ArrayList<Entity>();

Camera cam;
static int de;
static PVector front;
static PVector back;


BeatTimer timer;
float currTime;
float currBeat;
static float fpb;

static float cos60 = cos(PI/3);

char keyR;
char keyP;

void setup() {
  size(1000,1000,P3D);
  de = (int)(width*0.5+height*0.5);
  front = new PVector(de*2,de,de*0.2);
  back = new PVector(-de*2,-de,-de*2);

  cam = new Camera(width/2,height*0.9,-de*1.6, -0.12,0,0);

  textSize(de/10);
  rectMode(CENTER);
  textAlign(CENTER);

  mim = new Minim(this);
  song = mim.loadFile(songName, 1024);
  fft = new FFT(song.bufferSize(), song.sampleRate());

  timer = new BeatTimer(threshold,offset,bpm);
  fpb = 3600/bpm;
  
  song.loop();
  song.setGain(volumeGain);

  setSketch();
  addEvents();
}

void draw() {
  background(0);
  cam.render();
  update();

  render();

  for (Entity mob : mobs) {
    if (mob.draw) mob.render();
  }

  fill(255);
  //drawBorders();
  //drawWidthBox(de);
  //drawPitches();
  // push();
  // translate(0,de*0.75,0);
  // text(currBeat + " " + (int)frameRate,0,0);
  // pop();
}

void update() {
  calcFFT();

  currTime = song.position();
  if (timer.beat) currBeat += beatInc;

  cam.update();
  timer.update();

  updateEvents();

  for (Entity mob : mobs) {
    mob.update();
  }
  for (int i = 0 ; i < mobs.size() ; i ++) {
    if (mobs.get(i).finished) mobs.remove(i);
  }
}

void updateEvents() {
  for (int i = 0 ; i < events.size() ; i ++) {
    Event event = events.get(i);
    if (currBeat >= event.time && currBeat < event.timeEnd) {
      if (!event.spawned) {
        event.spawned = true;
        event.spawn();
      }
      event.update();
      event.render();
      if (currBeat == event.timeEnding && !event.ending) {
        event.ending = true;
        event.ending();
      }
    } else if (currBeat >= event.timeEnd) {
        if (!event.spawned) {
          event.spawned = true;
          event.spawn();
        }
        if (!event.finished) event.end();
        event.finished = true;
    }
  }
}

void calcFFT() {
  fft.forward(song.mix);

  avg = 0;
  max = 0;
  float temp;
  for (int i = 0 ; i < av.length ; i ++) {
    temp = 0;
    for (int k = i ; k < fft.specSize() ; k += i + 1) {
      temp += fft.getBand(k);
    }
    temp /= av.length / (i + 1);
    temp = pow(temp,fftPow);
    avg += temp;
    av[i] = temp;
  }
  avg /= av.length;

  for (int i = 0 ; i < av.length ; i ++) {
    if (av[i] < avg*fftThreshold) {
      av[i] /= fftAmp;
    } else {
      av[i] += (av[i] - avg * fftThreshold) /fftAmp;
    }
    if (av[i] > max) max = av[i];
  }
}

void mousePressed() {
  // float temp = ((float)mouseX / width) * song.length();
  // float tempBeat = ((temp+timer.offset)/60000.0*bpm);
  // tempBeat = tempBeat - tempBeat%0.5;
  // println(tempBeat);
  // for (Event event : events) {
  //   if (tempBeat <= event.time) {
  //     event.spawned = false;
  //     event.finished = false;
  //   }
  //   if (currBeat >= event.time && currBeat < event.timeEnd) {
  //     if (tempBeat < event.time || tempBeat >= event.timeEnd) event.end();
  //   }
  // }
  // song.cue((int)temp);
  // currBeat = tempBeat;
}

void setTime(float time) {
  float beat = ((time-timer.offset)/60000.0*bpm);
  beat = beat - beat%0.5;
  setTime(time, beat);
}

void setTime(float time, float beat) {
  for (Event event : events) {
    if (beat <= event.time) {
      event.spawned = false;
      event.finished = false;
    }
    if (currBeat >= event.time && currBeat < event.timeEnd) {
      if (beat < event.time || beat >= event.timeEnd) event.end();
    }
  }
  song.cue((int)time);
  currBeat = beat;
  timer.resetBooleans();
}

void keyPressed() {
  if (key == 'e') {
    if (!cam.lock) {
      cam.lock = true;
      cam.ang.P.set(cam.dang.x, cam.dang.y, cam.dang.z);
    } else {
      cam.lock = false;
    }
    println("Cam lock: " + cam.lock);
  } else {
    println("KEY: " + key + " " + currTime + " " + currBeat + " " + frameRate);
    keyP = key;
    keyboardInput();
  }
}

void drawPitches() {
  push();
  fill(255);
  translate(0,height,0);
  for (int i = 0 ; i < binCount ; i ++) {
    float w = width/(float)binCount;
    translate(w, 0,0);
    rect(0,0,w,av[i]*10);
  }
  pop();
}

void drawBorders() {
  noFill();
  stroke(255);
  push();
  translate(0,0,-de);
  rect(0,0,de*2,de*2);
  pop();
  line(de,de,de,de,de,-de);
  line(de,-de,de,de,-de,-de);
  line(-de,de,de,-de,de,-de);
  line(-de,-de,de,-de,-de,-de);
}

void drawWidthBox(float w) {
  push();
  textSize(w/10);
  push();
  translate(0,0,0);
  text("0,0,0",0,0);
  pop();

  push();
  translate(w,w,w);
  text("1,1,1",0,0);
  pop();

  push();
  translate(-w,w,w);
  text("-1,1,1",0,0);
  pop();

  push();
  translate(-w,-w,w);
  text("-1,-1,1",0,0);
  pop();

  push();
  translate(w,-w,w);
  text("1,-1,-1",0,0);
  pop();

  push();
  translate(w,w,-w);
  text("1,1,-1",0,0);
  pop();

  push();
  translate(-w,w,-w);
  text("-1,1,-1",0,0);
  pop();

  push();
  translate(-w,-w,-w);
  text("-1,-1,-1",0,0);
  pop();

  push();
  translate(w,-w,-w);
  text("1,-1,-1",0,0);
  pop();
  pop();
}