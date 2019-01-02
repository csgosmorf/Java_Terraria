byte[][] world;
int world_width = 1000;
int surface_height = 1000;
int terrain_height = 5;
int sky_height = 200;
int world_height = surface_height + terrain_height + sky_height;
int block_scl = 25;

float terrain_intensity = 0.2;
float camX = world_width / 2.0;
float camY = surface_height + terrain_height;


void setup() {
  fullScreen();
  world = new byte[world_width][world_height];
  float xoff = 0.0;
  float n = round((terrain_height * noise(xoff)));
  
  for (int x = 0; x < world.length; x++)
  for (int y = 0; y < world[0].length; y++)
  world[x][y] = 0;
  
  for (int x = 0; x < world.length; x++) {
    for (int y = 0; y < surface_height + n; y++) {
      world[x][y] = 1;
    }
    xoff += terrain_intensity;
    n = (int)(terrain_height * noise(xoff));
  }
}

void draw() {
  background(127,218,255);
  drawBlocks();
  camX += 0.25;
}

void drawDevText() {
  text("camera: " + camX + ", " + camY,50,50);
  text("FPS: " + frameRate,50,70);
}

void drawBlocks() {
  int startX = max(floor(camX - width/(2*block_scl) - 1),0);
  int endX = min(ceil(camX + width/(2*block_scl)),world.length - 1);
  int startY = max(floor(camY - height/(2*block_scl)) - 1,0);
  int endY = min(ceil(camY + height/(2*block_scl)),world[0].length - 1);
  
  for (int x = startX; x <= endX; x++) {
    for (int y = startY; y < endY; y++) {
      if (world[x][y] == 1) {
        fill(139,69,13);
        rect(block_scl*(x - camX) + width/2,height - block_scl*(y + 1 - camY) - height/2,block_scl,block_scl);
      }
    }
  }
}
