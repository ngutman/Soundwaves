int camerax;
int cameray;
int cameraz;

Structure structure = new Structure();
color[][] leds;

void setup() {
  size(1000, 1000, P3D);
  camerax = width/2;
  cameray = height/2;
  cameraz = 0;
  
  leds = new color[HORNS][];
  
  for (int i = 0; i < HORNS; i++) {
    leds[i] = new color[LEDS]; 
  }
}

int startMillis = 0;
int frames = 0;

void draw() {
  background(0);
  
  calculateLeds();
  
  structure.updateLeds(leds);
  structure.drawStructure();
  
  changeCamera();
  
  frames++;
  if (millis() > startMillis + 1000) {
    startMillis = millis();
    println("FPS: ", frames);
    frames = 0;
  }
}

void calculateLeds() {
  for (int i = 0; i < HORNS; i++) {
    for (int j = 0; j < LEDS; j++) {
      leds[i][j] = color(random(255), random(255), random(255));  
    }
  }
}

void changeCamera() {
  camera(camerax, cameray, (height/2) / tan(PI/8) + cameraz, mouseX, mouseY, 0, 0, 1, 0);
  if (keyPressed) {
    if (key == 'w') {
      cameraz -= 4;
    } else if (key == 's') {
      cameraz += 4;
    } else if (key == 'd') {
      camerax += 4;      
    } else if (key == 'a') {
      camerax -= 4;
    }
  }
}