boolean KEY_W = false, KEY_A = false, KEY_S = false, KEY_D = false;
float camX = WORLD_WIDTH / 2.0;
float camY = SURFACE_HEIGHT + TERRAIN_HEIGHT;
static PImage dirtImg;

void loadImages() {
  dirtImg = loadImage("images/textures/0.png", "png");
  dirtImg.resize(SCL,SCL);
}

void keyPressed() {
  if (key == 'w') KEY_W = true;
  else if (key == 'a') KEY_A = true;
  else if (key == 's') KEY_S = true;
  else if (key == 'd') KEY_D = true;
}

void keyReleased() {
  if (key == 'w') KEY_W = false;
  else if (key == 'a') KEY_A = false;
  else if (key == 's') KEY_S = false;
  else if (key == 'd') KEY_D = false;
}

void drawDevText() {
  text("camera: " + camX + ", " + camY,50,50);
  text("FPS: " + frameRate,50,65);
  text("toBlockX(mouseX) = " + toBlockX(mouseX),50,80);
  text("toBlockY(mouseY) = " + toBlockY(mouseY),50,95);
}

void moveCamera() {
  if (KEY_W) camY += 0.5;
  if (KEY_S) camY -= 0.5;
  if (KEY_A) camX -= 0.5;
  if (KEY_D) camX += 0.5;
}

boolean inRange(float n, float min, float max) { return (n >= min && n < max); }
float toScreenX(int x) { return SCL*(x - camX) + width/2; }
float toScreenY(int y) { return height/2 - SCL*(y + 1 - camY); }
int toBlockX(float x) { return floor((x - width/2)/(SCL) + camX); }
int toBlockY(float y) { return floor((y-height/2)/-SCL +camY); }
