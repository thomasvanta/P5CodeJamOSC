//bigger size when apart from the others

class attractor{
  
 int r, g, b;
 PVector pos;
 float strength;
 float radius;
 boolean action;
 
 int opacity = 0;
 boolean on = false;
  
  
 attractor(PVector _pos, float _str, float _rad){
   pos = _pos;
   strength = _str;
   radius = _rad;
 }
 
   void setSize(float size) {
    this.radius = size * 100;
    //println(size);
  }
  
    void setColor(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
 
 void display(){
   
   pushStyle();

    strokeWeight(2);
    stroke(255);

    fill(r, g, b, opacity);
    ellipse(pos.x * width, height - (pos.y * height), radius, radius);
    //invert Y axis because of Lemur

  if(on && opacity  > 0)
  opacity -= 10;
  else if(!on && opacity < 255)
  opacity += 10;

    popStyle();
 
 }
 
 //gravitational attract method
 
 PVector attract(particle p){
   PVector scaledPos = new PVector(pos.x*width , height - (pos.y*height));
   PVector dir = PVector.sub(scaledPos, p.pos);
   float d = dir.mag();
   dir.normalize();
   d = constrain(d,5,100);
   float force = (3 * strength * p.mass) / (d * d);
   dir.mult(force);
   return dir;
 }
 
   void setOn() {
    opacity = 255;
    on = true;
  }

  void setOff() {
    opacity = 0;
    on = false;
  }
 
 
  
}//class
