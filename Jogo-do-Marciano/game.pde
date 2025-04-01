import java.util.Random;

int MAX_NUMBER = 100;
int MAX_GUESSES = 10;

class Game {
  Random random;
  int secret_number = -1;
  int guesses = 0;
  int current_guess = 0;
  int last_guess = 0;
  boolean guessed = false;
  boolean game_over = false;
  List<Integer> best_guesses = new ArrayList<Integer>();

  Game() {
    random = new Random();
    this.generate_random_number();
  }

  public void draw() {
    if (guessed) {
      print_victory_prompt();
      return;
    }

    if (game_over) {
      print_game_over_prompt();
      return;
    }

    if (guesses > 0) {
      textSize(24);
      text("Tentativa: " + guesses, 20, 40);
    }

    if (last_guess != 0) {
      int offset = 15;
      print_centered_text("Tentativa anterior: " + last_guess, offset);
      print_guessed_number_status(-offset);
    }

    print_guess_prompt();
    print_best_guesses();
  }

  public void keyPressed() {
    int x = key - '0';
    if (x > -1 && x < 10) append_input(x);
    if (key == BACKSPACE) pop_number();
    if (key == ENTER) try_guess();
  }

  private void print_best_guesses() {
    int size = best_guesses.size();
    if (size == 0) return;

    float x = 20;
    int gap = 10;

    text("Melhores tentativas:", x, height - 35);

    for (int guess : best_guesses) {
      String guess_str = String.valueOf(guess);
      text(guess_str, x, height - 10);
      x += textWidth(guess_str) + gap;

      stroke(5);
      line(x, height - 25, x, height - 5);
      stroke(1);

      x += gap;
    }
  }

  private void print_victory_prompt() {
    int offset = 15;
    print_centered_text("Você venceu! O número era: " + secret_number, -offset);
    print_centered_text("Você conseguiu em " + guesses + " tentativas.", offset);

    print_centered_text("Pressione \"Enter\" para jogar novamente.", height / 2 - 20);
  }

  private void print_game_over_prompt() {
    int offset = 15;
    print_centered_text("Você peruderu! O número era: " + secret_number, -offset);
    print_centered_text("Você atingiu o número máximo de " + MAX_GUESSES + " tentativas.", offset);

    print_centered_text("Pressione \"Enter\" para jogar novamente.", height / 2 - 20);
  }

  private void print_guess_prompt() {
    float y = height * 0.75;
    String guess_number_prompt = "Digite sua tentativa: ";
    textSize(20);
    text(guess_number_prompt, 20, y);
    float prompt_width = textWidth(guess_number_prompt);

    if (current_guess != 0) {
      text(current_guess, int(prompt_width) + 40, y);
    }

    String confirm_text = "Pressione \"Enter\" para confirmar!";
    float confirm_text_width = textWidth(confirm_text);
    text(confirm_text, width - confirm_text_width - 20, y);
  }

  private void print_guessed_number_status(int y_offset) {
    String text = "";

    if (last_guess > secret_number) text = "Muito alto!";
    else if (last_guess < secret_number) text = "Muito baixo!";

    print_centered_text(text, y_offset);
  }

  private void append_input(int x) {
    int new_guess = (current_guess * 10) + x;
    if (new_guess > MAX_NUMBER) return;
    current_guess = new_guess;
  }

  private void pop_number() {
    current_guess /= 10;
  }

  private void try_guess() {
    if (current_guess == 0) return;
    guesses++;

    if (guessed || game_over) {
      guessed = false;
      game_over = false;
      current_guess = 0;
      guesses = 0;
      last_guess = 0;
      generate_random_number();
    }
    
    if (guesses > MAX_GUESSES) {
      game_over = true;
      return; 
    }

    if (current_guess == secret_number) {
      guessed = true;
      best_guesses.add(guesses);
      Collections.sort(best_guesses);
      return;
    }

    last_guess = current_guess;
    current_guess = 0;
  }

  private void print_centered_text(String text, int y_offset) {
    float text_width = textWidth(text);
    text(text, (width / 2) - (text_width / 2), (height / 2) + y_offset);
  }

  private void generate_random_number() {
    secret_number = random.nextInt(MAX_NUMBER) + 1;
  }
}
