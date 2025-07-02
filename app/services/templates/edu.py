# Modern Educational Learning Path - TikTok Generation Style
# Gamifiziert, Dopamin-optimiert, Micro-Learning
from sqlalchemy.ext.asyncio.session import AsyncSession

from app.models import Template

edu_templates = [
    # ===== LEVEL 1: INSTANT GRATIFICATION =====
    {
        "id": 1,
        "name": "⚡ 60 Sekunden Challenge: Mach was Krasses!",
        "category": "edu_speedrun",
        "level": 1,
        "duration": "60 sec",
        "description": "Bau in 60 Sekunden was Geiles - ohne Code zu sehen!",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>60 Second Challenge</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-black text-white min-h-screen flex items-center justify-center" x-data="{
    timeLeft: 60,
    started: false,
    score: 0,
    achievements: [],
    currentChallenge: 1,
    boom: false,
    init() {
        this.$watch('timeLeft', value => {
            if (value === 0 && this.started) {
                this.started = false;
                this.boom = true;
            }
        });
    },
    startTimer() {
        this.started = true;
        const timer = setInterval(() => {
            if (this.timeLeft > 0 && this.started) {
                this.timeLeft--;
            } else {
                clearInterval(timer);
            }
        }, 1000);
    },
    addAchievement(points, text) {
        this.score += points;
        this.achievements.push(text);
    }
}">
    <div class="max-w-4xl w-full px-8">
        <!-- Start Screen -->
        <div x-show="!started && timeLeft === 60" class="text-center">
            <h1 class="text-6xl font-bold mb-8 bg-gradient-to-r from-pink-500 to-yellow-500 bg-clip-text text-transparent">
                ⚡ 60 SEKUNDEN CHALLENGE
            </h1>

            <div class="bg-gray-900 rounded-2xl p-8 mb-8">
                <p class="text-2xl mb-6">Bau die krasseste Website in 60 Sekunden!</p>

                <div class="grid grid-cols-3 gap-4 mb-8">
                    <div class="bg-gray-800 rounded-xl p-4">
                        <p class="text-4xl mb-2">🎨</p>
                        <p class="text-sm">FARBEN</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <p class="text-4xl mb-2">✨</p>
                        <p class="text-sm">EFFEKTE</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <p class="text-4xl mb-2">🚀</p>
                        <p class="text-sm">ANIMATIONEN</p>
                    </div>
                </div>

                <button @click="startTimer" 
                        class="bg-gradient-to-r from-green-400 to-blue-500 px-12 py-6 rounded-full text-2xl font-bold hover:scale-110 transform transition">
                    START! 🚀
                </button>
            </div>

            <div class="text-gray-400">
                <p>Sag der KI einfach was du willst - sie macht den Rest!</p>
            </div>
        </div>

        <!-- Game Screen -->
        <div x-show="started" x-transition>
            <!-- Timer -->
            <div class="fixed top-8 right-8">
                <div class="text-6xl font-bold" 
                     :class="timeLeft < 10 ? 'text-red-500 animate-pulse' : 'text-green-400'">
                    <span x-text="timeLeft"></span>s
                </div>
            </div>

            <!-- Score -->
            <div class="fixed top-8 left-8">
                <div class="text-4xl font-bold text-yellow-400">
                    <span x-text="score"></span> PUNKTE
                </div>
            </div>

            <!-- Challenge Area -->
            <div class="mt-20">
                <div class="bg-gray-900 rounded-2xl p-8 mb-8">
                    <h2 class="text-3xl font-bold mb-6 text-center">
                        QUICK! Sag der KI:
                    </h2>

                    <div class="space-y-4">
                        <div class="bg-gray-800 rounded-xl p-6 hover:bg-gray-700 transition cursor-pointer"
                             @click="addAchievement(100, '🎨 Farb-Explosion!')">
                            <p class="text-xl font-bold text-pink-400">
                                "Mach alles NEON PINK mit Glow-Effekt!"
                            </p>
                            <p class="text-sm text-gray-400 mt-2">+100 Punkte</p>
                        </div>

                        <div class="bg-gray-800 rounded-xl p-6 hover:bg-gray-700 transition cursor-pointer"
                             @click="addAchievement(200, '🌈 Regenbogen-Wahnsinn!')">
                            <p class="text-xl font-bold text-purple-400">
                                "Füge einen REGENBOGEN-HINTERGRUND hinzu!"
                            </p>
                            <p class="text-sm text-gray-400 mt-2">+200 Punkte</p>
                        </div>

                        <div class="bg-gray-800 rounded-xl p-6 hover:bg-gray-700 transition cursor-pointer"
                             @click="addAchievement(300, '💥 Animations-Master!')">
                            <p class="text-xl font-bold text-yellow-400">
                                "Lass ALLES WACKELN und BLINKEN!"
                            </p>
                            <p class="text-sm text-gray-400 mt-2">+300 Punkte</p>
                        </div>

                        <div class="bg-gray-800 rounded-xl p-6 hover:bg-gray-700 transition cursor-pointer"
                             @click="addAchievement(500, '🚀 MEGA COMBO!')">
                            <p class="text-xl font-bold bg-gradient-to-r from-red-500 to-yellow-500 bg-clip-text text-transparent">
                                "Mach eine PARTY-WEBSITE mit KONFETTI!"
                            </p>
                            <p class="text-sm text-gray-400 mt-2">+500 Punkte - JACKPOT!</p>
                        </div>
                    </div>
                </div>

                <!-- Live Achievements -->
                <div x-show="achievements.length > 0" class="fixed bottom-8 left-8">
                    <div class="space-y-2">
                        <template x-for="achievement in achievements" :key="achievement">
                            <div class="bg-green-600 px-4 py-2 rounded-full animate-bounce"
                                 x-text="achievement"></div>
                        </template>
                    </div>
                </div>
            </div>
        </div>

        <!-- Time's Up Screen -->
        <div x-show="boom" x-transition class="text-center">
            <h1 class="text-8xl font-bold mb-8 animate-bounce">💥 BOOM!</h1>
            <p class="text-4xl mb-8">Zeit ist um!</p>
            <p class="text-6xl font-bold text-yellow-400 mb-8">
                <span x-text="score"></span> PUNKTE!
            </p>

            <div class="bg-gray-900 rounded-2xl p-8">
                <h3 class="text-2xl font-bold mb-4">Was hast du gelernt?</h3>
                <div class="text-left space-y-2 text-gray-300">
                    <p>✅ KI versteht deine Sprache</p>
                    <p>✅ Farben und Effekte sind easy</p>
                    <p>✅ Du kannst ALLES bauen</p>
                    <p>✅ Code? Brauchst du nicht sehen!</p>
                </div>

                <button class="mt-6 bg-gradient-to-r from-purple-500 to-pink-500 px-8 py-4 rounded-full text-xl font-bold">
                    Level 2 freischalten! 🔓
                </button>
            </div>
        </div>
    </div>

    <!-- Background Effects -->
    <div class="fixed inset-0 -z-10 overflow-hidden">
        <div class="absolute w-96 h-96 bg-purple-500 rounded-full blur-3xl opacity-20 -top-48 -left-48 animate-pulse"></div>
        <div class="absolute w-96 h-96 bg-pink-500 rounded-full blur-3xl opacity-20 -bottom-48 -right-48 animate-pulse"></div>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    {
        "id": 2,
        "name": "🎮 Website = Game? Mind Blown!",
        "category": "edu_gamified",
        "level": 2,
        "duration": "3 min",
        "description": "Lerne wie Websites funktionieren - als Game erklärt!",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Website Game Theory</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gradient-to-br from-purple-900 to-pink-900 min-h-screen text-white" x-data="{
    currentLevel: 'start',
    unlockedPowers: [],
    hearts: 3,
    coins: 0,
    showPowerUp: false,
    powerUpText: '',
    unlockPower(power, text, coins = 10) {
        this.unlockedPowers.push(power);
        this.showPowerUp = true;
        this.powerUpText = text;
        this.coins += coins;
        setTimeout(() => this.showPowerUp = false, 3000);
    }
}">
    <div class="max-w-6xl mx-auto p-8">
        <!-- Game HUD -->
        <div class="fixed top-0 left-0 right-0 bg-black bg-opacity-50 p-4 z-50">
            <div class="max-w-6xl mx-auto flex justify-between items-center">
                <div class="flex gap-6">
                    <!-- Hearts -->
                    <div class="flex gap-1">
                        <template x-for="i in hearts">
                            <span class="text-2xl">❤️</span>
                        </template>
                    </div>
                    <!-- Coins -->
                    <div class="flex items-center gap-2">
                        <span class="text-2xl">🪙</span>
                        <span class="text-xl font-bold" x-text="coins"></span>
                    </div>
                </div>
                <!-- Powers -->
                <div class="flex gap-2">
                    <div x-show="unlockedPowers.includes('html')" class="bg-orange-600 px-3 py-1 rounded">HTML</div>
                    <div x-show="unlockedPowers.includes('css')" class="bg-purple-600 px-3 py-1 rounded">CSS</div>
                    <div x-show="unlockedPowers.includes('js')" class="bg-green-600 px-3 py-1 rounded">JS</div>
                </div>
            </div>
        </div>

        <!-- Power Up Notification -->
        <div x-show="showPowerUp" x-transition 
             class="fixed top-20 left-1/2 transform -translate-x-1/2 z-50">
            <div class="bg-yellow-400 text-black px-8 py-4 rounded-full text-xl font-bold animate-bounce">
                <span x-text="powerUpText"></span>
            </div>
        </div>

        <!-- Start Screen -->
        <div x-show="currentLevel === 'start'" class="mt-20 text-center">
            <h1 class="text-6xl font-bold mb-8">🎮 WEBSITE QUEST</h1>
            <p class="text-2xl mb-8">Entdecke die geheimen Powers des Webs!</p>

            <div class="bg-black bg-opacity-50 rounded-2xl p-8 max-w-2xl mx-auto">
                <p class="text-xl mb-6">Eine Website ist wie ein Videospiel:</p>
                <div class="space-y-4 text-left">
                    <div class="flex items-center gap-4">
                        <span class="text-3xl">🏗️</span>
                        <p><strong>HTML</strong> = Das Level-Design</p>
                    </div>
                    <div class="flex items-center gap-4">
                        <span class="text-3xl">🎨</span>
                        <p><strong>CSS</strong> = Die Grafik-Engine</p>
                    </div>
                    <div class="flex items-center gap-4">
                        <span class="text-3xl">⚡</span>
                        <p><strong>JavaScript</strong> = Die Game-Mechanik</p>
                    </div>
                </div>

                <button @click="currentLevel = 'html_world'" 
                        class="mt-8 bg-gradient-to-r from-yellow-400 to-orange-500 px-8 py-4 rounded-full text-xl font-bold text-black hover:scale-110 transform transition">
                    Start Game! 🚀
                </button>
            </div>
        </div>

        <!-- HTML World -->
        <div x-show="currentLevel === 'html_world'" x-transition class="mt-20">
            <h2 class="text-4xl font-bold text-center mb-8">🏗️ Level 1: HTML World</h2>

            <div class="grid md:grid-cols-3 gap-6 mb-8">
                <!-- Building Blocks -->
                <div @click="unlockPower('html', '🏗️ HTML Power unlocked!')" 
                     class="bg-orange-800 bg-opacity-50 rounded-xl p-6 cursor-pointer hover:bg-opacity-70 transition transform hover:scale-105">
                    <h3 class="text-2xl font-bold mb-4">Baustein-Box</h3>
                    <div class="space-y-2">
                        <div class="bg-orange-600 p-2 rounded">Überschrift-Block</div>
                        <div class="bg-orange-600 p-2 rounded">Text-Block</div>
                        <div class="bg-orange-600 p-2 rounded">Bild-Block</div>
                        <div class="bg-orange-600 p-2 rounded">Button-Block</div>
                    </div>
                    <p class="mt-4 text-sm">Klick mich! Diese Blöcke bauen deine Website!</p>
                </div>

                <!-- Example Structure -->
                <div class="bg-gray-800 bg-opacity-50 rounded-xl p-6 col-span-2">
                    <h3 class="text-2xl font-bold mb-4">So sieht ein Level aus:</h3>
                    <div class="bg-gray-900 rounded-lg p-4 font-mono text-sm">
                        <p class="text-orange-400">🏠 Haus (Website)</p>
                        <p class="text-orange-300 ml-4">├── 🚪 Eingang (Header)</p>
                        <p class="text-orange-300 ml-4">├── 🛋️ Wohnzimmer (Main)</p>
                        <p class="text-orange-300 ml-8">├── 📺 TV (Video)</p>
                        <p class="text-orange-300 ml-8">└── 🛋️ Sofa (Text)</p>
                        <p class="text-orange-300 ml-4">└── 🚪 Ausgang (Footer)</p>
                    </div>

                    <div class="mt-4 bg-orange-900 bg-opacity-50 p-4 rounded">
                        <p class="font-bold">💡 ERKENNTNIS:</p>
                        <p>HTML ist nur die Struktur - wie Minecraft ohne Texturen!</p>
                    </div>
                </div>
            </div>

            <div class="text-center">
                <button @click="currentLevel = 'css_world'" 
                        class="bg-purple-600 hover:bg-purple-700 px-8 py-4 rounded-full text-xl font-bold">
                    Weiter zu CSS World →
                </button>
            </div>
        </div>

        <!-- CSS World -->
        <div x-show="currentLevel === 'css_world'" x-transition class="mt-20">
            <h2 class="text-4xl font-bold text-center mb-8">🎨 Level 2: CSS World</h2>

            <div class="bg-purple-800 bg-opacity-50 rounded-2xl p-8 mb-8">
                <h3 class="text-2xl font-bold mb-6">Skin-Shop für deine Website!</h3>

                <div class="grid md:grid-cols-4 gap-4">
                    <!-- Color Skins -->
                    <div @click="unlockPower('css', '🎨 CSS Power unlocked!', 20)" 
                         class="bg-gradient-to-br from-red-500 to-yellow-500 rounded-xl p-6 cursor-pointer hover:scale-110 transform transition">
                        <p class="font-bold">Fire Skin</p>
                        <p class="text-sm">🔥 Hot!</p>
                    </div>

                    <div class="bg-gradient-to-br from-blue-500 to-cyan-500 rounded-xl p-6 cursor-pointer hover:scale-110 transform transition">
                        <p class="font-bold">Ice Skin</p>
                        <p class="text-sm">❄️ Cool!</p>
                    </div>

                    <div class="bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl p-6 cursor-pointer hover:scale-110 transform transition">
                        <p class="font-bold">Galaxy Skin</p>
                        <p class="text-sm">🌌 Space!</p>
                    </div>

                    <div class="bg-gradient-to-br from-green-500 to-emerald-500 rounded-xl p-6 cursor-pointer hover:scale-110 transform transition">
                        <p class="font-bold">Nature Skin</p>
                        <p class="text-sm">🌿 Fresh!</p>
                    </div>
                </div>

                <div class="mt-6 bg-purple-900 bg-opacity-50 p-4 rounded">
                    <p class="font-bold">💡 ERKENNTNIS:</p>
                    <p>CSS ist wie Skins in Fortnite - macht alles geiler, ändert aber nicht das Gameplay!</p>
                </div>
            </div>

            <!-- Effects Shop -->
            <div class="bg-pink-800 bg-opacity-50 rounded-2xl p-8 mb-8">
                <h3 class="text-2xl font-bold mb-4">✨ Effect-Shop</h3>
                <div class="flex flex-wrap gap-4">
                    <div class="bg-pink-600 px-4 py-2 rounded-full animate-pulse">Glow Effect</div>
                    <div class="bg-pink-600 px-4 py-2 rounded-full animate-bounce">Bounce Effect</div>
                    <div class="bg-pink-600 px-4 py-2 rounded-full animate-spin">Spin Effect</div>
                    <div class="bg-pink-600 px-4 py-2 rounded-full hover:scale-125 transition">Hover Effect</div>
                </div>
            </div>

            <div class="text-center">
                <button @click="currentLevel = 'js_world'" 
                        class="bg-green-600 hover:bg-green-700 px-8 py-4 rounded-full text-xl font-bold">
                    Final Level: JavaScript →
                </button>
            </div>
        </div>

        <!-- JavaScript World -->
        <div x-show="currentLevel === 'js_world'" x-transition class="mt-20">
            <h2 class="text-4xl font-bold text-center mb-8">⚡ Level 3: JavaScript World</h2>

            <div class="bg-green-800 bg-opacity-50 rounded-2xl p-8 mb-8">
                <h3 class="text-2xl font-bold mb-6">Game Mechanics Shop!</h3>

                <div class="grid md:grid-cols-2 gap-6">
                    <div @click="unlockPower('js', '⚡ JavaScript Power unlocked!', 50)" 
                         class="bg-green-700 bg-opacity-50 rounded-xl p-6 cursor-pointer hover:bg-opacity-70 transition">
                        <h4 class="text-xl font-bold mb-4">🎮 Controls</h4>
                        <ul class="space-y-2">
                            <li>• Click = Action</li>
                            <li>• Hover = Highlight</li>
                            <li>• Drag = Move</li>
                            <li>• Type = Input</li>
                        </ul>
                    </div>

                    <div class="bg-green-700 bg-opacity-50 rounded-xl p-6">
                        <h4 class="text-xl font-bold mb-4">🧠 Logic</h4>
                        <ul class="space-y-2">
                            <li>• If This → Do That</li>
                            <li>• Count Stuff</li>
                            <li>• Remember Things</li>
                            <li>• Change Things</li>
                        </ul>
                    </div>
                </div>

                <div class="mt-6 bg-green-900 bg-opacity-50 p-4 rounded">
                    <p class="font-bold">💡 MEGA-ERKENNTNIS:</p>
                    <p>JavaScript macht aus einer Website ein SPIEL! Alles wird interaktiv!</p>
                </div>
            </div>

            <!-- Final Challenge -->
            <div x-show="unlockedPowers.length === 3" class="bg-gradient-to-r from-yellow-600 to-red-600 rounded-2xl p-8 text-center">
                <h3 class="text-3xl font-bold mb-4">🏆 ALLE POWERS UNLOCKED!</h3>
                <p class="text-xl mb-6">Du verstehst jetzt wie Websites funktionieren!</p>

                <div class="bg-black bg-opacity-50 rounded-xl p-6">
                    <p class="text-lg mb-4">Bereit für die ultimative Challenge?</p>
                    <p class="text-2xl font-bold mb-6">"Bau dein eigenes Mini-Game!"</p>

                    <button class="bg-white text-black px-8 py-4 rounded-full text-xl font-bold hover:scale-110 transform transition">
                        Challenge accepted! 🚀
                    </button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    {
        "id": 3,
        "name": "🧠 Design IQ: Warum sieht das geil aus?",
        "category": "edu_design",
        "level": 3,
        "duration": "5 min",
        "description": "Design-Psychologie die dein Gehirn versteht",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Design IQ Booster</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-black text-white" x-data="{
    currentLesson: 1,
    designIQ: 0,
    discoveries: [],
    showMindBlown: false,
    activePrinciple: null,
    addDiscovery(principle, points) {
        if (!this.discoveries.includes(principle)) {
            this.discoveries.push(principle);
            this.designIQ += points;
            this.showMindBlown = true;
            setTimeout(() => this.showMindBlown = false, 2000);
        }
    }
}">
    <!-- IQ Meter -->
    <div class="fixed top-4 right-4 bg-gray-900 rounded-full p-6 text-center">
        <p class="text-sm text-gray-400">Design IQ</p>
        <p class="text-3xl font-bold text-yellow-400" x-text="designIQ"></p>
    </div>

    <!-- Mind Blown Effect -->
    <div x-show="showMindBlown" x-transition 
         class="fixed inset-0 flex items-center justify-center pointer-events-none z-50">
        <div class="text-8xl animate-ping">🤯</div>
    </div>

    <div class="max-w-6xl mx-auto p-8">
        <!-- Header -->
        <div class="text-center mb-12">
            <h1 class="text-5xl font-bold mb-4 bg-gradient-to-r from-cyan-400 to-purple-600 bg-clip-text text-transparent">
                DESIGN IQ BOOSTER
            </h1>
            <p class="text-xl text-gray-400">Lerne warum manche Websites FEUER sind 🔥</p>
        </div>

        <!-- Lesson 1: Kontrast -->
        <div x-show="currentLesson === 1" x-transition>
            <h2 class="text-3xl font-bold mb-8">Lektion 1: KONTRAST = ATTENTION</h2>

            <div class="grid md:grid-cols-2 gap-8 mb-8">
                <!-- Bad Example -->
                <div class="bg-gray-800 rounded-xl p-8">
                    <h3 class="text-xl font-bold mb-4 text-gray-500">😴 Langweilig</h3>
                    <div class="bg-gray-700 p-6 rounded">
                        <p class="text-gray-600">Dieser Text ist kaum lesbar</p>
                        <button class="bg-gray-600 text-gray-700 px-4 py-2 rounded mt-4">
                            Unsichtbarer Button
                        </button>
                    </div>
                    <p class="text-red-400 mt-4">❌ Kein Kontrast = Niemand sieht's</p>
                </div>

                <!-- Good Example -->
                <div class="bg-gray-800 rounded-xl p-8">
                    <h3 class="text-xl font-bold mb-4 text-green-400">🔥 FIRE!</h3>
                    <div class="bg-black p-6 rounded">
                        <p class="text-white font-bold">DIESER TEXT KNALLT!</p>
                        <button @click="addDiscovery('contrast', 20)" 
                                class="bg-yellow-400 text-black px-6 py-3 rounded mt-4 font-bold hover:bg-yellow-300 transform hover:scale-110 transition">
                            CLICK MICH!
                        </button>
                    </div>
                    <p class="text-green-400 mt-4">✅ Krasser Kontrast = Alle schauen hin</p>
                </div>
            </div>

            <div class="bg-purple-900 bg-opacity-30 rounded-xl p-6 mb-8">
                <p class="text-xl font-bold mb-2">🧠 GEHIRN-HACK:</p>
                <p>Dein Gehirn liebt Kontraste! Hell/Dunkel, Groß/Klein, Bunt/Grau - das zieht Blicke magisch an!</p>
            </div>

            <button @click="currentLesson = 2" 
                    class="bg-gradient-to-r from-purple-500 to-pink-500 px-8 py-4 rounded-full text-xl font-bold w-full">
                Nächste Lektion →
            </button>
        </div>

        <!-- Lesson 2: Whitespace -->
        <div x-show="currentLesson === 2" x-transition>
            <h2 class="text-3xl font-bold mb-8">Lektion 2: SPACE = LUXURY</h2>

            <div class="grid md:grid-cols-2 gap-8 mb-8">
                <!-- Cramped Example -->
                <div class="bg-gray-800 rounded-xl p-2">
                    <h3 class="text-lg font-bold text-red-400">😵 Chaos</h3>
                    <div class="bg-gray-700">
                        <p class="text-xs">Alles ist eng</p>
                        <p class="text-xs">Kein Platz zum Atmen</p>
                        <p class="text-xs">Stress für die Augen</p>
                        <button class="bg-blue-600 text-white text-xs px-2 py-1">Mini</button>
                    </div>
                    <p class="text-red-400 text-sm">❌ Zu eng = Billig-Look</p>
                </div>

                <!-- Spacious Example -->
                <div class="bg-gray-800 rounded-xl p-8">
                    <h3 class="text-xl font-bold mb-6 text-green-400">✨ Premium</h3>
                    <div class="bg-gray-900 p-8 rounded-lg">
                        <p class="text-lg mb-4">Raum zum Atmen</p>
                        <p class="text-lg mb-6">Alles hat seinen Platz</p>
                        <button @click="addDiscovery('whitespace', 25)" 
                                class="bg-blue-600 text-white px-8 py-4 rounded-lg text-lg hover:bg-blue-700 transition">
                            Premium Button
                        </button>
                    </div>
                    <p class="text-green-400 mt-6">✅ Viel Space = Premium-Feel</p>
                </div>
            </div>

            <div class="bg-blue-900 bg-opacity-30 rounded-xl p-6 mb-8">
                <p class="text-xl font-bold mb-2">🧠 GEHIRN-HACK:</p>
                <p>Leerer Raum = Luxus! Denk an Apple Stores - viel Platz, wenig Produkte. Dein Gehirn denkt: "Das ist wertvoll!"</p>
            </div>

            <button @click="currentLesson = 3" 
                    class="bg-gradient-to-r from-blue-500 to-purple-500 px-8 py-4 rounded-full text-xl font-bold w-full">
                Nächste Lektion →
            </button>
        </div>

        <!-- Lesson 3: Visual Hierarchy -->
        <div x-show="currentLesson === 3" x-transition>
            <h2 class="text-3xl font-bold mb-8">Lektion 3: GRÖßE = WICHTIGKEIT</h2>

            <div class="bg-gray-800 rounded-xl p-8 mb-8">
                <div class="text-center space-y-4">
                    <h1 class="text-6xl font-bold text-yellow-400">DAS IST MEGA WICHTIG!</h1>
                    <h2 class="text-3xl text-blue-400">Das ist auch wichtig</h2>
                    <h3 class="text-xl text-green-400">Das hier ist okay wichtig</h3>
                    <p class="text-base text-gray-400">Und das sind Details</p>
                    <p class="text-xs text-gray-600">Das liest eh keiner</p>
                </div>

                <div class="mt-8 bg-gray-900 rounded-lg p-6">
                    <p class="text-lg mb-4">📱 Stell dir vor, das ist wie Instagram:</p>
                    <ul class="space-y-2">
                        <li>• <span class="text-2xl font-bold">Bild</span> = Riesig (Hauptsache)</li>
                        <li>• <span class="text-lg">Username</span> = Mittel (Wichtig)</li>
                        <li>• <span class="text-sm">Likes</span> = Klein (Nebensache)</li>
                    </ul>
                </div>

                <button @click="addDiscovery('hierarchy', 30)" 
                        class="mt-6 bg-gradient-to-r from-yellow-400 to-orange-500 px-8 py-4 rounded-full text-xl font-bold text-black w-full hover:scale-105 transition">
                    Mind = Blown! 🤯
                </button>
            </div>

            <div class="bg-orange-900 bg-opacity-30 rounded-xl p-6 mb-8">
                <p class="text-xl font-bold mb-2">🧠 GEHIRN-HACK:</p>
                <p>Dein Gehirn scannt in 0.05 Sekunden: Groß → Mittel → Klein. Mach das Wichtigste FETT!</p>
            </div>

            <button @click="currentLesson = 4" 
                    class="bg-gradient-to-r from-orange-500 to-red-500 px-8 py-4 rounded-full text-xl font-bold w-full">
                Final Boss →
            </button>
        </div>

        <!-- Lesson 4: Color Psychology -->
        <div x-show="currentLesson === 4" x-transition>
            <h2 class="text-3xl font-bold mb-8">Lektion 4: FARBEN = GEFÜHLE</h2>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
                <div @click="activePrinciple = 'red'" 
                     class="bg-red-600 rounded-xl p-6 text-center cursor-pointer hover:scale-110 transition">
                    <p class="text-2xl mb-2">🔥</p>
                    <p class="font-bold">ROT</p>
                    <p class="text-sm">Action! Energie!</p>
                </div>

                <div @click="activePrinciple = 'blue'" 
                     class="bg-blue-600 rounded-xl p-6 text-center cursor-pointer hover:scale-110 transition">
                    <p class="text-2xl mb-2">💧</p>
                    <p class="font-bold">BLAU</p>
                    <p class="text-sm">Trust! Chill!</p>
                </div>

                <div @click="activePrinciple = 'green'" 
                     class="bg-green-600 rounded-xl p-6 text-center cursor-pointer hover:scale-110 transition">
                    <p class="text-2xl mb-2">💰</p>
                    <p class="font-bold">GRÜN</p>
                    <p class="text-sm">Money! Growth!</p>
                </div>

                <div @click="activePrinciple = 'purple'" 
                     class="bg-purple-600 rounded-xl p-6 text-center cursor-pointer hover:scale-110 transition">
                    <p class="text-2xl mb-2">👑</p>
                    <p class="font-bold">LILA</p>
                    <p class="text-sm">Luxus! Magic!</p>
                </div>
            </div>

            <!-- Color Details -->
            <div x-show="activePrinciple === 'red'" class="bg-red-900 bg-opacity-30 rounded-xl p-6 mb-8">
                <p class="text-xl font-bold">ROT = Dein Gehirn schreit: "ATTENTION!"</p>
                <p>YouTube-Play-Button, Netflix-Logo, Sale-Schilder - alles rot! Warum? Weil's funktioniert!</p>
            </div>

            <div x-show="activePrinciple === 'blue'" class="bg-blue-900 bg-opacity-30 rounded-xl p-6 mb-8">
                <p class="text-xl font-bold">BLAU = Dein Gehirn sagt: "Dem vertrau ich!"</p>
                <p>Facebook, Twitter, PayPal - alle blau! Blau = seriös, sicher, stable.</p>
            </div>

            <div x-show="activePrinciple === 'green'" class="bg-green-900 bg-opacity-30 rounded-xl p-6 mb-8">
                <p class="text-xl font-bold">GRÜN = Dein Gehirn denkt: "GO! POSITIV!"</p>
                <p>WhatsApp, Spotify, Fiverr - grün bedeutet: Los geht's, alles gut, wachsen!</p>
            </div>

            <div x-show="activePrinciple === 'purple'" class="bg-purple-900 bg-opacity-30 rounded-xl p-6 mb-8">
                <p class="text-xl font-bold">LILA = Dein Gehirn fühlt: "Das ist special!"</p>
                <p>Twitch, Discord - purple ist mystisch, kreativ, anders!</p>
            </div>

            <button @click="addDiscovery('color', 35)" 
                    class="bg-gradient-to-r from-red-500 via-yellow-500 to-green-500 px-8 py-4 rounded-full text-xl font-bold w-full hover:scale-105 transition">
                Ich bin jetzt ein Design-Genie! 🎨
            </button>
        </div>

        <!-- Final Score -->
        <div x-show="designIQ >= 100" class="text-center mt-12">
            <h2 class="text-5xl font-bold mb-8 bg-gradient-to-r from-yellow-400 to-yellow-600 bg-clip-text text-transparent">
                🏆 DESIGN IQ: GENIUS LEVEL!
            </h2>

            <div class="bg-gradient-to-r from-purple-900 to-pink-900 rounded-2xl p-8">
                <h3 class="text-2xl font-bold mb-6">Du verstehst jetzt:</h3>
                <div class="grid md:grid-cols-2 gap-4 text-left">
                    <div class="bg-black bg-opacity-50 rounded-lg p-4">
                        <p>✅ Warum manche Websites GEIL aussehen</p>
                    </div>
                    <div class="bg-black bg-opacity-50 rounded-lg p-4">
                        <p>✅ Wie du die KI richtig briefst</p>
                    </div>
                    <div class="bg-black bg-opacity-50 rounded-lg p-4">
                        <p>✅ Was dein Gehirn mag</p>
                    </div>
                    <div class="bg-black bg-opacity-50 rounded-lg p-4">
                        <p>✅ Wie Design funktioniert</p>
                    </div>
                </div>

                <button class="mt-8 bg-white text-black px-8 py-4 rounded-full text-xl font-bold hover:scale-110 transition">
                    Jetzt will ich BAUEN! 🚀
                </button>
            </div>
        </div>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    {
        "id": 4,
        "name": "🎯 Interaktivität verstehen - Touch it!",
        "category": "edu_interaction",
        "level": 4,
        "duration": "4 min",
        "description": "Warum klicken wir? Die Psychologie der Interaktion",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Touch Everything!</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gradient-to-br from-indigo-900 via-purple-900 to-pink-900 min-h-screen text-white" x-data="{
    touches: 0,
    discoveries: [],
    currentZone: 'start',
    satisfactionLevel: 0,
    showReward: false,
    buttonPresses: 0,
    sliderValue: 50,
    switchOn: false,
    selectedColor: null,
    textInput: '',
    draggedItem: null,
    addDiscovery(type, satisfaction = 10) {
        if (!this.discoveries.includes(type)) {
            this.discoveries.push(type);
            this.satisfactionLevel += satisfaction;
            this.showReward = true;
            setTimeout(() => this.showReward = false, 1500);
        }
        this.touches++;
    }
}">
    <!-- Touch Counter -->
    <div class="fixed top-4 left-4 bg-black bg-opacity-50 rounded-full p-4">
        <p class="text-sm">Touches</p>
        <p class="text-2xl font-bold" x-text="touches"></p>
    </div>

    <!-- Satisfaction Meter -->
    <div class="fixed top-4 right-4 bg-black bg-opacity-50 rounded-lg p-4">
        <p class="text-sm mb-2">Satisfaction</p>
        <div class="w-32 bg-gray-700 rounded-full h-3">
            <div class="bg-gradient-to-r from-green-400 to-blue-500 h-3 rounded-full transition-all duration-500" 
                 :style="'width: ' + satisfactionLevel + '%'"></div>
        </div>
    </div>

    <!-- Reward Animation -->
    <div x-show="showReward" x-transition 
         class="fixed top-20 left-1/2 transform -translate-x-1/2 z-50">
        <div class="bg-yellow-400 text-black px-6 py-3 rounded-full font-bold animate-bounce">
            +10 SATISFACTION! ✨
        </div>
    </div>

    <div class="max-w-6xl mx-auto p-8">
        <!-- Start Screen -->
        <div x-show="currentZone === 'start'" class="text-center mt-20">
            <h1 class="text-6xl font-bold mb-8">
                🎯 TOUCH EVERYTHING!
            </h1>
            <p class="text-2xl mb-8">Lerne warum Menschen Dinge anklicken wollen</p>

            <button @click="currentZone = 'basics'; addDiscovery('start', 5)" 
                    class="bg-white text-purple-900 px-12 py-6 rounded-full text-2xl font-bold hover:scale-110 transform transition hover:rotate-3">
                START TOUCHING! 👆
            </button>

            <p class="text-gray-400 mt-8">Fun Fact: Dieser Button will angeklickt werden!</p>
        </div>

        <!-- Zone 1: Button Psychology -->
        <div x-show="currentZone === 'basics'" x-transition>
            <h2 class="text-4xl font-bold mb-8 text-center">Zone 1: Button Psychology</h2>

            <div class="bg-black bg-opacity-30 rounded-2xl p-8 mb-8">
                <h3 class="text-2xl font-bold mb-6">Warum lieben wir Buttons? 🤔</h3>

                <div class="grid md:grid-cols-3 gap-6">
                    <!-- Boring Button -->
                    <div class="text-center">
                        <p class="mb-4 text-gray-400">Langweilig</p>
                        <button class="bg-gray-600 text-gray-400 px-6 py-2 rounded">
                            Meh Button
                        </button>
                        <p class="text-sm mt-2 text-red-400">❌ Niemand klickt das</p>
                    </div>

                    <!-- Good Button -->
                    <div class="text-center">
                        <p class="mb-4 text-yellow-400">Interessant!</p>
                        <button @click="buttonPresses++; addDiscovery('button')" 
                                class="bg-blue-600 hover:bg-blue-700 px-8 py-3 rounded-lg font-bold transform hover:scale-105 transition shadow-lg">
                            Click Me! ⚡
                        </button>
                        <p class="text-sm mt-2 text-green-400">✅ <span x-text="buttonPresses"></span>x geklickt!</p>
                    </div>

                    <!-- Amazing Button -->
                    <div class="text-center">
                        <p class="mb-4 text-green-400">KRASS!</p>
                        <button @click="addDiscovery('amazing_button', 15)" 
                                class="relative bg-gradient-to-r from-pink-500 to-yellow-500 px-10 py-4 rounded-full font-bold text-xl hover:scale-110 transform transition shadow-2xl animate-pulse">
                            <span class="absolute -top-2 -right-2 bg-red-500 text-white text-xs px-2 py-1 rounded-full">NEW!</span>
                            MEGA BUTTON 🔥
                        </button>
                        <p class="text-sm mt-2 text-green-400">✅ Unwiderstehlich!</p>
                    </div>
                </div>

                <div class="mt-8 bg-purple-800 bg-opacity-50 rounded-lg p-4">
                    <p class="font-bold">🧠 PSYCHO-FAKT:</p>
                    <p>Buttons die sich bewegen, Farbe ändern oder Feedback geben aktivieren dein Belohnungszentrum!</p>
                </div>
            </div>

            <button @click="currentZone = 'controls'" 
                    class="w-full bg-purple-600 hover:bg-purple-700 px-8 py-4 rounded-full text-xl font-bold">
                Weiter zu Controls →
            </button>
        </div>

        <!-- Zone 2: Interactive Controls -->
        <div x-show="currentZone === 'controls'" x-transition>
            <h2 class="text-4xl font-bold mb-8 text-center">Zone 2: Control Freak Paradise</h2>

            <div class="grid md:grid-cols-2 gap-8">
                <!-- Slider -->
                <div class="bg-black bg-opacity-30 rounded-xl p-6">
                    <h3 class="text-xl font-bold mb-4">🎚️ Slider = Macht</h3>
                    <input type="range" x-model="sliderValue" @input="addDiscovery('slider')"
                           class="w-full h-3 bg-gray-700 rounded-lg appearance-none cursor-pointer slider">
                    <div class="mt-4 text-center">
                        <p class="text-4xl font-bold" 
                           :style="'color: hsl(' + (sliderValue * 3.6) + ', 100%, 50%)'">
                           <span x-text="sliderValue"></span>%
                        </p>
                        <p class="text-sm text-gray-400">Menschen lieben Kontrolle!</p>
                    </div>
                </div>

                <!-- Switch -->
                <div class="bg-black bg-opacity-30 rounded-xl p-6">
                    <h3 class="text-xl font-bold mb-4">🔄 Switch = Instant Change</h3>
                    <div class="flex justify-center">
                        <button @click="switchOn = !switchOn; addDiscovery('switch')" 
                                class="relative w-20 h-10 rounded-full transition-colors duration-300"
                                :class="switchOn ? 'bg-green-500' : 'bg-gray-600'">
                            <div class="absolute top-1 transition-transform duration-300 w-8 h-8 bg-white rounded-full shadow-md"
                                 :class="switchOn ? 'translate-x-10' : 'translate-x-1'"></div>
                        </button>
                    </div>
                    <div class="mt-4 text-center">
                        <p class="text-2xl" x-text="switchOn ? '💡 AN!' : '🌙 AUS!'"></p>
                        <p class="text-sm text-gray-400">ON/OFF = Sofort-Befriedigung!</p>
                    </div>
                </div>

                <!-- Color Picker -->
                <div class="bg-black bg-opacity-30 rounded-xl p-6">
                    <h3 class="text-xl font-bold mb-4">🎨 Farben = Emotion</h3>
                    <div class="grid grid-cols-4 gap-2">
                        <template x-for="color in ['red', 'blue', 'green', 'yellow', 'purple', 'pink', 'orange', 'cyan']">
                            <button @click="selectedColor = color; addDiscovery('color_picker')" 
                                    :class="'bg-' + color + '-500'"
                                    class="w-full h-12 rounded-lg hover:scale-110 transition">
                            </button>
                        </template>
                    </div>
                    <div class="mt-4 text-center" x-show="selectedColor">
                        <p class="text-2xl">Deine Wahl: <span x-text="selectedColor" class="font-bold uppercase"></span></p>
                    </div>
                </div>

                <!-- Text Input -->
                <div class="bg-black bg-opacity-30 rounded-xl p-6">
                    <h3 class="text-xl font-bold mb-4">⌨️ Input = Personal</h3>
                    <input type="text" x-model="textInput" @input="addDiscovery('input')"
                           placeholder="Schreib was..." 
                           class="w-full px-4 py-3 bg-gray-800 rounded-lg text-white placeholder-gray-500">
                    <div class="mt-4" x-show="textInput.length > 0">
                        <p class="text-xl">Du sagst: <span class="font-bold text-yellow-400" x-text="textInput"></span></p>
                        <p class="text-sm text-gray-400">Persönlicher Input = Engagement!</p>
                    </div>
                </div>
            </div>

            <button @click="currentZone = 'advanced'" 
                    class="w-full bg-green-600 hover:bg-green-700 px-8 py-4 rounded-full text-xl font-bold mt-8">
                Advanced Stuff →
            </button>
        </div>

        <!-- Zone 3: Advanced Interactions -->
        <div x-show="currentZone === 'advanced'" x-transition>
            <h2 class="text-4xl font-bold mb-8 text-center">Zone 3: Next Level Interactions</h2>

            <div class="bg-black bg-opacity-30 rounded-2xl p-8">
                <h3 class="text-2xl font-bold mb-6">🎮 Gamification Elements</h3>

                <!-- Progress Bar -->
                <div class="mb-8">
                    <h4 class="text-xl mb-4">Progress Bars = Motivation</h4>
                    <div class="bg-gray-700 rounded-full h-8 relative overflow-hidden">
                        <div class="bg-gradient-to-r from-green-400 to-blue-600 h-full rounded-full transition-all duration-1000 flex items-center justify-end pr-4"
                             :style="'width: ' + satisfactionLevel + '%'">
                            <span class="text-sm font-bold" x-show="satisfactionLevel > 20">
                                <span x-text="satisfactionLevel"></span>%
                            </span>
                        </div>
                    </div>
                    <p class="text-sm text-gray-400 mt-2">Menschen MÜSSEN Bars füllen!</p>
                </div>

                <!-- Hover Effects -->
                <div class="mb-8">
                    <h4 class="text-xl mb-4">Hover = Discovery</h4>
                    <div class="grid grid-cols-3 gap-4">
                        <div @mouseenter="addDiscovery('hover1')" 
                             class="bg-gray-800 p-6 rounded-lg hover:bg-purple-600 transition-all duration-300 hover:scale-105 cursor-pointer">
                            <p class="text-center">Hover me! 👀</p>
                        </div>
                        <div @mouseenter="addDiscovery('hover2')" 
                             class="bg-gray-800 p-6 rounded-lg hover:rotate-6 transition-all duration-300 cursor-pointer">
                            <p class="text-center">Ich drehe! 🌀</p>
                        </div>
                        <div @mouseenter="addDiscovery('hover3')" 
                             class="bg-gray-800 p-6 rounded-lg hover:shadow-2xl hover:shadow-pink-500 transition-all duration-300 cursor-pointer">
                            <p class="text-center">Glow Effect! ✨</p>
                        </div>
                    </div>
                </div>

                <!-- Feedback -->
                <div class="bg-purple-800 bg-opacity-50 rounded-lg p-6">
                    <h4 class="text-xl font-bold mb-4">🧠 Die Psychologie dahinter:</h4>
                    <ul class="space-y-2">
                        <li>• <strong>Instant Feedback</strong> = Dopamin-Hit</li>
                        <li>• <strong>Smooth Animations</strong> = Gehirn denkt "Premium"</li>
                        <li>• <strong>Überraschungen</strong> = Neugier bleibt</li>
                        <li>• <strong>Personalisierung</strong> = "Das gehört mir!"</li>
                    </ul>
                </div>
            </div>

            <!-- Final Summary -->
            <div x-show="satisfactionLevel >= 90" class="mt-8 bg-gradient-to-r from-yellow-600 to-orange-600 rounded-2xl p-8 text-center">
                <h3 class="text-3xl font-bold mb-4">🏆 INTERACTION MASTER!</h3>
                <p class="text-xl mb-6">Du verstehst jetzt warum Menschen klicken!</p>

                <div class="bg-black bg-opacity-50 rounded-xl p-6">
                    <p class="text-lg mb-4">Nutze dieses Wissen:</p>
                    <ul class="space-y-2">
                        <li>✅ Mache Buttons unwiderstehlich</li>
                        <li>✅ Gib immer Feedback</li>
                        <li>✅ Überrasche die User</li>
                        <li>✅ Lass sie kontrollieren</li>
                    </ul>
                </div>

                <button class="mt-6 bg-white text-black px-8 py-4 rounded-full text-xl font-bold hover:scale-110 transition">
                    Ich will INTERAKTIVES bauen! 🚀
                </button>
            </div>
        </div>
    </div>

    <style>
        input[type="range"]::-webkit-slider-thumb {
            appearance: none;
            width: 20px;
            height: 20px;
            background: white;
            cursor: pointer;
            border-radius: 50%;
            box-shadow: 0 0 10px rgba(0,0,0,0.5);
        }
    </style>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    {
        "id": 5,
        "name": "🚀 Final Boss: Bau dein Ding!",
        "category": "edu_final",
        "level": 5,
        "duration": "∞",
        "description": "Alles gelernt - jetzt baust du!",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Final Boss - Build Mode</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-black text-white min-h-screen" x-data="{
    buildMode: false,
    playerLevel: 100,
    unlockedSkills: ['HTML', 'CSS', 'JavaScript', 'Design', 'Interactivity'],
    projectIdea: '',
    showCelebration: false,
    tips: [
        'Denk groß - die KI macht alles möglich!',
        'Nutze krasse Farben für Aufmerksamkeit',
        'Füge Animationen für Premium-Feel hinzu',
        'Mach es persönlich - User lieben das',
        'Mobile First - alle sind am Handy!'
    ],
    currentTip: 0
}">
    <!-- Epic Header -->
    <div class="relative overflow-hidden">
        <div class="absolute inset-0 bg-gradient-to-br from-purple-600 via-pink-600 to-orange-600 opacity-50"></div>
        <div class="relative z-10 text-center py-20">
            <h1 class="text-8xl font-bold mb-4 animate-pulse">
                🏆 FINAL BOSS
            </h1>
            <p class="text-3xl mb-8">Level <span x-text="playerLevel"></span> Web Builder</p>

            <!-- Skills -->
            <div class="flex justify-center gap-4 flex-wrap mb-8">
                <template x-for="skill in unlockedSkills">
                    <div class="bg-black bg-opacity-50 px-4 py-2 rounded-full border-2 border-yellow-400">
                        ⭐ <span x-text="skill"></span>
                    </div>
                </template>
            </div>
        </div>
    </div>

    <!-- Build Mode Toggle -->
    <div class="max-w-6xl mx-auto p-8">
        <div x-show="!buildMode" class="text-center">
            <div class="bg-gray-900 rounded-2xl p-12 mb-8">
                <h2 class="text-4xl font-bold mb-6">Ready to BUILD? 🚀</h2>
                <p class="text-xl mb-8 text-gray-400">Du hast alle Skills. Zeit sie zu nutzen!</p>

                <button @click="buildMode = true" 
                        class="bg-gradient-to-r from-green-400 to-blue-600 px-12 py-6 rounded-full text-3xl font-bold hover:scale-110 transform transition animate-bounce">
                    ENTER BUILD MODE
                </button>
            </div>

            <!-- Quick Recap -->
            <div class="grid md:grid-cols-5 gap-4">
                <div class="bg-orange-900 bg-opacity-50 rounded-lg p-4 text-center">
                    <p class="text-2xl mb-2">🏗️</p>
                    <p class="font-bold">HTML</p>
                    <p class="text-sm">Struktur</p>
                </div>
                <div class="bg-purple-900 bg-opacity-50 rounded-lg p-4 text-center">
                    <p class="text-2xl mb-2">🎨</p>
                    <p class="font-bold">CSS</p>
                    <p class="text-sm">Style</p>
                </div>
                <div class="bg-green-900 bg-opacity-50 rounded-lg p-4 text-center">
                    <p class="text-2xl mb-2">⚡</p>
                    <p class="font-bold">JS</p>
                    <p class="text-sm">Action</p>
                </div>
                <div class="bg-blue-900 bg-opacity-50 rounded-lg p-4 text-center">
                    <p class="text-2xl mb-2">🧠</p>
                    <p class="font-bold">Design</p>
                    <p class="text-sm">Psychology</p>
                </div>
                <div class="bg-pink-900 bg-opacity-50 rounded-lg p-4 text-center">
                    <p class="text-2xl mb-2">🎯</p>
                    <p class="font-bold">UX</p>
                    <p class="text-sm">Experience</p>
                </div>
            </div>
        </div>

        <!-- Build Mode Active -->
        <div x-show="buildMode" x-transition>
            <div class="bg-gradient-to-br from-gray-900 to-gray-800 rounded-2xl p-8 mb-8">
                <h2 class="text-4xl font-bold mb-8 text-center">
                    🛠️ BUILD MODE ACTIVATED
                </h2>

                <!-- Project Idea Generator -->
                <div class="mb-8">
                    <h3 class="text-2xl font-bold mb-4">Was willst du bauen?</h3>
                    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
                        <button @click="projectIdea = 'gaming'" 
                                class="bg-purple-800 hover:bg-purple-700 p-6 rounded-lg transition hover:scale-105">
                            <p class="text-2xl mb-2">🎮</p>
                            <p class="font-bold">Gaming Site</p>
                            <p class="text-sm">Stats, Leaderboards, Profile</p>
                        </button>

                        <button @click="projectIdea = 'social'" 
                                class="bg-blue-800 hover:bg-blue-700 p-6 rounded-lg transition hover:scale-105">
                            <p class="text-2xl mb-2">📱</p>
                            <p class="font-bold">Social Network</p>
                            <p class="text-sm">Posts, Likes, Stories</p>
                        </button>

                        <button @click="projectIdea = 'shop'" 
                                class="bg-green-800 hover:bg-green-700 p-6 rounded-lg transition hover:scale-105">
                            <p class="text-2xl mb-2">🛍️</p>
                            <p class="font-bold">Online Shop</p>
                            <p class="text-sm">Products, Cart, Checkout</p>
                        </button>

                        <button @click="projectIdea = 'portfolio'" 
                                class="bg-orange-800 hover:bg-orange-700 p-6 rounded-lg transition hover:scale-105">
                            <p class="text-2xl mb-2">💼</p>
                            <p class="font-bold">Portfolio</p>
                            <p class="text-sm">Projects, Skills, Contact</p>
                        </button>

                        <button @click="projectIdea = 'blog'" 
                                class="bg-pink-800 hover:bg-pink-700 p-6 rounded-lg transition hover:scale-105">
                            <p class="text-2xl mb-2">📝</p>
                            <p class="font-bold">Blog/Vlog</p>
                            <p class="text-sm">Articles, Videos, Comments</p>
                        </button>

                        <button @click="projectIdea = 'custom'" 
                                class="bg-gray-700 hover:bg-gray-600 p-6 rounded-lg transition hover:scale-105 border-2 border-yellow-400">
                            <p class="text-2xl mb-2">✨</p>
                            <p class="font-bold">Eigene Idee</p>
                            <p class="text-sm">Sky is the limit!</p>
                        </button>
                    </div>
                </div>

                <!-- AI Commands -->
                <div x-show="projectIdea" class="bg-black bg-opacity-50 rounded-xl p-6 mb-8">
                    <h3 class="text-2xl font-bold mb-4">🤖 KI-Commands für <span x-text="projectIdea" class="text-yellow-400 uppercase"></span>:</h3>

                    <div class="grid md:grid-cols-2 gap-6">
                        <div>
                            <h4 class="font-bold mb-3 text-green-400">Starter Commands:</h4>
                            <ul class="space-y-2 text-sm">
                                <li class="bg-gray-800 p-2 rounded">• "Erstelle eine <span x-text="projectIdea"></span> Website"</li>
                                <li class="bg-gray-800 p-2 rounded">• "Mach es modern und responsive"</li>
                                <li class="bg-gray-800 p-2 rounded">• "Nutze dunkles Theme mit Neon-Akzenten"</li>
                                <li class="bg-gray-800 p-2 rounded">• "Füge coole Hover-Effekte hinzu"</li>
                            </ul>
                        </div>

                        <div>
                            <h4 class="font-bold mb-3 text-purple-400">Power Commands:</h4>
                            <ul class="space-y-2 text-sm">
                                <li class="bg-gray-800 p-2 rounded">• "Füge Animationen beim Scrollen hinzu"</li>
                                <li class="bg-gray-800 p-2 rounded">• "Mache es interaktiv mit Alpine.js"</li>
                                <li class="bg-gray-800 p-2 rounded">• "Füge Sound-Effekte hinzu"</li>
                                <li class="bg-gray-800 p-2 rounded">• "Erstelle ein Easter Egg"</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Pro Tips Carousel -->
                <div class="bg-gradient-to-r from-yellow-900 to-orange-900 rounded-xl p-6 mb-8">
                    <h3 class="text-xl font-bold mb-4">💡 PRO TIP:</h3>
                    <p class="text-lg mb-4" x-text="tips[currentTip]"></p>
                    <button @click="currentTip = (currentTip + 1) % tips.length" 
                            class="bg-yellow-600 hover:bg-yellow-700 px-4 py-2 rounded-full text-sm">
                        Nächster Tipp →
                    </button>
                </div>

                <!-- Launch Button -->
                <div class="text-center">
                    <button @click="showCelebration = true" 
                            class="bg-gradient-to-r from-green-400 via-blue-500 to-purple-600 px-12 py-6 rounded-full text-2xl font-bold hover:scale-110 transform transition relative">
                        <span class="absolute -top-2 -right-2 bg-red-500 text-white text-xs px-2 py-1 rounded-full animate-ping">LIVE</span>
                        START BUILDING NOW! 🚀
                    </button>
                </div>
            </div>

            <!-- Cheat Sheet -->
            <div class="bg-gray-900 rounded-2xl p-8">
                <h3 class="text-2xl font-bold mb-6">📋 Ultimate Cheat Sheet</h3>

                <div class="grid md:grid-cols-3 gap-6">
                    <div>
                        <h4 class="font-bold mb-3 text-orange-400">Struktur-Hacks:</h4>
                        <ul class="space-y-1 text-sm text-gray-400">
                            <li>• Header oben</li>
                            <li>• Navigation sticky</li>
                            <li>• Hero Section groß</li>
                            <li>• Footer unten</li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="font-bold mb-3 text-purple-400">Style-Hacks:</h4>
                        <ul class="space-y-1 text-sm text-gray-400">
                            <li>• Gradients = Modern</li>
                            <li>• Shadows = Tiefe</li>
                            <li>• Rounded = Friendly</li>
                            <li>• Animations = Leben</li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="font-bold mb-3 text-green-400">UX-Hacks:</h4>
                        <ul class="space-y-1 text-sm text-gray-400">
                            <li>• Buttons groß</li>
                            <li>• Feedback instant</li>
                            <li>• Mobile first</li>
                            <li>• Loading states</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Celebration -->
        <div x-show="showCelebration" x-transition 
             class="fixed inset-0 bg-black bg-opacity-90 flex items-center justify-center z-50">
            <div class="text-center">
                <h2 class="text-6xl font-bold mb-8 animate-bounce">
                    🎉 LEGEND STATUS! 🎉
                </h2>
                <p class="text-2xl mb-8">Du bist jetzt ein Web Builder!</p>

                <div class="bg-gradient-to-r from-purple-600 to-pink-600 rounded-2xl p-8">
                    <p class="text-xl mb-4">Remember:</p>
                    <p class="text-lg">Mit KI kannst du ALLES bauen.</p>
                    <p class="text-lg">Du hast das Wissen.</p>
                    <p class="text-lg font-bold mt-4">GO CREATE! 🚀</p>
                </div>

                <button @click="showCelebration = false" 
                        class="mt-8 bg-white text-black px-8 py-4 rounded-full text-xl font-bold">
                    Let's GO! 💪
                </button>
            </div>
        </div>
    </div>

    <!-- Floating Action Buttons -->
    <div class="fixed bottom-8 right-8 space-y-4">
        <button class="bg-purple-600 hover:bg-purple-700 w-16 h-16 rounded-full shadow-lg flex items-center justify-center text-2xl hover:scale-110 transition">
            💬
        </button>
        <button class="bg-green-600 hover:bg-green-700 w-16 h-16 rounded-full shadow-lg flex items-center justify-center text-2xl hover:scale-110 transition">
            ?
        </button>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    }
]


# Database Integration
async def save_edu_templates_to_db(db: AsyncSession):
    """Save educational templates to database"""
    for template_data in edu_templates:
        template = Template(
            name=template_data["name"],
            category=template_data["category"],
            description=template_data["description"],
            html=template_data["html"],
            css=template_data["css"],
            js=template_data["js"],
            is_active=True,
            order_index=template_data["id"],
            metadata={
                "level": template_data.get("level", 1),
                "duration": template_data.get("duration", ""),
                "module": template_data.get("module", "")
            }
        )
        db.add(template)
    await db.commit()


# Learning Path Structure
learning_path = {
    "title": "Web Development Mastery - TikTok Style",
    "description": "Lerne Web Development wie ein Game - schnell, spaßig, sofort!",
    "modules": [
        {
            "id": 1,
            "name": "⚡ Speed Run",
            "description": "60 Sekunden Challenges - Instant Gratification",
            "templates": [1]
        },
        {
            "id": 2,
            "name": "🎮 Game Theory",
            "description": "Websites als Games verstehen",
            "templates": [2]
        },
        {
            "id": 3,
            "name": "🧠 Design Psychology",
            "description": "Warum Dinge geil aussehen",
            "templates": [3]
        },
        {
            "id": 4,
            "name": "🎯 Interaction Design",
            "description": "Touch, Click, Swipe - Die Psychologie",
            "templates": [4]
        },
        {
            "id": 5,
            "name": "🚀 Final Boss",
            "description": "Build Mode - Jetzt baust du!",
            "templates": [5]
        }
    ],
    "achievements": [
        {"name": "Speed Demon", "requirement": "Complete 60 second challenge"},
        {"name": "Game Master", "requirement": "Understand website = game"},
        {"name": "Design Guru", "requirement": "Master all design principles"},
        {"name": "Interaction Expert", "requirement": "Create engaging interactions"},
        {"name": "Web Builder", "requirement": "Complete final boss"}
    ]
}