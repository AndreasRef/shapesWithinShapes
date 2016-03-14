//OSC
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

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

float red;
float blue;
float orange;
float pink;
float white;

int circleResolution = 8;

float drawAlpha = 100;
float fadeSpeed = 5.3;

color strokeColor = color(255, drawAlpha);

PGraphics canvas;


void setup() {
  size(720, 720, P2D);
  //fullScreen(P2D);
  canvas = createGraphics(width, height);

  smooth();
  noFill();
  background(255);
  oscP5 = new OscP5(this, 8000);
  myRemoteLocation = new NetAddress("192.168.10.120", 9000);

  //Sound
  minim   = new Minim(this);
  //myAudio = minim.loadFile("HECQ_With_Angels_Trifonic_Remix_cut.wav");
  myAudio = minim.loadFile("MUSICDIRECTOR_tr5-Extreme_Explorations-Itay_Steinberg_Roman_Weinstein_Or_Chausah-stye412-songs_to_your_eyes.mp3");
  myAudio.loop();

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  myAudioFFT.window(FFT.GAUSS);

  //Update OSC values
  defaultOSCValues();
  //Send OSC Messages to turn on active LED indictator 
  OscMessage circlesLEDMessage = new OscMessage("/1/circlesLED");
  circlesLEDMessage.add(0);
  oscP5.send(circlesLEDMessage, myRemoteLocation);

  OscMessage rectanglesLEDMessage = new OscMessage("/1/rectanglesLED");
  rectanglesLEDMessage.add(0);
  oscP5.send(rectanglesLEDMessage, myRemoteLocation);

  OscMessage trianglesLEDMessage = new OscMessage("/1/trianglesLED");
  trianglesLEDMessage.add(0);
  oscP5.send(trianglesLEDMessage, myRemoteLocation);

  OscMessage octagonsLEDMessage = new OscMessage("/1/octagonsLED");
  octagonsLEDMessage.add(1);
  oscP5.send(octagonsLEDMessage, myRemoteLocation);
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

  fadeGraphics(canvas, fadeSpeed);

  canvas.beginDraw();
  canvas.noFill();

  if (radiusX >5) {

    canvas.pushMatrix();
    canvas.translate(width/2, height/2);


    float angle = TWO_PI/circleResolution;

    canvas.strokeWeight(fftStrokeWeight);
    //canvas.stroke(0,50); //Also has interesting effect
    if (frameCount % 2 ==0) { 
      canvas.stroke(strokeColor, drawAlpha);
    } else {
      canvas.stroke(255, drawAlpha);
    }

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
    canvas.endDraw();
  }

  image(canvas, 0, 0);

  if (showVisualizer) myAudioDataWidget();
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
  noStroke(); 
  fill(0, 200); 
  rect(0, height-112, 102, 102);
  for (int i = 0; i < myAudioRange; ++i) {
    fill(#CCCCCC); 
    rect(10 + (i*5), (height-myAudioData[i])-11, 4, myAudioData[i]);
  }
}


void keyPressed()
{
  if ( key == 'f' )
  { 
    myAudio.skip(5000); //Skip forward 5 seconds (5000 milliseconds)
  }
  if ( key == 'r' )
  {
    myAudio.skip(-5000); //Skip backward 5 seconds (5000 milliseconds)
  }
}

void stop() {
  myAudio.close();
  minim.stop();  
  super.stop();
}