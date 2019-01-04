//Constants
/**/static final int WORLD_WIDTH = 1024;
/**/static final int SURFACE_HEIGHT = 256;
/**/static final int TERRAIN_HEIGHT = 16;
/**/static final int SKY_HEIGHT = 128;
/**/static final int WORLD_HEIGHT = SURFACE_HEIGHT + TERRAIN_HEIGHT + SKY_HEIGHT;
/**/static final int SCL = 16;
/**/static final float TERRAIN_INTENSITY = 0.05;
/**/static final byte AIR = 0, DIRT = 1;
/**/static final PVector GRAVITY = new PVector(0,-90);
/**/color sky_color = color(127,218,255);
byte[][] world;


void drawSky() { background(sky_color); }
void allocateWorld() { world = new byte[WORLD_WIDTH][WORLD_HEIGHT]; }
void generateDirt() {
  float xoff = 0.0;
  float n = round((TERRAIN_HEIGHT * noise(xoff)));
  for (int x = 0; x < WORLD_WIDTH; x++) {
    for (int y = 0; y < SURFACE_HEIGHT + n; y++) {
      world[x][y] = DIRT;
    }
    xoff += TERRAIN_INTENSITY;
    n = round(TERRAIN_HEIGHT * noise(xoff));
  }
}

void drawBlocks() {
  noFill();
  stroke(0);
  imageMode(CORNERS);
  int startX = max(floor(camX - width/(2*SCL) - 1),0);
  int endX = min(ceil(camX + width/(2*SCL)),WORLD_WIDTH - 1);
  int startY = max(floor(camY - height/(2*SCL)) - 2,0);
  int endY = min(ceil(camY + height/(2*SCL)) + 1,WORLD_HEIGHT - 1);
  for (int x = startX; x <= endX; x++) {
    float screenX = toScreenX(x);
    for (int y = startY; y <= endY; y++) {
      if (world[x][y] == DIRT) {
        image(dirtImg,screenX,toScreenY(y));
      }
    }
  }
}
//Makes sure block is within bounds and not air
boolean yesBlockNoAir(int x, int y) { return inWorld(x,y) && world[x][y] != 0; }
