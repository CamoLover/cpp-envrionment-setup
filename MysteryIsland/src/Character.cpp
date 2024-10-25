// Character.cpp
#include "Character.h"
#include <iostream>

// Character base class
Character::Character(const std::string& name, int health, int maxHealth)
    : name(name), health(health), maxHealth(maxHealth) {}

int Character::getHealth() const {
    return health;
}

int Character::getMaxHealth() const {
    return maxHealth;
}

std::string Character::getName() const {
    return name;
}

void Character::takeDamage(int amount) {
    health -= amount;
    if (health < 0) health = 0;
}

void Character::heal(int amount) {
    health += amount;
    if (health > maxHealth) health = maxHealth;
}

bool Character::isAlive() const {
    return health > 0;
}

// Player class
Player::Player(const std::string& name, int health, int maxHealth)
    : Character(name, health, maxHealth) {}

void Player::addToInventory(const std::string& item) {
    inventory.push_back(item);
}

void Player::showInventory() const {
    std::cout << "------------------------\n";
    std::cout << "Inventaire :\n";
    for (const auto& item : inventory) {
        std::cout << "- " << item << "\n";
    }
    if (inventory.empty()) {
        std::cout << "Votre inventaire est vide.\n";
    }
    std::cout << "------------------------\n";
}

void Player::display() const {
    std::cout << "Joueur: " << name << ", PV: " << health << "/" << maxHealth << "\n";
}

// Enemy class
Enemy::Enemy(const std::string& name, int health, int maxHealth)
    : Character(name, health, maxHealth) {}

void Enemy::display() const {
    std::cout << "Ennemi: " << name << ", PV: " << health << "/" << maxHealth << "\n";
}
