import java.util.Iterator;
ArrayList<Planet> planets= new ArrayList<Planet>();

float accel=2;
float thrust=.1;
float spinThrust=.004;
float maxSpin=.25;

float spinFuelCost=.001;
float engineFuelCost=.004;

float scroll=0;
float lastPlanetScroll=10000000;

float rx;
float ry;
float rvx;
float rvy;

float rot;
float rota;
float rotv;

boolean left;
boolean right;
boolean engine;

float fuel=1.0;
float refuelRate=.0003;
float fuelRadius=155;

color planetColor=color(100);

void setup() {
  frameRate(60);
  size(500, 1000);
  background(0);
  rx=width/2;
  ry=height*3/4;
}

void draw() {
  background(0);
  float ax=0;
  float ay=0;

  if (engine&&fuel>0) {
    fuel-=engineFuelCost;
    ay-=thrust*cos(rot);
    ax+=thrust*sin(rot);
  }
  rota=-constrain(rotv, -spinThrust, spinThrust);
  if (abs(rotv)<maxSpin&&fuel>0) {
    if (left) {
      fuel-=spinFuelCost;
      rota=-spinThrust;
    }
    if (right) {
      fuel-=spinFuelCost;
      rota=spinThrust;
    }
  }
  rotv+=rota;
  rot+=rotv;

  for (Planet planet : planets) {
    ax+=accel*(planet.x-rx)/( sq(planet.x-rx)+sq(planet.y-ry-scroll));
    ay+=accel*(planet.y-ry-scroll)/( sq(planet.x-rx)+sq(planet.y-ry-scroll));
    if (sqrt(sq(planet.x-rx)+sq(planet.y-ry-scroll))<planet.r/2) {
      println("crash");
      while (true);
    }
    if (sqrt(sq(planet.x-rx)+sq(planet.y-ry-scroll))<fuelRadius) {
      if (fuel<1) {
        fuel+=refuelRate;
      }
      planet.c=color(red(planetColor)*.8, green(planetColor)*1.6, blue(planetColor)*.8);
    } else {
      planet.c=planetColor;
    }
  }
  rvx+=ax;
  rvy+=ay;
  rx+=rvx;
  ry+=rvy;

  if (ry<height/2) {
    scroll-=height/2-ry;
    ry+=height/2-ry;
  }

  if (scroll-lastPlanetScroll<0) {
    lastPlanetScroll=scroll+random(-1000, 0);
    planets.add(new Planet());
  }

  float pvx=rvx;
  float pvy=rvy;
  float px=rx;
  float py=ry;

  for (int i=0; i<100; i++) {
    fill(255, 0, 0);
    ax=0;
    ay=0;
    for (Planet planet : planets) {
      ax+=accel*(planet.x-px)/( sq(planet.x-px)+sq(planet.y-py-scroll));
      ay+=accel*(planet.y-py-scroll)/( sq(planet.x-px)+sq(planet.y-py-scroll));
      if (sqrt(sq(planet.x-px)+sq(planet.y-py-scroll))<fuelRadius) {
        fill(0, 255, 0);
      }
    }
    pvx+=5*ax;
    pvy+=5*ay;
    px+=5*pvx;
    py+=5*pvy;
    ellipse(px, py, 2, 2);
  }

  noStroke();
  fill(255, 100, 255);
  pushMatrix();
  translate(rx, ry);
  rotate(rot);
  triangle(0, -25, -10, 0, 10, 0);
  popMatrix();
  Iterator<Planet> it=planets.iterator();
  while (it.hasNext()) {
    Planet planet=it.next();
    if (planet.draw()) {
      it.remove();
    }
  }
  fill(100, 255, 0);
  rect(0, 0, map(fuel, 0, 1, 0, width), 10);
}

class Planet {
  float x;
  float y;
  color c= planetColor;
  float r;

  Planet() {
    x=random(0, width);
    y=scroll-height*2;
    r=random(30, 100);
  }
  boolean draw() {
    fill(c);
    noStroke();
    ellipse(x, y-scroll, r, r);
    if (y-scroll>height*2) {
      return true;
    }
    return false;
  }
}


void keyPressed() {
  if (key==' ') {
    engine=true;
  }
  if (key==CODED&&keyCode==LEFT) {
    left=true;
  }
  if (key==CODED&&keyCode==RIGHT) {
    right=true;
  }
}
void keyReleased() {
  if (key==' ') {
    engine=false;
  }
  if (key==CODED&&keyCode==LEFT) {
    left=false;
  }
  if (key==CODED&&keyCode==RIGHT) {
    right=false;
  }
}
