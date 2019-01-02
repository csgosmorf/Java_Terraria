//Terraria Clone by Peter Barnett

//Constants
/**/int WORLD_WIDTH = 1000;
/**/int SURFACE_HEIGHT = 1000;
/**/int TERRAIN_HEIGHT = 5;
/**/int SKY_HEIGHT = 200;
/**/int WORLD_HEIGHT = SURFACE_HEIGHT + TERRAIN_HEIGHT + SKY_HEIGHT;
/**/int SCL = 16;
/**/float TERRAIN_INTENSITY = 0.2;
/**/byte AIR = 0, DIRT = 1;
/**/color sky_color = color(127,218,255);

byte[][] world;
PImage dirtImg;
float camX = WORLD_WIDTH / 2.0;
float camY = SURFACE_HEIGHT + TERRAIN_HEIGHT;

void setup() {
  fullScreen();
  world = new byte[WORLD_WIDTH][WORLD_HEIGHT];
  generateDirt();
  dirtImg = loadImage("images/textures/0.png", "png");
  dirtImg.resize(SCL,SCL);
}

void draw() {
  background(sky_color);
  mine();
  drawBlocks();
  drawDevText();
}
