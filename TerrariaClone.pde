//Terraria Clone by Peter Barnett

void setup() {
  fullScreen(P3D);
  frameRate(60);
  allocateWorld();
  generateDirt();
  loadImages();
  cursor(blue_cursor);
}

void draw() {
  drawSky();
  player.update();
  player.mine();
  player.place();
  drawBlocks();
  player.display();
  drawDevText();
}
