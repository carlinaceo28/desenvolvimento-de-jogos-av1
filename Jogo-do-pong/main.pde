int modoSelecionado = -1;
int dificuldadeSelecionada = -1;

float ballX, ballY;
float ballSpeedX, ballSpeedY;
float ballSize = 20;
float velocidadeInicialX, velocidadeInicialY;

float paddleWidth = 15, paddleHeight;
float playerX = 20, playerY;
float enemyX, enemyY;
float enemySpeed;

int playerScore = 0;
int enemyScore = 0;
int scoreLimit = 5;

boolean gameOver = false;
String winner = "";

int tempoUltimoReset;
int intervaloAumento = 5000;

int velocidadePlayer = 10;

void setup() {
  size(800, 400);
  textAlign(CENTER, CENTER);
  textSize(32);
}

void draw() {
  background(0);

  if (modoSelecionado == -1) {
    mostrarMenuModo();
    return;
  }

  if (modoSelecionado == 1 && dificuldadeSelecionada == -1) {
    mostrarMenuDificuldade();
    return;
  }

  if (gameOver) {
    fill(255);
    text("Vencedor: " + winner, width / 2, height / 2 - 20);
    text("Pressione R para reiniciar", width / 2, height / 2 + 30);
    return;
  }

  if (millis() - tempoUltimoReset > intervaloAumento) {
    ballSpeedX *= 1.2;
    ballSpeedY *= 1.2;
    tempoUltimoReset = millis();
  }

  fill(255);
  ellipse(ballX, ballY, ballSize, ballSize);
  rect(playerX, playerY, paddleWidth, paddleHeight);
  rect(enemyX, enemyY, paddleWidth, paddleHeight);
  text(playerScore + " : " + enemyScore, width / 2, 30);

  ballX += ballSpeedX;
  ballY += ballSpeedY;

  if (ballY < 0 || ballY > height - ballSize) {
    ballSpeedY *= -1;
  }

  if (ballX < playerX + paddleWidth && ballY > playerY && ballY < playerY + paddleHeight) {
    ballSpeedX *= -1;
    ballX = playerX + paddleWidth;
  }

  if (ballX > enemyX - ballSize && ballY > enemyY && ballY < enemyY + paddleHeight) {
    ballSpeedX *= -1;
    ballX = enemyX - ballSize;
  }

  if (ballX < 0) {
    enemyScore++;
    checkWinner();
    resetBall(true);
  }

  if (ballX > width) {
    playerScore++;
    checkWinner();
    resetBall(true);
  }

  if (modoSelecionado == 1) {
    if (ballY > enemyY + paddleHeight / 2) {
      enemyY += enemySpeed;
    } else {
      enemyY -= enemySpeed;
    }
    enemyY = constrain(enemyY, 0, height - paddleHeight);
  }
  
  handlePlayerMovement();
}

void mostrarMenuModo() {
  fill(255);
  text("Selecione o modo de jogo:", width / 2, 100);
  text("1 - Jogar contra IA", width / 2, 150);
  text("2 - Dois jogadores", width / 2, 200);
}

void mostrarMenuDificuldade() {
  fill(255);
  text("Selecione a dificuldade:", width / 2, 100);
  text("1 - Fácil   2 - Médio   3 - Difícil", width / 2, 150);
}

void escolherDificuldade(int nivel) {
  if (nivel == 1) {
    paddleHeight = 120;
    velocidadeInicialX = 3;
    velocidadeInicialY = 2;
    enemySpeed = 2;
  } else if (nivel == 2) {
    paddleHeight = 80;
    velocidadeInicialX = 5;
    velocidadeInicialY = 3;
    enemySpeed = 4;
  } else if (nivel == 3) {
    paddleHeight = 60;
    velocidadeInicialX = 7;
    velocidadeInicialY = 4;
    enemySpeed = 6;
  }

  iniciarJogo();
  dificuldadeSelecionada = nivel;
}

void iniciarJogo() {
  ballX = width / 2;
  ballY = height / 2;
  playerY = height / 2 - paddleHeight / 2;
  enemyX = width - playerX - paddleWidth;
  enemyY = height / 2 - paddleHeight / 2;
  resetBall(false);
}

void resetBall(boolean reiniciarVelocidade) {
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = velocidadeInicialX * (random(1) > 0.5 ? 1 : -1);
  ballSpeedY = random(-velocidadeInicialY, velocidadeInicialY);

  if (reiniciarVelocidade) {
    tempoUltimoReset = millis(); // zera o tempo de contagem de aumento
  }
}

void checkWinner() {
  if (playerScore >= scoreLimit) {
    gameOver = true;
    winner = "Jogador 1";
  } else if (enemyScore >= scoreLimit) {
    winner = (modoSelecionado == 2) ? "Jogador 2" : "Inimigo";
    gameOver = true;
  }
}

void handlePlayerMovement() {
  if (!keyPressed) return;
  if (key == 'w' || key == 'W') {
    playerY -= velocidadePlayer;
  } else if (key == 's' || key == 'S') {
    playerY += velocidadePlayer;
  }
  playerY = constrain(playerY, 0, height - paddleHeight);
  
  if (modoSelecionado == 2) {
    if (keyCode == UP) {
      enemyY -= velocidadePlayer;
    } else if (keyCode == DOWN) {
      enemyY += velocidadePlayer;
    }
    enemyY = constrain(enemyY, 0, height - paddleHeight);
  }
}

void keyPressed() {
  if (modoSelecionado == -1) {
    if (key == '1') modoSelecionado = 1;
    else if (key == '2') {
      modoSelecionado = 2;
      escolherDificuldade(2);
    }
    return;
  }

  if (modoSelecionado == 1 && dificuldadeSelecionada == -1) {
    if (key == '1') escolherDificuldade(1);
    else if (key == '2') escolherDificuldade(2);
    else if (key == '3') escolherDificuldade(3);
    return;
  }

  if (modoSelecionado == 2) {
    if (keyCode == UP) {
      enemyY -= 20;
    } else if (keyCode == DOWN) {
      enemyY += 20;
    }
    enemyY = constrain(enemyY, 0, height - paddleHeight);
  }

  if (gameOver && (key == 'r' || key == 'R')) {
    playerScore = 0;
    enemyScore = 0;
    gameOver = false;
    winner = "";
    resetBall(true);
  }
}
