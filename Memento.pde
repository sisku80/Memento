
//MENU VARS--------------------------------
PImage bg;
color azul = color(0, 102, 153);
color azulOscuro = color(20,20,100);
color verde = color(20,120,0);
color rojo = color(200,0,0);
int rectOver = 0;
boolean menu = false;

//----------------------------------------

//PUZZLE VARS-----------------------------

  // IMAGE VARS
  PImage original;
  PImage pieces[];
  PImage puzzled[];
  int nRows;
  int nPieces;
  int selectedPiece;
  boolean flag_back;
  ArrayList<Integer> nums = new ArrayList<Integer>();
  ArrayList<Integer> nums_aux = new ArrayList<Integer>();

  

public void setup() {
    
    size(300, 450);
    
    //MENU SETUP ---------------------------
    ellipseMode(CENTER);
    bg = loadImage("bg22.jpg");
  
    //PUZZLE SETUP--------------------------
    nRows = 3;                // Rows/Columns in the puzzle
    nPieces = nRows * nRows;  // # of pieces in the puzzle

    original = loadImage("fog.jpg"); // Image to load
    original.resize(280, 280);
    original.loadPixels();           // Initialize pixels from original image
    pieces = new PImage[nPieces];    // Initialize vector pieces
    puzzled = new PImage[nPieces];   // Initialize vector puzzled
    selectedPiece = -1;
    flag_back = false;
    // SCRAMBLE NUMBERS AND SAVE IT ON NUMS[]
    for (int i = 0; i < nPieces; i++) {
      nums_aux.add(i);
      print(nums_aux.get(i) + ", ");
    }
    println();
    for (int i = 0; i < nPieces; i++) {

      int index = (int) random(nums_aux.size());
      nums.add(nums_aux.get(index));
      print(nums.get(i) + ", ");
      nums_aux.remove(index);
      // println(nums.get(i));

    }
    for (int i = 0; i < nPieces; i++) {
      nums_aux.add(i);
      print(nums_aux.get(i) + ", ");
    }

    /*-----------------------*/


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

  public void draw() {
   
   //DRAW FOR THE MENU
   update(mouseX, mouseY);
  background(bg);
  fill(azulOscuro);
  textSize(48);
  text("Puzzled", width/15, height/11);
  textSize(56);
  text("Memento", width/10, height/5);
  textSize(10);
  fill(azul);
  text("by Francesc Ramirez", width/10, height/4.5);
  text("     Luis Prieto", width/10, height/4);
  text("     Ricardo Saldaña", width/10, height/3.6);
  fill(azul);
  
  if (menu == false){
    stroke(0);
    rect(width/11, height/2, width*0.8, height*0.22);
    textSize(56);
    fill(azulOscuro);
    //-----------------------------------------//
    text("Start", width/2 -70, height/2+70);
    fill(azul);
  }
  else{
    
    stroke(0);
    rect(width/2 - 125, height/2, 250, 80);
    rect(width/2 - 125, height/2+100, 250, 80);
   
    fill(azulOscuro);
    textSize(40);
    text("Take Photo", width/2-110, height/2+60);
    textSize(30);
    text("Choose Picture", width/2-110, height/2+150);
    fill(azul);
  }
   
   
    //DRAW FOR PUZZLE-------------------------------------
    if(flag_back == false)
      background(255);
    else
      background(255,0,0);
    /*if (mousePressed) {
      overPieza();
    }*/
    // set(original_x, original_y, pieces[0]);
    for (int w = 0; w < nRows; w++) {
      for (int h = 0; h < nRows; h++) {
        // image(pieces[w+h*nRows], 20+
        // w*(20+original.width)/nRows,20+h*(20+original.height)/nRows);
        // if(nums.get(w+h*nRows) < nPieces-1)
        image(  pieces[nums.get(w + h * nRows)], 
            10+w*( original.width) / nRows, 
            10+h* (original.height) / nRows);
            //20 + w*(20 + original.width) / nRows + (width/nRows), 
            //20 + h* (20 + original.height) / nRows + (heightnRows));
      }
    }
    //END OF DRAW PUZZLE -------------------------------
  }

  public void mouseClicked(){
    
    if(overRect(10,10,10+original.width,10+original.height)){
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

  int overPieza(){
    int over_p = 0;
    for (int w = 0; w < nRows; w++) {
      for (int h = 0; h < nRows; h++) {
        if (  mouseX >= (w*( original.width) / nRows) && 
            mouseX <= (w*( original.width) / nRows) + (original.width / nRows) && 
            mouseY >= (h* (original.height) / nRows) && 
            mouseY <= (h* (original.height) / nRows) + (original.width / nRows)){
              over_p = w+h*nRows;
             
        }
      }
    }
    return over_p;
    
  }

void update(int x, int y) {
  if (menu==false){
    if ( overRect(width/2 - 125, height/2, 250, 110)) {
      rectOver = 1;
    } else {
      rectOver = 0;
    }
  }
  else {
   if ( overRect(width/2 - 125, height/2, 250, 80)) {
      rectOver = 2;
   } else if( overRect(width/2 - 125, height/2+100, 250, 80)){
     rectOver = 3;
    } else {
     rectOver = 0;
    }
  }
}

void mousePressed() {
  if (rectOver == 1) {
    println("Start");
    menu = true;
  }
  else if (rectOver == 2) {
    println("Take Photo");
    menu = true;
  }
  else if (rectOver == 3) {
    println("Choose Picture");
    menu = true;
  }
}


boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
void flip(int a, int b){
  int aux;
  aux = nums.get(a);
  nums.set(a,nums.get(b));
  nums.set(b,aux);
  
}

