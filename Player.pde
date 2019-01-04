Player player = new Player(WORLD_WIDTH / 2.0, SURFACE_HEIGHT + TERRAIN_HEIGHT + 4);
float totalIterateTime = 0.0;
float player_width = 1.5;
float player_height = 2.8;
float[] xCollideOffsets = {0.0,1.0,player_width - 0.2};
float[] yCollideOffsets = {-1.6,-1.0,0.0,0.75};

class Player {
  PVector pos;
  PVector vel;
  PVector acc;
  char direction = 'R';
  float walkingFrame = 0;
  
  Player(float x, float y) {
    pos = new PVector(x,y);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
  }
  
  void update() {
    acc.add(GRAVITY);
    if (KEY_SPACE && onGround()) {
      acc.y += 0.7;
      KEY_SPACE = false;
    }
    if (KEY_A) {
      acc.x -= 0.06;
    }
    if (KEY_D) {
      acc.x += 0.06;
    }
    if (!KEY_D && !KEY_A) {
      vel.x *= 0.9;
      //float frictionX = -vel.x * 0.15;
      //vel.x += frictionX;
    }
    vel.add(acc);
    
    vel.x = constrain(vel.x,-0.3,0.3);
    vel.y = constrain(vel.y,-0.6,0.6);
    
    iterativeCollideFixX();
    iterativeCollideFixY();
    
    setCamera(pos.x + 0.75,pos.y + 1 - 1.4);
    limitCamToWorld();
    if (abs(vel.x) < 0.05 && acc.x == 0) vel.x = 0;
    acc.set(0,0);
  }
  
  boolean onGround() {
    int row = (int)(pos.x + 0);
    int col = (int)(pos.y - 1.82);
    if (inWorld(row,col)) {
      if (world[row][col] != 0) {
        return true;
      }
    }
    
    row = (int)(pos.x + 1);
    col = (int)(pos.y - 1.82);
    if (inWorld(row,col)) {
      if (world[row][col] != 0) {
        return true;
      }
    }
    row = (int)(pos.x + 1.4);
    col = (int)(pos.y - 1.82);
    if (inWorld(row,col)) {
      if (world[row][col] != 0) {
        return true;
      }
    }
    return false;
  }
  
  //Does as many steps as needed to add vel to pos without collision mistake
  void iterativeCollideFixX() {
    boolean hitX = false;
    int numAdds = (int)(abs(vel.x) / 0.15);
    for (int i = 0; i < numAdds; i++) {
      pos.x += (vel.x > 0 ? 0.15: -0.15);
      keepPlayerInWorldX();
      hitX = fixCollisionX() || hitX;
    }
    float remainder = abs(vel.x) - numAdds * 0.15;
    pos.x += vel.x > 0 ? remainder: -remainder;
    keepPlayerInWorldX();
    hitX = fixCollisionX() || hitX;
    if (hitX) vel.x = 0;
  }
  
  //Does as many steps as needed to add vel to pos without collision mistake
  void iterativeCollideFixY() {
    boolean hitY = false;
    int numAdds = (int)(abs(vel.y) / 0.15);
    for (int i = 0; i < numAdds; i++) {
      pos.y += (vel.y > 0 ? 0.15: -0.15);
      keepPlayerInWorldY();
      hitY = fixCollisionY() || hitY;
    }
    float remainder = abs(vel.y) - numAdds * 0.15;
    pos.y += vel.y > 0 ? remainder: -remainder;
    keepPlayerInWorldY();
    hitY = fixCollisionY() || hitY;
    if (hitY) vel.y = 0;
  }
  
  void display() {
    //fill(255,0,0);
    //ellipse(width/2,height/2,10,10);
    imageMode(CENTER);
    if (direction == 'L') {
      if (!onGround()) {
        image(jumping_left,toScreenX(pos.x) + SCL *0.75,toScreenY(pos.y) + SCL*1.4);
      }
      
      else if (vel.x == 0) {
        image(standing_left,toScreenX(pos.x) + SCL *0.75,toScreenY(pos.y) + SCL*1.4);
        walkingFrame = 0;
      }
      else {
        image(running_left[(int)walkingFrame],toScreenX(pos.x) + SCL *0.75,toScreenY(pos.y) + SCL*1.4);
        walkingFrame+= max(abs(vel.x)*1.4,0.2);
        if (walkingFrame >= 13) walkingFrame = 0;
      }
    } 
    else {
      if (!onGround()) {
        image(jumping_right,toScreenX(pos.x) + SCL *0.75,toScreenY(pos.y) + SCL*1.4);
      }
      
      else if (vel.x == 0) {
        image(standing_right,toScreenX(pos.x) + SCL *0.75,toScreenY(pos.y) + SCL*1.4);
        walkingFrame = 0;
      }
      else {
        image(running_right[(int)walkingFrame],toScreenX(pos.x) + SCL *0.75,toScreenY(pos.y) + SCL*1.4);
        walkingFrame+= max(abs(vel.x)*1.4,0.2);
        if (walkingFrame >= 13) walkingFrame = 0;
      }
    }
    //noFill();
    //strokeWeight(2);
    //stroke(120,150,0);
    //rect(toScreenX(pos.x),toScreenY(pos.y),SCL*1.5 , SCL * 2.8);
  }
  
  void mine() {
    int blockX = toBlockX(mouseX);
    int blockY = toBlockY(mouseY);
    if (mousePressed && mouseButton == LEFT)
    if (inRange(blockX,0,WORLD_WIDTH-1) && inRange(blockY,0,WORLD_HEIGHT-1))
      world[blockX][blockY] = 0;
  }
  
  void place() {
    int blockX = toBlockX(mouseX);
    int blockY = toBlockY(mouseY);
    if (mousePressed && mouseButton == RIGHT)
    if (inRange(blockX,0,WORLD_WIDTH-1) && inRange(blockY,0,WORLD_HEIGHT-1)) {
      text("Placing...",50,185);
      world[blockX][blockY] = 1;
    }
  }
  
  //Returns true if collision occurs in X dir
  boolean fixCollisionX() {
      boolean hitX = false;
      for (int i = 0; i < 4; i++) {
        int row = (int)(pos.x);
        int col = (int)(pos.y + yCollideOffsets[i]);
        if (inWorld(row,col)) {
          if (world[row][col] != 0) {
            pos.x = (int)pos.x + 1;
            hitX = true;
          }
        }
      }
      for (int i = 0; i < 4; i++) {
        int row = (int)(pos.x + player_width);
        int col = (int)(pos.y + yCollideOffsets[i]);
        if (inWorld(row,col)) {
          if (world[row][col] != 0) {
            pos.x = (int)pos.x + 0.5;
            hitX = true;
          }
        }
      }
      return hitX;
  }
  
  //Returns true if collision occurs in X dir
  boolean fixCollisionY() {
      boolean hitY = false;
      for (int i = 0; i < 3; i++) {
        int row = (int)(pos.x + xCollideOffsets[i]);
        int col = (int)(pos.y - player_height) + 1;
        if (inWorld(row,col)) {
          if (world[row][col] != 0) {
            pos.y = (int)pos.y + 0.8;
            hitY = true;
          }
        }
      }
      for (int i = 0; i < 3; i++) {
        int row = (int)(pos.x + xCollideOffsets[i]);
        int col = (int)(pos.y) + 1;
        if (inWorld(row,col)) {
          if (world[row][col] != 0) {
            pos.y = (int)pos.y;
            hitY = true;
          }
        }
      }
      return hitY;
  }
  
  void keepPlayerInWorldX() {
    if (pos.x < 0) {
      pos.x = 0;
    } else if (pos.x > world.length - player_width) {
      pos.x = world.length - player_width;
    }
  }
  
  void keepPlayerInWorldY() {
    if (pos.y < -1 + player_height) {
      pos.y = -1 + player_height;
    } else if (pos.y > WORLD_HEIGHT - 1) {
      pos.y = world[0].length - 1;
    }
  }
}
