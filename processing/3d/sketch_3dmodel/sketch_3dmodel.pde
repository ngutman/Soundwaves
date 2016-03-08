int MEMBRANE_DIAMETER = 200;
int MEMBRANE_ANGLE = 240;

float START_ANGLE_OF_MEMBRANE = PI - (radians(MEMBRANE_ANGLE) - PI) / 2;
float END_ANGLE_OF_MEMBRANE = START_ANGLE_OF_MEMBRANE + radians(MEMBRANE_ANGLE);

int HORNS = 7;
int LEDS = 80;
int LED_SIZE = 5;
int LED_SPACE = 5;
int HORN_OPENING_ANGLE = 5;
int HORN_LENGTH = LEDS * (LED_SIZE+LED_SPACE) - LED_SPACE;

int LEDS_ARC_ANGLE = 120;
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
  drawFloor();
  
  changeCamera();
}

void drawFloor() {
  int floorSize = 1000;
  pushMatrix();
  
  float floorHeight = cos((TWO_PI - radians(MEMBRANE_ANGLE))/2) * (MEMBRANE_DIAMETER / 2);
  
  translate(-floorSize/2, floorHeight, 0);
  rotateX(PI/2);
  
  fill(222, 208, 104, 255);
  rect(0, 0, floorSize, floorSize);
  
  popMatrix();
}

void drawRing() {
  float ringZPosition = cos(radians(HORN_OPENING_ANGLE)) * HORN_LENGTH;
  float ringDiameter = MEMBRANE_DIAMETER + 2 * sin(radians(HORN_OPENING_ANGLE)) * HORN_LENGTH;
  
  pushMatrix();
  
  translate(0, 0, ringZPosition);
  noFill();
  stroke(255, 255, 255, 255);
  strokeWeight(10);
  arc(0, 0, ringDiameter, ringDiameter, START_ANGLE_OF_MEMBRANE, END_ANGLE_OF_MEMBRANE);
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
  camera(camerax, cameray, (height/2) / tan(PI/8) + cameraz, mouseX, mouseY, 0, 0, 1, 0);
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
  
  arc(0, 0, MEMBRANE_DIAMETER, MEMBRANE_DIAMETER, START_ANGLE_OF_MEMBRANE, END_ANGLE_OF_MEMBRANE);
}