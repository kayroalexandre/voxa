
# Voxa Application Blueprint

## Overview

Voxa is a Flutter-based mobile application designed to streamline the process of capturing, organizing, and summarizing ideas. The app provides a comprehensive suite of tools for creating notes, journals, and mind maps, with a focus on voice-to-text input and AI-powered summarization.

## Core Features

*   **Authentication:** Secure user authentication using Firebase Authentication.
*   **Notes:** Create and manage text-based notes.
*   **Journals:** Maintain a personal journal with timestamped entries.
*   **Mind Maps:** Visually organize ideas with mind maps, including the ability to attach files.
*   **Speech-to-Text:** Utilize the device's microphone to transcribe spoken words into text for notes and journals.
*   **AI Summarization:** Leverage the power of AI to generate concise summaries of mind maps.

## Architecture

The application follows a feature-based architecture, with each core feature encapsulated in its own directory. This modular approach promotes code organization, maintainability, and scalability.

### Authentication

*   **`auth_service.dart`:** Handles user authentication logic, including sign-up, sign-in, and sign-out, using Firebase Authentication.
*   **`auth_screen.dart`:** Provides the user interface for authentication, allowing users to either log in or create a new account.

### AI

*   **`ai_service.dart`:** Interacts with a generative AI model to provide summarization capabilities for mind maps.

### Journals

*   **`journal_model.dart`:** Defines the data structure for a journal entry.
*   **`journal_service.dart`:** Manages CRUD (Create, Read, Update, Delete) operations for journals, interacting with the Firestore database.

### Mind Maps

*   **`mind_map_model.dart`:** Defines the data structure for a mind map, including nodes and attached files.
*   **`mind_map_service.dart`:** Manages CRUD operations for mind maps and handles file uploads to Firebase Storage.

### Notes

*   **`note_model.dart`:** Defines the data structure for a note.
*   **`note_service.dart`:** Manages CRUD operations for notes.

### Speech

*   **`speech_service.dart`:** Provides a service for converting speech to text using the `speech_to_text` package.

### Storage

*   **`storage_service.dart`:** Manages file uploads and downloads with Firebase Storage.

## State Management

The application utilizes the `provider` package for state management, allowing for a clear separation of concerns between the UI and the underlying business logic. Services are provided to the widget tree, making them accessible to any widget that needs them.

## Error Handling

Structured logging is implemented throughout the application using the `dart:developer` library. This provides detailed and informative error messages, making it easier to debug and troubleshoot issues during development.

## Next Steps

*   Implement a more robust error handling strategy to gracefully handle network errors and other potential issues.
*   Add the ability to edit existing notes, journals, and mind maps.
*   Enhance the mind map feature with more advanced functionality, such as the ability to create connections between nodes.
*   Improve the UI/UX of the application to provide a more intuitive and user-friendly experience.
