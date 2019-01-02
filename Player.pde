Player player = new Player(WORLD_WIDTH / 2.0, SURFACE_HEIGHT + TERRAIN_HEIGHT);

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
      for (int i = -1; i <= 1; i++)
        if (world[(int)(pos.x)][(int)(pos.y + i)] != 0) 
          pos.x = (int)pos.x + 1;
      if (world[(int)(pos.x)][(int)(pos.y - 1.8)] != 0)
        pos.x = (int)pos.x + 1;
    }
    else if (vel.x > 0) {
      for (int i = -1; i <= 1; i++)
        if (world[(int)(pos.x + 1.5)][(int)(pos.y + i)] != 0) 
          pos.x = (int)pos.x + 0.5;
      if (world[(int)(pos.x + 1.5)][(int)(pos.y - 1.8)] != 0)
        {pos.x = (int)pos.x + 0.5; text("THIS BLOCK",width-500,200);}
    }
    
    if (vel.y < 0) {
      if (world[(int)(pos.x)][(int)(pos.y - 1.8)] != 0)
        pos.y = (int)pos.y + 0.79;
      if (world[(int)(pos.x + 1.5)][(int)(pos.y - 1.8)] != 0)
        pos.y = (int)pos.y + 0.79;
    }
    else if (vel.y > 0) {
      if (world[(int)(pos.x)][(int)(pos.y + 1)] != 0) 
          pos.y = (int)pos.y;
      if (world[(int)(pos.x + 1.5)][(int)(pos.y + 1)] != 0) 
          pos.y = (int)pos.y;
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
