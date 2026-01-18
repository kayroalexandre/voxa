
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { gemini15Flash, Part } = require("@genkit-ai/googleai");
const { generate } = require("@genkit-ai/ai");
const { z } = require("zod");

initializeApp();

exports.enhanceText = onCall(
  {
    enforceAppCheck: true, // Optional: Enforce App Check
  },
  async (request) => {
    // 1. Authentication Check
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated."
      );
    }

    // 2. Input Validation
    const dataSchema = z.object({
      text: z.string().min(1),
    });

    const validation = dataSchema.safeParse(request.data);
    if (!validation.success) {
      throw new HttpsError(
        "invalid-argument",
        "The function must be called with a non-empty 'text' argument."
      );
    }

    const { text } = validation.data;

    // 3. AI Processing with GenKit
    try {
      const prompt = `Your task is to correct and improve a given text.
        Focus on fixing grammar, spelling, punctuation, and improving the overall fluency.
        It is absolutely critical that you preserve 100% of the original meaning and tone.
        Do NOT summarize the text.
        Do NOT add any new information, content, or ideas.
        The user's original text is: "${text}"`;

      const response = await generate({
        model: gemini15Flash,
        prompt: prompt,
      });

      const enhancedText = response.text();

      // 4. Return successful response
      return { enhancedText };
    } catch (error) {
      console.error("Error calling Gemini API:", error);
      throw new HttpsError(
        "internal",
        "An error occurred while enhancing the text."
      );
    }
  }
);

