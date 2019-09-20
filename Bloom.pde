PImage raw;

int blurIntensity = 20;
int w = 384;
int h = 216;

void setup() {
  size(768, 432);
  raw = loadImage("bulb.jpg");
}

void draw() {
  image(raw, 0, 0, w, h);
  image(raw, w, 0, w, h);
  image(raw, w, h, w, h);
  image(raw, 0, h, w, h);

  //blur(0, 0, w, h);
  topBrightness(w, 0, w*2, h);

  //isolate
  topBrightness(w, h, w*2, h*2);
  blur(w, h, w*2, h*2);

  //bloom 
  bloom(w, h, w*2, h*2);

  fill(255);
  textSize(14);
  text("Blurr Intensity: " + blurIntensity, 0, 0, width, height);
}

void bloom(int startx, int starty, int wid, int hei) {
  for (int i = startx; i < wid; i++) {
    for (int j = starty; j < hei; j++) {      
      color to = get(i, j);
      color c = get(i-w, j);

      set(i-w, j, color((red(c) + red(to))/2, (green(c) + green(to))/2, (blue(c) + blue(to))/2));
    }
  }
}

void topBrightness(int startx, int starty, int wid, int hei) {
  int maxBright = 220;

  for (int i = startx; i < wid; i++) {
    for (int j = starty; j < hei; j++) {
      color c = get(i, j);

      if (red(c) < maxBright && green(c) < maxBright && blue(c) < maxBright) {
        set(i, j, color(0));
      }
    }
  }
}

void blur(int startx, int starty, int wid, int hei) {
  for (int i = startx; i < wid; i++) {
    for (int j = starty; j < hei; j++) {
      int count = 0;

      int red = 0, green = 0, blue = 0;
      for (int x = -blurIntensity; x < (blurIntensity+1); x++) {
        for (int y = -blurIntensity; y < (blurIntensity+1); y++) {
          int ind = (i + x);
          int ind2 = (y + j);

          if (ind >= 0 && ind < wid && ind2 >= 0 && ind2 < hei) {
            color c = get(ind, ind2);
            red += red(c);
            green += green(c);
            blue += blue(c);

            count++;
          }
        }
      }

      if (count > 0) set(i, j, color(red/count, green/count, blue/count));
    }
  }
}

void keyPressed() {
  if (keyCode == UP) {
    blurIntensity++;
  } else if (keyCode == DOWN && blurIntensity > 0) {
    blurIntensity--;
  }
}
