#include <iostream>
#include <string>
#include <thread>
#include <chrono>
#include <cstdlib>
#include <iomanip>
#include <sstream>

#ifdef _WIN32
#include <windows.h>
#endif

// Function to set text color to green
void setGreenText() {
    #ifdef _WIN32
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hConsole, FOREGROUND_GREEN);
    #else
    std::cout << "\033[32m";
    #endif
}

// Function to print text with animation
void animatedPrint(const std::string& text, int delay_ms = 5) {
    for (char c : text) {
        std::cout << c << std::flush;
        std::this_thread::sleep_for(std::chrono::milliseconds(delay_ms));
    }
    std::cout << std::endl;
}

// ASCII Art for SCiPnet logo
const std::string SCIPNET_LOGO = R"(
       _____ _______ ____             __ 
      / ___// ____(_) __ \____  ___  / /_
      \__ \/ /   / / /_/ / __ \/ _ \/ __/
     ___/ / /___/ / ____/ / / /  __/ /_  
    /____/\____/_/_/   /_/ /_/\___/\__/  
)";

void processCommand(const std::string& command) {
    if (command == "help") {
        animatedPrint("\nAvailable commands:");
        animatedPrint("help     - Show this help message");
        animatedPrint("clear    - Clear the screen");
        animatedPrint("exit     - Exit the terminal");
        animatedPrint("status   - Show system status");
        animatedPrint("rs <num> - Show SCP link for the specified SCP number");
    }
    else if (command == "clear") {
        #ifdef _WIN32
        system("cls");
        #else
        system("clear");
        #endif
    }
    else if (command == "status") {
        animatedPrint("[INFO] System Status:");
        animatedPrint("[INFO] All systems operational");
        animatedPrint("[INFO] Security protocols active");
        animatedPrint("[INFO] Network connection: Stable");
    }
    else if (command.rfind("rs ", 0) == 0) { // Check if command starts with "rs "
        std::string scpNumber = command.substr(3); // Extract the SCP number
        try {
            int num = std::stoi(scpNumber); // Convert to integer
            std::stringstream ss;
            ss << std::setw(3) << std::setfill('0') << num; // Format as 3-digit with leading zeros
            std::string formattedNumber = ss.str();
            std::string url = "http://fondationscp.wikidot.com/scp-" + formattedNumber;
            animatedPrint("Link: " + url);
        } catch (const std::invalid_argument&) {
            animatedPrint("Invalid SCP number format: " + scpNumber);
        } catch (const std::out_of_range&) {
            animatedPrint("SCP number out of range: " + scpNumber);
        }
    }
    else if (command != "exit") {
        animatedPrint("Unknown command: " + command);
        animatedPrint("Type 'help' for available commands.");
    }
}

int main() {
    // Set console to green text
    setGreenText();

    // Login process
    std::string username, password;
    
    animatedPrint("Login: ");
    std::getline(std::cin, username);
    
    animatedPrint("Password: ");
    std::getline(std::cin, password);

    if (username != "Hartmann" || password != "demission") {
        animatedPrint("[ERROR] Invalid credentials.");
        return 1;
    }

    // Clear screen after successful login
    #ifdef _WIN32
    system("cls");
    #else
    system("clear");
    #endif

    // Welcome sequence
    animatedPrint("[INFO] Welcome to SCiPnet Terminal v5.213.0.9");
    animatedPrint("[INFO] Loading system protocols...");
    animatedPrint("[INFO] Verifying credentials...");
    animatedPrint("[INFO] Access Granted.");
    std::cout << std::endl;

    // Display logo
    animatedPrint(SCIPNET_LOGO);
    std::cout << std::endl;

    animatedPrint("[INFO] Bienvenue, Superviseur Hartmann.");
    animatedPrint("[INFO] Faite help.");

    // Command loop
    std::string command;
    while (true) {
        std::cout << "\n> ";
        std::getline(std::cin, command);
        
        if (command == "exit") {
            animatedPrint("[INFO] Terminating session...");
            break;
        }
        
        processCommand(command);
    }

    return 0;
}
