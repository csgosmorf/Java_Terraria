//Terraria Clone by Peter Barnett

void setup() {
  fullScreen();
  allocateWorld();
  generateDirt();
  loadImages();
}

void draw() {
  drawSky();
  moveCamera();
  mine();
  drawBlocks();
  drawDevText();
}
