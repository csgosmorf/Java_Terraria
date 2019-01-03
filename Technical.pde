boolean KEY_W = false, KEY_A = false, KEY_S = false, KEY_D = false, KEY_SPACE = false;
float camX = WORLD_WIDTH / 2.0;
float camY = SURFACE_HEIGHT + TERRAIN_HEIGHT;
static PImage dirtImg;

void setCamera(float x, float y) {
  camX = x;
  camY = y;
}

void limitCamToWorld() {
  camX = constrain(camX,width/(2*SCL),WORLD_WIDTH - width/(2*SCL));
  camY = constrain(camY,height/(2*SCL) + 1,WORLD_HEIGHT - 2 - height/(2*SCL));
}

void loadImages() {
  dirtImg = loadImage("data/images/textures/0.png", "png");
  dirtImg.resize(SCL,SCL);
}

void keyPressed() {
  if (key == 'w' || key == 'W') KEY_W = true;
  else if (key == 'a' || key == 'A') KEY_A = true;
  else if (key == 's' || key == 'S') KEY_S = true;
  else if (key == 'd' || key == 'D') KEY_D = true;
  else if (key == ' ') KEY_SPACE = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') KEY_W = false;
  else if (key == 'a' || key == 'A') KEY_A = false;
  else if (key == 's' || key == 'S') KEY_S = false;
  else if (key == 'd' || key == 'D') KEY_D = false;
  else if (key == ' ') KEY_SPACE = false;
}

void drawDevText() {
  fill(0);
  text("camera: " + camX + ", " + camY,50,50);
  text("FPS: " + frameRate,50,65);
  text("toBlockX(mouseX) = " + toBlockX(mouseX),50,80);
  text("toBlockY(mouseY) = " + toBlockY(mouseY),50,95);
  text("playerPosX = " + player.pos.x,50,110);
  text("playerPosY = " + player.pos.y,50,125);
  text("playerVelX = " + player.vel.x,50,140);
  text("playerVelY = " + player.vel.y,50,155);
  text("onGround = " + player.onGround(),50,170);
}
boolean inWorld(int x, int y) {
  return inRange(x,0,WORLD_WIDTH) && inRange(y,0,WORLD_HEIGHT);
}

boolean inRange(float n, float min, float max) { return (n >= min && n < max); }
float toScreenX(float x) { return SCL*(x - camX) + width/2; }
float toScreenY(float y) { return height/2 - SCL*(y + 1 - camY); }
int toBlockX(float x) { return floor((x - width/2)/(SCL) + camX); }
int toBlockY(float y) { return floor((y-height/2)/-SCL +camY); }
