import java.util.ArrayList;
import java.util.List;
import java.util.Collections;
import processing.sound.SoundFile;

Game game;
SoundFile music;
boolean playing;
int current_speech = 0;
int MAX_SPEECHES = 5;

void setup() {
  size(640, 480);
  game = new Game();
  playing = false;
  music = new SoundFile(this, "ost.mp3");
  music.loop();
  music.amp(0.2);
}

void draw() {
  background(125);
  fill(0);
  
  if (!playing) {
    textSize(24);
    String text = "";
    switch (current_speech) {
    case 0:
      text = "Era uma vem um jovem chamado\nJoel que estava tranquilamente\nem sua casa...";
      break;
    case 1:
      text = "Ele estava cansado de\nficar tanto tempo sem fazer\nnada em sua casa...";
      break;
    case 2:
      text = "Então resolveu sair para dar uma volta,\naté que DE REPENTE...";
      break;
    case 3:
      text = "Um aligenígena do mal maligno apareceu!!!\nOh não, e agora???";
      break;
    case 4:
      text = "Ele está tentando se comunicar...????";
      break;
    case 5:
      text = "Ele quer que você adivinhe o número entre 1 e 100.";
      break;
    }

    text_centered(text);
  }
  if (playing) game.draw();
}

void keyPressed() {
  if (playing) game.keyPressed();
  if (!playing && ++current_speech > MAX_SPEECHES) {
    playing = true;
  }
}

private void text_centered(String text) {
  float text_width = textWidth(text);
  text(text, (width / 2) - (text_width / 2), (height / 2));
}
