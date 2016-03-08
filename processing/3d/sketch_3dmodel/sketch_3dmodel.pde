int MEMBRANE_SIZE = 200;
int HORNS = 20;
int LEDS = 80;
int LED_SIZE = 5;
int LED_SPACE = 5;
int HORN_OPENING_ANGLE = 5;

int LEDS_ARC_ANGLE = 160;
float HORN_ANGLE = radians(LEDS_ARC_ANGLE)/(HORNS-1);
float HORN_START_ANGLE = (PI-radians(LEDS_ARC_ANGLE))/2;

int camerax;
int cameray;
int cameraz;

void setup() {
  size(1000, 1000, P3D);
  camerax = width/2;
  cameray = height/2;
  cameraz = 0;
}

void draw() {
  background(0);
  
  translate(width/2, height/2);
  
  drawMembrane();
  
  for (int i = 0; i < HORNS; i++) {
    drawHorn(i);
  }
  
  drawRing();
  
  changeCamera();
}

void drawRing() {
  int hornLength = LEDS * (LED_SIZE+LED_SPACE) - LED_SPACE;
  float ringZPosition = cos(radians(HORN_OPENING_ANGLE)) * hornLength;
  float ringDiameter = MEMBRANE_SIZE + 2 * sin(radians(HORN_OPENING_ANGLE)) * hornLength;
  
  pushMatrix();
  
  translate(0, 0, ringZPosition);
  noFill();
  stroke(255, 255, 255, 255);
  arc(0, 0, ringDiameter, ringDiameter, -PI-PI/6, PI/6);
  arc(0, 0, ringDiameter + 5, ringDiameter + 5, -PI-PI/6, PI/6);
  
  popMatrix();
}

void drawHorn(int horn) {
  pushMatrix();
  float angle = -(HORN_START_ANGLE + HORN_ANGLE * horn);
  
  float x = cos(angle) * MEMBRANE_SIZE/2;
  float y = sin(angle) * MEMBRANE_SIZE/2;
  
  translate(x, y);
  
  rotate(angle);
  rotateY(radians(-90 + HORN_OPENING_ANGLE));
 
  for (int i=0; i < LEDS; i++) {
    drawLed(i);
  }
  
  popMatrix();
}

void drawLed(int led) {
  pushMatrix();
  
  translate(led * (LED_SIZE+LED_SPACE), 0, 0);
  
  fill(255, 0, 0, 255);
  noStroke();
  rect(0, 0, LED_SIZE, LED_SIZE);
  
  popMatrix();
}

void changeCamera() {
  camera(camerax, cameray, (height/2) / tan(PI/6) + cameraz, mouseX, mouseY, 0, 0, 1, 0);
  if (keyPressed) {
    if (key == 'w') {
      cameraz -= 2;
    } else if (key == 's') {
      cameraz += 2;
    } else if (key == 'd') {
      camerax += 2;      
    } else if (key == 'a') {
      camerax -= 2;
    }
  }
}

void drawMembrane() {
  noFill();
  stroke(255);
  arc(0, 0, MEMBRANE_SIZE, MEMBRANE_SIZE, -PI-PI/6, PI/6);
}