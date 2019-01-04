Player player = new Player(WORLD_WIDTH / 2.0, SURFACE_HEIGHT + TERRAIN_HEIGHT + 4);
float totalIterateTime = 0.0;
static float player_width = 1.5;
static float player_height = 2.8;
static float SMALL_NUM = 0.001;
static float ANIMATE_SPEED = 1.4;
static float MIN_ANIMATE_SPEED = 0.2;
static float horizontal_accel = 0.02;
static float jump_accel = 0.7;
static float friction_strength = 0.9;
static float MAX_XSPEED = 0.3;
static float MAX_YSPEED = 0.6;
static float collideStepSize = 0.15;

class Player {
  PVector pos;
  PVector vel;
  PVector acc;
  char direction = 'R';
  float walkFrame = 0;
  
  Player(float x, float y) {
    pos = new PVector(x,y);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
  }
  
  void update() {
    acc.add(GRAVITY);
    if (KEY_SPACE && onGround()) {
      acc.y += jump_accel;
      KEY_SPACE = false;
    }
    if (KEY_A) {
      acc.x -= horizontal_accel;
    }
    if (KEY_D) {
      acc.x += horizontal_accel;
    }
    if (!KEY_D && !KEY_A) {
      vel.x *= friction_strength;
    }
    vel.add(acc);
    
    vel.x = constrain(vel.x,-MAX_XSPEED,MAX_XSPEED);
    vel.y = constrain(vel.y,-MAX_YSPEED,MAX_YSPEED);
    
    iterativeCollideFixX();
    iterativeCollideFixY();
    
    setCamera(pos.x + player_width/2,pos.y + 1 - player_height/2);
    limitCamToWorld();
    if (abs(vel.x) < 0.05 && acc.x == 0) vel.x = 0;
    acc.set(0,0);
  }
  
  boolean onGround() {
    int[] x = {(int)(pos.x), (int)(pos.x + 1), (int)(pos.x + player_width - SMALL_NUM)};
    int y = (int)(pos.y - player_height + SMALL_NUM);
    return yesBlockNoAir(x[0],y) || yesBlockNoAir(x[1],y) || yesBlockNoAir(x[2],y);
  }
  
  //Does as many steps as needed to add vel to pos without collision mistake
  void iterativeCollideFixX() {
    boolean hitX = false;
    int numAdds = (int)(abs(vel.x) / collideStepSize);
    for (int i = 0; i < numAdds; i++) {
      pos.x += (vel.x > 0 ? collideStepSize: -collideStepSize);
      keepPlayerInWorldX();
      hitX = fixCollisionX() || hitX;
    }
    float remainder = abs(vel.x) - numAdds * collideStepSize;
    pos.x += vel.x > 0 ? remainder: -remainder;
    keepPlayerInWorldX();
    hitX = fixCollisionX() || hitX;
    if (hitX) vel.x = 0;
  }
  
  //Does as many steps as needed to add vel to pos without collision mistake
  void iterativeCollideFixY() {
    boolean hitY = false;
    int numAdds = (int)(abs(vel.y) / collideStepSize);
    for (int i = 0; i < numAdds; i++) {
      pos.y += (vel.y > 0 ? collideStepSize: -collideStepSize);
      keepPlayerInWorldY();
      hitY = fixCollisionY() || hitY;
    }
    float remainder = abs(vel.y) - numAdds * collideStepSize;
    pos.y += vel.y > 0 ? remainder: -remainder;
    keepPlayerInWorldY();
    hitY = fixCollisionY() || hitY;
    if (hitY) vel.y = 0;
  }
  
  void display() {
    imageMode(CENTER);
    float x = toScreenX(pos.x) + SCL * (player_width/2);
    float y = toScreenY(pos.y) + SCL* (player_height/2);
    if (direction == 'L') {
      if (!onGround()) image(jumping_left,x,y);
      else if (vel.x == 0) { image(standing_left,x,y); walkFrame = 0; }
      else { 
        image(running_left[(int)walkFrame],x,y);
        walkFrame += animationSpeed();
        if (walkFrame >= running_right.length) walkFrame = 0;
      }
    } 
    else {
      if (!onGround()) { image(jumping_right,x,y); }
      else if (vel.x == 0) { image(standing_right,x,y); walkFrame = 0; }
      else {
        image(running_right[(int)walkFrame],x,y);
        walkFrame += animationSpeed();
        if (walkFrame >= running_right.length) walkFrame = 0;
      }
    }
  }
  
  void mine() {
    int blockX = toBlockX(mouseX);
    int blockY = toBlockY(mouseY);
    if (mousePressed && mouseButton == LEFT)
    if (inRange(blockX,0,WORLD_WIDTH-1) && inRange(blockY,0,WORLD_HEIGHT-1))
      world[blockX][blockY] = AIR;
  }
  void place() {
    int blockX = toBlockX(mouseX);
    int blockY = toBlockY(mouseY);
    if (mousePressed && mouseButton == RIGHT)
    if (inRange(blockX,0,WORLD_WIDTH-1) && inRange(blockY,0,WORLD_HEIGHT-1))
      world[blockX][blockY] = DIRT;
  }
  
  float animationSpeed() {
    return max(abs(vel.x)*ANIMATE_SPEED,MIN_ANIMATE_SPEED);
  }
  
  //Returns true if collide in X, used for iterativeCollisionFixX
  boolean fixCollisionX() {
    int[] x = {(int)(pos.x), (int)(pos.x + player_width)};
    int[] y = {(int)(pos.y - player_height + 1), (int)(pos.y - 1), (int)(pos.y), (int)(pos.y + 1 - SMALL_NUM)};
    boolean hitX = false;
    if (yesBlockNoAir(x[0],y[0]) || yesBlockNoAir(x[0],y[1]) || yesBlockNoAir(x[0],y[2]) || yesBlockNoAir(x[0],y[3])) {
      pos.x = (int)pos.x + 1;
      hitX = true;
    }
    if (yesBlockNoAir(x[1],y[0]) || yesBlockNoAir(x[1],y[1]) || yesBlockNoAir(x[1],y[2]) || yesBlockNoAir(x[1],y[3])) {
      pos.x = (int)pos.x + (player_width - (int)player_width);
      hitX = true;
    }
    return hitX;
  }
  
  //Returns true if collide in Y, used for iterativeCollisionFixY
  boolean fixCollisionY() {
      //Block coordinates to be checked
      int[] x = {(int)(pos.x + SMALL_NUM), (int)(pos.x + 1), (int)(pos.x + player_width - SMALL_NUM)};
      int[] y = {(int)(pos.y + 1), (int)(pos.y - player_height + 1)};
      boolean hitY = false;
      if (yesBlockNoAir(x[0],y[0]) || yesBlockNoAir(x[1],y[0]) || yesBlockNoAir(x[2],y[0])) {
        pos.y = (int)pos.y;
        hitY = true;
      }
      if (yesBlockNoAir(x[0],y[1]) || yesBlockNoAir(x[1],y[1]) || yesBlockNoAir(x[2],y[1])) {
        pos.y = (int)pos.y + (player_height - (int)player_height);
        hitY = true;
      }
      return hitY;
  }
  
  void keepPlayerInWorldX() {
    if (pos.x < 0) { pos.x = 0; } 
    else if (pos.x > WORLD_WIDTH - player_width) { pos.x = WORLD_WIDTH - player_width; }
  }
  void keepPlayerInWorldY() {
    if (pos.y < -1 + player_height) { pos.y = -1 + player_height; } 
    else if (pos.y > WORLD_HEIGHT - 1) { pos.y = WORLD_HEIGHT - 1; }
  }
}
