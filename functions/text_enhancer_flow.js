const { core, firebase, googleAI } = require("genkit");
const { z } = require("zod");

core.init({
  plugins: [firebase(), googleAI()],
  logLevel: "debug",
  enableTracingAndMetrics: true,
});

const textEnhancerPrompt = `You are a text enhancement assistant. Your task is to correct grammar and improve the fluency of the given text, while preserving its original meaning. Do not add any new content or summarize the text. Just return the enhanced text.`;

exports.textEnhancerFlow = core.defineFlow(
  {
    name: "textEnhancerFlow",
    inputSchema: z.object({
      text: z.string(),
      userId: z.string(),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    const { text } = input;

    const llmResponse = await core.generate({
      model: "gemini-1.5-flash",
      prompt: `${textEnhancerPrompt}\n\n${text}`,
    });

    return llmResponse.text();
  }
);
