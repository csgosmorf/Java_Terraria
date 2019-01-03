//Terraria Clone by Peter Barnett

//For testing processing time of methods
//ArrayList<Integer> frameTimes;

void setup() {
  fullScreen(P3D);
  frameRate(180);
  allocateWorld();
  generateDirt();
  loadImages();
  
  //frameTimes = new ArrayList<Integer>();
}

void draw() {
  drawSky();
  player.update();
  player.mine();
  player.place();
  drawBlocks();
  player.display();
  drawDevText();
  
  //For testing processing time of methods
  //int start = millis();
  //Function to test
  //int end = millis();
  //if (millis() > 3000)
  //frameTimes.add(end - start);
  //if (frameTimes.size() > 0)
  //text("Average frame time: " + average(frameTimes) + "ms",width-200,150);
  //if (mousePressed && mouseButton == RIGHT) frameTimes.clear();
}

//For testing processing time of methods
//float average(ArrayList<Integer> arr) {
//  int totalMS = 0;
//  for (int i = 0; i < arr.size(); i++)
//    totalMS += arr.get(i);
//  return (float)totalMS / arr.size();
//}
