int AIR = 0;
int DIRT = 1;
int[][] world;

void setup() {
  size(800,800);
  world = new int[10][10];
  float xoff = 0.0;
  float n = 4 * (int)(noise(xoff));
  
  for (int x = 0; x < 10; x++)
  for (int y = 0; y < 10; y++)
    world[x][y] = 0;
  
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 6 + n; y++) {
      world[x][y] = 1;
    }
    xoff += 0.4;
    n = (int)(4 * noise(xoff));
  }
}

void draw() {
  background(255);
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 10; y++) {
      if (world[x][y] == 1)
      rect(30*x,height - 30*y,30,30);
    }
  }
}
