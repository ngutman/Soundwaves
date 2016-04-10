float camerax;
float cameray;
float cameraz;

Structure structure = new Structure();
TeensyFFT teensyFFT = new TeensyFFT();

color[][] leds;

void setup() {
  size(1200, 800, P3D);
  camerax = 1288;
  cameray = 400;
  cameraz = 903;
  
  teensyFFT.setup(this);
  
  leds = new color[HORNS][];
  
  for (int i = 0; i < HORNS; i++) {
    leds[i] = new color[LEDS]; 
  }
  println("num leds", LEDS);
}

int startMillis = 0;
int frames = 0;

void draw() {
  
  background(0);
  
  calculateLeds();
 
  structure.drawStructure(leds);
  
  changeCamera();
  
  frames++;
  if (millis() > startMillis + 1000) {
    startMillis = millis();
    //println("FPS: ", frames);
    frames = 0;
  }
}

void calculateLeds() {
  teensyFFT.update();
  
  for (int i = 0; i < HORNS; i++) {
    leds[i] = teensyFFT.getStrip(i);
  }
}

void changeCamera() {
  camera(camerax, cameray, cameraz, mouseX, mouseY, 0, 0, 1, 0);
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