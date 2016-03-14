//All the OSC communcation takes place here. Too lazy (or bad at coding) to code it in a proper manner, so I'm hiding it here in shame  :D 

void defaultOSCValues () {

  circleResolution = 8;
  drawAlpha = 100;
  fadeSpeed = 5.3;
  easing = 0.15;
  myAudioAmp = 40;
  strokeColor = color(255, 255, 255, drawAlpha);

  //Send osc message to update values on the device
  OscMessage fadeMessage = new OscMessage("/1/fadeSpeed");
  fadeMessage.add(fadeSpeed);
  oscP5.send(fadeMessage, myRemoteLocation);

  OscMessage alphaMessage = new OscMessage("/1/alpha");
  alphaMessage.add(drawAlpha);
  oscP5.send(alphaMessage, myRemoteLocation);

  OscMessage easingMessage = new OscMessage("/1/easing");
  easingMessage.add(easing);
  oscP5.send(easingMessage, myRemoteLocation);

  OscMessage myAudioMessage = new OscMessage("/1/AudioInputLevel");
  myAudioMessage.add(myAudioAmp);
  oscP5.send(myAudioMessage, myRemoteLocation);

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


  //Color
  //Send OSC Messages to turn on active LED indictator 
  OscMessage redLEDMessage = new OscMessage("/1/redLED");
  redLEDMessage.add(0);
  oscP5.send(redLEDMessage, myRemoteLocation);

  OscMessage blueLEDMessage = new OscMessage("/1/blueLED");
  blueLEDMessage.add(0);
  oscP5.send(blueLEDMessage, myRemoteLocation);

  OscMessage orangeLEDMessage = new OscMessage("/1/orangeLED");
  orangeLEDMessage.add(0);
  oscP5.send(orangeLEDMessage, myRemoteLocation);

  OscMessage pinkLEDMessage = new OscMessage("/1/pinkLED");
  pinkLEDMessage.add(0);
  oscP5.send(pinkLEDMessage, myRemoteLocation);

  OscMessage whiteLEDMessage = new OscMessage("/1/whiteLED");
  whiteLEDMessage.add(1);
  oscP5.send(whiteLEDMessage, myRemoteLocation);
}

void oscEvent(OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();
  float  val  = theOscMessage.get(0).floatValue();

  if (addr.equals("/1/circles")) { 
    canvas.clear();
    circleResolution=128;


    //Send OSC Messages to turn on active LED indictator 
    OscMessage circlesLEDMessage = new OscMessage("/1/circlesLED");
    circlesLEDMessage.add(1);
    oscP5.send(circlesLEDMessage, myRemoteLocation);

    OscMessage rectanglesLEDMessage = new OscMessage("/1/rectanglesLED");
    rectanglesLEDMessage.add(0);
    oscP5.send(rectanglesLEDMessage, myRemoteLocation);

    OscMessage trianglesLEDMessage = new OscMessage("/1/trianglesLED");
    trianglesLEDMessage.add(0);
    oscP5.send(trianglesLEDMessage, myRemoteLocation);

    OscMessage octagonsLEDMessage = new OscMessage("/1/octagonsLED");
    octagonsLEDMessage.add(0);
    oscP5.send(octagonsLEDMessage, myRemoteLocation);
  } else if (addr.equals("/1/rectangles")) { 
    canvas.clear();
    circleResolution=4;

    //Send OSC Messages to turn on active LED indictator 
    OscMessage circlesLEDMessage = new OscMessage("/1/circlesLED");
    circlesLEDMessage.add(0);
    oscP5.send(circlesLEDMessage, myRemoteLocation);

    OscMessage rectanglesLEDMessage = new OscMessage("/1/rectanglesLED");
    rectanglesLEDMessage.add(1);
    oscP5.send(rectanglesLEDMessage, myRemoteLocation);

    OscMessage trianglesLEDMessage = new OscMessage("/1/trianglesLED");
    trianglesLEDMessage.add(0);
    oscP5.send(trianglesLEDMessage, myRemoteLocation);

    OscMessage octagonsLEDMessage = new OscMessage("/1/octagonsLED");
    octagonsLEDMessage.add(0);
    oscP5.send(octagonsLEDMessage, myRemoteLocation);
  } else if (addr.equals("/1/triangles")) { 
    canvas.clear();
    circleResolution = 3;

    //Send OSC Messages to turn on active LED indictator 
    OscMessage circlesLEDMessage = new OscMessage("/1/circlesLED");
    circlesLEDMessage.add(0);
    oscP5.send(circlesLEDMessage, myRemoteLocation);

    OscMessage rectanglesLEDMessage = new OscMessage("/1/rectanglesLED");
    rectanglesLEDMessage.add(0);
    oscP5.send(rectanglesLEDMessage, myRemoteLocation);

    OscMessage trianglesLEDMessage = new OscMessage("/1/trianglesLED");
    trianglesLEDMessage.add(1);
    oscP5.send(trianglesLEDMessage, myRemoteLocation);

    OscMessage octagonsLEDMessage = new OscMessage("/1/octagonsLED");
    octagonsLEDMessage.add(0);
    oscP5.send(octagonsLEDMessage, myRemoteLocation);
  } else if (addr.equals("/1/octagons")) { 
    canvas.clear();
    circleResolution = 8;

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
  } else if (addr.equals("/1/red")) { 
    red = val;
    strokeColor = color(255, 0, 0, drawAlpha);

    //Send OSC Messages to turn on active LED indictator 
    OscMessage redLEDMessage = new OscMessage("/1/redLED");
    redLEDMessage.add(1);
    oscP5.send(redLEDMessage, myRemoteLocation);

    OscMessage blueLEDMessage = new OscMessage("/1/blueLED");
    blueLEDMessage.add(0);
    oscP5.send(blueLEDMessage, myRemoteLocation);

    OscMessage orangeLEDMessage = new OscMessage("/1/orangeLED");
    orangeLEDMessage.add(0);
    oscP5.send(orangeLEDMessage, myRemoteLocation);

    OscMessage pinkLEDMessage = new OscMessage("/1/pinkLED");
    pinkLEDMessage.add(0);
    oscP5.send(pinkLEDMessage, myRemoteLocation);

    OscMessage whiteLEDMessage = new OscMessage("/1/whiteLED");
    whiteLEDMessage.add(0);
    oscP5.send(whiteLEDMessage, myRemoteLocation);
  } else if (addr.equals("/1/blue")) { 
    blue = val;
    strokeColor = color(0, 0, 255, drawAlpha);

    //Send OSC Messages to turn on active LED indictator 
    OscMessage redLEDMessage = new OscMessage("/1/redLED");
    redLEDMessage.add(0);
    oscP5.send(redLEDMessage, myRemoteLocation);

    OscMessage blueLEDMessage = new OscMessage("/1/blueLED");
    blueLEDMessage.add(1);
    oscP5.send(blueLEDMessage, myRemoteLocation);

    OscMessage orangeLEDMessage = new OscMessage("/1/orangeLED");
    orangeLEDMessage.add(0);
    oscP5.send(orangeLEDMessage, myRemoteLocation);

    OscMessage pinkLEDMessage = new OscMessage("/1/pinkLED");
    pinkLEDMessage.add(0);
    oscP5.send(pinkLEDMessage, myRemoteLocation);

    OscMessage whiteLEDMessage = new OscMessage("/1/whiteLED");
    whiteLEDMessage.add(0);
    oscP5.send(whiteLEDMessage, myRemoteLocation);
  } else if (addr.equals("/1/orange")) { 
    orange = val;
    strokeColor = color(255, 200, 0, drawAlpha);

    //Send OSC Messages to turn on active LED indictator 
    OscMessage redLEDMessage = new OscMessage("/1/redLED");
    redLEDMessage.add(0);
    oscP5.send(redLEDMessage, myRemoteLocation);

    OscMessage blueLEDMessage = new OscMessage("/1/blueLED");
    blueLEDMessage.add(0);
    oscP5.send(blueLEDMessage, myRemoteLocation);

    OscMessage orangeLEDMessage = new OscMessage("/1/orangeLED");
    orangeLEDMessage.add(1);
    oscP5.send(orangeLEDMessage, myRemoteLocation);

    OscMessage pinkLEDMessage = new OscMessage("/1/pinkLED");
    pinkLEDMessage.add(0);
    oscP5.send(pinkLEDMessage, myRemoteLocation);

    OscMessage whiteLEDMessage = new OscMessage("/1/whiteLED");
    whiteLEDMessage.add(0);
    oscP5.send(whiteLEDMessage, myRemoteLocation);
  } else if (addr.equals("/1/pink")) { 
    strokeColor = color(255, 0, 255, drawAlpha);
    pink = val;

    //Send OSC Messages to turn on active LED indictator 
    OscMessage redLEDMessage = new OscMessage("/1/redLED");
    redLEDMessage.add(0);
    oscP5.send(redLEDMessage, myRemoteLocation);

    OscMessage blueLEDMessage = new OscMessage("/1/blueLED");
    blueLEDMessage.add(0);
    oscP5.send(blueLEDMessage, myRemoteLocation);

    OscMessage orangeLEDMessage = new OscMessage("/1/orangeLED");
    orangeLEDMessage.add(0);
    oscP5.send(orangeLEDMessage, myRemoteLocation);

    OscMessage pinkLEDMessage = new OscMessage("/1/pinkLED");
    pinkLEDMessage.add(1);
    oscP5.send(pinkLEDMessage, myRemoteLocation);

    OscMessage whiteLEDMessage = new OscMessage("/1/whiteLED");
    whiteLEDMessage.add(0);
    oscP5.send(whiteLEDMessage, myRemoteLocation);
  } else if (addr.equals("/1/white")) { 
    strokeColor = color(255, 255, 255, drawAlpha);
    white = val;

    //Send OSC Messages to turn on active LED indictator 
    OscMessage redLEDMessage = new OscMessage("/1/redLED");
    redLEDMessage.add(0);
    oscP5.send(redLEDMessage, myRemoteLocation);

    OscMessage blueLEDMessage = new OscMessage("/1/blueLED");
    blueLEDMessage.add(0);
    oscP5.send(blueLEDMessage, myRemoteLocation);

    OscMessage orangeLEDMessage = new OscMessage("/1/orangeLED");
    orangeLEDMessage.add(0);
    oscP5.send(orangeLEDMessage, myRemoteLocation);

    OscMessage pinkLEDMessage = new OscMessage("/1/pinkLED");
    pinkLEDMessage.add(0);
    oscP5.send(pinkLEDMessage, myRemoteLocation);

    OscMessage whiteLEDMessage = new OscMessage("/1/whiteLED");
    whiteLEDMessage.add(1);
    oscP5.send(whiteLEDMessage, myRemoteLocation);
  } else if (addr.equals("/1/fadeSpeed")) { 
    fadeSpeed = val;
  } else if (addr.equals("/1/alpha")) { 
    drawAlpha = val;
  } else if (addr.equals("/1/easing")) { 
    easing = val;
  } else if (addr.equals("/1/AudioInputLevel")) { 
    myAudioAmp = val;
  } else if (addr.equals("/1/reset")) { 
    canvas.clear();  
    defaultOSCValues();
  }
}