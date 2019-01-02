//Terraria Clone by Peter Barnett

//Constants
/**/byte[][] world;
/**/int world_width = 1000;
/**/int surface_height = 1000;
/**/int terrain_height = 5;
/**/int sky_height = 200;
/**/int world_height = surface_height + terrain_height + sky_height;
/**/int block_scl = 16;
/**/float terrain_intensity = 0.2;
/**/float camX = world_width / 2.0;
/**/float camY = surface_height + terrain_height;
/**/PImage dirtImg;
/**/byte AIR = 0, DIRT = 1;
/**/color sky_color = color(127,218,255);

void setup() {
  fullScreen();
  world = new byte[world_width][world_height];
  generateDirt();
  dirtImg = loadImage("images/textures/0.png", "png");
  dirtImg.resize(block_scl,block_scl);
}

void draw() {
  background(sky_color);
  mine();
  drawBlocks();
  drawDevText();
}
