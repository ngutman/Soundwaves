int MEMBRANE_SIZE = 200;
int HORNS = 7;
int LEDS = 40;
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
  
  changeCamera();
}

void drawHorn(int horn) {
  pushMatrix();
  float angle = -(PI/(HORNS-1)) * horn;
  float x = cos(angle) * MEMBRANE_SIZE/2;
  float y = sin(angle) * MEMBRANE_SIZE/2;
  
  translate(x, y);
  
  rotate(angle);
  rotateY(radians(-85));
 
  for (int i=0; i < LEDS; i++) {
    drawLed(i);
  }
  
  popMatrix();
}

void drawLed(int led) {
  pushMatrix();
  
  translate(led * 20, 0, 0);
  
  fill(255, 0, 0, 255);
  noStroke();
  rect(0, 0, 5, 5);
  
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