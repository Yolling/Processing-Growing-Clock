Piece outer, inner;

void setup() {
  size(480, 480);
  smooth(8);  
  outer = new Piece(-0.1, 240, 0.55); // (angle velocity, radius, ratio)
  inner = new Piece(+0.1, 160, 0.52);
}

void draw() {
  background(250, 248, 240); 
  outer.show();
  inner.show(); 
  mainClock(); 
}


class Branch {
  float radius, ratio, rotation;
  Branch(float radius_,float ratio_, float rotation_) {
    radius = radius_;
    ratio = ratio_;
    rotation = rotation_;
  }    
  
  void generate(){
    pushMatrix();
    rotate(radians(rotation));
    float len = getStartLength(radius,ratio);
    branch(len);
    popMatrix();
  }  
  
  void branch(float len){
    stroke(50, 60);
    strokeWeight(1.8); 
    strokeCap(ROUND);
    line(0, 0, 0, -len);
    translate(0, -len);
    
    float bloom = map(second(),0,59,0,35); // attach the bloom rate to second
    if( len > 2 ){
      pushMatrix();
      branch(len * ratio);
      popMatrix();   
      
      pushMatrix();
      rotate(radians(bloom));
      branch (getStartLength(len, ratio));
      popMatrix();
      
      pushMatrix();
      rotate(radians(-bloom));
      branch (getStartLength(len, ratio));      
      popMatrix();
    }
  }    
  float getStartLength(float length, float ratio){
    float len = (1 - ratio) * length; // change the drawing length to iterate
    return len;
  }  
}


class Piece {
  float aVelocity, radius, ratio, rotation = 30;  
  Branch[] branches = new Branch[6]; // 6 branches per piece
  Piece (float aVelocity_, float radius_, float ratio_) {
    aVelocity = aVelocity_;
    radius = radius_;
    ratio = ratio_; 
    for (int i = 0; i < 6; i++) branches[i] = new Branch(radius, ratio, i*60);
  }
  
  void show() {
    pushMatrix();
    translate(width/2, height/2);
    rotate(radians(rotation));
    for (Branch b: branches) b.generate();
    popMatrix();
    rotation += aVelocity;
  }
}


void mainClock() {
  translate(width/2,height/2);     
  fill(0,160);
  noStroke();  
  
  // Draw the dial
  for(int i=1;i<=60;i++)
  {
    pushMatrix();
    rotate(PI*2*i/60);       
    if(i%15==0) ellipse(0, 95, 4.2, 17);
    else if( i%5 ==0) ellipse(0, 95, 3, 13);    
    else ellipse(0, 95, 2, 8);     
    popMatrix();
  } 
  
  // Draw the second hand
  pushMatrix();   
  rotate(radians(6)*second()+PI);   
  stroke(250, 50, 50, 180); 
  strokeWeight(2);  
  line(0,0,0,85); 
  popMatrix();
  
  //Draw the minute hand
  pushMatrix();
  rotate(radians(6)*minute() + radians(0.1)*second() + PI);
  stroke(100);
  strokeWeight(4);
  line(0,0,0,70);  
  popMatrix();
  
  //Draw the hour hand
  pushMatrix();
  rotate(radians(30)*hour() + radians(0.5)*minute() + PI);
  stroke(50);
  strokeWeight(6);
  line(0,0,0,50);   
  popMatrix();
}
