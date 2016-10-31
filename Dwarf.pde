public class Dwarf {

  private float fitness, distance;
  private int lifeTime, rad = 30;
  private ArrayList<PVector> dna = new ArrayList<PVector>();
  private PVector pos, dwarfColor;
  private boolean targetReached, collided, finished;

  // first init is Random
  public Dwarf () {

    //set startconditions
    this.setPos(new PVector(250, height/2));
    this.targetReached = false;
    this.collided = false;
    this.dwarfColor = new PVector(0,255,0);
    // adds 100 random directions as DNA
    for (int i = 0; i < dnaSize; i++) {
      this.dna.add(new PVector((int)random(-speed, speed), (int)random(-speed, speed)));
    }
  }

  // after the first generation every dwarf gets dna from parents
  public Dwarf(ArrayList<PVector>newDna) {
    this.dwarfColor = new PVector(255,0,0);
    //set startposition
    this.setPos(new PVector(250, height/2));
    // get inherited dna
    this.dna = newDna;
  }

  // moves the dwarf along the dnapattern and checks for collisions
  public void move (int dnaIndex) {

    if (!this.targetReached && !this.collided) {
      PVector newPos = new PVector(this.pos.x + this.dna.get(dnaIndex).x, this.pos.y + this.dna.get(dnaIndex).y);
      this.setPos(newPos);
      this.setLifeTime(dnaIndex);

      // checking for collisions
      if (this.pos.x < 0 + this.rad || this.pos.x > width - this.rad ||
        this.pos.y < 0 + this.rad || this.pos.y > height - this.rad) {
        this.setCollided(true);
        this.setFinished(true);
      }

      // checking for target is reached
      this.setDistance(dist(this.getPos().x, this.getPos().y, life.target.x, life.target.y));
      if (this.distance < life.targetRad) {
        this.setTargetReached(true);
        this.setFinished(true);
      }
    }
  }


  public void display() {

    fill(dwarfColor.x, dwarfColor.y, 0, 75);
    ellipse(this.pos.x, this.pos.y, this.rad, this.rad);
  }

  // getter/ setter
  public void setPos(PVector newPos) { 
    this.pos = newPos;
  }
  public PVector getPos() { 
    return this.pos;
  }
  public void setFitness(float newFitness) { 
    this.fitness = newFitness;
  }
  public float getFitness() { 
    return this.fitness;
  }
  public void setDistance(float newDistance) { 
    this.distance = newDistance;
  }
  public float getDistance() { 
    return this.distance;
  }
  public void setLifeTime(int newlifeTime) { 
    this.lifeTime = newlifeTime;
  }
  public int getLifeTime() { 
    return this.lifeTime;
  }    
  public void setTargetReached(boolean newTargetReached) {
    this.targetReached = newTargetReached;
  }
  public boolean getTargetReached(){
    return this.targetReached;
  }
    public void setCollided(boolean newCollided) {
    this.collided = newCollided;
  }
  public boolean getCollided(){
    return this.collided;
  }
    public void setFinished(boolean newFinished) {
    this.finished = newFinished;
  }
  public boolean getFinished(){
    return this.finished;
  }
  public void setDna(ArrayList<PVector> newDna) {
    this.dna = newDna;
  }
  public ArrayList<PVector> getDna() {
    return this.dna;
  }
}