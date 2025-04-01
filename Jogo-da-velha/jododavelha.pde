int[][] board = new int[3][3]; // Matriz do tabuleiro (0 = vazio, 1 = X, 2 = O)
int currentPlayer = 1;         // Jogador atual (1 = X, 2 = O)
boolean gameOver = false;      // Controla se o jogo terminou
boolean winnerFound = false;   // Indica se houve vencedor (para desenhar a linha vencedora)
int[] winnerLine = new int[4]; // [0] = tipo (0=horizontal, 1=vertical, 2=diagonal principal, 3=diagonal secundária)

// Variáveis para o placar
int player1Score = 0; // Placar do jogador 1
int player2Score = 0; // Placar do jogador 2

void setup() {
  size(300, 350); // Espaço extra para o botão de reiniciar
}

void draw() {
  background(255);
  
  // Desenha o placar no topo, com o ajuste para não cobrir o tabuleiro
  textSize(24);
  textAlign(CENTER, CENTER);
  fill(0);
  text("X: " + player1Score + "   O: " + player2Score, width / 2, 10); // Placar ajustado para y = 40
  
  stroke(0);
  strokeWeight(4);
  // Desenha as linhas do tabuleiro
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  
  textSize(64);
  textAlign(CENTER, CENTER);
  fill(0);
  // Desenha os símbolos no tabuleiro
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      int x = j * 100 + 50;
      int y = i * 100 + 50;
      if (board[i][j] == 1) {
        text("X", x, y);
      } else if (board[i][j] == 2) {
        text("O", x, y);
      }
    }
  }
  
  // Se o jogo acabou, exibe a linha vencedora ou mensagem de empate e o botão de reiniciar
  if (gameOver) {
    if (winnerFound) {
      stroke(255, 0, 0);
      strokeWeight(6);
      float startX = 0, startY = 0, endX = 0, endY = 0;
      if (winnerLine[0] == 0) { // Horizontal
        startX = 0;
        startY = winnerLine[2] * 100 + 50;
        endX = 300;
        endY = startY;
      } else if (winnerLine[0] == 1) { // Vertical
        startX = winnerLine[1] * 100 + 50;
        startY = 0;
        endX = startX;
        endY = 300;
      } else if (winnerLine[0] == 2) { // Diagonal principal
        startX = 0;
        startY = 0;
        endX = 300;
        endY = 300;
      } else if (winnerLine[0] == 3) { // Diagonal secundária
        startX = 300;
        startY = 0;
        endX = 0;
        endY = 300;
      }
      line(startX, startY, endX, endY);
    } else { // Se não houve vencedor, é empate
      fill(0);
      textSize(32);
      text("Empate!", width / 2, height / 2);
    }
    // Desenha o botão de reiniciar
    fill(200, 200, 255);
    rect(100, 310, 100, 30);
    fill(0);
    textSize(18);
    text("Reiniciar", 150, 325);
  }
}

void mousePressed() {
  // Se o jogo terminou, verifica se o clique foi no botão de reiniciar
  if (gameOver) {
    if (mouseX > 100 && mouseX < 200 && mouseY > 310 && mouseY < 340) {
      resetGame();
    }
    return;
  }
  
  int col = mouseX / 100;
  int row = mouseY / 100;
  
  if (row >= 0 && row < 3 && col >= 0 && col < 3 && board[row][col] == 0) {
    board[row][col] = currentPlayer;
    
    if (checkWinner(currentPlayer)) {
      gameOver = true;
      winnerFound = true;
      if (currentPlayer == 1) {
        player1Score++; // Incrementa o placar de X
      } else {
        player2Score++; // Incrementa o placar de O
      }
    } else if (checkDraw()) {
      gameOver = true;
      winnerFound = false;
    } else {
      currentPlayer = (currentPlayer == 1) ? 2 : 1;
    }
  }
}

boolean checkWinner(int player) {
  // Verifica linhas e colunas
  for (int i = 0; i < 3; i++) {
    if (board[i][0] == player && board[i][1] == player && board[i][2] == player) {
      winnerLine = new int[]{0, 0, i, 2}; // Linha horizontal
      return true;
    }
    if (board[0][i] == player && board[1][i] == player && board[2][i] == player) {
      winnerLine = new int[]{1, i, 0, 2}; // Linha vertical
      return true;
    }
  }
  
  // Verifica diagonais
  if (board[0][0] == player && board[1][1] == player && board[2][2] == player) {
    winnerLine = new int[]{2, 0, 0, 2}; // Diagonal principal
    return true;
  }
  if (board[0][2] == player && board[1][1] == player && board[2][0] == player) {
    winnerLine = new int[]{3, 2, 0, 0}; // Diagonal secundária
    return true;
  }
  return false;
}

boolean checkDraw() {
  // Se houver alguma casa vazia, não é empate
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        return false;
      }
    }
  }
  return true;
}

void resetGame() {
  board = new int[3][3];  // Limpa o tabuleiro
  currentPlayer = 1;       // Reinicia para o jogador 1
  gameOver = false;        // Reseta o estado do jogo
  winnerFound = false;     // Reseta a flag do vencedor
  winnerLine = new int[4]; // Limpa a linha vencedora
}
