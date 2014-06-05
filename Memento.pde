
//IMAGE VARS
PImage original;
PImage pieces[];
PImage puzzled[];
int nRows;
int nPieces;

ArrayList<Integer> nums = new ArrayList<Integer>();
ArrayList<Integer> nums_aux = new ArrayList<Integer>();

//PUZZLE VARS
int original_x;
int original_y;


void setup(){
  size(400, 600);                       //Window setup
  nRows = 3;                            //Rows/Columns in the puzzle
  nPieces = nRows*nRows;                // # of pieces in the puzzle

  original = loadImage("fog.jpg");      //Image to load
  
  original.loadPixels();                //Initialize pixels from original image
  pieces = new PImage[nPieces];         //Initialize vector pieces
  puzzled = new PImage[nPieces];         //Initialize vector puzzled
  
  
  //SCRAMBLE NUMBERS AND SAVE IT ON NUMS[]
  for(int i = 0; i < nPieces ; i++){
    nums_aux.add(i);
    print(nums_aux.get(i) + ", ");
  }
  println();
  for(int i = 0 ; i < nPieces ; i++){
    
    int index =  (int)random(nums_aux.size());    
    nums.add(nums_aux.get(index));
    print(nums.get(i) + ", ");
    nums_aux.remove(index);
    //println(nums.get(i));
  }
  
  /*-----------------------*/
  //original_x = 0;
  //original_y = 0;

  
  // SPLITTER CORE - SHIFT PIECES H+W^NROWS
  for(int w = 0 ; w < nRows ; w++){
    for(int h = 0 ; h < nRows ; h++){ 
        pieces[h+w*nRows] = new PImage(original.width/nRows, original.height/nRows);        //Initialize every piece
        pieces[h+w*nRows].loadPixels();
        //SHIFT PIXELS 
        int pos = 0;
        for (int i = original.width/nRows*w; i < original.width/nRows*(w+1); i++) {         //Horizontal shift
          for (int j = original.width/nRows*h; j < original.height/nRows*(h+1); j++) {      //Vertical shift
            pieces[h+w*nRows].pixels[pos] =  original.pixels[j + i*original.width];         //Save pixel
            pos++;
          } 
        }  
        pieces[h+w*nRows].updatePixels();
    }
  }
    
}

void draw() {
  background(255);
  if(mousePressed){
  original_x = constrain(mouseX-(original.width/2),0, width-original.width);
  original_y = constrain(mouseY-(original.height/2),0, height-original.height);
  }
  //set(original_x, original_y, pieces[0]);
  for(int w = 0 ; w < nRows ; w++){
    for(int h = 0 ; h < nRows ; h++){ 
        //image(pieces[w+h*nRows],  20+ w*(20+original.width)/nRows,20+h*(20+original.height)/nRows);
        if(nums.get(w+h*nRows) < nPieces-1)
          image(pieces[nums.get(w+h*nRows)],  20+ w*(20+original.width)/nRows,20+h*(20+original.height)/nRows);
    } 
  }  
      
}
