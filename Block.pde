class Block {
  shortVec pos;
  byte id;
  
  Block(short x, short y, byte id) {
    this.pos = new shortVec(x,y);
    this.id = id;
  }
  
  void display(int scl) {
    rect(scl *(this.pos.x - camX), world_height - scl*(this.pos.y - camY), scl, scl);
  }
}
