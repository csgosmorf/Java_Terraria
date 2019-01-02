int[][] world;
float camX = 8;
float camY = 5;


void setup() {
  size(900,900);
  world = new int[16][10];
  float xoff = 0.0;
  float n = 4 * (int)(noise(xoff));
  
  for (int x = 0; x < world.length; x++)
  for (int y = 0; y < world[0].length; y++)
  world[x][y] = 0;
  
  for (int x = 0; x < world.length; x++) {
    for (int y = 0; y < world[0].length - n; y++) {
      world[x][y] = 1;
    }
    xoff += 0.4;
    n = (int)(4 * noise(xoff));
  }
}

void draw() {
  background(127,218,255);
  for (int x = 0; x < world.length; x++) {
    for (int y = 0; y < world[0].length; y++) {
      if (world[x][y] == 1) {
        fill(139,69,13);
        rect(30*(x - camX) + width/2,height - 30*(y - camY) - height/2,30,30);
      }
    }
  }
  text("camera: " + camX + ", " + camY,50,50);
  //camX += 0.02;
}
