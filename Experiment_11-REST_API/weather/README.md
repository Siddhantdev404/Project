☀️ Flutter Weather Forecast App (New Delhi, India)

This project is a mobile application built using Flutter (Dart) that demonstrates the fundamental principles of consuming a Public REST API, following a clean, layered architecture, and managing application states (Loading, Success, Error).

The application meets all the core objectives outlined in the project requirements, including a focus on code quality and robust error handling.

✨ Project Goals and Requirements

This app was developed to satisfy the following core requirements from the assignment:

Objective: Fetch data from a Public REST API and display the results in a scrollable list.

API Used: Open-Meteo API (a Public, RESTful service).

Location: Currently fetching a 7-day forecast for New Delhi, India.

State Management: Must handle and display Loading, Success, Empty, and Error states.

Data Flow: Must implement a clear, layered architecture.

📐 Architecture and Data Flow

The app rigorously follows the UI → View Model → Repository → API data flow pattern to ensure clean separation of concerns and maintainability.

Layer

Component

Responsibility

UI (View)

WeatherScreen & ForecastCard

Renders the interface, displays current state, and handles user input (e.g., refresh).

View Model

WeatherViewModel

Manages the UI state (loading, error, success) and contains the logic for presentation. Uses ChangeNotifier to update the UI.

Repository

WeatherRepository

Acts as the data source. Client interface used here (package:http). Fetches raw JSON and handles API-level errors.

Data Models

ForecastItem & WeatherCondition

Parses raw JSON into structured, type-safe Dart objects (JSON is parsed).

🛠️ Technical Implementation Details

API Consumption

Client: package:http (Dart's recommended HTTP client for Flutter).

Method: HTTP GET request is used to retrieve data from the public endpoint.

No Blocking: All network calls (await _repository.fetchForecast()) are performed asynchronously to ensure no blocking on the main thread.

Robust Error Handling

The application demonstrates full error lifecycle management:

Network Errors: Uses a try-catch block for http.ClientException to specifically handle "No Internet" or "Airplane Mode" scenarios.

API Errors: Checks HTTP status codes (4xx, 5xx) and throws custom DomainError exceptions for user-friendly messages.

Data Validation: Includes checks for empty data or malformed JSON (FormatException).

⚙️ How to Run the App (Local Setup)

To run this project locally, you need the Flutter SDK and VS Code/Android Studio.

Create Project: Run flutter create <project_name> in your terminal.

Dependencies: Ensure the http package is in your pubspec.yaml file:

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0




OUTPUT VIDEO:
https://drive.google.com/drive/folders/13avfQyHTI9yrMiPsmaJKWdt-_SBuiv3Y?usp=drive_link