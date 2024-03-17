int LAB_SIZE = 21;
char labyrinthe [][];
char sides [][][];
int posX=0, posY=1;
int dirX=1,dirY=0;
int oldDirX,oldDirY;
PImage img;
float anim;
float rotate;
void setup() {
  img = loadImage("stones.jpg");
  frameRate(20);
  randomSeed(2);
  size(1000, 1000, P3D);
  labyrinthe = new char[LAB_SIZE][LAB_SIZE];
  sides = new char[LAB_SIZE][LAB_SIZE][5];
  int todig = 0;
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      sides[j][i][0] = 0;
      sides[j][i][1] = 0;
      sides[j][i][2] = 0;
      sides[j][i][3] = 0;
      sides[j][i][4] = 0;
      if (j%2==1 && i%2==1) {
        labyrinthe[j][i] = '.';
        todig ++;
      } else
        labyrinthe[j][i] = '#';
    }
  }
  int gx = 1;
  int gy = 1;
  while (todig>0 ) {
    int oldgx = gx;
    int oldgy = gy;
    int alea = floor(random(0, 4)); // selon un tirage aleatoire
    if      (alea==0 && gx>1)          gx -= 2; // le fantome va a gauche
    else if (alea==1 && gy>1)          gy -= 2; // le fantome va en haut
    else if (alea==2 && gx<LAB_SIZE-2) gx += 2; // .. va a droite
    else if (alea==3 && gy<LAB_SIZE-2) gy += 2; // .. va en bas

    if (labyrinthe[gy][gx] == '.') {
      todig--;
      labyrinthe[gy][gx] = ' ';
      labyrinthe[(gy+oldgy)/2][(gx+oldgx)/2] = ' ';
    }
  }

  labyrinthe[0][1]                   = ' '; // entree
  labyrinthe[LAB_SIZE-2][LAB_SIZE-1] = ' '; // sortie

  for (int j=1; j<LAB_SIZE-1; j++) {
    for (int i=1; i<LAB_SIZE-1; i++) {
      if (labyrinthe[j][i]==' ') {
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]==' ' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
          sides[j-1][i][0] = 1;// c'est un bout de couloir vers le haut
        if (labyrinthe[j-1][i]==' ' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
          sides[j+1][i][3] = 1;// c'est un bout de couloir vers le bas
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]==' ' && labyrinthe[j][i+1]=='#')
          sides[j][i+1][1] = 1;// c'est un bout de couloir vers la droite
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]==' ')
          sides[j][i-1][2] = 1;// c'est un bout de couloir vers la gauche
      }
    }
  }

  // un affichage texte pour vous aider a visualiser le labyrinthe en 2D
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      print(labyrinthe[j][i]);
    }
    println("");
  }
}
void draw_with_box(int boxSize){
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      pushMatrix();
      translate(j*boxSize,i*boxSize,0);
      if(labyrinthe[i][j] == '#' && sides[i][j][4]==1){
        fill(12*j+15,12*i+15,255);
        box(boxSize);
      }
      else if(labyrinthe[i][j] == ' ' && sides[i][j][4]==1){
        translate(0,0,-boxSize);
        fill(255,50);
        noStroke();
        box(boxSize);
        stroke(0);
        translate(0,0,boxSize);
      }
      popMatrix();
    }
  }
  fill(0,255,0);
  pushMatrix();
    translate(posY*boxSize,posX*boxSize,0);
    noStroke();
    sphere(boxSize/2.0);
    stroke(0);
  popMatrix();
}

void draw_laby_my_way(int boxSize){
  beginShape(QUADS);
  for (int i=0; i<LAB_SIZE; i++) {
    for (int j=0; j<LAB_SIZE; j++) {
      fill(12*j+15,12*i+15,255);
      if(labyrinthe[i][j] == '#'){
        noStroke();
        texture(img);
        if(i == 0 || labyrinthe[i-1][j] != '#'){
        if(sides[i][j][3]==1)fill(0,255,255);
        vertex(i*boxSize, j*boxSize, 0,0,0);
        vertex(i*boxSize,(j+1)*boxSize,0,img.width,0);
        vertex(i*boxSize,(j+1)*boxSize,boxSize,img.width,img.height);
        vertex((i)*boxSize,j*boxSize,boxSize,0,img.height);
        }
        fill(12*j+15,12*i+15,255);
        if(j == LAB_SIZE-1 ||labyrinthe[i][j+1] != '#'){
         if(sides[i][j][2]==1)fill(255,0,0);
        vertex(i*boxSize, (j+1)*boxSize, 0,0,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,0,img.width,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,boxSize,img.width,img.height);
        vertex(i*boxSize,(j+1)*boxSize,boxSize,0,img.height);
        }
        fill(12*j+15,12*i+15,255);
       if(j == 0 || labyrinthe[i][j-1] != '#'){
         if(sides[i][j][1]==1)fill(0,255,0);
        vertex(i*boxSize, (j)*boxSize, 0,0,0);
        vertex((i+1)*boxSize,(j)*boxSize,0,img.width,0);
        vertex((i+1)*boxSize,(j)*boxSize,boxSize,img.width,img.height);
        vertex(i*boxSize,(j)*boxSize,boxSize,0,img.height);
       }
       fill(12*j+15,12*i+15,255);
       if ( i == LAB_SIZE-1 || labyrinthe[i+1][j] != '#'){
         if(sides[i][j][0]==1)fill(0,0,255);
        vertex((i+1)*boxSize, (j)*boxSize, 0,0,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,0,img.width,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,boxSize,img.width,img.height);
        vertex((i+1)*boxSize,(j)*boxSize,boxSize,0,img.height);
       }
       stroke(0);
      }
      else{
        noTexture();
        fill(128,128,128);
        vertex((i)*boxSize, (j)*boxSize, 0);
        vertex((i+1)*boxSize,(j)*boxSize,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,0);
        vertex((i)*boxSize,(j+1)*boxSize,0);
      }
    }
  }
  endShape();
}

void draw_laby_my_way2(int boxSize){
  beginShape(QUADS);
  for (int i=0; i<LAB_SIZE; i++) {
    for (int j=0; j<LAB_SIZE; j++) {
      fill(12*j+15,12*i+15,255);
      if(labyrinthe[i][j] == '#'){
        noStroke();
        texture(img);
        if(i == 0 || labyrinthe[i-1][j] != '#'){
        if(sides[i][j][3]==1)fill(0,255,255);
        vertex(i*boxSize, j*boxSize, 0,0,0);
        vertex(i*boxSize,(j+1)*boxSize,0,img.width,0);
        vertex(i*boxSize,(j+1)*boxSize,boxSize,img.width,img.height);
        vertex((i)*boxSize,j*boxSize,boxSize,0,img.height);
        }
        fill(12*j+15,12*i+15,255);
        if(j == LAB_SIZE-1 ||labyrinthe[i][j+1] != '#'){
         if(sides[i][j][2]==1)fill(255,0,0);
        vertex(i*boxSize, (j+1)*boxSize, 0,0,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,0,img.width,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,boxSize,img.width,img.height);
        vertex(i*boxSize,(j+1)*boxSize,boxSize,0,img.height);
        }
        fill(12*j+15,12*i+15,255);
       if(j == 0 || labyrinthe[i][j-1] != '#'){
         if(sides[i][j][1]==1)fill(0,255,0);
        vertex(i*boxSize, (j)*boxSize, 0,0,0);
        vertex((i+1)*boxSize,(j)*boxSize,0,img.width,0);
        vertex((i+1)*boxSize,(j)*boxSize,boxSize,img.width,img.height);
        vertex(i*boxSize,(j)*boxSize,boxSize,0,img.height);
       }
       fill(12*j+15,12*i+15,255);
       if ( i == LAB_SIZE-1 || labyrinthe[i+1][j] != '#'){
         if(sides[i][j][0]==1)fill(0,0,255);
        vertex((i+1)*boxSize, (j)*boxSize, 0,0,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,0,img.width,0);
        vertex((i+1)*boxSize,(j+1)*boxSize,boxSize,img.width,img.height);
        vertex((i+1)*boxSize,(j)*boxSize,boxSize,0,img.height);
       }
       stroke(0);
      }
      else{
        noTexture();
        fill(128,128,128);
        vertex((i)*boxSize, (j)*boxSize, boxSize);
        vertex((i+1)*boxSize,(j)*boxSize,boxSize);
        vertex((i+1)*boxSize,(j+1)*boxSize,boxSize);
        vertex((i)*boxSize,(j+1)*boxSize,boxSize);
      }
    }
  }
  endShape();
}

void keyPressed() {
  if (anim == 0 && rotate==0){
    if(posY+dirY <21 && posX+dirX<21){
      if (keyCode == UP && labyrinthe[(int)(posX + dirX)][(int)(posY + dirY)] != '#') {
        anim = 20;
        posX += dirX;
        posY += dirY;
      }
      else if(keyCode == RIGHT){
        rotate = 20;
        oldDirX = dirX;
        oldDirY = dirY;
        int tmp = -dirX;
        dirX = dirY;
        dirY = tmp;
      }
      else if(keyCode == LEFT){
        rotate = 20;
        oldDirX = dirX;
        oldDirY = dirY;
        int tmp = -dirY;
        dirY = dirX;
        dirX= tmp;
      }
    }
  }
}


float cosh(float x){
  return (exp(x) + exp(-x)) / 2.0;
}

void advance_cam(int boxSize){
  camera(boxSize*0.5+(posX)*boxSize-anim/20*dirX*boxSize,boxSize*0.5+posY*boxSize-anim/20*dirY*boxSize,1.2*boxSize*1/(cosh(0.4*(anim/10-1))-(cosh(0.4)-1)),
  (dirX+posX)*boxSize+boxSize*0.5,boxSize*0.5 +(dirY+posY)*boxSize,boxSize*1.2,0,0,1);
  //camera(boxSize*0.5+posX*boxSize,boxSize*0.5+posY*boxSize,boxSize*1.2,(dirX+posX)*boxSize+boxSize*0.5,boxSize*0.5 +(dirY+posY)*boxSize,boxSize*1.2,0,0,1);
}
void rotate_cam(int boxSize){
  //camera(boxSize*0.5+posX*boxSize,boxSize*0.5+posY*boxSize,boxSize*1.2,(dirX+posX)*boxSize+boxSize*0.5,boxSize*0.5 +(dirY+posY)*boxSize,boxSize*1.2,0,0,1);
  camera(boxSize*0.5+posX*boxSize,boxSize*0.5+posY*boxSize,boxSize*1.2,
  (oldDirX+(dirX-oldDirX)*(20-rotate)/20+posX)*boxSize+boxSize*0.5,boxSize*0.5 +(oldDirY+(dirY-oldDirY)*(20-rotate)/20+posY)*boxSize,boxSize*1.2,0,0,1);
}

void update_sides(){
  if (posX == 0){
  sides[posX][posY][4]=1;
  sides[posX][posY+1][4]=1;
  sides[posX+1][posY+1][4]=1;
  sides[posX+1][posY][4]=1;
  sides[posX+1][posY-1][4]=1;
  sides[posX][posY][4]=1;
  }
  else if(posY == LAB_SIZE-1){
   sides[posX][posY][4]=1;
  sides[posX-1][posY][4]=1;
  sides[posX+1][posY][4]=1;
  sides[posX+1][posY-1][4]=1;
  sides[posX-1][posY-1][4]=1;
  sides[posX][posY-1][4]=1;
  }
  else{
  sides[posX][posY][4]=1;
  sides[posX][posY+1][4]=1;
  sides[posX][posY-1][4]=1;
  sides[posX+1][posY][4]=1;
  sides[posX+1][posY-1][4]=1;
  sides[posX+1][posY+1][4]=1;
  sides[posX-1][posY-1][4]=1;
  sides[posX-1][posY][4]=1;
  sides[posX-1][posY+1][4]=1;
  }
}
void draw(){
  background(255,255,255);
  update_sides();
  pushMatrix();
   int boxSize= 40;
   float fov = PI/3.0;
   float cameraZ = (height/2.0) / tan(fov/2.0);
   camera(boxSize*0.5+posX*boxSize,boxSize*0.5+posY*boxSize,boxSize*1.2,(dirX+posX)*boxSize+boxSize*0.5,boxSize*0.5 +(dirY+posY)*boxSize,boxSize*1.2,0,0,1);
   if(rotate>0){ 
     rotate_cam(boxSize);
     rotate --;
   }
   else if(anim>0){
     advance_cam(boxSize);
     anim--;
   }
   lightFalloff(0.03,0.01,0.001);
   //pointLight(255,255,255,boxSize*0.5+posX*boxSize,boxSize*0.5+posY*boxSize,boxSize*1.2);
   pointLight(255,255,255,boxSize*0.5+(posX)*boxSize-anim/20*dirX*boxSize,boxSize*0.5+posY*boxSize-anim/20*dirY*boxSize,1.2*boxSize);
   perspective(PI/1.3,width*1.2/height, 0.5, 10*cameraZ);
   draw_laby_my_way(boxSize);
   translate(0,0,boxSize);
   draw_laby_my_way2(boxSize);
  popMatrix();
  noLights();
  //translate(510,-250,0);
  translate(610,-150,0);
  rotateZ(PI);
  // on peut decommenter le premier translate et commenter
  //le deuxieme avec rotateZ pour avoir la mini map de lexo. c'est juste que
  //d'autre preferent la map transposee.
  ortho(0, width, 0, height, -1000, 1000); 
  draw_with_box(5);
}
