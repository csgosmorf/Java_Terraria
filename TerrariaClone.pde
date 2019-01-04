//Terraria Clone by Peter Barnett

//Setting dt to 1/60 sec. for 1st frame
float t0 = 0.0, t1 = 0.0;
float dt = 1.0 / 60.0;

void setup() {
  fullScreen(P3D);
  frameRate(1000);
  allocateWorld();
  generateDirt();
  loadImages();
  cursor(blue_cursor);
}

void draw() {
  adjustTiming();
  drawSky();
  player.update(dt);
  player.mine();
  player.place();
  drawBlocks();
  player.display(dt);
  drawDevText();
}

void adjustTiming() {
  if (frameCount == 1) {
    t0 = System.nanoTime();
  } else {
    t0 = t1;
    t1 = System.nanoTime();
    dt = (t1 - t0) / 1E9;
  }
}
