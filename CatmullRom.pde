int x, y;
int numOfClicks;
float t, startTimer;
ArrayList<Storage> clicks;
ArrayList<PVector> tangents;
boolean abc = false;
String a, b, c, d, e;

void setup() { 
  size(500, 500);
  background(255);
  clicks = new ArrayList<Storage>();  //create arraylist for end points to store the time and position(coordinates)
  tangents = new ArrayList<PVector>();//create array for tangent points to store the coordinates
  a = "Left-click to set points";
  b = "1st & 2nd clicks: endpoints";
  c = "3rd & 4th clicks: tangent points";
  d = "Enter: Draw";
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
  
  if (abc ==true) { //only execute interpolation when enter is pressed
    t = float(millis())/1000 - startTimer; //so that the time t will start at 0 when interpolation begins
    int currentKeyframe;
    for (currentKeyframe = 0; currentKeyframe < clicks.size()-1; currentKeyframe++)
    {
      if (clicks.get(currentKeyframe).time < t && clicks.get(currentKeyframe+1).time > t)
        break;
    }//Ensure that interpolation does not extend beyond the last keyframe
    
    PVector pos; //store coordinates of position of the ellipse to be animated
    if (currentKeyframe == clicks.size()-1) {
      pos = clicks.get(currentKeyframe).position;
    } else { //does interpolation till the last keyframe using the Catmull Rom formula
      PVector p1 = clicks.get(currentKeyframe).position;   //coordinates of the starting point
      PVector p2 = clicks.get(currentKeyframe+1).position; //coordinates of the ending point
      PVector tp1 = tangents.get(currentKeyframe);         //coordinates of first tangent point
      PVector tp2 = tangents.get(currentKeyframe+1);       //coordinates of 2nd tangent point
      PVector dm1 = PVector.sub(tp1, p2);                  //getting the gradient
      PVector dm2 = PVector.sub(tp2, p1);
      dm1 = dm1.mult(0.5); //tension parameter set to 0.5
      dm2 = dm2.mult(0.5);

      float t1 = clicks.get(currentKeyframe).time;   //t of starting point
      float t2 = clicks.get(currentKeyframe+1).time; //t of ending point
      float nt = (t-t1)/(t2-t1);

      float h1 = (2*pow(nt, 3)-3*pow(nt, 2)+1);
      float h2 = (-2*pow(nt, 3)+3*pow(nt, 2));
      float h3 = (pow(nt, 3)-2*pow(nt, 2)+nt);
      float h4 = (pow(nt, 3) - pow(nt, 2));

      PVector e1 = PVector.mult(p1, h1);
      PVector e2 = PVector.mult(p2, h2);
      PVector e3 = PVector.mult(dm1, h3);
      PVector e4 = PVector.mult(dm2, h4); //following the catmull rom equation

      pos = PVector.add(e1, e2);  
      pos = PVector.add(e3, pos);
      pos = PVector.add(e4, pos); //new interpolated position
    }

    pushMatrix(); //animate ellipse with new interpolated position each frame
    translate(pos.x, pos.y);
    ellipse(0, 0, 10, 10);
    popMatrix();
  }
}

void mousePressed() {
  x = mouseX;
  y = mouseY;
  if (mouseButton == LEFT) {
    if (numOfClicks<=1) { //first two clicks determine the starting and ending point
      fill(0);
      ellipse(mouseX, mouseY, 10, 10); //indicate points with circle
      clicks.add(new Storage(numOfClicks, x, y)); //store the coordinates of mouseclick and time t with numOfClicks
      numOfClicks++;
    } else if (numOfClicks>1 && numOfClicks<=3) {//next two clicks determine the tangent points
      fill(0);
      ellipse(mouseX, mouseY, 10, 10); //indicate points with circle
      tangents.add(new PVector(x, y)); //store the position for calculation
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
    abc = false;     //exit from the if loop from running
    clicks.clear();  //empty the arraylist clicks
    tangents.clear(); //empty the array tangents
    background(255);
    numOfClicks = 0;   //reset to zero so first click will be the zeroth array again
  }
}
