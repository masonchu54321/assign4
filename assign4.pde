//object pic
PImage hpImage, fighterImage, enemyImage, treasureImage;

//background pic
PImage start1Image, start2Image, bg1Image, bg2Image, end1Image, end2Image;

//position var
int x_fighter, y_fighter, x_hpRect,x_treasure, y_treasure, x_bg1, x_bg2;
int numEnemy = 5;
int [] x_enemy = new int [numEnemy];
int [] y_enemy = new int [numEnemy];

//pressed
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//state
final int STATE_START = 0, STATE_PLAYING = 1, STATE_END = 2;
int state = STATE_START;

//arraies
final int ARRAY_1 = 0, ARRAY_2 = 1, ARRAY_3 = 2;
int array = ARRAY_1;

//
int speed_fighter = 2;
final int full_hp = 206;
float x, y;
int spacingX = 50, spacingY =50;



//pic properties
final int height_trease = 41, width_trease = 41;
final int height_fighter = 51, width_fighter = 51;
final int height_enemy = 61, width_enemy = 61;

void setup () {
  size(640,480) ;
  
  //input pic
  hpImage = loadImage("img/hp.png");
  fighterImage = loadImage("img/fighter.png");
  enemyImage = loadImage("img/enemy.png");
  treasureImage = loadImage("img/treasure.png");
  bg1Image = loadImage("img/bg1.png");
  bg2Image = loadImage("img/bg2.png");
  start1Image = loadImage("img/start1.png");
  start2Image = loadImage("img/start2.png");
  end1Image = loadImage("img/end1.png");
  end2Image = loadImage("img/end2.png");
  


  
  //position var
  x_fighter = 590;
  y_fighter = 243;
  x_hpRect = 46;
  x_treasure = floor(random(150,580));
  y_treasure = floor(random(35,435));
  for (int i = 0; i <numEnemy; i++){
    x_enemy[i] = - (i+1) * spacingX;
  }
  y_enemy[0] = floor(random(35,417));
  rectMode(CORNERS);
  x_bg1 = 0;
  
}

void draw() {
  switch(state){
    case STATE_START:
      image(start2Image,0,0);
      if(mouseX >= 205 && mouseX <= 455) {
        if(mouseY >= 374 && mouseY <= 415) {
          if(mousePressed) {
            state = STATE_PLAYING;
          } else {
            image(start1Image,0,0);
          }
        }
      }
      break;    
    case STATE_PLAYING:
      //background
      image(bg1Image,x_bg1 % (width*2) -width,0);
      image(bg2Image,(x_bg1+width) % (width*2) -width,0);
      x_bg1 += 1;
      
      //fighter
      image(fighterImage, x_fighter, y_fighter);
      image(treasureImage, x_treasure, y_treasure);
      
      //hp
      rect(5,3,x_hpRect,25);
      fill(255,0,0);
      image(hpImage,0,0);
      
      //enemies
      switch(array % 3){
        case ARRAY_1:
          for (int i = 0; i < numEnemy; i++){
            y_enemy[i] = y_enemy[0];
            image(enemyImage, x_enemy[i], y_enemy[i]);
          }
        break;
        case ARRAY_2:
          if( y_enemy[4] >= height) {
            y_enemy[0] = floor(random(35,height - 5 * spacingY));
          }
          for (int i = 0; i < numEnemy; i++){
            y_enemy[i] = y_enemy[0] + i * spacingY;
            image(enemyImage,x_enemy[i], y_enemy[i]);
          }
        break;
        case ARRAY_3:
          if( y_enemy[2] + spacingY >= height || y_enemy[2] - 2 * spacingY <= 35) {
            y_enemy[0] = floor(random(35 + 2 * spacingY,height - 3 * spacingY));
          }
          for (int i = 0; i < numEnemy; i++){
            if(i > 2){
              y_enemy[i] = y_enemy[0] -(i-4) * spacingY;
            } else{
            y_enemy[i] = y_enemy[0] + i * spacingY;
            }
            image(enemyImage,x_enemy[i], y_enemy[i]);
            image(enemyImage,x_enemy[i], y_enemy[i]);
          }
        
      }
      for (int i = 0; i <numEnemy; i++){
        x_enemy[i] +=3;
        if(x_enemy[numEnemy-1] >= width) {
          for (int j = 0; j <numEnemy; j++){
            x_enemy[j] = - (j+1) * spacingX;
          }
        y_enemy[0] = floor(random(35,417));
        array++;          
        }
      }

      
      //if(y_enemy + height_enemy/2 < y_fighter + height_fighter/2) {
        //y_enemy += 1;
      //}
      //if(y_enemy + height_enemy/2 > y_fighter + height_fighter/2) {
        //y_enemy -= 1;
      //}
      
      //fighter control
      if(upPressed) {y_fighter -= speed_fighter;}
      if(downPressed) {y_fighter += speed_fighter;}
      if(rightPressed) {x_fighter += speed_fighter;}
      if(leftPressed) {x_fighter -= speed_fighter;}
      
      // fighter boundary
      if(y_fighter <= 2) {
        y_fighter = 2;
      }
      if (y_fighter >= height-52) {
        y_fighter = height-52;
      }
      if(x_fighter <= 2) {
        x_fighter = 2;
      }
      if(x_fighter >= width-52) {
        x_fighter = width-52;
      }
      
      //get tresure
      if(x_fighter <= x_treasure + width_trease && x_fighter +width_fighter >= x_treasure) {
        if(y_fighter + height_fighter >= y_treasure && y_fighter <= y_treasure + height_fighter) {
          x_treasure = floor(random(150,580));
          y_treasure = floor(random(35,435));
          if(x_hpRect < full_hp) {
            x_hpRect += 20;
          }
        }
      }
      
      //crush 
      for (int i = 0; i <numEnemy; i++){
        if(x_fighter <= x_enemy[i] + width_enemy && x_fighter +width_fighter >= x_enemy[i]) {
          if(y_fighter + height_fighter/2 >= y_enemy[i] && y_fighter + height_fighter/2 <= y_enemy[i] + height_enemy) {
            //y_enemy = floor(random(35,417));
            if(x_hpRect > 6) {
              x_hpRect -= 40;
            }
          }
        }
      }
      
      if(x_hpRect <= 6) {
        state = STATE_END;
      }
      break;
    case STATE_END:
      image(end2Image,0,0);
      if(mouseX >= 205 && mouseX <= 438) {
        if(mouseY >= 306 && mouseY <= 349) {
          if(mousePressed) {
            state = STATE_START;
            x_hpRect = 46;
            x_fighter = 590;
            y_fighter = 243;
          } else {
            image(end1Image,0,0);
          }
        }
      }
      break;
  }
}
void keyPressed(){
  if(key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
    }
  }
}
void keyReleased(){
  if(key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
    }
  }

}
