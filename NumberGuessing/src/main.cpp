#include <iostream>
#include <cstdlib>
#include <ctime>

int main() {
    // Seed the random number generator
    std::srand(static_cast<unsigned int>(std::time(0)));

    // Generate a random number between 1 and 100
    int numberToGuess = std::rand() % 100 + 1;
    int playerGuess = 0;
    int numberOfTries = 0;

    std::cout << "Welcome to the Number Guessing Game!\n";
    std::cout << "I have selected a number between 1 and 100. Can you guess it?\n";

    // Loop until the player guesses the correct number
    while (playerGuess != numberToGuess) {
        std::cout << "Enter your guess: ";
        std::cin >> playerGuess;
        numberOfTries++;

        // Provide feedback to the player
        if (playerGuess < numberToGuess) {
            std::cout << "Too low! Try again.\n";
        } else if (playerGuess > numberToGuess) {
            std::cout << "Too high! Try again.\n";
        } else {
            std::cout << "Congratulations! You've guessed the number " << numberToGuess
                      << " in " << numberOfTries << " tries!\n";
        }
    }

    return 0;
}
