# Translator

A multi-language translation application built with Flutter. This app allows users to translate text between various languages, view translation history, and see detailed match results for translated segments.

## Features

*   **Real-time Translation**: Utilizes the MyMemory Translation API to provide quick and accurate translations.
*   **Multi-Language Support**: Supports a wide range of languages, including English, Arabic, French, German, Spanish, and more.
*   **Language Swapping**: Easily swap the source and target languages with a single tap.
*   **Local History**: All translations are saved locally on the device using Hive, allowing for offline access to past translations.
*   **Segment Matching**: Displays a list of matched words and segments from the translation result.
*   **Similar Translations**: Suggests similar translations from your history based on partial text matches.
*   **Clear History**: Option to clear all saved translation history.

## Tech Stack & Architecture

*   **Framework**: Flutter
*   **State Management**: GetX
*   **Networking**: Dio
*   **Local Storage**: Hive
*   **Translation API**: [MyMemory Translated API](https://mymemory.translated.net/doc/spec.php)
*   **Architecture**: The project follows a clean architecture pattern, separating UI (pages and widgets), business logic (controllers), and data handling (services and models).

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/mhmdashraf11/translator.git
    cd translator
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Run the Hive code generator:**
    This step is necessary to generate the `TypeAdapter` for the Hive database models.
    ```sh
    flutter packages pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```sh
    flutter run
    ```

## Project Structure

The project's code is organized within the `lib` directory, following a feature-first approach.

```
lib/
├── app/
│   ├── bindings/       # GetX bindings for dependency injection
│   ├── controllers/    # Business logic and state management (HomeController)
│   ├── data/
│   │   ├── models/     # Data models for API responses and local storage (Hive)
│   │   └── services/   # Services for API communication (TranslateService)
│   ├── pages/          # Main screens of the application (Home)
│   └── widgets/        # Reusable UI components used across the app
├── common/             # Shared styles and utilities
└── main.dart           # Application entry point and Hive initialization
