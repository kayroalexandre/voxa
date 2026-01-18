/**
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const { onCall } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");

initializeApp();

const { textEnhancerFlow } = require("./text_enhancer_flow");

exports.enhanceText = onCall({ region: "us-central1" }, async (request) => {
  if (!request.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }

  const { text } = request.data;
  const userId = request.auth.uid;

  try {
    const enhancedText = await textEnhancerFlow.run({
      text,
      userId,
    });

    return { enhancedText };
  } catch (error) {
    console.error("Error enhancing text:", error);
    throw new functions.https.HttpsError(
      "internal",
      "An error occurred while enhancing the text."
    );
  }
});
