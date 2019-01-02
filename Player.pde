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
    
    if (keyPressed) {
      if (key == 'd') vel.x = -5;
      if (key == 'a') vel.x = 5;
      if (key == 'w') vel.y = 5;
      if (key == 's') vel.y = -5;
    }
    
    //vel.add(acc);
    //vel.limit(10);
    pos.add(vel);
    vel.mult(0);
  }
}
