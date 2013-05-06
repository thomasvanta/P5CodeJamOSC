import oscP5.*;
import netP5.*;
import promidi.*;

OscP5 oscP5;
MidiIO midiIO;

attractor r, g, b; //Our virtual entities

int red, green, blue; //for passing colors to the particles
PVector positionR;
PVector positionG;
PVector positionB;
float strength;
int radius;

//int nAttractors;
int nParticles;  //number of particles in the system

particle[] particles;

//attractor[] attractors;


void setup() {
  smooth();
  size(1024, 768, P2D);
  //size(displayWidth, displayHeight, P2D); //fullscreen mode

  oscP5 = new OscP5(this, 3334);

  positionR = new PVector(width/2, height/2);  //initialization
  positionG = new PVector(width/2, height/2);
  positionB = new PVector(width/2, height/2);
  strength = 35;
  radius = 69;
  //nAttractors = 3;

  r = new attractor(positionR, strength, radius);
  r.setColor(255, 0, 0);

  g = new attractor(positionG, strength, radius);
  g.setColor(0, 255, 0);

  b = new attractor(positionB, strength, radius);
  b.setColor(0, 0, 255);

  /*attractors = new attractor[nAttractors];
   for (int i=0 ; i < attractors.length ; i++){
   attractors[i] = new attractor(position, strength, radius);
   //a.attract(true);
   }*/

  red = 155;
  green = 155;
  blue = 155;
  nParticles = 100;
  particles = new particle[nParticles];
  for (int i=0 ; i < particles.length ; i++) {
    particles[i] = new particle();
  }

  // MIDI stuff

  midiIO = MidiIO.getInstance(this);
  //midiIO.printDevices();
  midiIO.openInput(0, 0);
  midiIO.openInput(0, 1);
  midiIO.openInput(0, 2);
}

void draw() {
  background(0);

  for (particle p : particles) { //enhanced Loop

    PVector gravity = new PVector(0, 0.05); //create gravity
    gravity.mult(p.mass);
    //p.applyForce(gravity);   //apply gravity

    p.update();
    p.edges();
    p.display(red, green, blue);

    //Drag force, for desacceleration
    
    PVector drag = p.vel.get(); //get a copy of velocity
    drag.normalize(); //normalize it
    float c = -0.005; //coeficient
    float speed = p.vel.mag(); //modulo de la velocidad
    drag.mult(c*speed*speed);
    p.applyForce(drag);
  }

  //Apply every attractor force to every particle
  
  for (particle p: particles) {
    PVector forceR = r.attract(p);
    p.applyForce(forceR);
    PVector forceG = g.attract(p);
    p.applyForce(forceG);
    PVector forceB = b.attract(p);
    p.applyForce(forceB);
    //println(force.x);
  }

  updateDistances();

  r.display();
  g.display();
  b.display();

  //println(r.pos.x);
}

//the farther the attractor is, the bigger it becomes

void updateDistances() {
  r.setSize(dist(r.pos.x, r.pos.y, g.pos.x, g.pos.y) + dist(r.pos.x, r.pos.y, b.pos.x, b.pos.y));
  g.setSize(dist(g.pos.x, g.pos.y, r.pos.x, r.pos.y) + dist(g.pos.x, g.pos.y, b.pos.x, b.pos.y));
  b.setSize(dist(b.pos.x, b.pos.y, r.pos.x, r.pos.y) + dist(b.pos.x, b.pos.y, g.pos.x, g.pos.y));
}


// OSC stuff

void oscEvent(OscMessage theOscMessage) 
{  
  //println(theOscMessage.toString());

  // R R R R R R R R R R R R R R  R R R R R R 
  if (theOscMessage.addrPattern().equals("/MultiBallR/x")) 
    r.pos.x = theOscMessage.get(0).floatValue();

  if (theOscMessage.addrPattern().equals("/MultiBallR/y")) 
    r.pos.y  = theOscMessage.get(0).floatValue();



  // G  G GG G  GG G G GG G GG GG G GG 
  if (theOscMessage.addrPattern().equals("/MultiBallG/x")) 
    g.pos.x = theOscMessage.get(0).floatValue();

  if (theOscMessage.addrPattern().equals("/MultiBallG/y")) 
    g.pos.y  = theOscMessage.get(0).floatValue();


  // B B B B BBB BB BB B BB BB B BB B
  if (theOscMessage.addrPattern().equals("/MultiBallB/x")) 
    b.pos.x = theOscMessage.get(0).floatValue();

  if (theOscMessage.addrPattern().equals("/MultiBallB/y")) 
    b.pos.y  = theOscMessage.get(0).floatValue();
}


//MIDI

void noteOn(Note note, int device, int channel) {
  println(note.getPitch() + " - noteOn        channel: " + channel);



  if (channel == 0) {
    r.setOn();
  } 
  else if (channel == 1) {
    g.setOn();
  } 
  else if (channel == 2) {
    b.setOn();
  }


  // int vel = note.getVelocity();
  // int pit = note.getPitch();


  // midiIn.isPlaying = true;
}

void noteOff(Note note, int device, int channel) {
  println(note.getPitch() + " - noteOf" + "       channel: " + channel);

  if (channel == 0) {
    r.setOff();
  } 
  else if (channel == 1) {
    g.setOff();
  } 
  else if (channel == 2) {
    b.setOff();
  }

  // int pit = note.getPitch();

  //midiIn.isPlaying = false;
}

