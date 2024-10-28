#include <iostream>
#include <string>
#include <thread>
#include <chrono>
#include <cstdlib>
#include <iomanip>
#include <sstream>
#include <fstream>

#ifdef _WIN32
#include <windows.h>
#include <shellapi.h>
#endif

// Function to set text color to green
void setGreenText() {
    #ifdef _WIN32
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hConsole, FOREGROUND_GREEN);
    #else
    std::cout << "\033[32m";  // ANSI escape code for green text
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

// Function to display help information
void showHelp() {
    animatedPrint("\nAvailable commands:");
    animatedPrint("help           - Show this help message");
    animatedPrint("clear          - Clear the screen");
    animatedPrint("rs <num>      - Show SCP link for the specified SCP number");
    animatedPrint("pixeleur       - Open Pixeleur website");
    animatedPrint("log <message>  - Log a message to the system log");
    animatedPrint("status         - Check system status");
    animatedPrint("exit           - Exit the terminal");
}

// Function to clear the console screen
void clearScreen() {
    #ifdef _WIN32
    system("cls");
    #else
    system("clear");
    #endif
}

// Function to open the Pixeleur website
void openPixeleur() {
    animatedPrint("[INFO] Opening the Pixeleur website...");
    ShellExecute(0, 0, "http://www.pixeleur.fr", 0, 0 , SW_SHOW );
}

// Function to log messages
void logMessage(const std::string& message) {
    std::ofstream logFile("system.log", std::ios::app);
    if (logFile.is_open()) {
        logFile << message << std::endl;
        animatedPrint("[INFO] Message logged: " + message);
    } else {
        animatedPrint("[ERROR] Unable to open log file.");
    }
}

// Function to check system status
void checkStatus() {
    animatedPrint("[INFO] Checking system status...");
    // Simulated status check
    std::this_thread::sleep_for(std::chrono::seconds(1));
    animatedPrint("[STATUS] All systems operational.");
}

// Function to process user commands
void processCommand(const std::string& command) {
    if (command == "help") {
        showHelp();
    } else if (command == "clear") {
        clearScreen();
    } else if (command == "pixeleur") {
        openPixeleur();
    } else if (command.rfind("rs ", 0) == 0) { // Check if command starts with "rs "
        std::string scpNumber = command.substr(3); // Extract the SCP number
        try {
            int num = std::stoi(scpNumber); // Convert to integer
            std::stringstream ss;
            ss << std::setw(3) << std::setfill('0') << num; // Format as 3-digit with leading zeros
            std::string formattedNumber = ss.str();
            std::string url = "http://fondationscp.wikidot.com/scp-" + formattedNumber;
            animatedPrint("Link: " + url);
        } catch (const std::invalid_argument&) {
            animatedPrint("[ERROR] Invalid SCP number format: " + scpNumber);
        } catch (const std::out_of_range&) {
            animatedPrint("[ERROR] SCP number out of range: " + scpNumber);
        }
    } else if (command.rfind("log ", 0) == 0) { // Check if command starts with "log "
        std::string message = command.substr(4); // Extract the message
        logMessage(message);
    } else if (command == "status") {
        checkStatus();
    } else if (command != "exit") {
        animatedPrint("[ERROR] Unknown command: " + command);
        animatedPrint("Type 'help' for available commands.");
    }
}

// Function for user login
bool login() {
    std::string username, password;
    std::cout << "Login: " << std::flush;
    std::getline(std::cin, username);
    
    std::cout << "Password: " << std::flush;
    std::getline(std::cin, password);

    if (username != "Hartmann" || password != "demission") {
        animatedPrint("[ERROR] Invalid credentials.");
        return false;
    }
    return true;
}

int main() {
    setGreenText();  // Set console to green text

    // Login process
    if (!login()) {
        return 1; // Exit if login fails
    }

    clearScreen(); // Clear screen after successful login

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
    animatedPrint("[INFO] Vous avez [2] nouveaux messages.");
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
