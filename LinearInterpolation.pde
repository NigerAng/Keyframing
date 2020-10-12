Storage [] order;
int x, y;
int numOfClicks;
float t, startTimer,currentTime;
ArrayList<Storage> clicks;
boolean abc = false;
String a,b,c;

void setup() {
  size(500, 500);
  background(255);
  clicks = new ArrayList<Storage>(); //create arraylist for end points to store the time and position(coordinates)
  a = "Left-click: set points";
  b = "Enter: Draw";
  c = "R: Reset";
  textSize(16);
  textAlign(CENTER);
  fill(0);
}

void draw() { 
  text(a,250,380);
  text(b,250,400);
  text(c,250,420); //instructions
  
  if (abc ==true) {  //only execute interpolation when enter is pressed 
    t = float(millis())/1000 - startTimer; //so that the time t will start at 0 when interpolation begins
    int currentKeyframe;
    for (currentKeyframe = 0; currentKeyframe < clicks.size()-1; currentKeyframe++)
    {
      if (clicks.get(currentKeyframe).time < t && clicks.get(currentKeyframe+1).time > t)
        break;
    }//Ensure that interpolation does not extend beyond the last frame

    PVector pos; //store coordinates of position of the ellipse to be animated
    if (currentKeyframe == clicks.size()-1) { //does interpolation till the last keyframe using the linear interpolation equation
      pos = clicks.get(currentKeyframe).position;
    } else {
      PVector p1 = clicks.get(currentKeyframe).position; //get coordinates of first point and the next one after it
      PVector p2 = clicks.get(currentKeyframe+1).position;//and subsequent points till last point

      float t1 = clicks.get(currentKeyframe).time;    //get t of first point and the next one after
      float t2 = clicks.get(currentKeyframe+1).time;  //and subsequent point till last point

      float nt = (t-t1)/(t2-t1);
      p1 = PVector.mult(p1, 1.0-nt);
      p2 = PVector.mult(p2, nt);
      pos = PVector.add(p1, p2); //new interpolated position
    }
    pushMatrix(); //animate ellipse with new interpolated position each frame
    translate(pos.x, pos.y);
    ellipse(0, 0, 20, 20);
    fill(0);
    popMatrix();
  }
}



void mousePressed() {
  x = mouseX;
  y = mouseY;
  if (mouseButton == LEFT) { //determine the points to interpolate
    fill(0);
    ellipse(mouseX, mouseY, 20, 20);
    clicks.add(new Storage(numOfClicks, x, y)); //store the coordinates of the point and t
    numOfClicks++;  //add 1 more to the count so next click will be register in the next array in arraylist
  }
}

void keyPressed() {
  if (key == ENTER || key == RETURN) { //execute interpolation when enter is press
    abc = true;
    startTimer = float(millis())/1000; //use to minus of the elapsed time from start of program to get t = 0
  }
  if (key =='r' || key == 'R') { //reset entire sketch when R is pressed
    abc = false;    //stop the if loop from running
    clicks.clear(); //empty the arraylist clicks
    background(255);
    numOfClicks = 0; //reset to zero so first click will be the zeroth array again
  }
}