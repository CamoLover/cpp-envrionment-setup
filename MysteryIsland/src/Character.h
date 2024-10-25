// Character.h
#ifndef CHARACTER_H
#define CHARACTER_H

#include <string>
#include <vector>

class Character {
protected:
    std::string name;
    int health;
    int maxHealth;

public:
    Character(const std::string& name, int health, int maxHealth);
    
    virtual ~Character() = default;
    
    int getHealth() const;
    int getMaxHealth() const;
    std::string getName() const;
    
    void takeDamage(int amount);
    void heal(int amount);
    bool isAlive() const;
    
    virtual void display() const = 0;
};

// Player class
class Player : public Character {
private:
    std::vector<std::string> inventory;

public:
    Player(const std::string& name, int health, int maxHealth);
    
    void addToInventory(const std::string& item);
    void showInventory() const;
    
    void display() const override;
};

// Enemy class
class Enemy : public Character {
public:
    Enemy(const std::string& name, int health, int maxHealth);
    void display() const override;
};

#endif
