Block[][] blocks;
short world_width;
short world_height;
short sky_height;
short terrain_height;
float terrain_intensity;
color sky_color;
short block_scale;

float camX;
float camY;

Player p;

void setup() {
  world_width = 20;
  world_height = 20;
  sky_height = 5;
  terrain_height = 5;
  terrain_intensity = 0.44f;
  sky_color = color(0,191,255);
  block_scale = 30;
  camX = 0;
  camY = 0;
  
  blocks = new Block[world_width][world_height];
  generateWorld(blocks, world_height, sky_height, terrain_height, terrain_intensity);
  size(800,800);
  
  p = new Player(0,0);
}

void draw() {
  background(sky_color);
  translate(p.pos.x,p.pos.y);
  displayBlocks(blocks,block_scale);
  p.update();
  camX+= 0.01
}


void displayBlocks(Block[][] world, short blkScl) {
  for (int x = 0; x < world.length; x++) {
    for (int y = 0; y < world.length; y++) {
      if (world[x][y].id != 0)
      world[x][y].display(blkScl);
    }
  }
}

void generateDirt(Block[][] world, short undergroundHt, short terrainHt, float intensity) {
  float offset = 0.0;
  short n = (short)(noise(offset) * terrainHt);
  for (short x = 0; x < world.length; x++) {
    for (short y = 0; y < undergroundHt + n; y++) {
      world[x][y].id = 1;
    }
    offset += intensity;
    n = (short)(noise(offset) * terrainHt);
  }
}

void fillWithSky(Block[][] world) {
  for (short x = 0; x < world.length; x++) {
    for (short y = 0; y < world[x].length; y++) {
      world[x][y] = new Block(x,y,(byte)0);
    }
  }
}

void generateWorld(Block[][] world, short worldHt, short skyHt, short terrainHt, float intensity) {
  fillWithSky(world);
  generateDirt(world,(short)(worldHt - skyHt - terrainHt), terrainHt, intensity);
}
