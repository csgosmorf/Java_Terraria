//Constants
/**/static final int WORLD_WIDTH = 10000;
/**/static final int SURFACE_HEIGHT = 100;
/**/static final int TERRAIN_HEIGHT = 16;
/**/static final int SKY_HEIGHT = 300;
/**/static final int WORLD_HEIGHT = SURFACE_HEIGHT + TERRAIN_HEIGHT + SKY_HEIGHT;
/**/static final int SCL = 16;
/**/static final float TERRAIN_INTENSITY = 0.05;
/**/static final byte AIR = 0, DIRT = 1;
/**/static final PVector GRAVITY = new PVector(0,-0.02);
/**/color sky_color = color(127,218,255);
byte[][] world;


void drawSky() { background(sky_color); }
void allocateWorld() { world = new byte[WORLD_WIDTH][WORLD_HEIGHT]; }

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
  noFill();
  stroke(0);
  imageMode(CORNERS);
  int startX = max(floor(camX - width/(2*SCL) - 1),0);
  int endX = min(ceil(camX + width/(2*SCL)),world.length - 1);
  int startY = max(floor(camY - height/(2*SCL)) - 2,0);
  int endY = min(ceil(camY + height/(2*SCL)) + 1,world[0].length - 1);
  for (int x = startX; x <= endX; x++) {
    float screenX = toScreenX(x);
    for (int y = startY; y < endY; y++) {
      if (world[x][y] == DIRT) {
        image(dirtImg,screenX,toScreenY(y));
      }
    }
  }
}
