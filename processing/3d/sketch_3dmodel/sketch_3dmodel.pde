int camerax;
int cameray;
int cameraz;

Structure structure = new Structure();

void setup() {
  size(1000, 1000, P3D);
  camerax = width/2;
  cameray = height/2;
  cameraz = 0;
}

void draw() {
  background(0);
  
  structure.drawStructure();  
  
  changeCamera();
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