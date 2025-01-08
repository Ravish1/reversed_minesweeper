

Reversed Minesweeper
Reversed Minesweeper is a unique twist on the classic Minesweeper game where the objective is to strategically place pieces on a grid while avoiding hidden bombs.

🕹 Features

🎮 Interactive Gameplay: Drag-and-drop mechanics for an engaging experience.

💣 Dynamic Bomb Animations: Bomb explosions and discoveries with animations.

🔑 Authentication Options:

Google Sign-In.

Guest Login.

📂 Persistent User Data: Stores user details using SharedPreferences.

⚙ Customizable Grid: Adjust the grid size via the app bar menu.

🎨 Beautiful Design:

Animated splash screen.

Stunning game-over UI with vibrant colors and animations.

🚀 Requirements

Before you can build and run the project, ensure you have the following installed:

Flutter SDK (version 3.5.4 or later).

Android Studio or any preferred IDE (e.g., VS Code).

Firebase CLI for Firebase setup.

Firebase Project:

Create a Firebase project.

Enable Google Sign-In under Authentication.

📋 Usage

🔐 Login Screen

Login with Google: Authenticate using your Google account.

Login as Guest: Play without signing in.

🎮 Gameplay

Drag and drop pieces to the grid.

Bombs are dynamically discovered or exploded periodically.

Change grid size using the menu in the app bar.

View your profile (Google login only) by tapping the profile icon.

💣 Game Over Screen

Displays the total number of bombs discovered.

A Play Again button allows you to restart the game.




🛠 Setup and Installation

Clone the repository:

bash

Copy code

git clone https://github.com/yourusername/reversed-minesweeper.git

cd reversed-minesweeper

Install dependencies:

bash

Copy code

flutter pub get

Configure Firebase:

Add your google-services.json file to android/app/.
Run the app:


bash

Copy code

flutter run

🎯 Troubleshooting

Common Issues

Firebase Errors:

Ensure google-services.json is correctly placed in android/app/.
Gradle Errors:

Run flutter clean and flutter pub get to refresh dependencies.
Flutter Errors:

Check your Flutter version using:
bash
Copy code
flutter doctor
Debugging
Use the following command to diagnose common issues:

bash
Copy code
flutter doctor




