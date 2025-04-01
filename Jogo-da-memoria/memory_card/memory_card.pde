import processing.sound.*;


SoundFile acertoSound;
SoundFile erroSound;
SoundFile musicaMenu;
PImage[] catImages = new PImage[10]; 
int[] indicesCartas = new int[20];   
PImage[] cardBacks;                  
boolean[] cardFlipped;               
boolean[] cardMatched;               
int firstCard = -1;                  
int secondCard = -1;                 
int tentativas = 0;                  
int acertos = 0;                     
int estadoJogo = 0;                  
int[] records = new int[10];         
PFont font;                          


int tempoVirada = 1000;              
int tempoUltimaVirada = 0;           
boolean esperandoParaDesvirar = false; 

void setup() {
  size(800, 600);
  surface.setTitle("Memória de Gato");
  
  
  try {
    acertoSound = new SoundFile(this, "acerto.wav");
    erroSound = new SoundFile(this, "erro.wav");
    musicaMenu = new SoundFile(this, "menuSound.wav");
    musicaMenu.loop();
  } catch (Exception e) {
    println("Erro ao carregar sons: " + e.getMessage());
  }
  

  font = createFont("Arial", 24);
  textFont(font);
  

  for (int i = 0; i < records.length; i++) {
    records[i] = 999; 
  }
  
  
  for (int i = 0; i < 10; i++) {
    catImages[i] = loadImage("imagem" + (i+1) + ".jpg");
    catImages[i].resize(100, 100); 
  }
  
 
  prepararJogo();
}

void prepararJogo() {
  
  cardBacks = new PImage[20];
  for (int i = 0; i < 20; i++) {
    cardBacks[i] = createImage(100, 100, RGB);
    cardBacks[i].loadPixels();
    for (int j = 0; j < cardBacks[i].pixels.length; j++) {
      cardBacks[i].pixels[j] = color(random(100, 200), random(100, 200), random(100, 200));
    }
    cardBacks[i].updatePixels();
  }
  
  
  cardFlipped = new boolean[20];
  cardMatched = new boolean[20];
  for (int i = 0; i < 20; i++) {
    cardFlipped[i] = false;
    cardMatched[i] = false;
  }
  
  
  tentativas = 0;
  acertos = 0;
  firstCard = -1;
  secondCard = -1;
  esperandoParaDesvirar = false;
  
  
  embaralharCartas();
}

void embaralharCartas() {
  
  for (int i = 0; i < 10; i++) {
    indicesCartas[i] = i;
    indicesCartas[i+10] = i;
  }
  
  
  for (int i = indicesCartas.length - 1; i > 0; i--) {
    int j = (int)random(i + 1);
    
    int temp = indicesCartas[i];
    indicesCartas[i] = indicesCartas[j];
    indicesCartas[j] = temp;
  }
}

void draw() {
  background(220);
  
  
  if (esperandoParaDesvirar && millis() - tempoUltimaVirada > tempoVirada) {
    cardFlipped[firstCard] = false;
    cardFlipped[secondCard] = false;
    firstCard = -1;
    secondCard = -1;
    esperandoParaDesvirar = false;
  }
  
  
  if (estadoJogo == 0 && musicaMenu != null && !musicaMenu.isPlaying()) {
    musicaMenu.loop();
  } else if (estadoJogo != 0 && musicaMenu != null && musicaMenu.isPlaying()) {
    musicaMenu.stop();
  }
  
  
  switch(estadoJogo) {
    case 0: desenharMenu(); break;
    case 1: desenharJogo(); break;
    case 2: desenharRecords(); break;
  }
}

void desenharMenu() {
 
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Memória de Gato", width/2, 100);
  
 
  fill(100, 100, 255);
  rect(width/2 - 100, 200, 200, 50, 10);
  fill(255);
  textSize(32);
  text("Novo Jogo", width/2, 225);
  

  fill(100, 255, 100);
  rect(width/2 - 100, 280, 200, 50, 10);
  fill(255);
  text("Records", width/2, 305);
  

  fill(255, 100, 100);
  rect(width/2 - 100, 360, 200, 50, 10);
  fill(255);
  text("Sair", width/2, 385);
}

void desenharJogo() {

  for (int i = 0; i < 20; i++) {
    int x = 50 + (i % 5) * 120; 
    int y = 100 + (i / 5) * 120; 
    
    if (cardMatched[i]) {
   
      tint(255, 150);
      image(catImages[indicesCartas[i]], x, y, 100, 100);
      noTint();
    } else if (cardFlipped[i]) {
   
      image(catImages[indicesCartas[i]], x, y, 100, 100);
    } else {
    
      image(cardBacks[i], x, y, 100, 100);
    }
    

    stroke(0);
    noFill();
    rect(x, y, 100, 100);
  }
  

  fill(0);
  textSize(24);
  textAlign(LEFT);
  text("Tentativas: " + tentativas, 50, 80);
  text("Acertos: " + acertos + "/10", 300, 80);
  

  fill(255, 100, 100);
  rect(width - 150, 30, 120, 40, 5);
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Menu", width - 90, 50);
}

void desenharRecords() {

  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Melhores Recordes", width/2, 80);
  

  textSize(24);
  for (int i = 0; i < records.length; i++) {
    if (records[i] != 999) {
      text((i+1) + ". " + records[i] + " tentativas", width/2, 150 + i * 30);
    } else {
      text((i+1) + ". ---", width/2, 150 + i * 30);
    }
  }
  

  fill(100, 100, 255);
  rect(width/2 - 60, 500, 120, 40, 5);
  fill(255);
  textSize(20);
  text("Voltar", width/2, 520);
}

void mousePressed() {
  switch(estadoJogo) {
    case 0: verificarCliqueMenu(); break;
    case 1: verificarCliqueJogo(); break;
    case 2: verificarCliqueRecords(); break;
  }
}

void verificarCliqueMenu() {

  if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
      mouseY > 200 && mouseY < 250) {
    estadoJogo = 1;
    prepararJogo();
  }
  

  if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
      mouseY > 280 && mouseY < 330) {
    estadoJogo = 2;
  }
  

  if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
      mouseY > 360 && mouseY < 410) {
    exit();
  }
}

void verificarCliqueJogo() {

  if (mouseX > width - 150 && mouseX < width - 30 &&
      mouseY > 30 && mouseY < 70) {
    estadoJogo = 0;
    return;
  }
  
  if (esperandoParaDesvirar) {
    return;
  }
  

  for (int i = 0; i < 20; i++) {
    int x = 50 + (i % 5) * 120;
    int y = 100 + (i / 5) * 120;
    
    if (mouseX > x && mouseX < x + 100 &&
        mouseY > y && mouseY < y + 100 &&
        !cardMatched[i] && !cardFlipped[i]) {
      
    
      if (acertoSound != null && acertoSound.isPlaying()) acertoSound.stop();
      if (erroSound != null && erroSound.isPlaying()) erroSound.stop();
      
      cardFlipped[i] = true;
      
      if (firstCard == -1) {
        firstCard = i;
      } else {
        secondCard = i;
        tentativas++;
        

        if (indicesCartas[firstCard] == indicesCartas[secondCard]) {
          if (acertoSound != null) acertoSound.play();
          cardMatched[firstCard] = true;
          cardMatched[secondCard] = true;
          acertos++;
          
          firstCard = -1;
          secondCard = -1;
          

          if (acertos == 10) {
            adicionarRecord(tentativas);
            delay(1000);
            estadoJogo = 0;
          }
        } else {
          if (erroSound != null) erroSound.play();
          esperandoParaDesvirar = true;
          tempoUltimaVirada = millis();
        }
      }
      break;
    }
  }
}

void verificarCliqueRecords() {

  if (mouseX > width/2 - 60 && mouseX < width/2 + 60 &&
      mouseY > 500 && mouseY < 540) {
    estadoJogo = 0;
  }
}

void adicionarRecord(int tentativas) {
  
  for (int i = 0; i < records.length; i++) {
    if (tentativas < records[i] || records[i] == 999) {

      for (int j = records.length - 1; j > i; j--) {
        records[j] = records[j-1];
      }
      records[i] = tentativas;
      break;
    }
  }
}
