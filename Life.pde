public class Life {

  private int lifeTimeCounter, genCount, targetRad = 50, targetReachedDwarfs;

  private ArrayList<Dwarf> generation = new ArrayList<Dwarf>();
  private PVector target;
  private float closest, heighestFitness, mutations = 0;

  public Life () {

    // create the first generation with random dwarfs
    for (int i = 0; i < genSize; i++) {

      this.generation.add(new Dwarf());
      this.genCount = 1;

      // target spawns random at the right side of the screen
      this.target  = new PVector(random(600, width - targetRad), random(targetRad, height - targetRad));
    }

    // restets lifetimecounter
    this.lifeTimeCounter = 0;
    this.closest = 0;
    this.heighestFitness = 0;
  }


  // Main
  public void isGoingOn() {

    if (this.generation == null) {
      text("Gen = NULL!", 40, 40);
    }
    if (this.lifeTimeCounter < dnaSize && this.generation != null && this.keepThisGen()) {
      //draw all dwarfs
      for (Dwarf d : generation) {
        d.move(this.lifeTimeCounter);
      }

      // display all content
      this.display();

      this.lifeTimeCounter++;
    } else if (generation != null) {
      this.generation = this.evolve();
      this.lifeTimeCounter = 0;
    }
  }


  public ArrayList<Dwarf> evolve() {

    ArrayList<Dwarf> nextGeneration = new ArrayList<Dwarf>();
    ArrayList<Dwarf> matingPool = new ArrayList<Dwarf>();
    ArrayList<PVector> newDna = new ArrayList<PVector>();
    this.setFitness();

    //create a matingpool fitness = times in matingpool
    for (Dwarf d : generation) {
      for (int i = 0; i < d.getFitness(); i++) {
        matingPool.add(d);
      }
    }

    // create a new generation with 10 dwarfs
    for (int i = 0; i < genSize - dwarfMutant; i++) {


      // get 2 new paerents
      Dwarf parentA = matingPool.get((int)random(0, matingPool.size()));
      Dwarf parentB = matingPool.get((int)random(0, matingPool.size()));
      int findParentCounter = 0;
      while (parentA.getFitness() == parentB.getFitness()) {
        parentB = matingPool.get((int)random(0, matingPool.size()));
        if (findParentCounter > 100) {
          parentB = new Dwarf();
          break;
        }
        findParentCounter++;
      }
      if (10 > random(0, 10000)) {
        parentB = new Dwarf();
      }

      // crossover the dna with a mutationrate
      newDna = crossover(parentA, parentB);

      // add a new dwarf with the new dna we have
      nextGeneration.add(new Dwarf(newDna));
    }
    
    for (int i = 0; i < dwarfMutant; i++) {
      nextGeneration.add(new Dwarf());
    }
    this.genCount++;
    return nextGeneration;
  }

  public void setFitness() {

    float lowDist = 10000; 
    float heighDist = 0;
    float lowLifeTime = 10000;
    float heigthLifeTime = 0;
    this.targetReachedDwarfs = 0;
    for (Dwarf d : generation) {

      // geting heighest and lowest distance/ lifetime to map
      if (d.getDistance() > heighDist) {
        heighDist = d.getDistance();
      } else if (d.getDistance() < lowDist) {
        lowDist = d.getDistance();
      }
      if (d.getLifeTime() > heigthLifeTime) {
        heigthLifeTime = d.getLifeTime();
      } else if (d.getLifeTime() < lowLifeTime) {
        lowLifeTime = d.getLifeTime();
      }
      if (d.getTargetReached()) {
          this.targetReachedDwarfs += 1;
      }
    }

    // set the final fitness for every dwarf
    for (Dwarf d : generation) {
      float tempFitness = map(d.getDistance(), heighDist, lowDist, 1, 250);
      if (d.getTargetReached()) {
        tempFitness += map(d.getLifeTime(), heigthLifeTime, 0, 1, 100);
        tempFitness += 300;
      }
      if (d.getCollided()) {
        tempFitness -= 50;
      } 
      if (tempFitness > this.heighestFitness) {
        this.heighestFitness = tempFitness;
      }

      d.setFitness(tempFitness);
    }

    this.closest = lowDist;
  }

  public ArrayList<PVector> crossover(Dwarf parentA, Dwarf parentB) {

    ArrayList<PVector> newDna = new ArrayList<PVector>();


    for (int i = 0; i < dnaSize; i++) {

      if ( i % mutationRate == 0) {
        newDna.add(new PVector(random(-speed, speed), random(-speed, speed)));
      } else if (i % 2 == 0) {
        newDna.add(parentA.getDna().get(i));
      } else {
        newDna.add(parentB.getDna().get(i));
      }
    }
    return newDna;
  }


  // returns weather we keep the generation going or not
  public boolean keepThisGen() {
    int tempCounter = 0;
    for (Dwarf d : generation) {
      if (!d.getFinished()) {
        tempCounter++;
      }
    }

    if (tempCounter > 0) {
      return true;
    } else {
      return false;
    }
  }

  public void display() {

    //draw all dwarfs
    for (Dwarf d : generation) {
      d.display();
    }
    // draw the target
    fill(0, 0, 255);
    ellipse(target.x, target.y, targetRad, targetRad);

    if (showInformation) {
      fill(150);
      textSize(15);
      text("Actual generation:\t\t" + (float)this.genCount, 40, 20);

      text("Last Generation:\t\t", 40, 60);
      text("Closest distance:\t\t" + this.closest, 40, 80);
      text("Heighest Fitness:\t\t" + this.heighestFitness, 40, 100);
      text("Target Reached:\t\t" + this.targetReachedDwarfs, 40, 120);
      //text("Mutants:\t\t" + this.mutants/ genSize, 40, 140);
    }
  }


  public void setTarget(PVector newTarget) {
    this.target = newTarget;
  }
}










//whitespace