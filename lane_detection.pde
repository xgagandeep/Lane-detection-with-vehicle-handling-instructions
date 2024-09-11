import gab.opencv.*;
import processing.video.*;
Lane lane;
OpenCV opencv,opencv2;
ArrayList<Line> lines;
Movie sr;

int i = 1;
void setup()
{
  lane = new Lane();
  size(1280, 720);
  opencv = new OpenCV(this,1280,360);
  opencv2 = new OpenCV(this,1280,720);
  sr = new Movie(this,"d.mp4");
  //lane.cvOperation(); 
  //lane.drawBackgroundImage();
  //lane.laneDetect();
  //lane.drawDetectedLane();
  //lane.distanceFromCenter();
  sr.play();
  //sr.read();
  //sr.loop();
 }
//void movieEvent(Movie sr)
//{
 
//}
void draw() 
{ 
  lane.drawBackgroundImage();
  if(sr.available())
  {
    
     sr.read();
  }
  lane.cvOperation();
  lane.laneDetect();
  lane.linearRegression();
  
  lane.drawDetectedLane();
  lane.distanceFromCenter();
println(frameRate);
}
void mousePressed()
{
  if(i==1)
  {
    sr.pause();
    i=5;
  }
  else
  {
    sr.play();
    i=1;
  }
}