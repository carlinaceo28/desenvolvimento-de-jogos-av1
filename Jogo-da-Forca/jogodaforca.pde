String[] palavras = {"PROCESSING", "JAVA", "GRAFICOS", "JOGO", "ANIMACAO", "AJUDA", "BOLO", "LOJA", "TELHADO", "FACULDADE", "PROJETO","RATO"};
String palavraEscolhida;
char[] palavraOculta;
boolean[] letrasCorretas;
int erros = 0;
char[] tentativas = new char[26];
int numTentativas = 0;
boolean fimDeJogo = false;

void setup() {
  size(500, 500);
  textSize(32);
  escolherPalavra();
}

void escolherPalavra() {
  palavraEscolhida = palavras[int(random(palavras.length))];
  palavraOculta = new char[palavraEscolhida.length()];
  letrasCorretas = new boolean[palavraEscolhida.length()];
  tentativas = new char[26];
  numTentativas = 0;
  erros = 0;
  fimDeJogo = false;
  
  for (int i = 0; i < palavraOculta.length; i++) {
    palavraOculta[i] = '_';
  }
  loop(); // Garante que o jogo continue caso tenha parado
}

void draw() {
  background(255);
  desenharForca();
  exibirPalavra();
  exibirTentativas();
  verificarVitoria();
}

void desenharForca() {
  stroke(0);
  line(100, 400, 200, 400); // Base
  line(150, 400, 150, 100); // Poste
  line(150, 100, 250, 100); // Haste superior
  line(250, 100, 250, 130); // Corda

  if (erros > 0) ellipse(250, 150, 40, 40); // Cabeça
  if (erros > 1) line(250, 170, 250, 250); // Corpo
  if (erros > 2) line(250, 190, 230, 220); // Braço esquerdo
  if (erros > 3) line(250, 190, 270, 220); // Braço direito
  if (erros > 4) line(250, 250, 230, 280); // Perna esquerda
  if (erros > 5) line(250, 250, 270, 280); // Perna direita
}

void exibirPalavra() {
  fill(0);
  textAlign(CENTER);
  text(new String(palavraOculta), width / 2, 450);
}

void exibirTentativas() {
  fill(0);
  textSize(16);
  textAlign(LEFT);
  String letras = "Tentativas: ";
  for (int i = 0; i < numTentativas; i++) {
    letras += tentativas[i] + " ";
  }
  text(letras, 10, 480);
}

void keyPressed() {
  if (fimDeJogo) {
    escolherPalavra(); // Reinicia o jogo se estiver finalizado
    return;
  }

  char letra = Character.toUpperCase(key);
  if (letra >= 'A' && letra <= 'Z') {
    if (!tentativaJaFeita(letra)) {
      tentativas[numTentativas++] = letra;
      verificarLetra(letra);
    }
  }
}

boolean tentativaJaFeita(char letra) {
  for (int i = 0; i < numTentativas; i++) {
    if (tentativas[i] == letra) return true;
  }
  return false;
}

void verificarLetra(char letra) {
  boolean acertou = false;
  for (int i = 0; i < palavraEscolhida.length(); i++) {
    if (palavraEscolhida.charAt(i) == letra) {
      palavraOculta[i] = letra;
      letrasCorretas[i] = true;
      acertou = true;
    }
  }
  if (!acertou) erros++;
}

void verificarVitoria() {
  if (erros >= 6) {
    fill(255, 0, 0);
    textAlign(CENTER);
    text("Você perdeu! A palavra era " + palavraEscolhida, width / 2, 50);
    fimDeJogo = true;
    noLoop();
  }
  boolean venceu = true;
  for (boolean letraCorreta : letrasCorretas) { 
    if (!letraCorreta) {
      venceu = false;
      break;
    }
  }
  if (venceu) {
    fill(0, 255, 0);
    textAlign(CENTER);
    text("Parabéns! Você venceu!", width / 2, 50);
    fimDeJogo = true;
    noLoop();
  }
}
