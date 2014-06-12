import ketai.sensors.*;
import ketai.camera.*;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import oscP5.*;

//MENU VARS--------------------------------
PImage bg;
color azul = color(0, 102, 153);
color azulOscuro = color(20,20,100);
color verde = color(20,120,0);
color rojo = color(200,0,0);
int rectOver = 0;
int menu = 0;
ArrayList<Integer> pmenu = new ArrayList<Integer>();
PImage img1, img2, img3;
boolean flagStarted;


//----------------------------------------

//PUZZLE VARS-----------------------------

  // IMAGE VARS
  PImage original;
  PImage pieces[];
  PImage puzzled[];
  int nRows = 2;
  int nPieces;
  int selectedPiece;
  boolean flag_back;
  ArrayList<Integer> nums = new ArrayList<Integer>();
  ArrayList<Integer> nums_aux = new ArrayList<Integer>();
KetaiSensor sensor;
int colour;
PVector accelerometer = new PVector(),
        pAccelerometer = new PVector();
KetaiCamera cam;
KetaiBluetooth bt;
String info = "";
KetaiList klist;
PVector remoteMouse = new PVector();

ArrayList<String> devicesDiscovered = new ArrayList();
boolean isConfiguring = true;
String UIText;

public void setup() {
    
    size(displayWidth,displayHeight);
    
    //MENU SETUP ---------------------------
    ellipseMode(CENTER);
    //bg = loadImage("bg2.jpg");
    //bg.resize(displayWidth,displayHeight);
    img1 = loadImage("mountain1_.jpg");
    img2 = loadImage("landscape1_.jpg");
    img3 = loadImage("oscars1_.jpg");
    
    sensor = new KetaiSensor(this);
  sensor.start();
  
  orientation(LANDSCAPE);
  imageMode(CENTER);
  cam = new KetaiCamera(this, 320, 240, 24);
  
  //SETUP BLUETOOTH!!!!!
   bt = new KetaiBluetooth(this);
      //start listening for BT connections
      bt.start();    
      
      if(bt.getAddress().equals("CC:C3:EA:2E:8B:5B")){
          bt.connectDevice("34:BB:26:E1:51:3C");
        }
        else if(bt.getAddress().equals("34:BB:26:E1:51:3C")){
          bt.connectDevice("CC:C3:EA:2E:8B:5B");
        }
        
        
}




  public void draw() {
    OscMessage m = new OscMessage("/remoteMouse/");
    //m.add(cam.width);
    //m.add(cam.height);
    m.add(mouseX);
    m.add(mouseY);
    //println("ENVIANDO: "+cam.width + ", "+cam.height);
  /*  for(int i = 0; i < cam.width*cam.height; i++)
    {
      m.add(cam.pixels[i]);
      print(i);
    }*/
    bt.broadcast(m.getBytes());
    
    
    //DRAW FOR THE MENU
    //update(mouseX, mouseY);
    textAlign(LEFT);
    background(192,192,192);
    if(menu != 4){
    stroke(0);
    fill(azulOscuro);
    textSize(64);
    text("Puzzled", width/15, height/11);
    textSize(78);
    text("Memento", width/10, height/5);
    textSize(20);
    fill(azul);
    }
    if(menu == 0){
      textAlign(LEFT);
      textSize(30);
      text("by Francesc Ramirez", width/9.7, 3*height/12);
      text("      Luis Prieto", width/9.7, 3.5*height/12);
      text("      Ricardo Saldaña", width/9.7, 4*height/12);
    }
    
  if (menu == 0){
    textAlign(CENTER);
    rect(width/11, height/2, width*0.8, height*0.22);//start
    textSize(56);
    fill(azulOscuro);
    text("Start", width/2, height/1.55);
    fill(azul);
  }
  else if (menu == 1){
    textAlign(CENTER,CENTER);
    
    rect(width/11, 1.5*height/5, width*0.8, height*0.15);//take photo
    rect(width/11, 2.5*height/5, width*0.8, height*0.15);//Choose Picture
    rect(width/11, 3.5*height/5, width*0.8, height*0.15);//Listen Bluetooth
    float plus = ((height*0.15)/2);
    fill(azulOscuro);
    textSize(40);
    text("Take Photo", width/2, (1.5*height/5)+plus);
    textSize(40);
    text("Choose Picture",width/2, (2.5*height/5)+plus);
    textSize(40);
    text("Listen Bluetooth", width/2, (3.5*height/5)+plus);
    fill(azul);
  }
  else if(menu == 5)
  {
     textAlign(CENTER,CENTER);
     textSize(50);
     text("Listening...", width/2, height/2); 
     //bluetooth...
    
    
      
  }
  else if(menu == 2)
  {
     textAlign(CENTER);
     imageMode(CENTER);
     image(cam, width/2, height/2, width, height); 
  }
  
  else if (menu == 3){
    
    imageMode(CENTER);
    image(img1, 0.6*width/3, height/2, height*0.4, height*0.4);//mountain
    image(img2, 1.5*width/3, height/2, height*0.4, height*0.4);//landscape
    image(img3, 2.4*width/3, height/2, height*0.4, height*0.4);//oscars
   
    /*fill(azulOscuro);
    textSize(40);
    text("Take Photo", width/8, height/1.65);
    textSize(30);
    text("Choose Picture", width/8, height/1.23);
    fill(azul);*/
  }

   if (menu == 4){
    //DRAW FOR PUZZLE-------------------------------------
    
    textAlign(CENTER);
    if(flag_back == true){
      textSize(78);
      image(original,375,(height/4));//background(255,0,0);/////////////YOU WIN
      fill(azulOscuro);
      
      text("YOU WIN!", width/2, height/5);
      fill(azul);
    } else{
      /*if (mousePressed) {
        overPieza();
      }*/
      imageMode(CORNER);
      // set(original_x, original_y, pieces[0]);
      for (int w = 0; w < nRows; w++) {
        for (int h = 0; h < nRows; h++) {
          // image(pieces[w+h*nRows], 20+
          // w*(20+original.width)/nRows,20+h*(20+original.height)/nRows);
          // if(nums.get(w+h*nRows) < nPieces-1)
          imageMode(CORNER);
          image(pieces[nums.get(w + h * nRows)], 
              375+w*( original.width) / nRows, 
              (height/4)+h* (original.height) / nRows);
              //20 + w*(20 + original.width) / nRows + (width/nRows), 
              //20 + h* (20 + original.height) / nRows + (heightnRows));
              
          if(selectedPiece == w + h*nRows){
            noFill();
            strokeWeight(2);
            stroke(0,255,0);
            rect( 375+w*( original.width) / nRows, (height/4)+h* (original.height) / nRows, original.width/nRows-2, original.height/nRows-2);
            fill(azul);
            strokeWeight(1);
            stroke(0);
          }
        }
      }
    }
      //END OF DRAW PUZZLE ------------------------------
   }
   if (menu != 0){
    
    textSize(25);
    textAlign(CENTER,CENTER);
    rect(0, height-(height/11), width/6, height/11);
    fill(azulOscuro);
    text("< Back", width/12, height/1.04);
    fill(azul);
   }
   
   
   
   //shake
   float delta = PVector.angleBetween(accelerometer, pAccelerometer);
  if (degrees(delta) > 45) {
    if(flagStarted == false){
      if(nRows < 5){
        nRows++;
        setupPuzzle(original,nRows);
      }
      scrambleNums();
    }
  }
  pAccelerometer.set(accelerometer);
}

void onAccelerometerEvent(float x, float y, float z, long a, int b) {
 accelerometer.x = x;
  accelerometer.y = y;
  accelerometer.z = z;

}

  public void mousePressed(){
    if (menu !=0){//Atras
      if (overRect(0, height/1.1, width/5, height/11)) {
        println("Atras");
        menu = pmenu.get(pmenu.size()-1);
        pmenu.remove(pmenu.size()-1);
      } 
    }
    if (menu == 0){ //Start
      if (overRect(width/11, height/2, width*0.8, height*0.22)) {
        println("Start");
        pmenu.add(menu);
        menu = 1;
      } 
    }
  
    else if (menu == 1){//Take photo or Choose Picture
     if (overRect(width/11, 1.5*height/5, width*0.8, height*0.15)) {//take photo
        println("Take Photo");
        pmenu.add(menu);
        menu = 2;
     } else if( overRect(width/11, 2.5*height/5, width*0.8, height*0.15)){//Choose Picture
        println("Choose Picture");
        pmenu.add(menu);
        menu = 3;
      }
     else if( overRect(width/11, 3.5*height/5, width*0.8, height*0.15)){//Listen
        println("Listen");
        pmenu.add(menu);
        menu = 5;
      }
    }
    
    else if(menu == 2)
    {
      if (cam.isStarted())
      {
        cam.stop();
        menu = 4;
        nRows = 3;
        flagStarted = false;
        setupPuzzle(cam,nRows);
      }
      else
        cam.start();
    }    
    else if (menu == 3){//Take photo or Choose Picture
       if (overRect(0.6*width/3 - (height*0.2), height/2 - (height*0.2), height*0.4, height*0.4)) {//take photo
          println("mountain");
          pmenu.add(menu);
          menu = 4;
          nRows = 3;
          flagStarted = false;
          setupPuzzle(img1,nRows);
       } else if( overRect(1.5*width/3 - (height*0.2), height/2 - (height*0.2), height*0.4, height*0.4)){//Choose Picture
          println("landscape");
          pmenu.add(menu);
          menu = 4;
          nRows = 3;
          flagStarted = false;
          setupPuzzle(img2,nRows);
       }else if( overRect(2.4*width/3 - (height*0.2), height/2 - (height*0.2), height*0.4, height*0.4)){//Choose Picture
          println("oscars");
          pmenu.add(menu);
          menu = 4;
          nRows = 3;
          flagStarted = false;
          setupPuzzle(img3,nRows);
       }
     }
      
    
   else if (menu == 4){
    if(flag_back == false){
       if(overRect(375,(height/4),10+original.width,(height/4)+original.height)){
        int over = overPieza();
        println(over);
        if(selectedPiece == -1){
          selectedPiece = over;
        } else{
          flip(selectedPiece, over);
          println("Flip: "+ selectedPiece +"," + over);
          selectedPiece = -1;
        }
        flag_back = true;
        for(int c = 0; c < nPieces ; c++){
          
          if(nums_aux.get(c) != nums.get(c)){
            flag_back = false;
          }
        }
      }
    }
   }
}


void setupPuzzle(PImage photo, int inRows){
    //PUZZLE SETUP--------------------------
    if(inRows < 3)
      inRows = 3;
    nRows = inRows;                // Rows/Columns in the puzzle
    nPieces = nRows * nRows;  // # of pieces in the puzzle
    
    original = photo;// Image to load
    original.resize(500,500);
    original.loadPixels();           // Initialize pixels from original image
    pieces = new PImage[nPieces];    // Initialize vector pieces
    puzzled = new PImage[nPieces];   // Initialize vector puzzled
    selectedPiece = -1;
    flag_back = false;
    
    scrambleNums();


    // SPLITTER CORE - SHIFT PIECES H+W^NROWS
    for (int w = 0; w < nRows; w++) {
      for (int h = 0; h < nRows; h++) {
        pieces[h + w * nRows] = new PImage(original.width / nRows,original.height / nRows); // Initialize every piece
        pieces[h + w * nRows].loadPixels();
        // SHIFT PIXELS
        int pos = 0;
        for (int i = original.width / nRows * w; i < original.width
            / nRows * (w + 1); i++) { // Horizontal shift
          for (int j = original.width / nRows * h; j < original.height
              / nRows * (h + 1); j++) { // Vertical shift
            pieces[h + w * nRows].pixels[pos] = original.pixels[j
                + i * original.width]; // Save pixel
            pos++;
          }
        }
        pieces[h + w * nRows].updatePixels();
      }
    }
}

int overPieza(){
  int over_p = 0;
  for (int w = 0; w < nRows; w++) {
    for (int h = 0; h < nRows; h++) {
      if (  mouseX >= (375+ w*( original.width) / nRows) && 
          mouseX <= (375 + w*( original.width) / nRows) + (original.width / nRows) && 
          mouseY >= ((height/4) + h* (original.height) / nRows) && 
          mouseY <= ((height/4) + h* (original.height) / nRows) + (original.width / nRows)){
            over_p = w+h*nRows;   
      }
    }
  }
  return over_p;
}

boolean overRect(float x, float y, float width, float height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
void flip(int a, int b){
  flagStarted = true;
  int aux;
  aux = nums.get(a);
  nums.set(a,nums.get(b));
  nums.set(b,aux);
}

void scrambleNums(){
// SCRAMBLE NUMBERS AND SAVE IT ON NUMS[]
    nums_aux.clear();
    for (int i = 0; i < nPieces; i++) {
      nums_aux.add(i);
      print(nums_aux.get(i) + ", ");
    }
    println();
    nums.clear();
    for (int i = 0; i < nPieces; i++) {

      int index = (int) random(nums_aux.size());
      nums.add(nums_aux.get(index));
      print(nums.get(i) + ", ");
      nums_aux.remove(index);
      // println(nums.get(i));

    }
    nums_aux.clear();
    for (int i = 0; i < nPieces; i++) {
      nums_aux.add(i);
    }

    /*-----------------------*/  
}

void onCameraPreviewEvent()
{
  cam.read();
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  //KetaiOSCMessage is the same as OscMessage
  //   but allows construction by byte array
  KetaiOSCMessage m = new KetaiOSCMessage(data);
  if (m.isValid())
  {
    if (m.checkAddrPattern("/remoteMouse/"))
    {
      if (m.checkTypetag("ii"))
      {
        int w = m.get(0).intValue();
        int h = m.get(1).intValue();
        /* int size = w*h;
        PImage img = new PImage(w,h);
       for(int i = 2; i < size+2; i++)
        {
          int c = m.get(i).intValue();
          img.pixels[i-2] = c;
        }
        img.updatePixels();
        pmenu.add(menu);
        menu = 4;
        setupPuzzle(img,nRows);*/
        textAlign(CENTER,CENTER);
        textSize(48);
        text(w+ ", " + h, width/2, height/2);
        println("JZJZJZJZJZ: " + w + ", "+h);
      }
    }
  }
}
String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device: devices)
  {
    btInfo+= device+"\n*****************************\n";
  }

  return btInfo;
}

