//Test with AndreasTestLayout & fading background
//Strange ideas: Each frequencyband controls a seperate figures diameter, and (perhaps) each one has a different (lerp)color


//Sound
import ddf.minim.*;
import ddf.minim.analysis.*;
Minim         minim;
AudioPlayer   myAudio;
FFT           myAudioFFT;

boolean       showVisualizer   = true;


int           myAudioRange     = 11;
int           myAudioMax       = 100;

float         myAudioAmp       = 40.0;
float         myAudioIndex     = 0.2;
float         myAudioIndexAmp  = myAudioIndex;
float         myAudioIndexStep = 0.35;

float[]       myAudioData      = new float[myAudioRange];

float easing = 0.15;
float radiusX;


import oscP5.*;
import netP5.*;
OscP5 oscP5;

float ellipses;
float rectangles;
float triangles;
float lines;

float red;
float blue;
float orange;
float pink;

int circleResolution = 8;

int drawAlpha = 100;

color strokeColor = color(255, drawAlpha);

PGraphics canvas;


void setup() {
  //size(720, 720, P2D);
  fullScreen(P2D);
  canvas = createGraphics(width, height);

  smooth();
  noFill();
  background(255);
  //frameRate(25); //obsolete?
  oscP5 = new OscP5(this, 8000);


  //Sound
  minim   = new Minim(this);
  //myAudio = minim.loadFile("HECQ_With_Angels_Trifonic_Remix_cut.wav");
  myAudio = minim.loadFile("MUSICDIRECTOR_tr5-Extreme_Explorations-Itay_Steinberg_Roman_Weinstein_Or_Chausah-stye412-songs_to_your_eyes.mp3");
  myAudio.loop();

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  myAudioFFT.window(FFT.GAUSS);
}

void draw() {

  myAudioFFT.forward(myAudio.mix);
  myAudioDataUpdate();

  //Easing
  int radiusTarget   = (int)map(myAudioData[5], 0, myAudioMax, -200, height/2+50); //Give the numbers more range
  radiusTarget = constrain(radiusTarget, 1, height/2);

  float dRadiusTarget = radiusTarget - radiusX;
  radiusX += dRadiusTarget * easing;

  int fftStrokeWeight = (int)map(myAudioData[0], 0, myAudioMax, 1, 20);

  background(0);

  fadeGraphics(canvas, 2.3);

  canvas.beginDraw();
  //canvas.fill(strokeColor, 50);
  canvas.noFill();
  //if (mousePressed) {


  if (radiusX >5) {

    canvas.pushMatrix();
    canvas.translate(width/2, height/2);


    //int circleResolution = (int)map(mouseY+100, 0, height, 2, 10);
    //int radius = min(abs(mouseX-width/2), height/2-10); //Stay within the screen borders
    float angle = TWO_PI/circleResolution;

    //canvas.strokeWeight(2);
    canvas.strokeWeight(fftStrokeWeight);
    //canvas.stroke(0,50); //Also has interesting effect
    if (frameCount % 2 ==0) { 
      canvas.stroke(strokeColor, drawAlpha);
    } else {
      canvas.stroke(255, drawAlpha);
    }
    //canvas.rotate(radians(mouseY));

    //Don't do stuff if the radius is very small


    if (circleResolution == 3) { //Trick to fix Vertex StrokeCap issue
      canvas.strokeJoin(MITER);
      canvas.translate(0, -10); //This number is arbitrary
      canvas.rotate(PI/2);
      canvas.rotate(radians(180));  
      canvas.triangle(cos(angle*0) * radiusX, sin(angle*0) * radiusX, cos(angle*1) * radiusX, sin(angle*1) * radiusX, cos(angle*2) * radiusX, sin(angle*2) * radiusX);
      
      //Triangles within triangles
      if (myAudioData[0]==100 || mousePressed)  for (float j=1.2; j<4; j=j*1.4) {
        canvas.strokeWeight(fftStrokeWeight/j);
        canvas.triangle(cos(angle*0) * radiusX/j, sin(angle*0) * radiusX/j, cos(angle*1) * radiusX/j, sin(angle*1) * radiusX/j, cos(angle*2) * radiusX/j, sin(angle*2) * radiusX/j);
      }
    } else {
      canvas.beginShape();
      canvas.strokeJoin(ROUND);
      for (int i=0; i<=circleResolution; i++) {
        float x = 0 + cos(angle*i) * radiusX;
        float y = 0 + sin(angle*i) * radiusX;
        canvas.vertex(x, y);
      }
      canvas.endShape();
      
      //Other shapes within shapes
      if (myAudioData[0]==100 || mousePressed) {
        for (float j=1.2; j<4; j=j*1.4) { //These numbers are arbitrary and should be better thought out
          canvas.beginShape();
          canvas.strokeJoin(ROUND);
          canvas.strokeWeight(fftStrokeWeight/j);
          for (int i=0; i<=circleResolution; i++) {
            float x = 0 + cos(angle*i) * radiusX/(j);
            float y = 0 + sin(angle*i) * radiusX/(j);
            canvas.vertex(x, y);
          }
          canvas.endShape();
        }
      }
    }

    canvas.popMatrix();
    //}

    canvas.endDraw();
  }

  image(canvas, 0, 0);

  if (showVisualizer) myAudioDataWidget();
}

void oscEvent(OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();
  float  val  = theOscMessage.get(0).floatValue();

  if (addr.equals("/1/ellipses")) { 
    canvas.clear();
    ellipses = val;
    circleResolution=8;
  } else if (addr.equals("/1/rectangles")) { 
    canvas.clear();
    rectangles = val;
    circleResolution=4;
  } else if (addr.equals("/1/triangles")) { 
    canvas.clear();
    triangles = val;
    circleResolution = 3;
  } else if (addr.equals("/1/lines")) { 
    canvas.clear();
    lines = val;
    circleResolution = 6;

    println("lines doesn't work currently - setting circleResolution to 8 instead");
  } else if (addr.equals("/1/red")) { 
    red = val;
    strokeColor = color(255, 0, 0, drawAlpha);
  } else if (addr.equals("/1/blue")) { 
    blue = val;
    strokeColor = color(0, 0, 255, drawAlpha);
  } else if (addr.equals("/1/orange")) { 
    orange = val;
    strokeColor = color(255, 200, 0, drawAlpha);
  } else if (addr.equals("/1/pink")) { 
    strokeColor = color(255, 0, 255, drawAlpha);
    pink = val;
  } else {
    //print("### received an osc message.");
    //print(" addrpattern: "+theOscMessage.addrPattern());
    //println(" typetag: "+theOscMessage.typetag());
  }

  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //print(" value: "+val); //Printing one value
  //println(" typetag: "+theOscMessage.typetag());
}


void keyReleased() {
  if (key == DELETE || key == BACKSPACE) canvas.clear(); 

  switch(key) {
  case '1':
    strokeColor = color(#FFFFFF, drawAlpha);
    break;
  case '2':
    strokeColor = color(192, 100, 64, drawAlpha);
    break;
  case '3':
    strokeColor = color(52, 100, 71, drawAlpha);
    break;
  }
}

void fadeGraphics(PGraphics c, float fadeAmount) {
  c.beginDraw();
  c.loadPixels();

  // iterate over pixels
  for (int i =0; i<c.pixels.length; i++) {

    // get alpha value
    float alpha = (c.pixels[i] >> 24) & 0xFF ;

    // reduce alpha value
    alpha = max(0, alpha-fadeAmount);

    // assign color with new alpha-value
    c.pixels[i] = int(alpha)<<24 | (c.pixels[i]) & 0xFFFFFF ;
  }

  canvas.updatePixels();
  canvas.endDraw();
}

void myAudioDataUpdate() {
  for (int i = 0; i < myAudioRange; ++i) {
    float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
    float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
    myAudioData[i]     = tempIndexCon;
    myAudioIndexAmp+=myAudioIndexStep;
  }
  myAudioIndexAmp = myAudioIndex;
}

void myAudioDataWidget() {
  //noLights();
  //hint(DISABLE_DEPTH_TEST);
  noStroke(); 
  fill(0, 200); 
  rect(0, height-112, 102, 102);
  for (int i = 0; i < myAudioRange; ++i) {
    fill(#CCCCCC); 
    rect(10 + (i*5), (height-myAudioData[i])-11, 4, myAudioData[i]);
  }
  //hint(ENABLE_DEPTH_TEST);
}


void keyPressed()
{
  if ( key == 'f' )
  {
    // skip forward 5 seconds (5000 milliseconds)
    myAudio.skip(5000);
  }
  if ( key == 'r' )
  {
    // skip backward 5 seconds (5000 milliseconds)
    myAudio.skip(-5000);
  }
}

void stop() {
  myAudio.close();
  minim.stop();  
  super.stop();
}