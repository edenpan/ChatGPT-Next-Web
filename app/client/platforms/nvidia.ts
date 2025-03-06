import { LLMApi } from "../api";
import { ChatOptions, LLMModel, LLMUsage, SpeechOptions } from "../api";
import { getHeaders } from "../api";

export class NvidiaDeepSeekApi implements LLMApi {
  async chat(options: ChatOptions): Promise<void> {
    const messages = options.messages.map((v) => ({
      role: v.role,
      content: v.content,
    }));

    const requestPayload = {
      messages,
      model: options.config.model,
      temperature: options.config.temperature,
      top_p: options.config.top_p,
      max_tokens: 4096,
      stream: options.config.stream,
    };

    const controller = new AbortController();
    options.onController?.(controller);

    try {
      const chatPath = "/chat/completions";
      const response = await fetch(chatPath, {
        method: "POST",
        body: JSON.stringify(requestPayload),
        headers: getHeaders(),
        signal: controller.signal,
      });

      if (!response.ok) {
        console.error(response.statusText);
        throw new Error(response.statusText);
      }

      const streamReader = response.body?.getReader();
      let responseText = "";

      while (true) {
        const { done, value } = await streamReader!.read();
        if (done) break;

        const text = new TextDecoder().decode(value);
        responseText += text;
        options.onUpdate?.(responseText, text);
      }

      options.onFinish(responseText, response);
    } catch (e) {
      console.error("[Request] failed to make a chat request", e);
      options.onError?.(e as Error);
    }
  }

  async speech(options: SpeechOptions): Promise<ArrayBuffer> {
    throw new Error("Speech not implemented");
  }

  async usage(): Promise<LLMUsage> {
    return {
      used: 0,
      total: 0,
    };
  }

  async models(): Promise<LLMModel[]> {
    return [{
      name: "deepseek-ai/deepseek-r1",
      available: true,
      provider: {
        id: "nvidia",
        providerName: "Nvidia",
        providerType: "nvidia",
        sorted: 15,
      },
      sorted: 1500,
    }];
  }
} 