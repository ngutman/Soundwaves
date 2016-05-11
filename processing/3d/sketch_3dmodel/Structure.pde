int MEMBRANE_DIAMETER = 350;
int RING_DIAMETER = 682;
int MEMBRANE_ANGLE = 300;

float START_ANGLE_OF_MEMBRANE = PI - (radians(MEMBRANE_ANGLE) - PI) / 2;
float END_ANGLE_OF_MEMBRANE = START_ANGLE_OF_MEMBRANE + radians(MEMBRANE_ANGLE);

int HORNS = 8;

int DISTANCE_BETWEEN_MEMRANE_AND_RING = 700;
float HORN_OPENING_ANGLE = 13.2;

int HORN_LENGTH = 700;
int LED_SIZE = 2;
int LED_SPACE = 1;
int LEDS = HORN_LENGTH / (LED_SIZE + LED_SPACE);

int LEDS_ARC_ANGLE = 126;
float HORN_ANGLE = radians(LEDS_ARC_ANGLE)/(HORNS-1);
float HORN_START_ANGLE = (PI-radians(LEDS_ARC_ANGLE))/2;

class Structure {
  color[][] leds;
  
  void drawStructure(color[][] leds) {
    this.leds = leds;
    translate(width/2, height/2);
    
    stroke(255, 0, 0, 255);
    line(0, 0, 0, 100, 0, 0);
    
    stroke(0, 255, 0, 255);
    line(0, 0, 0, 0, 100, 0);
    
    stroke(0, 0, 255, 255);
    line(0, 0, 0, 0, 0, 100);
  
    drawMembrane();
    
    drawBox();
    
    for (int i = 0; i < HORNS; i++) {
      drawHorn(i);
    }
    
    drawRing();
    drawFloor();
  }
  
  void drawBox() {
    pushMatrix();
    translate(0, -50, -250);
    box(500, 350, 500);
    popMatrix();
  }
  
  void drawFloor() {
    int floorSize = 1000;
    pushMatrix();
    
    float floorHeight = 100;
    
    translate(-floorSize/2, floorHeight, 0);
    rotateX(PI/2);
    
    fill(222, 208, 104, 255);
    rect(0, 0, floorSize, floorSize);
    
    popMatrix();
  }
  
  void drawRing() {
    
    pushMatrix();
    
    translate(0, 0, DISTANCE_BETWEEN_MEMRANE_AND_RING);
    noFill();
    stroke(255, 255, 255, 255);
    strokeWeight(2);
    arc(0, 0, RING_DIAMETER, RING_DIAMETER, START_ANGLE_OF_MEMBRANE, END_ANGLE_OF_MEMBRANE);
    strokeWeight(1);
    
    popMatrix();
  }
  
  void drawHorn(int horn) {
    pushMatrix();
    float angle = -(HORN_START_ANGLE + HORN_ANGLE * horn);
    
    float x = cos(angle) * MEMBRANE_DIAMETER/2;
    float y = sin(angle) * MEMBRANE_DIAMETER/2;
    
    translate(x, y);
    
    rotate(angle);
    rotateY(radians(-90 + HORN_OPENING_ANGLE));
   
    for (int i=0; i < LEDS; i++) {
      drawLed(i, horn);
    }
    
    popMatrix();
  }
  
  void drawLed(int led, int horn) {
    pushMatrix();
    
    translate(led * (LED_SIZE+LED_SPACE), 0, 0);
    
    fill(leds[horn][led]);
    noStroke();
    box(LED_SIZE);
    
    popMatrix();
  }
  
  void drawMembrane() {
    noFill();
    stroke(255);
    
    arc(0, 0, MEMBRANE_DIAMETER, MEMBRANE_DIAMETER, START_ANGLE_OF_MEMBRANE, END_ANGLE_OF_MEMBRANE);
  }
  
}