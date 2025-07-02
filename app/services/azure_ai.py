import json
import logging
import time
import re
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

AUSFÜHRUNGSUMGEBUNG:
- Code läuft in einem IFRAME mit srcdoc - vollständiger Zugriff auf moderne Web APIs
- Tailwind CSS und Alpine.js sind BEREITS über CDN eingebunden
- Vollzugriff auf: document, window, Alpine, localStorage, sessionStorage, Canvas, etc.
- Kein eval(), innerHTML mit User-Input, oder externe Scripts (Sicherheit)

TECHNISCHE VORGABEN:
- NIEMALS diese Tags hinzufügen: <script src="https://cdn.tailwindcss.com">, <script src="...alpinejs...">
- Nutze Tailwind CSS Utility-Klassen für Styling
- Nutze Alpine.js Direktiven für Interaktivität (x-data, x-show, x-model, x-transition)
- Erstelle NUR Body-Content, keine DOCTYPE, head, oder CDN script-Tags

NAVIGATION & LINKS:
- Normale <a href="..."> Links funktionieren NICHT im iframe
- STATTDESSEN: Alpine.js für interne Navigation nutzen
- Beispiele: @click="currentPage = 'about'", x-show="currentPage === 'home'"
- Smooth transitions mit x-transition möglich
- Modal-basierte Navigation: x-data="{ activeModal: null }"

ALPINE.JS PATTERNS:
- View-Switching: x-data="{ currentPage: 'home' }" mit x-show + x-transition
- Tabs: x-data="{ activeTab: 'services' }" für Tab-Interfaces
- Modals: x-data="{ showModal: false }" für Overlays
- Forms: x-model für Two-Way Binding, @submit.prevent für Form-Handling
- State Management: Alpine.store() für globalen Zustand

BILDER VERWENDEN:
- Wenn der User Bilder hochgeladen hat, kannst du sie in den Code einbauen
- Verwende die Bild-URLs aus dem Kontext: /api/images/{image_id}/data
- Frage den User, wo und wie er das Bild verwenden möchte
- Schlage passende Platzierungen vor (Header, Galerie, Hintergrund, etc.)
- Erkläre welche Tailwind-Klassen du für die Bild-Darstellung verwendest
- Denke an responsive Design und Barrierefreiheit (alt-Text)

TAILWIND CSS BEST PRACTICES:
- Farb-Konsistenz: Wähle 1-2 Hauptfarben und bleibe dabei (z.B. blue-500/600)
- Responsive Design: Mobile-first mit sm:, md:, lg:, xl: Breakpoints
- Layout Patterns: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
- Container: "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" für responsive Breite
- Spacing System: Nutze 4, 6, 8, 12, 16 für harmonische Abstände
- Komponenten: "bg-white rounded-xl shadow-md hover:shadow-xl transition-all p-6"
- Buttons: "px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
- Animationen: "transition-all duration-300" für alle Hover-Effekte
- Typografie: text-4xl/3xl/2xl mit font-bold/semibold, leading-relaxed für Body

CODE-REGELN:
- Schreibe sauberen, gut strukturierten Code
- Verwende moderne Best Practices, vermeide anti-patterns
- Erkläre in einfacher Sprache was du tust
- Erwähne welche Tailwind-Klassen du verwendest und was sie bewirken
- Stelle sicher, dass der Code sicher ist (keine eval, innerHTML mit User-Input)
- Barrierefreiheit: focus:ring-2 für Tastatur-Navigation, ausreichend Kontrast

LERNVERFOLGUNG:
- Der Nutzer hat bereits bestimmte Konzepte gelernt (siehe Kontext)
- Ein KONZEPT ist eine wiederverwendbare Technik/Pattern, NICHT einzelne Syntax-Elemente
- Erkenne neue Konzepte auf der richtigen Abstraktionsebene:
  ✓ "CSS Flexbox" (nicht nur "CSS" oder "display: flex")
  ✓ "Alpine.js Komponenten" (nicht nur "Alpine.js")
  ✓ "Event Handling" (nicht jedes einzelne Event)
  ✓ "Responsive Design" (nicht jeden Breakpoint)

WENN ein neues Konzept eingeführt wird:
1. PRÜFE: Ist es wirklich neu? Nicht nur eine Variation eines bekannten Konzepts?
2. ERKLÄRE: Kurz den Zweck und Nutzen (1-2 Sätze)
3. ZEIGE: "Schau dir Zeile X an, dort siehst du wie [Konzept] funktioniert"
4. FÜGE HINZU: Nur bedeutsame Konzepte zur "new_concepts" Liste

KONZEPT-KATEGORIEN (als Orientierung):
- Layout: "CSS Grid", "Flexbox", "Positioning"
- Interaktivität: "Event Handling", "Alpine.js State", "DOM Manipulation"
- Styling: "Responsive Design", "Animationen", "Custom Properties"
- Struktur: "Semantic HTML", "Komponenten-Denken", "Accessibility"

BEISPIEL:
Nutzer kennt: ["CSS Flexbox", "Alpine.js x-data"]
Du verwendest: Alpine.js x-show zum ersten Mal
→ new_concepts: ["Alpine.js Conditionals"] (NICHT "x-show" allein)

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
            chat_history: Optional[List[ChatCompletionMessageParam]] = None,
            user_images: Optional[List[Dict[str, Any]]] = None,
            learned_concepts: Optional[List[str]] = None
    ) -> tuple[LLMResponse, Dict[str, Any]]:
        """Generate AI response for user prompt"""
        start_time = time.time()

        if self.endpoint_type == "openai":
            return await self._generate_response_openai(prompt, current_code, context, chat_history, start_time, user_images, learned_concepts)
        elif self.endpoint_type == "ai-inference":
            return await self._generate_response_ai_inference(prompt, current_code, context, chat_history, start_time, user_images, learned_concepts)
        else:
            raise ValueError(f"Unsupported endpoint type: {self.endpoint_type}")

    async def _generate_response_openai(self, prompt: str, current_code: Dict[str, str],
                                        context: str, chat_history: Optional[List[ChatCompletionMessageParam]],
                                        start_time: float, user_images: Optional[List[Dict[str, Any]]] = None,
                                        learned_concepts: Optional[List[str]] = None) -> tuple[LLMResponse, Dict[str, Any]]:
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

        # Add current code context with iframe execution info
        code_context = f"""
Aktueller Code der Website (läuft in iframe mit Tailwind + Alpine.js):

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

IFRAME-KONTEXT:
- Vollständiger Zugriff auf Web APIs (localStorage, Canvas, etc.)
- Alpine.js verfügbar für Navigation (da normale Links nicht funktionieren)
- Tailwind CSS vollständig geladen
- Real-time Preview mit sofortiger Aktualisierung
"""

        # Add learned concepts if available
        if learned_concepts:
            code_context += f"\n\nBereits erlernte Konzepte des Nutzers: {', '.join(learned_concepts)}"

        # Add image context if available
        image_context = ""
        if user_images:
            image_context = "\n\nVerfügbare Bilder:\n"
            for img in user_images:
                image_context += f"- {img['original_name']} ({img['width']}x{img['height']}) - ID: {img['id']}\n"
                image_context += f"  URL für HTML-Code: /api/images/public/{img['id']}/data\n"
                image_context += f"  Alt-Text: {img.get('alt_text', 'Kein Alt-Text')}\n"

        # Add user message with code context
        messages.append(ChatCompletionUserMessageParam(
            role="user",
            content=f"{code_context}{image_context}\n\nNutzer-Anfrage: {prompt}"
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
                            "enum": ["chat", "update", "update_all", "rewrite"],
                            "description": "Type of response: chat (just talk), update (modify one specific instance), update_all (replace all occurrences), rewrite (complete new code)"
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
                        },
                        "new_concepts": {
                            "type": "array",
                            "items": {"type": "string"},
                            "description": "Liste neuer Konzepte, die in dieser Antwort eingeführt wurden"
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
            
            # Log the raw arguments for debugging
            logger.debug(f"Raw tool call arguments: {tool_call.function.arguments}")
            
            try:
                response_data = json.loads(tool_call.function.arguments)
            except json.JSONDecodeError as json_error:
                logger.error(f"JSON decode error: {json_error}")
                logger.error(f"Problematic JSON: {tool_call.function.arguments}")
                
                # Try to fix common JSON issues
                fixed_json = tool_call.function.arguments
                
                # Fix unterminated strings by finding the last quote and adding closing quote if needed
                if fixed_json.count('"') % 2 != 0:
                    # Odd number of quotes, likely unterminated string
                    fixed_json = fixed_json + '"'
                    logger.info("Attempted to fix unterminated string by adding closing quote")
                
                # Try to parse the fixed JSON
                try:
                    response_data = json.loads(fixed_json)
                    logger.info("Successfully parsed fixed JSON")
                except json.JSONDecodeError:
                    # If still can't parse, return a safe fallback response
                    logger.error("Could not fix JSON, returning fallback response")
                    response_data = {
                        "response_type": "chat_only",
                        "chat_message": "I apologize, but I encountered an error processing your request. Please try again."
                    }

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
                                              start_time: float, user_images: Optional[List[Dict[str, Any]]] = None,
                                              learned_concepts: Optional[List[str]] = None) -> tuple[LLMResponse, Dict[str, Any]]:
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

        # Add current code context with iframe execution info
        code_context = f"""
Aktueller Code der Website (läuft in iframe mit Tailwind + Alpine.js):

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

IFRAME-KONTEXT:
- Vollständiger Zugriff auf Web APIs (localStorage, Canvas, etc.)
- Alpine.js verfügbar für Navigation (da normale Links nicht funktionieren)
- Tailwind CSS vollständig geladen
- Real-time Preview mit sofortiger Aktualisierung
"""

        # Add learned concepts if available
        if learned_concepts:
            code_context += f"\n\nBereits erlernte Konzepte des Nutzers: {', '.join(learned_concepts)}"

        # Add image context if available
        image_context = ""
        if user_images:
            image_context = "\n\nVerfügbare Bilder:\n"
            for img in user_images:
                image_context += f"- {img['original_name']} ({img['width']}x{img['height']}) - ID: {img['id']}\n"
                image_context += f"  URL für HTML-Code: /api/images/public/{img['id']}/data\n"
                image_context += f"  Alt-Text: {img.get('alt_text', 'Kein Alt-Text')}\n"

        # Add user message with code context
        messages.append(UserMessage(content=f"{code_context}{image_context}\n\nNutzer-Anfrage: {prompt}"))

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
                            "enum": ["chat", "update", "update_all", "rewrite"],
                            "description": "Type of response: chat (just talk), update (modify one specific instance), update_all (replace all occurrences), rewrite (complete new code)"
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
                        },
                        "new_concepts": {
                            "type": "array",
                            "items": {"type": "string"},
                            "description": "Liste neuer Konzepte, die in dieser Antwort eingeführt wurden"
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
            
            # Log the raw arguments for debugging
            logger.debug(f"Raw tool call arguments: {tool_call.function.arguments}")
            
            try:
                response_data = json.loads(tool_call.function.arguments)
            except json.JSONDecodeError as json_error:
                logger.error(f"JSON decode error: {json_error}")
                logger.error(f"Problematic JSON: {tool_call.function.arguments}")
                
                # Try to fix common JSON issues
                fixed_json = tool_call.function.arguments
                
                # Fix unterminated strings by finding the last quote and adding closing quote if needed
                if fixed_json.count('"') % 2 != 0:
                    # Odd number of quotes, likely unterminated string
                    fixed_json = fixed_json + '"'
                    logger.info("Attempted to fix unterminated string by adding closing quote")
                
                # Try to parse the fixed JSON
                try:
                    response_data = json.loads(fixed_json)
                    logger.info("Successfully parsed fixed JSON")
                except json.JSONDecodeError:
                    # If still can't parse, return a safe fallback response
                    logger.error("Could not fix JSON, returning fallback response")
                    response_data = {
                        "response_type": "chat_only",
                        "chat_message": "I apologize, but I encountered an error processing your request. Please try again."
                    }

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

    async def disambiguate_multiple_matches(
            self,
            original_request: str,
            old_str: str,
            matches: List[Dict[str, Any]],
            current_code: Dict[str, str],
            context: str = "workshop"
    ) -> tuple[LLMResponse, Dict[str, Any]]:
        """Ask LLM to clarify when multiple matches are found for an update"""
        
        # Build context showing all matches
        matches_context = f"Ich habe {len(matches)} Vorkommen von '{old_str}' gefunden:\n\n"
        for i, match in enumerate(matches, 1):
            matches_context += f"{i}. In {match['file']}.{match['file_ext']}:\n"
            matches_context += f"   Kontext: {match['context']}\n\n"
        
        disambiguation_prompt = f"""
Du wolltest '{old_str}' ändern, aber ich habe mehrere Vorkommen gefunden.

{matches_context}

Ursprüngliche Anfrage: "{original_request}"

WICHTIG: Code läuft in iframe - nutze Alpine.js für Navigation statt normale Links!

Bitte entscheide:
1. Falls du ALLE Vorkommen ändern wolltest → verwende "update_all"
2. Falls du nur EIN spezifisches Vorkommen ändern wolltest → verwende "update" mit erweiterten old_str

Beispiele für erweiterten Kontext:
- Statt: "text-red-500" → Verwende: "<h1 class=\\"text-red-500 font-bold\\">Welcome</h1>"
- Statt: "href=\\"#about\\"" → Nutze Alpine.js: "@click=\\"currentPage = 'about'\\""
"""
        
        return await self.generate_response(
            prompt=disambiguation_prompt,
            current_code=current_code,
            context=context
        )

    @staticmethod
    def find_multiple_matches(old_str: str, current_code: Dict[str, str]) -> List[Dict[str, Any]]:
        """Find all occurrences of old_str in current code with context"""
        matches = []
        
        for file_type in ['html', 'css', 'js']:
            content = current_code.get(file_type, '')
            if not content:
                continue
                
            # Find all matches with their positions
            for match in re.finditer(re.escape(old_str), content):
                start_pos = match.start()
                end_pos = match.end()
                
                # Get surrounding context (50 chars before and after)
                context_start = max(0, start_pos - 50)
                context_end = min(len(content), end_pos + 50)
                context = content[context_start:context_end]
                
                # Clean up context for display
                context = context.replace('\n', ' ').replace('\t', ' ')
                context = ' '.join(context.split())  # Remove extra whitespace
                
                matches.append({
                    'file': file_type,
                    'file_ext': file_type,
                    'context': context,
                    'start_pos': start_pos,
                    'end_pos': end_pos,
                    'match_text': old_str
                })
        
        return matches

    def calculate_cost(self, prompt_tokens: int, completion_tokens: int) -> float:
        """Calculate cost based on token usage"""
        input_cost = (prompt_tokens / 1_000_000) * self.settings.cost_per_1m_input_tokens
        output_cost = (completion_tokens / 1_000_000) * self.settings.cost_per_1m_output_tokens
        return round(input_cost + output_cost, 6)
