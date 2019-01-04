//Terraria Clone by Peter Barnett

float t = 0.0;
float rate = 120;
float dt = 1.0 / (rate - 9);

void setup() {
  fullScreen(P3D);
  frameRate(rate);
  allocateWorld();
  generateDirt();
  loadImages();
  cursor(blue_cursor);
}

void draw() {
  drawSky();
  player.update(dt);
  player.mine();
  player.place();
  drawBlocks();
  player.display(dt);
  drawDevText();
}
