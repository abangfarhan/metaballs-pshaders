/*
 * Note: Contrast this sketch with the other metaball sketch that
 * doesn't use shader. The speed difference is tremendous.
 * There it's like 20 FPS, here it's like 60 FPS. Good job, me.
 */

PShader mShader;
Ball[] balls = new Ball[15];
boolean isSave = false;

void setup() {
  size(1000, 600, P2D);
  colorMode(HSB);
  mShader = loadShader("frag.glsl");
  for(int i=0; i<balls.length; i++) {
    PVector pos = new PVector(random(width), random(height), 1.0); // GLSL only accept vec3
    PVector vel = new PVector(random(-3, 3), random(-1, 1), 0.0);
    color c = color(random(255), 255, 255);
    PVector rgb = new PVector(red(c)/255, green(c)/255, blue(c)/255);
    float r = random(50, 80);
    balls[i] = new Ball(pos, vel, rgb, r);
    balls[i].sync("balls", i);
  }
  mShader.set("n_balls", balls.length);
  colorMode(RGB);
}

void draw() {
  background(0);
  shader(mShader);
  rect(0, 0, width, height);

  balls[0].pos.x = mouseX;
  balls[0].pos.y = height - mouseY;
  balls[0].sync("balls", 0);
  for(int i=1; i<balls.length; i++) {
    balls[i].update();
    balls[i].sync("balls", i);
  }

  if(isSave) {
    saveFrame("screen-####.png");
  }
}

class Ball {
  PVector pos, rgb, vel;
  float r;

  Ball(PVector pos, PVector vel, PVector rgb, float r) {
    this.pos = pos;
    this.vel = vel;
    this.rgb = rgb;
    this.r = r;
  }

  void sync(String arrName, int idx) {
    String varname = arrName + "[" + idx + "].";
    mShader.set(varname + "pos", pos);
    mShader.set(varname + "rgb", rgb);
    mShader.set(varname + "r", r);
  }

  void update() {
    pos.add(vel);
    if(pos.x < 0 || pos.x >= width) {
      vel.x *= -1;
    }
    if(pos.y < 0 || pos.y >= height) {
      vel.y *= -1;
    }
  }
}
