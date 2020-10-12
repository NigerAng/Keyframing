int x, y;
int numOfClicks;
float t, startTimer;
ArrayList<Storage> clicks;
ArrayList<PVector> pts;
boolean abc = false;
String a, b, c, d, e;

void setup() {
  size(500, 500);
  background(255);
  clicks = new ArrayList<Storage>();  //create arraylist for end points to store the time and position(coordinates)
  pts = new ArrayList<PVector>();     //create array for control points to store the coordinates
  a = "Left-click: set points";
  b = "1st & 2nd clicks: set endpoints";  
  c = "3rd & 4th clicks: set control points";
  d = "Enter/Return: Draw";
  e = "R: Reset";
  textSize(16);
  textAlign(CENTER);
  fill(0);
}

void draw() {
  text(a, 250, 380);
  text(b, 250, 400);
  text(c, 250, 420);
  text(d, 250, 440);    
  text(e, 250, 460); //instructions
  
  if (abc ==true) {     //only execute interpolation when enter is pressed 
    t = float(millis())/1000 - startTimer;  //so that the time t will start at 0 when interpolation begins
    int currentKeyframe;
    for (currentKeyframe = 0; currentKeyframe < clicks.size()-1; currentKeyframe++)
    {
      if (clicks.get(currentKeyframe).time < t && clicks.get(currentKeyframe+1).time > t)
        break;
    } //Ensure that interpolation does not extend beyond the last frame

    PVector pos; //store coordinates of position of the ellipse to be animated
    if (currentKeyframe == clicks.size()-1) {
      pos = clicks.get(currentKeyframe).position;
    } else {  //does interpolation till the last keyframe using the cubic bezier formula
      PVector p1 = clicks.get(currentKeyframe).position;    //coordinates of curve starting point
      PVector p2 = clicks.get(currentKeyframe+1).position;  //coordinates of curve ending point
      PVector cP1 = pts.get(currentKeyframe);               //coordinates of 1st control point
      PVector cP2 = pts.get(currentKeyframe+1);             //coordinates of 2nd control point

      float t1 = clicks.get(currentKeyframe).time;         //t of starting point  
      float t2 = clicks.get(currentKeyframe+1).time;       //t of ending point
      
      float nt = (t-t1)/(t2-t1);        
      p1 = PVector.mult(p1, pow(1.0-nt, 3));
      p2 = PVector.mult(p2, pow(nt, 3));

      PVector p3 = PVector.mult(cP1, 3*sq(1-nt)*nt);
      PVector p4 = PVector.mult(cP2, 3*(1-nt)*sq(nt)); //following the cubic bezier equation

      pos = PVector.add(p1, p2);  
      pos = PVector.add(p3, pos);
      pos = PVector.add(p4, pos); //new interpolated position
    }
    pushMatrix(); //animated frame by frame with new interpolated postion each frame
    translate(pos.x, pos.y);
    ellipse(0, 0, 20, 20);
    fill(0);
    popMatrix();
  }
}


void mousePressed() {
  x = mouseX;
  y = mouseY;
  if (mouseButton == LEFT) {
    if (numOfClicks<=1) {  //first two clicks determine the starting and ending point
      fill(0);
      ellipse(mouseX, mouseY, 20, 20); //indicate points with circle
      clicks.add(new Storage(numOfClicks, x, y)); //store the coordinates of mouseclick and time t with numOfClicks
      numOfClicks++;
    } else if (numOfClicks>1 && numOfClicks<=3) {//next two clicks determine the control points
      fill(0);
      ellipse(mouseX, mouseY, 20, 20);  //indicate points with circle
      pts.add(new PVector(x, y));      //store the position for calculation
      numOfClicks++;
    }
  }
}

void keyPressed() {
  if (key == ENTER || key == RETURN) { //execute interpolation when enter is press
    abc = true;
    startTimer = float(millis())/1000; //use to minus of the elapsed time from start of program to get t = 0
  }
  if (key =='r' || key == 'R') { //reset entire sketch when R is pressed
    abc = false;       //exit from the if loop from running
    clicks.clear();    //empty the arraylist clicks
    pts.clear();       //empty the array pts
    background(255);   
    numOfClicks = 0;   //reset to zero so first click will be the zeroth array again
  }
}
