
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
    bg = loadImage("bg.jpg");
    img1 = loadImage("mountain.jpg");
    img2 = loadImage("landscape.jpg");
    img3 = loadImage("oscars.jpg");
    
}


void setupPuzzle(PImage photo){
    //PUZZLE SETUP--------------------------
    nRows = 2;                // Rows/Columns in the puzzle
    nPieces = nRows * nRows;  // # of pieces in the puzzle
    
    original = photo;// Image to load
    original.resize(280, 280);
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

  public void draw() {
  
    //DRAW FOR THE MENU
    //update(mouseX, mouseY);
    background(bg);
    if(menu != 4){
    stroke(0);
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
    }
  if (menu == 0){
   
    rect(width/11, height/2, width*0.8, height*0.22);//start
    textSize(56);
    fill(azulOscuro);
    text("Start", width/4, height/1.55);
    fill(azul);
  }
  else if (menu == 1){

    
    rect(width/11, height/2, width*0.8, height*0.15);//take photo
    rect(width/11, height/1.4, width*0.8, height*0.15);//Choose Picture
   
    fill(azulOscuro);
    textSize(40);
    text("Take Photo", width/8, height/1.65);
    textSize(30);
    text("Choose Picture", width/8, height/1.23);
    fill(azul);
  }
  else if (menu == 3){
    
  
    image(img1, width/13, height/3, height*0.15, height*0.15);//mountain
    image(img2, width/13, height/2, height*0.15, height*0.15);//landscape
    image(img3, width/13, height/1.5, height*0.15, height*0.15);//oscars
   
    /*fill(azulOscuro);
    textSize(40);
    text("Take Photo", width/8, height/1.65);
    textSize(30);
    text("Choose Picture", width/8, height/1.23);
    fill(azul);*/
  }

   if (menu == 4){
    //DRAW FOR PUZZLE-------------------------------------
    if(flag_back == true){
      textSize(48);
      image(original,10,(height/4));//background(255,0,0);/////////////YOU WIN
      fill(rojo);
      text("YOU WIN!", width/10, height/4.5);
      fill(azul);
    } else{
      /*if (mousePressed) {
        overPieza();
      }*/
      // set(original_x, original_y, pieces[0]);
      for (int w = 0; w < nRows; w++) {
        for (int h = 0; h < nRows; h++) {
          // image(pieces[w+h*nRows], 20+
          // w*(20+original.width)/nRows,20+h*(20+original.height)/nRows);
          // if(nums.get(w+h*nRows) < nPieces-1)
            
          image(pieces[nums.get(w + h * nRows)], 
              10+w*( original.width) / nRows, 
              (height/4)+h* (original.height) / nRows);
              //20 + w*(20 + original.width) / nRows + (width/nRows), 
              //20 + h* (20 + original.height) / nRows + (heightnRows));
              
          if(selectedPiece == w + h*nRows){
            noFill();
            strokeWeight(2);
            stroke(0,255,0);
            rect( 10+w*( original.width) / nRows, (height/4)+h* (original.height) / nRows, original.width/nRows-2, original.height/nRows-2);
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
    textSize(15);
    rect(0, height/1.1, width/5, height/11);
    fill(azulOscuro);
    text("< Back", 0, height/1.04);
    fill(azul);
   }
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
     if (overRect(width/11, height/2, width*0.8, height*0.15)) {//take photo
        println("Take Photo");
        pmenu.add(menu);
        menu = 2;
     } else if( overRect(width/11, height/1.4, width*0.8, height*0.15)){//Choose Picture
        println("Choose Picture");
        pmenu.add(menu);
        menu = 3;
      }
    }
     else if (menu == 3){//Take photo or Choose Picture
       if (overRect(width/13, height/3, height*0.15, height*0.15)) {//take photo
          println("mountain");
          pmenu.add(menu);
          menu = 4;
          setupPuzzle(img1);
       } else if( overRect(width/13, height/2, height*0.15, height*0.15)){//Choose Picture
          println("landscape");
          pmenu.add(menu);
          menu = 4;
          setupPuzzle(img2);
       }else if( overRect(width/13, height/1.5, height*0.15, height*0.15)){//Choose Picture
          println("oscars");
          pmenu.add(menu);
          menu = 4;
          setupPuzzle(img3);
          }
        }
      
    
   else if (menu == 4){
    if(flag_back == false){
       if(overRect(10,(height/4),10+original.width,(height/4)+original.height)){
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

int overPieza(){
  int over_p = 0;
  for (int w = 0; w < nRows; w++) {
    for (int h = 0; h < nRows; h++) {
      if (  mouseX >= (10+ w*( original.width) / nRows) && 
          mouseX <= (10 + w*( original.width) / nRows) + (original.width / nRows) && 
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


