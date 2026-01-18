const { https } = require("firebase-functions");
const { initializeApp } = require("firebase-admin/app");
const { defineFlow, configureGenkit } = require("@genkit-ai/core");
const { firebase } = require("@genkit-ai/firebase");
const { googleAI } = require("@genkit-ai/googleai");
const { z } = require("zod");

// Initialize Firebase Admin SDK
initializeApp();

// Configure Genkit
configureGenkit({
  plugins: [
    firebase(),
    googleAI(),
  ],
  logLevel: "debug",
  enableTracingAndMetrics: true,
});

// Define the Genkit flow for text enhancement
const enhanceTextFlow = defineFlow(
  {
    name: "enhanceTextFlow",
    inputSchema: z.string(),
    outputSchema: z.string(),
  },
  async (rawText) => {
    const llm = googleAI("gemini-1.5-flash");

    const prompt = `
      Você é um especialista em língua portuguesa do Brasil.
      Sua tarefa é corrigir o texto a seguir, que é a transcrição de um áudio.

      REGRAS DE CORREÇÃO:
      1.  **Correção Completa:** Corrija gramática, pontuação, concordância, ortografia e melhore a fluidez.
      2.  **Preservação Total:** NÃO altere o sentido, a intenção, o tom ou a personalidade do texto original. O resultado deve ser a mesma mensagem, apenas escrita corretamente.
      3.  **Sem Adições ou Remoções:** NÃO adicione informações que não estavam presentes e NÃO remova nenhuma parte do conteúdo original.
      4.  **Fidelidade ao Estilo:** Mantenha o estilo da fala, seja ele formal ou informal.

      TEXTO BRUTO PARA CORRIGIR:
      "${rawText}"

      RETORNE APENAS O TEXTO CORRIGIDO E NADA MAIS.
    `;

    const result = await llm.generate({ prompt });
    return result.text();
  }
);

// Define the HTTPS Cloud Function that wraps the Genkit flow
exports.enhanceText = https.onCall(async (data) => {
  // Validate input
  if (!data.text || typeof data.text !== 'string') {
    throw new https.HttpsError('invalid-argument', 'The function must be called with one argument "text" containing the text to enhance.');
  }

  try {
    // Run the Genkit flow
    const enhancedText = await enhanceTextFlow.run(data.text);
    return { enhancedText };
  } catch (error) {
    console.error("Error during text enhancement:", error);
    throw new https.HttpsError('internal', 'An error occurred while enhancing the text.');
  }
});
