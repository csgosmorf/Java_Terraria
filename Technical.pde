boolean KEY_W = false, KEY_A = false, KEY_S = false, KEY_D = false, KEY_SPACE = false;
float camX = WORLD_WIDTH / 2.0;
float camY = SURFACE_HEIGHT + TERRAIN_HEIGHT;
static PImage blue_cursor;
static PImage dirtImg;
static PImage spriteSheet;
static PImage standing_left;
static PImage standing_right;
static PImage jumping_left;
static PImage jumping_right;
static PImage[] running_right;
static PImage[] running_left;

void setCamera(float x, float y) { camX = x; camY = y; }
void limitCamToWorld() {
  camX = constrain(camX,width/(2*SCL),WORLD_WIDTH - width/(2*SCL));
  camY = constrain(camY,height/(2*SCL)+1,WORLD_HEIGHT - height/(2.0*SCL));
}

void loadImages() {
  blue_cursor = loadImage("data/images/cursors/myCursor.png","png");
  dirtImg = loadImage("data/images/textures/0.png", "png");
  dirtImg.resize(SCL,SCL);
  
  spriteSheet = loadImage("data/images/spriteSheet/char_sprite.png","png");
  
  standing_right = spriteSheet.get(4,12,32,42);
  standing_left = mirrorOf(standing_right);
  jumping_right = spriteSheet.get(4,292,32,42);
  jumping_left = mirrorOf(jumping_right);
  running_right = new PImage[14];
  running_left = new PImage[14];
  
  for (int i = 0; i < 14; i++) {
    running_right[i] = spriteSheet.get(4,346 + i * 56,32,44);
    running_left[i] = mirrorOf(running_right[i]);
  }
  resizePlayerAnimations();
}

void resizePlayerAnimations() {
  standing_right.resize(round(SCL*player_width*(standing_right.width/24.0)),round(SCL*player_height));
  standing_left.resize(round(SCL*player_width*(standing_left.width/24.0)),round(SCL*player_height));
  jumping_right.resize(round(SCL*player_width*(jumping_right.width/24.0)),round(SCL*player_height));
  jumping_left.resize(round(SCL*player_width*(jumping_left.width/24.0)),round(SCL*player_height));
  for (int i = 0; i < 14; i++) {
    running_left[i].resize(round(SCL*player_width*(32.0/24)),round(SCL*player_height*(44.0/42)));
    running_right[i].resize(round(SCL*player_width*(32.0/24)),round(SCL*player_height*(44.0/42)));
  }
}

PImage mirrorOf(PImage imgIn) {
  int w = imgIn.width;
  int h = imgIn.height;
  PImage imgOut = createImage(w,h,ARGB);
  for (int y = 0; y < h; y++)
  for (int x = 0; x < w; x++)
    imgOut.pixels[w*y + x] = imgIn.pixels[w*y + (w - 1) - x];
  return imgOut;
}

void keyPressed() {
  if (key == 'w' || key == 'W') KEY_W = true;
  else if (key == 'a' || key == 'A') {
    KEY_A = true;
    player.direction = 'L';
  }
  else if (key == 's' || key == 'S') KEY_S = true;
  else if (key == 'd' || key == 'D') {
    KEY_D = true;
    player.direction = 'R';
  }
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
boolean inWorld(int x, int y) { return inRange(x,0,WORLD_WIDTH-1) && inRange(y,0,WORLD_HEIGHT-1);}
boolean inRange(float n, float min, float max) { return (n >= min && n <= max); }
float toScreenX(float x) { return SCL*(x - camX) + width/2; }
float toScreenY(float y) { return height/2 - SCL*(y + 1 - camY); }
int toBlockX(float x) { return floor((x - width/2)/(SCL) + camX); }
int toBlockY(float y) { return floor((y-height/2)/-SCL + camY); }
