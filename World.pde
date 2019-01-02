//Constants
/**/static final int WORLD_WIDTH = 1000;
/**/static final int SURFACE_HEIGHT = 1000;
/**/static final int TERRAIN_HEIGHT = 16;
/**/static final int SKY_HEIGHT = 200;
/**/static final int WORLD_HEIGHT = SURFACE_HEIGHT + TERRAIN_HEIGHT + SKY_HEIGHT;
/**/static final int SCL = 16;
/**/static final float TERRAIN_INTENSITY = 0.05;
/**/static final byte AIR = 0, DIRT = 1;
/**/color sky_color = color(127,218,255);
byte[][] world;


void drawSky() {
  background(sky_color);
}

void allocateWorld() {
  world = new byte[WORLD_WIDTH][WORLD_HEIGHT];
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
  int endY = min(ceil(camY + height/(2*SCL)) + 1,world[0].length - 1);
  for (int x = startX; x <= endX; x++)
  for (int y = startY; y < endY; y++)
  if (world[x][y] == DIRT)
  image(dirtImg,toScreenX(x),toScreenY(y));
}
