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
*   **AI Text Enhancement:** Improve the grammar and fluency of text using AI.

## Architecture

The application follows a feature-based architecture, with each core feature encapsulated in its own directory. This modular approach promotes code organization, maintainability, and scalability.

### Authentication

*   **`auth_service.dart`:** Handles user authentication logic, including sign-up, sign-in, and sign-out, using Firebase Authentication.
*   **`auth_screen.dart`:** Provides the user interface for authentication, allowing users to either log in or create a new account.

### AI

*   **`ai_service.dart`:** Interacts with a generative AI model to provide summarization and text enhancement capabilities for mind maps.

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

## AI Architecture (GenKit + Gemini)

The AI capabilities of Voxa are powered by a combination of Cloud Functions for Firebase, GenKit, and the Gemini API. This architecture provides a secure, scalable, and maintainable solution for integrating generative AI into the application.

*   **Cloud Functions:** A Cloud Function, `enhanceText`, is used to expose the AI functionality to the Flutter application. This function is an `onCall` function, which means it can only be called by authenticated users.

*   **GenKit:** GenKit is used to orchestrate the AI flow. A `textEnhancerFlow` is defined to handle the interaction with the Gemini API. This flow takes a string of text as input, sends it to the Gemini API for processing, and returns the enhanced text.

*   **Gemini API:** The Gemini API is used to perform the actual text enhancement. A specific prompt is used to instruct the model to correct grammar and improve fluency without altering the original meaning of the text.

## State Management

The application utilizes the `provider` package for state management, allowing for a clear separation of concerns between the UI and the underlying business logic. Services are provided to the widget tree, making them accessible to any widget that needs them.

## Error Handling

Structured logging is implemented throughout the application using the `dart:developer` library. This provides detailed and informative error messages, making it easier to debug and troubleshoot issues during development.

## Current Plan: ETAPA 21 — Arquitetura de IA do Voxa (GenKit + Gemini)

**Objective:**
Set up the AI foundation for Voxa using Cloud Functions for Firebase, GenKit, and the Gemini model, without yet processing actual audio.

**Scope:**
- AI Infrastructure
- Orchestration via Cloud Functions
- Integration with Gemini
- No UI changes
- No audio recording

1. **Cloud Functions**
- Initialize Cloud Functions in the Firebase project.
- Use Node.js (recommended version by Firebase).
- Structure functions by responsibility.

2. **GenKit**
- Configure GenKit within the Cloud Functions environment.
- Create an initial flow.
- No complex logic in this step.

3. **Gemini Integration**
- Integrate the Gemini API via GenKit.
- Create a base prompt for:
  - grammatical correction
  - fluency improvement
  - preservation of the original meaning
- Do not add new content.
- Do not summarize yet.

4. **Initial Flow (Mandatory)**
Create a flow that receives:
- `text` (string)
- `userId` (string)

Processing:
- Send raw text to Gemini.
- Receive enhanced text.
- Return only the corrected text.

5. **App Integration**
- Flutter calls the Cloud Function.
- No direct calls to the Gemini API from the app.
- The Cloud Function returns the result.

6. **Security**
- The Cloud Function can only be called by authenticated users.
- Validate `request.auth.uid`.
- Never trust `userId` coming from the client.

## Next Steps

*   Implement a more robust error handling strategy to gracefully handle network errors and other potential issues.
*   Add the ability to edit existing notes, journals, and mind maps.
*   Enhance the mind map feature with more advanced functionality, such as the ability to create connections between nodes.
*   Improve the UI/UX of the application to provide a more intuitive and user-friendly experience.
*   Integrate the AI text enhancement feature into the UI.
*   Process audio and use the AI to transcribe and enhance it.
*   Automatically create mind maps from text.
*   Generate summaries of notes and journals.
*   Automatically persist data.
*   Create multiple flows for different AI tasks.
