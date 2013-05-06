//simple particle where forces can be applied to

class particle {
  
  PVector pos;
  PVector vel;
  PVector acc;
  int r, g, b;
  float mass;
  
  particle(){
    pos = new PVector(random(width),random(height));
    vel = new PVector(0,0);
    acc = new PVector(0,0);
    mass = random(0.5,2);
    
    
  }
  
  void update(){
    
    vel.add(acc);
    pos.add(vel);
    
    // reset forces
    acc.mult(0);
  
  }
  
  void display(int _r, int _g, int _b){
    r=_r;
    g=_g;
    b=_b;
    stroke(r,g,b);
    noFill();
    ellipse(pos.x,pos.y,mass*18,mass*18); //size related to mass
  
  }
  
  //bounce back if the particle is out of the screen
  
  void edges(){
   if (pos.x < 0){
    pos.x = 0;
    vel.x = vel.x * -1;
   }
   if (pos.x > width){
     pos.x = width;
     vel.x = vel.x * -1;
   }
   if (pos.y<0){
     pos.y = 0;
     vel.y = vel.y * -1;
   }
   if (pos.y>height){
     pos.y = height;
     vel.y = vel.y * -1;
   }
  }
  
  //method for applying the forces depending on mass (size)
  
  void applyForce(PVector force){
    PVector f = PVector.div(force, mass);
    
    acc.add(f);
  
  }
  
  
}//class
