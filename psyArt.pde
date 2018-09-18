//Adapted from Jeremy Kun's Random (Psychedelic) Art
//https://jeremykun.com/2012/01/01/random-psychedelic-art/


//Size of the pixel can be changed to render the sketch at a higher frame rate
int PIxSize = 1;

//Scaled width and height of the frame from the pixel size
float w, h;
//x,y will represent the position of the pixel (scaled between -1 and 1)
float x, y;
//r,g,b will be the R,G,B values for the colors of the pixels
float r, rA, g, gA, b, bA;
//Phase will be the offset of the cos and sine functions
float phase;
//phaseInc controls the speed at which the sketch evolves
float phaseInc = 0.01;
//The arrays will store the instructions to decide on the colors and alpha values
int[][] rValues, gValues, bValues ;

//contros the complexity of the function
int bArrayLength = 30;
int rArrayLength = 10;
int gArrayLength = 20;
//The 6 options are: 0: cos(pi*f), 1: sin(pi*f), 2: f*x, 3:f*y, 4: f+phase, 5:do nothing
int numOptions = 6;


void setup() {
  size(1280, 720);
  //rescales the size of the sketch depending on the number of pixels
  w = width/PIxSize;
  h = height/PIxSize;


  //Initialize the arrays
  rValues = new int[2][rArrayLength];

  gValues = new int[2][gArrayLength];
  bValues = new int[2][bArrayLength];
  //Fill the arrays with the recipe for each color and alpha
  for (int i=0; i<rArrayLength; i++) {
    rValues[0][i] = int(random(numOptions));
    rValues[1][i] = int(random(numOptions));
  }
  for (int i=0; i<bArrayLength; i++) {
    bValues[0][i] = int(random(numOptions));
    bValues[1][i] = int(random(numOptions));
  }
  for (int i=0; i<gArrayLength; i++) {
    gValues[0][i] = int(random(numOptions));
    gValues[1][i] = int(random(numOptions));
  }
  noStroke();
}


void draw() {
  //Run through horizontally
  for (int i=0; i<w; i++) {
    //Rescale the horizontal position to make between -1 and 1 
    x = i/(0.5*w)-1;
    //Runs through vertically
    for (int j=0; j<w; j++) {
      //Rescale the vertical position to make between -1 and 1 
      y = j/(0.5*h)-1;
      //evaluate the current values for each of the color and corresponding alpha
      r = 127.5*( eval(rValues[0], x, y, phase)+1);
      rA = 127.5*( eval(rValues[1], x, y, phase)+1);
      b = 127.5*(  eval(bValues[0], x, y, phase)+1);
      bA = 127.5*(  eval(bValues[1], x, y, phase)+1);
      g = 127.5*( eval(gValues[0], x, y, phase)+1);
      gA = 127.5*( eval(gValues[1], x, y, phase)+1);
      //draws a rectangle for each color
      fill(0, g, 0, gA);
      rect(i*PIxSize, j*PIxSize, PIxSize, PIxSize);
      fill(0, 0, b, bA);
      rect(i*PIxSize, j*PIxSize, PIxSize, PIxSize);
      fill(r, 0, 0, rA);
      rect(i*PIxSize, j*PIxSize, PIxSize, PIxSize);
    }
  }
  //increase the phase
  phase+=phaseInc;
  saveFrame("psych-######.tiff");
}


//0: cos, 1: sin, 2: x, 3:y, 4: add phase, 5:do nothing
float eval(int[] values, float x, float y, float phase) {
  //f stores the temporary value
  float f;
  //the first parameter should be x or y
  if (values[0]<3) {
    f = y;
  } else {
    f = x;
  }

  //applies the operation
  for (int i =1; i<values.length-1; i++) {
    if (values[i]==0) {
      f = cos(PI*f);
    } else if (values[i]==1) {
      f = sin(PI*f);
    } else if (values[i]==2) {
      f *= x;
    } else if (values[i]==3) {
      f *= y;
    } else if (values[i]==4) {
      f += phase;
    }
  }
  //last operation should be applying a cos or sin function
  if (values[values.length-1]<3) {
    return sin(PI*f);
  } else {
    return cos(PI*f);
  }
}