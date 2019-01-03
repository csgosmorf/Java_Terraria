Player player = new Player(WORLD_WIDTH / 2.0, SURFACE_HEIGHT + TERRAIN_HEIGHT);
float[] xCollideOffsets = {0.0,1.0,1.4};
float[] yCollideOffsets = {-1.7,-1.0,0.0,0.85};

class Player {
  PVector pos;
  PVector vel;
  PVector acc;
  
  Player(float x, float y) {
    pos = new PVector(x,y);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
  }
  
  void update() {
    if (KEY_A) vel.x = -0.1;
    if (KEY_D) vel.x = 0.1;
    if (KEY_W) vel.y = 0.1;
    if (KEY_S) vel.y = -0.1;
    pos.add(vel);
    keepPlayerInWorld();
    fixPlayerCollisions();
    setCamera(pos.x + 0.75,pos.y + 1 - 1.4);
    //setCamera(max(width/(2*SCL),camX),camY);
    vel.set(0,0);
  }
  
  void display() {
    noFill();
    strokeWeight(2);
    stroke(120,150,0);
    //rectMode(CENTER);
    rect(toScreenX(pos.x),toScreenY(pos.y),SCL*1.5 , SCL * 2.8);
    fill(255,0,0);
    ellipse(width/2,height/2,5,5);
  }
  
  void mine() {
    int blockX = toBlockX(mouseX);
    int blockY = toBlockY(mouseY);
    if (mousePressed && mouseButton == LEFT)
    if (inRange(blockX,0,WORLD_WIDTH) && inRange(blockY,0,WORLD_HEIGHT))
      world[blockX][blockY] = 0;
  }
  
  void place() {
    int blockX = toBlockX(mouseX);
    int blockY = toBlockY(mouseY);
    if (mousePressed && mouseButton == RIGHT)
    if (inRange(blockX,0,WORLD_WIDTH) && inRange(blockY,0,WORLD_HEIGHT))
      world[blockX][blockY] = 1;
  }
  
  void fixPlayerCollisions() {
    if (vel.x < 0) {
      for (int i = 0; i < 4; i++) {
        int row = (int)(pos.x);
        int col = (int)(pos.y + yCollideOffsets[i]);
        if (inWorld(row,col)) {
          if (world[row][col] != 0)
            pos.x = (int)pos.x + 1;
        }
      }
    }
    else if (vel.x > 0) {
      for (int i = 0; i < 4; i++) {
        int row = (int)(pos.x + 1.5);
        int col = (int)(pos.y + yCollideOffsets[i]);
        if (inWorld(row,col)) {
          if (world[row][col] != 0)
            pos.x = (int)pos.x + 0.5;
        }
      }
    }
    if (vel.y < 0) {
      for (int i = 0; i < 3; i++) {
        int row = (int)(pos.x + xCollideOffsets[i]);
        int col = (int)(pos.y - 1.8);
        if (inWorld(row,col)) {
          if (world[row][col] != 0)
            pos.y = (int)pos.y + 0.8;
        }
      }
    }
    else if (vel.y > 0) {
      for (int i = 0; i < 3; i++) {
        int row = (int)(pos.x + xCollideOffsets[i]);
        int col = (int)(pos.y + 1);
        if (inWorld(row,col)) {
          if (world[row][col] != 0)
            pos.y = (int)pos.y;
        }
      }
    }
  }
  
  void keepPlayerInWorld() {
    if (pos.x < 0) {
      pos.x = 0;
    } else if (pos.x > world.length - 1) {
      pos.x = world.length - 1;
    }
    
    if (pos.y < 0) {
      pos.y = 0;
    } else if (pos.y > world[0].length - 1) {
      pos.y = world[0].length - 1;
    }
  }
}
