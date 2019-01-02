//Terraria Clone by Peter Barnett

void setup() {
  fullScreen();
  frameRate(144);
  allocateWorld();
  generateDirt();
  loadImages();
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
