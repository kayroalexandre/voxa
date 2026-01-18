
# Voxa AI Architecture Blueprint

## Overview

This document outlines the architecture of the Voxa application, a mobile app that leverages AI to provide voice-to-text transcription, text enhancement, and mind map generation.

## Style and Design

The application will follow modern design principles, with a focus on a clean, intuitive user interface. It will be responsive and adapt to different screen sizes. The color palette, typography, and iconography will be carefully chosen to create a visually appealing and user-friendly experience.

## Architecture

The Voxa application follows a strict client-server architecture. The Flutter application acts as the client, responsible for the user interface and user experience. The Firebase backend, consisting of Cloud Functions, GenKit, and Gemini, is responsible for all AI-powered features.

### Frontend (Flutter)

*   The Flutter application is **only a client**.
*   It **does not** contain any AI-related logic or dependencies.
*   It **only** calls Cloud Functions for any AI-powered features.

### Backend (Firebase)

*   All AI logic is handled exclusively in the backend.
*   Cloud Functions are used to orchestrate the AI workflows.
*   GenKit is used to define and manage the AI flows.
*   The Gemini model is used for all generative AI tasks.

## Features

### Implemented

*   **AI-Powered Text Enhancement:** Users can input text and have it enhanced by an AI model. The model corrects grammar, improves fluency, and preserves the original meaning of the text. This is implemented using a GenKit flow with the Gemini 1.5 Flash model, orchestrated by a Firebase Cloud Function.
*   **Secure Authentication:** All AI-powered features require user authentication. The Cloud Function that handles text enhancement verifies that the user is authenticated before processing the request.

### Planned

*   **Voice-to-Text Transcription:** Users will be able to record their voice and have it transcribed into text.
*   **Mind Map Generation:** The app will automatically generate mind maps from transcribed text.
*   **Data Persistence:** Transcriptions, enhanced text, and mind maps will be saved to a database.

## Current Task: AI Architecture Correction

### Plan

1.  **Correct `AiService`:** Rewrite the `lib/features/ai/ai_service.dart` file to remove all AI-related logic and dependencies, and ensure it only calls the `enhanceText` Cloud Function.
2.  **Correct `pubspec.yaml`:** Remove the invalid `firebase_ai` dependency from the `pubspec.yaml` file.
3.  **Run `flutter pub get`:** Update the project's dependencies.
4.  **Verify Backend:** Review the `functions/index.js` and `functions/text_enhancer_flow.js` files to ensure they are correctly set up to handle requests from the Flutter application.
5.  **Update `blueprint.md`:** Update the `blueprint.md` file to reflect the corrected architecture.
