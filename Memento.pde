PImage original;
PImage pieces[];
int original_x;
int original_y;
int nRows;
int nPieces;

void setup(){
  size(400, 600);
  nRows = 3;
  nPieces = nRows*nRows;

  original = loadImage("busquets.jpg");
  original_x = 0;
  original_y = 0;
  int delta = (original.width/nRows)*(original.height/nRows);
  int size = original.width * original.height;
  original.loadPixels();
  pieces = new PImage[nPieces];
  
  //DESPLAZAMOS PIEZAS H+W^NROWS
  for(int w = 0 ; w < nRows ; w++){
    for(int h = 0 ; h < nRows ; h++){ 
        pieces[h+w*nRows] = new PImage(original.width/nRows, original.height/nRows);
        pieces[h+w*nRows].loadPixels();
        //DESPLAZAMOS PIXELS 
        int pos = 0;
        for (int i = original.width/nRows*w; i < original.width/nRows*(w+1); i++) { //HORIZONTAL
          for (int j = original.width/nRows*h; j < original.height/nRows*(h+1); j++) { //VERTICAL
          
            pieces[h+w*nRows].pixels[pos] =  original.pixels[j + i*original.width];
           
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
  image(pieces[0],0*width/nRows,0*height/nRows);
  image(pieces[1],1*width/nRows,0*height/nRows);
  image(pieces[2],2*width/nRows,0*height/nRows);
  image(pieces[3],0*width/nRows,1*height/nRows);
  image(pieces[4],1*width/nRows,1*height/nRows);
  image(pieces[5],2*width/nRows,1*height/nRows);
  image(pieces[6],0*width/nRows,2*height/nRows);
  image(pieces[7],1*width/nRows,2*height/nRows);
  image(pieces[8],2*width/nRows,2*height/nRows);
  
}
