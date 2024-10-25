// main.cpp
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <vector>
#include "Character.h"

void showIntro() {
    std::cout << "Bienvenue sur l'ile (lost ou quoi ?)\n";
    std::cout << "Vous vous retrouvez perdu sur une ile.\n";
    std::cout << "Vous pouvez explorer, et vos choix auront des consequences.\n";
    std::cout << "Trouverez-vous des tresors, echapperez-vous de cet endroit, ou allez-vous completement mourir ?\n\n";
}

Enemy generateRandomEnemy() {
    std::vector<Enemy> enemies = {
        Enemy("Sanglier", 30, 30),
        Enemy("Serpent", 20, 20),
        Enemy("Pirate", 40, 40),
        Enemy("Fantome", 50, 50)
    };

    int index = std::rand() % enemies.size();
    return enemies[index];
}

void exploreIsland(Player& player) {
    std::cout << "    __  ____      __                     ____     __                __\n";
    std::cout << "   /  |/  (_)____/ /____  _______  __   /  _/____/ /___ _____  ____/ /\n";
    std::cout << "  / /|_/ / / ___/ __/ _ \\/ ___/ / / /   / // ___/ / __ `/ __ \\/ __  / \n";
    std::cout << " / /  / / (__  ) /_/  __/ /  / /_/ /  _/ /(__  ) / /_/ / / / / /_/ /  \n";
    std::cout << "/_/  /_/_/____/\\__/\\___/_/   \\__, /  /___/____/_/\\__,_/_/ /_/\\__,_/   \n";
    std::cout << "                            /____/  \n";

    std::cout << "Vos choix :\n";
    std::cout << "1 - Explorer la foret\n";
    std::cout << "2 - Visiter la plage\n";
    std::cout << "3 - Monter la montagne\n";
    std::cout << "----------------------\n";
    std::cout << "4 - Inventaire\n";
    std::cout << "5 - Quitter\n";

    int choice;
    std::cin >> choice;

    switch (choice) {
        case 1: { // Explore la foret
            Enemy enemy = generateRandomEnemy();
            std::cout << "Vous rencontrez un " << enemy.getName() << " dans la foret!\n";
            enemy.display();
            player.takeDamage(10);
            std::cout << "Vous perdez 10PV, vous avez maintenant " << player.getHealth() << "\n";
            if (!player.isAlive()) {
                std::cout << "Vous etes mort. Game over!\n";
                exit(0);
            }
            break;
        }

        case 2: { // Visite la plage
            std::cout << "Vous voyez une plage magnifique et un coffre au tresor\n";
            std::cout << "Ouvrir le coffre ? (1 pour Oui, 2 pour Non): ";
            int openChest;
            std::cin >> openChest;
            if (openChest == 1) {
                std::cout << "Bravo! il y a une piece d'or!\n";
                player.addToInventory("Piece d'or");
            } else {
                std::cout << "Vous laisser le coffre\n";
            }
            break;
        }

        case 3: // Grimppe la montagne
            std::cout << "Vous grimper la montagne\n";
            player.heal(10);
            std::cout << "Vous gagner 10pv avec cette air frais, vous avez maintenant " << player.getHealth() << "\n";
            break;

        case 4: // Inventaire
            player.showInventory();
            break;

        case 5: // Quitte le jeu
            std::cout << "Et merci d'avoir jouer\n";
            exit(0);

        default:
            std::cout << "Invalide. Re-essayer\n";
            break;
    }
}

int main() {
    std::srand(static_cast<unsigned int>(std::time(0)));
    Player player("Joueur", 100, 100);

    showIntro();

    while (true) {
        exploreIsland(player);
    }

    return 0;
}
