void drawDevText() {
  text("camera: " + camX + ", " + camY,50,50);
  text("FPS: " + frameRate,50,65);
  text("toBlockX(mouseX) = " + toBlockX(mouseX),50,80);
  text("toBlockY(mouseY) = " + toBlockY(mouseY),50,95);
}

void mine() {
  int blockX = toBlockX(mouseX);
  int blockY = toBlockY(mouseY);
  if (mousePressed)
  if (inRange(blockX,0,WORLD_WIDTH) && inRange(blockY,0,WORLD_HEIGHT))
    world[toBlockX(mouseX)][toBlockY(mouseY)] = 0;
}

void generateDirt() {
  float xoff = 0.0;
  float n = round((TERRAIN_HEIGHT * noise(xoff)));
  for (int x = 0; x < world.length; x++) {
    for (int y = 0; y < SURFACE_HEIGHT + n; y++) {
      world[x][y] = DIRT;
    }
    xoff += TERRAIN_INTENSITY;
    n = (int)(TERRAIN_HEIGHT * noise(xoff));
  }
}

void drawBlocks() {
  int startX = max(floor(camX - width/(2*SCL) - 1),0);
  int endX = min(ceil(camX + width/(2*SCL)),world.length - 1);
  int startY = max(floor(camY - height/(2*SCL)) - 1,0);
  int endY = min(ceil(camY + height/(2*SCL)),world[0].length - 1);
  for (int x = startX; x <= endX; x++)
  for (int y = startY; y < endY; y++)
  if (world[x][y] == DIRT)
  image(dirtImg,toScreenX(x),toScreenY(y));
}

boolean inRange(float n, float min, float max) { return (n >= min && n < max); }
float toScreenX(int x) { return SCL*(x - camX) + width/2; }
float toScreenY(int y) { return height/2 - SCL*(y + 1 - camY); }
int toBlockX(float x) { return floor((x - width/2)/(SCL) + camX); }
int toBlockY(float y) { return floor((y-height/2)/-SCL +camY); }
