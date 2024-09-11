import gab.opencv.*;
class Lane
{
  //Right lane variables
  //length of longest right lane
  float rmaxlength;
  //starting point of longest right lane
  float rstartx;
  float rstarty;
  //ending point of longest right lane
  float rendx;
  float rendy;
  //Left lane variables
  //length of longest left lane
  float lmaxlength;
  //starting point of longes left lane
  float lstartx;
  float lstarty;
  //ending point of longest left lane
  float lendx;
  float lendy;
  //Region of interest variables
  int roiWidth;
  int roiHeight;
  int xoffset;
  int yoffset;
  //Images
  //Original image
  PImage src;
  //Region of interest image
  PImage roi;
  float center_distance;
  float right_distance;
  float left_distance;
  //Linear regression
  float lm = 0;
  float rm;
  float lb =0 ;
  float rb;
   int bottom_left_y ;
  int  bottom_left_x ;
   int top_left_y ;
    int top_left_x ;
      int bottom_right_y ;
    int  bottom_right_x ;
    int top_right_y ;
    int top_right_x ;
  Lane()
  {
    rmaxlength =0 ;
    lmaxlength = 0;
    roiWidth=1280;
    roiHeight=400;
    xoffset = 0;
    yoffset = 360;
    roi = createImage(roiWidth, roiHeight, RGB);
  }
  void cvOperation()
  {
    roi.copy(sr, xoffset, yoffset, roiWidth, roiHeight, 0, 0, roiWidth, roiHeight);
    opencv.loadImage(roi);
    //opencv2.loadImage(sr);
    //opencv2.findCannyEdges(100, 200);

    opencv.findCannyEdges(100, 200);
    // Find lines with Hough line detection
    // Arguments are: threshold, minLengthLength, maxLineGap
    lines = opencv.findLines(30, 150, 400);
  }
  void laneDetect()
  {
    //rstartx= 0 ;
    //rstarty = 0;
    rmaxlength = 0;
    //rendx= 0 ;
    //rendy = 0;
    //lstartx = 0;
    //lstarty = 0;
    lmaxlength = 0;
    //lendx = 0;
    //lendy = 0;
    //Advance for loop to detect the longest right and left line 
    for (Line line : lines)
    {

      // lines include angle in radians, measured in double precision

      // so we can select out vertical and horizontal lines

      //right side line 
      float rdist , ldist;

      if (line.angle < radians(0)&& line.angle > -4)
      {
        //println(line.angle);

        rdist =dist(line.start.x, line.start.y, line.end.x, line.end.y);
        if (rmaxlength < dist(line.start.x, line.start.y, line.end.x, line.end.y))
        {
          rmaxlength =  rdist;
          rstartx = line.start.x;
          rstarty = line.start.y;
          rendx = line.end.x;
          rendy = line.end.y;
          
        //  stroke(255, 0, 0);
        //line(rstartx+xoffset, rstarty+yoffset, rendx+xoffset, rendy+yoffset);

        }


      }

      //left side line

      if (line.angle > radians(0) && line.angle < radians(58))
      {
       ldist =  dist(line.start.x, line.start.y, line.end.x, line.end.y);
        if (lmaxlength < ldist)
        {
          lmaxlength =  ldist;
          lstartx = line.start.x;
          lstarty = line.start.y;
          lendx = line.end.x;
          lendy = line.end.y;
          
            //stroke(0, 255, 255);
            //line(lstartx+xoffset, lstarty+yoffset, lendx+xoffset, lendy+yoffset);
        }


      }
    }
    
  }
  void linearRegression()
  {
     lm= (lstarty-lendy)/(lstartx-lendx);
     lb = ((lstarty+lendy)/2) - lm* ((lstartx+lendx)/2);
     
    bottom_left_y = 400;
    bottom_left_x = int((bottom_left_y - lb)/lm);
    
    top_left_y = 0;
    top_left_x = int((top_left_y - lb)/lm);
    
    rm = (rendy-rstarty)/(rendx-rstartx);
    rb = ((rstarty+rendy)/2) - rm * ((rstartx+rendx)/2);
    bottom_right_y = 400;
    bottom_right_x = int((bottom_right_y - rb)/rm);
    top_right_y = 0;
    top_right_x = int((top_right_y - rb)/rm);
  }
  
  void drawDetectedLane()
  {
    
    //println(top_right_x+"  "+rstartx);
    
    strokeWeight(30);
    fill(192,90);
    stroke(192);
   // quad(top_right_x+xoffset, top_right_y+yoffset, top_left_x+xoffset, top_left_y+yoffset, bottom_left_x+xoffset, bottom_left_y+yoffset, bottom_right_x+xoffset, bottom_right_y+yoffset);
    stroke(139,0,139,90);
    //strokeWeight(30);
    //line(lstartx+xoffset, lstarty+yoffset, lendx+xoffset, lendy+yoffset);
    line(top_left_x+xoffset, top_left_y+yoffset, bottom_left_x+xoffset, bottom_left_y+yoffset);
    //stroke(0, 0, 0);
    //line(+xoffset, rstarty+yoffset, rendx+xoffset, rendy+yoffset);
      line(top_right_x+xoffset, top_right_y+yoffset, bottom_right_x+xoffset, bottom_right_y+yoffset);
  }
  void distanceFromCenter()
  {
    center_distance = dist(top_left_x,top_left_y,top_right_x, top_right_y);
    //text(center_distance, 50, 50);
    center_distance /= 2;

    float centerx;
    float centery;
    centerx = top_left_x+center_distance;
    centery = top_left_y;
    //text(centerx, 150, 50);
    left_distance = dist(lendx, lendy, centerx, centery);
    right_distance = dist(centerx, centery, rstartx, rstarty);
    //println(left_distance);
    //println(right_distance);
    strokeWeight(10);
    stroke(0);
    //line(top_left_x, top_left_y, centerx, centery);
    //line(centerx, centery, top_right_x, top_right_y);
    if((centerx+xoffset)<width/2)
    {
      fill(150,200,100);
      textSize(50);
        text("Turn Left", 150, 50);
    }
    else if((centerx+xoffset)>width/2)
    {
      fill(150,200,100);
      textSize(50);
       text("Turn Right", 750, 50);
    }
    else
    {
      fill(150,200,100);
      textSize(50);
       text("Go Straight", 450, 50);
      
    }

    line(centerx+xoffset-100, centery+yoffset+150, centerx+xoffset+100, centery+yoffset+150);
    strokeWeight(3);
    stroke(255, 0, 0);
    line(centerx+xoffset, centery+yoffset+135, centerx+xoffset, centery+yoffset+165);
    line(width/2, 500, width/2, 600);
    //text(left_distance, 10, 10);
  }
  void drawBackgroundImage()
  {
    image(sr, 0, 0);
    //image(opencv2.getSnapshot(),0,0,100,100);
    //image(opencv.getSnapshot(),xoffset,yoffset);
  }
}
