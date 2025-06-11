import json
import logging
import time
from typing import Dict, Any, Optional, NamedTuple, List
from openai import AsyncAzureOpenAI
from openai.types.chat import (
    ChatCompletionMessageParam,
    ChatCompletionNamedToolChoiceParam,
    ChatCompletionToolParam,
    ChatCompletionSystemMessageParam,
    ChatCompletionUserMessageParam
)
from azure.ai.inference import ChatCompletionsClient
from azure.core.credentials import AzureKeyCredential
from app.config import get_settings

logger = logging.getLogger(__name__)
settings = get_settings()


class LLMResponse(NamedTuple):
    """Response structure with token usage information"""
    content: str
    prompt_tokens: int
    completion_tokens: int
    total_tokens: int
    model: str = "gpt-4.1-mini"


class AzureAIService:
    """Azure AI service supporting both OpenAI and AI Inference endpoints"""

    def __init__(self):
        self.settings = settings
        self.endpoint_type = self._determine_endpoint_type(settings.azure_openai_endpoint)
        logger.info(f"Detected Azure endpoint type: {self.endpoint_type}")

        # Initialize appropriate client based on endpoint type
        if self.endpoint_type == "openai":
            self.openai_client = AsyncAzureOpenAI(
                api_key=settings.azure_openai_api_key,
                api_version=settings.azure_openai_api_version,
                azure_endpoint=settings.azure_openai_endpoint
            )
            self.chat_client = None
        elif self.endpoint_type == "ai-inference":
            self.openai_client = None
            self.chat_client = ChatCompletionsClient(
                endpoint=settings.azure_openai_endpoint,
                credential=AzureKeyCredential(settings.azure_openai_api_key),
                api_version=settings.azure_openai_api_version
            )
        else:
            raise ValueError(f"Unsupported endpoint type: {self.endpoint_type}")

        # System prompts for different contexts
        self.system_prompts = {
            "workshop": """Du bist ein KI-Assistent, der Jugendlichen hilft, ihre eigene Website zu erstellen.
Verwende einfache, verständliche Sprache. Erkläre was du tust und warum.
Fördere Kreativität und Experimentierfreude. Sei geduldig und ermutigend.
Antworte immer auf Deutsch, es sei denn der Nutzer schreibt in einer anderen Sprache.""",

            "code_generation": """Du bist ein Experte für Webentwicklung und hilfst beim Erstellen von HTML, CSS und JavaScript Code.
WICHTIG - TECHNISCHE VORGABEN:
- Tailwind CSS und Alpine.js sind BEREITS über CDN eingebunden - füge NIEMALS diese Script/Link Tags hinzu:
  - KEIN <script src="https://cdn.tailwindcss.com"></script>
  - KEIN <script src="...alpinejs..."></script>
  - KEIN <link href="...tailwind...">
- Nutze Tailwind CSS Utility-Klassen für Styling (z.B. "text-blue-600", "bg-gray-100", "p-4", "rounded-lg")
- Nutze Alpine.js Direktiven für Interaktivität (z.B. x-data="{open: false}" x-show="open")
- Erstelle NUR den Body-Content, keine DOCTYPE, head, oder script-Tags für Bibliotheken
- Denke mit: Wenn der nutzer dich nach einem design fragt (z.B. "mach es schöner"), überlege erst den state. Beispiel: Wenn die Website am anfang steht, sucht der Nutzer nach einem Design, das er dann anpassen kann. Wenn er fortgeschritten ist, will er vielleicht nur noch kleine Anpassungen. 
Frage im Zweifelsfall!


CODE-REGELN:
- Schreibe sauberen, gut strukturierten Code
- Verwende moderne Best Practices, vermeide anti-patterns soweit möglich
- Erkläre in einfacher Sprache was du tust
- Erwähne welche Tailwind-Klassen du verwendest und was sie bewirken
- Stelle sicher, dass der Code sicher ist (keine eval, innerHTML mit User-Input)

FOLLOW-UP VORSCHLÄGE:
Nach jeder Änderung kannst du bis zu 3 passende Verbesserungsvorschläge machen.
Diese werden als klickbare Buttons angezeigt."""
        }

    def _determine_endpoint_type(self, endpoint: str) -> str:
        """Determine the type of Azure endpoint based on the URL pattern."""
        if not endpoint:
            return "unknown"

        # Azure OpenAI endpoint pattern (usually contains 'openai.azure.com' or 'cognitiveservices.azure.com')
        if 'openai.azure.com' in endpoint or 'cognitiveservices.azure.com' in endpoint:
            return "openai"

        # Azure AI Inference endpoint pattern (usually contains 'models' or services.ai.azure.com)
        if 'models.ai.azure.com' in endpoint or 'services.ai.azure.com' in endpoint:
            return "ai-inference"

        # Default to AI Inference for other patterns
        return "ai-inference"

    async def generate_response(
            self,
            prompt: str,
            current_code: Dict[str, str],
            context: str = "workshop",
            chat_history: Optional[List[ChatCompletionMessageParam]] = None
    ) -> tuple[LLMResponse, Dict[str, Any]]:
        """Generate AI response for user prompt"""
        start_time = time.time()

        if self.endpoint_type == "openai":
            return await self._generate_response_openai(prompt, current_code, context, chat_history, start_time)
        elif self.endpoint_type == "ai-inference":
            return await self._generate_response_ai_inference(prompt, current_code, context, chat_history, start_time)
        else:
            raise ValueError(f"Unsupported endpoint type: {self.endpoint_type}")

    async def _generate_response_openai(self, prompt: str, current_code: Dict[str, str],
                                        context: str, chat_history: Optional[List[ChatCompletionMessageParam]],
                                        start_time: float) -> tuple[LLMResponse, Dict[str, Any]]:
        """Generate response using Azure OpenAI SDK"""
        # Build messages
        messages: List[ChatCompletionMessageParam] = [
            ChatCompletionSystemMessageParam(
                role="system",
                content=self.system_prompts.get(context, self.system_prompts["workshop"])
            )
        ]

        # Add chat history if provided
        if chat_history:
            messages.extend(chat_history[-5:])  # Last 5 messages for context

        # Add current code context
        code_context = f"""
Aktueller Code der Website:

HTML:
```html
{current_code.get('html', '')}
```

CSS:
```css
{current_code.get('css', '')}
```

JavaScript:
```javascript
{current_code.get('js', '')}
```
"""

        # Add user message with code context
        messages.append(ChatCompletionUserMessageParam(
            role="user",
            content=f"{code_context}\n\nNutzer-Anfrage: {prompt}"
        ))

        # Define response format
        tools: List[ChatCompletionToolParam] = [{
            "type": "function",
            "function": {
                "name": "process_website_request",
                "description": "Process user's website modification request",
                # In azure_ai.py - erweiterte Tool-Definition
                "parameters": {
                    "type": "object",
                    "properties": {
                        "response_type": {
                            "type": "string",
                            "enum": ["chat", "update", "rewrite"],
                            "description": "Type of response"
                        },
                        "chat_message": {
                            "type": "string",
                            "description": "Message to show the user"
                        },
                        "updates": {
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "file": {"type": "string", "enum": ["html", "css", "js"]},
                                    "old_str": {"type": "string"},
                                    "new_str": {"type": "string"},
                                    "description": {"type": "string"}
                                },
                                "required": ["file", "old_str", "new_str"]
                            }
                        },
                        "new_code": {
                            "type": "object",
                            "properties": {
                                "html": {"type": "string"},
                                "css": {"type": "string"},
                                "js": {"type": "string"}
                            }
                        },
                        "explanation": {
                            "type": "string",
                            "description": "Technical explanation"
                        },
                        "follow_up_suggestions": {
                            "type": "array",
                            "maxItems": 3,
                            "items": {
                                "type": "object",
                                "properties": {
                                    "title": {
                                        "type": "string",
                                        "description": "Kurzer Button-Text (max 25 Zeichen)"
                                    },
                                    "prompt": {
                                        "type": "string",
                                        "description": "Der vollständige Prompt, der gesendet wird"
                                    },
                                    "icon": {
                                        "type": "string",
                                        "description": "Emoji für den Button"
                                    }
                                },
                                "required": ["title", "prompt", "icon"]
                            },
                            "description": "Vorschläge für nächste Schritte"
                        }
                    },
                    "required": ["response_type", "chat_message"]
                }
            }
        }]

        try:
            # Make API call using Azure OpenAI deployment
            response = await self.openai_client.chat.completions.create(
                model=self.settings.azure_openai_deployment,
                messages=messages,
                tools=tools,
                tool_choice=ChatCompletionNamedToolChoiceParam(type="function",
                                                               function={"name": "process_website_request"}),
                temperature=0.7,
                max_tokens=2000
            )

            # Extract response
            message = response.choices[0].message
            tool_call = message.tool_calls[0]
            response_data = json.loads(tool_call.function.arguments)

            # Get token usage
            usage = response.usage

            duration_ms = int((time.time() - start_time) * 1000)

            logger.info(f"Azure OpenAI response generated: type={response_data['response_type']}, "
                        f"tokens={usage.total_tokens}, duration={duration_ms}ms")

            return (
                LLMResponse(
                    content=response_data.get('chat_message', ''),
                    prompt_tokens=usage.prompt_tokens,
                    completion_tokens=usage.completion_tokens,
                    total_tokens=usage.total_tokens,
                    model=self.settings.azure_openai_deployment
                ),
                response_data
            )

        except Exception as e:
            logger.error(f"Error generating Azure OpenAI response: {e}")
            raise

    async def _generate_response_ai_inference(self, prompt: str, current_code: Dict[str, str],
                                              context: str, chat_history: Optional[List[ChatCompletionMessageParam]],
                                              start_time: float) -> tuple[LLMResponse, Dict[str, Any]]:
        """Generate response using Azure AI Inference SDK"""
        from azure.ai.inference.models import SystemMessage, UserMessage, AssistantMessage, ToolMessage

        # Build messages using Azure AI message types
        messages = [
            SystemMessage(content=self.system_prompts.get(context, self.system_prompts["workshop"]))
        ]

        # Add chat history if provided
        if chat_history:
            for msg in chat_history[-5:]:  # Last 5 messages for context
                if msg['role'] == 'user':
                    messages.append(UserMessage(content=msg['content']))
                elif msg['role'] == 'assistant':
                    messages.append(AssistantMessage(content=msg['content']))
                elif msg['role'] == 'tool':
                    messages.append(ToolMessage(content=msg['content']))

        # Add current code context
        code_context = f"""
Aktueller Code der Website:

HTML:
```html
{current_code.get('html', '')}
```

CSS:
```css
{current_code.get('css', '')}
```

JavaScript:
```javascript
{current_code.get('js', '')}
```
"""

        # Add user message with code context
        messages.append(UserMessage(content=f"{code_context}\n\nNutzer-Anfrage: {prompt}"))

        # Define tools for structured response
        tools = [{
            "type": "function",
            "function": {
                "name": "process_website_request",
                "description": "Process user's website modification request",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "response_type": {
                            "type": "string",
                            "enum": ["chat", "update", "rewrite"],
                            "description": "Type of response: chat (just talk), update (modify existing), rewrite (complete new code)"
                        },
                        "chat_message": {
                            "type": "string",
                            "description": "Message to show the user explaining what you're doing"
                        },
                        "updates": {
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "file": {"type": "string", "enum": ["html", "css", "js"]},
                                    "old_str": {"type": "string"},
                                    "new_str": {"type": "string"},
                                    "description": {"type": "string"}
                                },
                                "required": ["file", "old_str", "new_str"]
                            },
                            "description": "List of code updates to apply"
                        },
                        "new_code": {
                            "type": "object",
                            "properties": {
                                "html": {"type": "string"},
                                "css": {"type": "string"},
                                "js": {"type": "string"}
                            },
                            "description": "Complete new code for rewrite"
                        },
                        "explanation": {
                            "type": "string",
                            "description": "Technical explanation of changes made"
                        }
                    },
                    "required": ["response_type", "chat_message"]
                }
            }
        }]

        try:
            # Make API call using Azure AI Inference with model name
            # Note: DeepSeek only supports "auto", "required", or "none" for tool_choice
            response = self.chat_client.complete(
                model=self.settings.azure_model_name,
                messages=messages,
                tools=tools,
                tool_choice="required",  # Force tool use since we need structured output
                temperature=0.7,
                max_tokens=5000
            )

            # Extract response
            message = response.choices[0].message
            tool_call = message.tool_calls[0]
            response_data = json.loads(tool_call.function.arguments)

            # Get token usage
            usage = response.usage

            duration_ms = int((time.time() - start_time) * 1000)

            logger.info(f"Azure AI Inference response generated: type={response_data['response_type']}, "
                        f"tokens={usage.total_tokens}, duration={duration_ms}ms")

            return (
                LLMResponse(
                    content=response_data.get('chat_message', ''),
                    prompt_tokens=usage.prompt_tokens,
                    completion_tokens=usage.completion_tokens,
                    total_tokens=usage.total_tokens,
                    model=self.settings.azure_model_name
                ),
                response_data
            )

        except Exception as e:
            logger.error(f"Error generating Azure AI Inference response: {e}")
            raise

    def calculate_cost(self, prompt_tokens: int, completion_tokens: int) -> float:
        """Calculate cost based on token usage"""
        input_cost = (prompt_tokens / 1_000_000) * self.settings.cost_per_1m_input_tokens
        output_cost = (completion_tokens / 1_000_000) * self.settings.cost_per_1m_output_tokens
        return round(input_cost + output_cost, 6)
