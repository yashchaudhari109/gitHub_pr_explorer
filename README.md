GitHub Pull Request Viewer 🚀
<br>
A Flutter application built for a hiring assessment that displays the open pull requests of a specified GitHub repository using the GitHub REST API. The app features simulated user authentication, dynamic repository switching, and a clean, scalable architecture.
<br>
<p align="center">
<img src="httpspreviews/app-demo.gif" alt="App Demo GIF" width="300"/>
</p>

🎥 Demo Video
Below is a demonstration of the app running on an Android emulator, showcasing its core features, bonus functionalities, and responsive UI.
<p align="center">
<a href="">
<!-- Replace this with a thumbnail image of your video -->
<img src="httpspreviews/video-thumbnail.png" alt="Watch the video" width="600"/>
</a>
<br>
<strong><a href="">Watch the Demo Video</a></strong>
</p>

✨ Key Features<br>
- View Open Pull Requests: Fetches and displays a list of all open PRs from a public GitHub repository.<br>
- Detailed PR View: Tap on any PR to see its full description with clickable links.<br>
- Simulated Authentication: A dummy login screen that demonstrates secure token handling using shared_preferences.<br>
- Dynamic Repository Switching: An "Edit" button that allows the user to change the target repository (owner/repo) in real-time.<br>
- Robust Error Handling: Handles various scenarios like invalid repository names, no internet connection, or API rate limits gracefully.<br>
- Modern UI/UX: Features a shimmer loading effect, pull-to-refresh, and a "Retry" option on failure.<br>

🛠️ Tech Stack & Architecture
<table>
<tr>
<td align="center"><strong>Framework</strong></td>
<td align="center"><strong>State Management</strong></td>
<td align="center"><strong>Architecture</strong></td>
<td align="center"><strong>Navigation</strong></td>
</tr>
<tr>
<td align="center">Flutter</td>
<td align="center">BLoC</td>
<td align="center">MVVM-inspired</td>
<td align="center">go_router</td>
</tr>
<tr>
<td align="center"><strong>API Calls</strong></td>
<td align="center"><strong>Dependency Injection</strong></td>
<td align="center"><strong>Local Storage</strong></td>
<td align="center"><strong>UI Helpers</strong></td>
</tr>
<tr>
<td align="center">http</td>
<td align="center">get_it</td>
<td align="center">shared_preferences</td>
<td align="center">flutter_linkify & url_launcher</td>
</tr>
</table>
<p align="center">
<img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter Badge"/>
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Badge"/>
<img src="https://img.shields.io/badge/BLoC-45A6F5?style=for-the-badge&logo=c&logoColor=white" alt="BLoC Badge"/>
</p>

📁 Project Structure <br>
The project follows a feature-first, modular structure to ensure scalability and separation of concerns.
code
Code
lib/
|-- app/                # Root of the application (MaterialApp, Router, etc.)
|-- core/               # Shared code: API clients, DI, error handling, themes
|   |-- api/
|   |-- di/
|   |-- error/
|-- features/           # Contains all the distinct features of the app
|   |-- auth/           # Authentication feature (Bloc, Data, View)
|   |-- pull_requests/  # Pull Request feature (Bloc, Data, View)
|-- main.dart           # App entry point


🔐 Token Handling Explained <br>
- The application simulates a login flow to demonstrate secure token handling, as requested in the bonus requirements.<br>
- Login Screen: On first launch, the user is presented with a dummy login screen.<br>
- Token Generation: Pressing the "LOGIN" button generates a hardcoded fake token (e.g., "abc123...").<br>
- Secure Storage: This fake token is securely stored on the device's local storage using the shared_preferences package.<br>
- State Management: The AuthBloc manages the authentication state. On successful login, it emits an AuthAuthenticated state.<br>
- Navigation Control: The go_router is configured to listen to the AuthBloc's state stream. If the state is AuthAuthenticated, it automatically redirects the user to the pull request list. If not, it shows the login screen.<br>
- Token Display: On the pull request screen, the stored token is retrieved and displayed at the top to confirm that the login state is being correctly read and persisted across app sessions.<br>

🌟 Bonus Features Implemented <br>
 - Simulated Token Storage: Implemented using shared_preferences.<br>
 - Pull to Refresh: The PR list can be refreshed by swiping down.<br>
 - Retry on Failure: A "Retry" button appears if the API call fails.<br>
 - Responsive Layout: The UI is built with widgets that adapt to different screen sizes.<br>
 - Dark Mode: The app is ready for a dark theme (foundation laid in app_theme.dart).<br>
 - Shimmer Loading: A shimmer animation is shown while fetching data for a better user experience.<br>
 - Dynamic Repository Changer: (Self-implemented bonus) An "Edit" button allows users to fetch PRs from any public repository.<br>
 - Detailed Error Handling: Specific, user-friendly error messages for different failure scenarios (e.g., "Repository Not Found").<br>
 - Detailed PR View with Clickable Links: Users can tap a PR to view its full body, with all links being automatically detected and launchable in a browser.<br>

🐞 Known Issues or Limitations <br>
- No Tests: Widget or unit tests have not been implemented for this assignment.<br>
- Limited Tablet Optimization: While the layout is responsive, it is not specifically optimized with a multi-column layout for tablet devices.<br>
- Fake Token: As per the assignment, the token is a simulation and does not provide access to private repositories.<br>