// Options
public final int dnaSize = 600;
public final int genSize = 20;
public final int mutationRate = 25;
public final int speed = 20;


public boolean showInformation = true;

// setup our life --- ?!

public Life life;

void setup() {
  size(800, 600);
  
  // init life
  
  life = new Life();
}

void draw() {
  noStroke();
  background(0);
  
  life.isGoingOn();
}

void mousePressed() {
 if (mousePressed && (mouseButton == LEFT)) {
   PVector newTarget = new PVector(mouseX, mouseY);
   life.setTarget(newTarget);
 }

}