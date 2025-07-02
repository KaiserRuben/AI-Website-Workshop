-- Migration: Gamified Templates
-- Category: gamified
-- Purpose: Game-based learning for Gen Z developers

INSERT INTO templates (name, description, html, css, js, category, is_active, order_index, template_metadata) VALUES

-- Template 1: Speed Builder Challenge
('⚡ Speed Builder Challenge', '60 Sekunden Website-Bau Challenge - Wie schnell bist du?',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Speed Builder Challenge</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-black text-white min-h-screen" x-data="{
    // Game state
    gameState: ''menu'', // menu, playing, results, leaderboard
    timeLeft: 60,
    score: 0,
    combo: 0,
    maxCombo: 0,
    playerName: '''',

    // Challenges
    currentChallenge: null,
    completedChallenges: [],
    availableChallenges: [
        {
            id: 1,
            task: ''🎨 Mach den Hintergrund NEON PINK!'',
            command: ''background neon pink'',
            points: 100,
            difficulty: ''easy'',
            timeBonus: 5
        },
        {
            id: 2,
            task: ''🌈 Füge einen REGENBOGEN-GRADIENT hinzu!'',
            command: ''gradient rainbow'',
            points: 200,
            difficulty: ''medium'',
            timeBonus: 7
        },
        {
            id: 3,
            task: ''💫 Lass ALLES ROTIEREN!'',
            command: ''rotate everything'',
            points: 150,
            difficulty: ''easy'',
            timeBonus: 5
        },
        {
            id: 4,
            task: ''🎪 Mach KONFETTI-REGEN!'',
            command: ''confetti rain'',
            points: 300,
            difficulty: ''hard'',
            timeBonus: 10
        },
        {
            id: 5,
            task: ''🔥 FEUER-ANIMATION überall!'',
            command: ''fire animation'',
            points: 250,
            difficulty: ''medium'',
            timeBonus: 8
        },
        {
            id: 6,
            task: ''👾 RETRO 8-BIT Style!'',
            command: ''retro 8bit'',
            points: 200,
            difficulty: ''medium'',
            timeBonus: 7
        },
        {
            id: 7,
            task: ''🌊 WELLEN-ANIMATION!'',
            command: ''wave animation'',
            points: 180,
            difficulty: ''medium'',
            timeBonus: 6
        },
        {
            id: 8,
            task: ''⚡ BLITZ-EFFEKTE!'',
            command: ''lightning effects'',
            points: 350,
            difficulty: ''hard'',
            timeBonus: 12
        }
    ],

    // Effects
    effects: {
        neonPink: false,
        rainbow: false,
        rotating: false,
        confetti: false,
        fire: false,
        retro: false,
        waves: false,
        lightning: false
    },

    // Sound effects (simulated)
    soundEnabled: true,

    // Leaderboard
    leaderboard: [
        { name: ''SpeedCoder'', score: 2850, time: ''58s'' },
        { name: ''CSSNinja'', score: 2650, time: ''55s'' },
        { name: ''HTMLHero'', score: 2400, time: ''60s'' },
        { name: ''WebWizard'', score: 2200, time: ''52s'' },
        { name: ''CodeRacer'', score: 2000, time: ''60s'' }
    ],

    // Methods
    startGame() {
        this.gameState = ''playing'';
        this.timeLeft = 60;
        this.score = 0;
        this.combo = 0;
        this.maxCombo = 0;
        this.completedChallenges = [];
        this.resetEffects();
        this.getNewChallenge();
        this.startTimer();
    },

    startTimer() {
        const timer = setInterval(() => {
            if (this.timeLeft > 0 && this.gameState === ''playing'') {
                this.timeLeft--;
            } else {
                clearInterval(timer);
                if (this.gameState === ''playing'') {
                    this.endGame();
                }
            }
        }, 1000);
    },

    getNewChallenge() {
        const available = this.availableChallenges.filter(c =>
            !this.completedChallenges.includes(c.id)
        );

        if (available.length === 0) {
            // All challenges completed - restart with bonus
            this.completedChallenges = [];
            this.score += 500;
            this.showNotification(''🎯 ALL CHALLENGES COMPLETED! +500 BONUS!'');
        }

        this.currentChallenge = available[Math.floor(Math.random() * available.length)];
    },

    completeChallenge(challengeId) {
        if (this.currentChallenge && this.currentChallenge.id === challengeId) {
            // Calculate score with combo
            this.combo++;
            if (this.combo > this.maxCombo) this.maxCombo = this.combo;

            const basePoints = this.currentChallenge.points;
            const comboBonus = this.combo > 1 ? (this.combo - 1) * 50 : 0;
            const totalPoints = basePoints + comboBonus;

            this.score += totalPoints;
            this.timeLeft += this.currentChallenge.timeBonus;
            this.completedChallenges.push(challengeId);

            // Apply effect
            this.applyEffect(challengeId);

            // Show notification
            if (this.combo > 1) {
                this.showNotification(`🔥 ${this.combo}x COMBO! +${totalPoints} POINTS!`);
            } else {
                this.showNotification(`✅ +${totalPoints} POINTS!`);
            }

            // Get next challenge
            this.getNewChallenge();
        }
    },

    applyEffect(challengeId) {
        switch(challengeId) {
            case 1: this.effects.neonPink = true; break;
            case 2: this.effects.rainbow = true; break;
            case 3: this.effects.rotating = true; break;
            case 4: this.effects.confetti = true; break;
            case 5: this.effects.fire = true; break;
            case 6: this.effects.retro = true; break;
            case 7: this.effects.waves = true; break;
            case 8: this.effects.lightning = true; break;
        }
    },

    resetEffects() {
        Object.keys(this.effects).forEach(key => {
            this.effects[key] = false;
        });
    },

    showNotification(text) {
        // This would show a notification in real implementation
        console.log(text);
    },

    endGame() {
        this.gameState = ''results'';

        // Check if high score
        const lowestScore = Math.min(...this.leaderboard.map(e => e.score));
        if (this.score > lowestScore) {
            this.showNotification(''🏆 NEW HIGH SCORE!'');
        }
    },

    submitScore() {
        if (this.playerName) {
            this.leaderboard.push({
                name: this.playerName,
                score: this.score,
                time: `${60 - this.timeLeft}s`
            });

            // Sort leaderboard
            this.leaderboard.sort((a, b) => b.score - a.score);
            this.leaderboard = this.leaderboard.slice(0, 10); // Keep top 10

            this.gameState = ''leaderboard'';
        }
    },

    get timeFormatted() {
        const minutes = Math.floor(this.timeLeft / 60);
        const seconds = this.timeLeft % 60;
        return `${minutes}:${seconds.toString().padStart(2, ''0'')}`;
    }
}"
:class="{
    ''bg-pink-900'': effects.neonPink,
    ''bg-gradient-to-br from-red-500 via-yellow-500 via-green-500 via-blue-500 to-purple-500'': effects.rainbow,
    ''animate-spin-slow'': effects.rotating,
    ''pixelated'': effects.retro
}">
    <!-- Menu Screen -->
    <div x-show="gameState === ''menu''" x-transition class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-4xl mx-auto px-8">
            <!-- Logo/Title -->
            <div class="mb-12">
                <h1 class="text-8xl font-bold mb-4 animate-pulse bg-gradient-to-r from-yellow-400 via-pink-500 to-purple-600 bg-clip-text text-transparent">
                    SPEED BUILDER
                </h1>
                <p class="text-3xl text-pink-400">60 Second Challenge</p>
            </div>

            <!-- Instructions -->
            <div class="bg-gray-900 rounded-3xl p-8 mb-8 backdrop-blur-lg bg-opacity-80">
                <h2 class="text-2xl font-bold mb-6 text-yellow-400">🎮 How to Play</h2>
                <div class="grid md:grid-cols-3 gap-6 text-left">
                    <div class="bg-gray-800 rounded-xl p-4">
                        <div class="text-3xl mb-2">⚡</div>
                        <h3 class="font-bold mb-2">Be Fast!</h3>
                        <p class="text-sm text-gray-400">Complete challenges before time runs out</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <div class="text-3xl mb-2">🎯</div>
                        <h3 class="font-bold mb-2">Follow Commands</h3>
                        <p class="text-sm text-gray-400">Tell the AI exactly what each challenge wants</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <div class="text-3xl mb-2">🔥</div>
                        <h3 class="font-bold mb-2">Build Combos</h3>
                        <p class="text-sm text-gray-400">Chain challenges for bonus points!</p>
                    </div>
                </div>
            </div>

            <!-- Start Button -->
            <button @click="startGame"
                    class="px-12 py-6 bg-gradient-to-r from-green-400 to-blue-500 rounded-full text-3xl font-bold hover:scale-110 transform transition animate-bounce">
                START GAME! 🚀
            </button>

            <!-- Leaderboard Preview -->
            <div class="mt-8">
                <button @click="gameState = ''leaderboard''"
                        class="text-yellow-400 hover:text-yellow-300 underline">
                    View Leaderboard 🏆
                </button>
            </div>
        </div>
    </div>

    <!-- Game Screen -->
    <div x-show="gameState === ''playing''" x-transition class="min-h-screen relative">
        <!-- Game HUD -->
        <div class="fixed top-0 left-0 right-0 bg-black bg-opacity-90 p-4 z-50">
            <div class="max-w-6xl mx-auto flex justify-between items-center">
                <!-- Timer -->
                <div class="text-center">
                    <div class="text-5xl font-bold"
                         :class="timeLeft < 10 ? ''text-red-500 animate-pulse'' : ''text-green-400''">
                        <span x-text="timeFormatted"></span>
                    </div>
                    <div class="text-sm text-gray-400">TIME</div>
                </div>

                <!-- Score -->
                <div class="text-center">
                    <div class="text-5xl font-bold text-yellow-400">
                        <span x-text="score.toLocaleString()"></span>
                    </div>
                    <div class="text-sm text-gray-400">SCORE</div>
                </div>

                <!-- Combo -->
                <div class="text-center">
                    <div class="text-5xl font-bold"
                         :class="combo > 0 ? ''text-orange-400'' : ''text-gray-600''">
                        <span x-text="combo"></span>x
                    </div>
                    <div class="text-sm text-gray-400">COMBO</div>
                </div>
            </div>
        </div>

        <!-- Current Challenge -->
        <div class="flex items-center justify-center min-h-screen pt-32">
            <div class="max-w-4xl w-full mx-auto px-8">
                <div x-show="currentChallenge"
                     class="bg-gray-900 rounded-3xl p-12 shadow-2xl transform transition hover:scale-105">
                    <div class="text-center">
                        <!-- Challenge Number -->
                        <div class="text-sm text-gray-400 mb-2">
                            CHALLENGE #<span x-text="completedChallenges.length + 1"></span>
                        </div>

                        <!-- Challenge Task -->
                        <h2 class="text-4xl font-bold mb-6" x-text="currentChallenge?.task"></h2>

                        <!-- Points & Difficulty -->
                        <div class="flex justify-center gap-6 mb-8">
                            <div class="bg-gray-800 rounded-lg px-4 py-2">
                                <span class="text-yellow-400 font-bold" x-text="currentChallenge?.points"></span> POINTS
                            </div>
                            <div class="bg-gray-800 rounded-lg px-4 py-2">
                                +<span x-text="currentChallenge?.timeBonus"></span>s TIME
                            </div>
                            <div class="rounded-lg px-4 py-2"
                                 :class="{
                                     ''bg-green-800'': currentChallenge?.difficulty === ''easy'',
                                     ''bg-yellow-800'': currentChallenge?.difficulty === ''medium'',
                                     ''bg-red-800'': currentChallenge?.difficulty === ''hard''
                                 }">
                                <span x-text="currentChallenge?.difficulty?.toUpperCase()"></span>
                            </div>
                        </div>

                        <!-- Command Hint -->
                        <div class="bg-gray-800 rounded-xl p-4">
                            <p class="text-sm text-gray-400 mb-2">Say to the AI:</p>
                            <p class="text-xl font-mono text-green-400">
                                "<span x-text="currentChallenge?.command"></span>"
                            </p>
                        </div>

                        <!-- Action Buttons (Simulated) -->
                        <div class="mt-8 grid grid-cols-2 gap-4">
                            <button @click="completeChallenge(currentChallenge.id)"
                                    class="bg-green-600 hover:bg-green-700 px-6 py-3 rounded-xl font-bold transform hover:scale-105 transition">
                                ✅ Complete!
                            </button>
                            <button @click="combo = 0; getNewChallenge()"
                                    class="bg-red-600 hover:bg-red-700 px-6 py-3 rounded-xl font-bold transform hover:scale-105 transition">
                                ❌ Skip (-combo)
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Progress Bar -->
                <div class="mt-8">
                    <div class="bg-gray-800 rounded-full h-4">
                        <div class="bg-gradient-to-r from-green-400 to-blue-500 h-full rounded-full transition-all duration-300"
                             :style="`width: ${(completedChallenges.length / availableChallenges.length) * 100}%`"></div>
                    </div>
                    <p class="text-center mt-2 text-gray-400">
                        <span x-text="completedChallenges.length"></span> / <span x-text="availableChallenges.length"></span> Challenges
                    </p>
                </div>
            </div>
        </div>

        <!-- Visual Effects -->
        <div class="fixed inset-0 pointer-events-none">
            <!-- Confetti -->
            <div x-show="effects.confetti" class="absolute inset-0">
                <div class="confetti-container">
                    <div class="confetti"></div>
                    <div class="confetti"></div>
                    <div class="confetti"></div>
                    <div class="confetti"></div>
                    <div class="confetti"></div>
                </div>
            </div>

            <!-- Fire -->
            <div x-show="effects.fire" class="absolute bottom-0 left-0 right-0 h-32">
                <div class="fire-effect"></div>
            </div>

            <!-- Lightning -->
            <div x-show="effects.lightning" class="absolute inset-0">
                <div class="lightning-flash"></div>
            </div>

            <!-- Waves -->
            <div x-show="effects.waves" class="absolute inset-0">
                <div class="wave-effect"></div>
            </div>
        </div>
    </div>

    <!-- Results Screen -->
    <div x-show="gameState === ''results''" x-transition class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-2xl mx-auto px-8">
            <h1 class="text-6xl font-bold mb-8">🏁 TIME''S UP!</h1>

            <!-- Final Score -->
            <div class="bg-gray-900 rounded-3xl p-8 mb-8">
                <div class="text-7xl font-bold text-yellow-400 mb-4">
                    <span x-text="score.toLocaleString()"></span>
                </div>
                <p class="text-2xl text-gray-400">FINAL SCORE</p>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-3 gap-4 mb-8">
                <div class="bg-gray-800 rounded-xl p-4">
                    <div class="text-3xl font-bold text-green-400" x-text="completedChallenges.length"></div>
                    <div class="text-sm text-gray-400">Challenges</div>
                </div>
                <div class="bg-gray-800 rounded-xl p-4">
                    <div class="text-3xl font-bold text-orange-400" x-text="maxCombo"></div>
                    <div class="text-sm text-gray-400">Max Combo</div>
                </div>
                <div class="bg-gray-800 rounded-xl p-4">
                    <div class="text-3xl font-bold text-purple-400">
                        <span x-text="60 - timeLeft"></span>s
                    </div>
                    <div class="text-sm text-gray-400">Time Used</div>
                </div>
            </div>

            <!-- Name Input -->
            <div class="mb-8">
                <input type="text"
                       x-model="playerName"
                       placeholder="Enter your name for leaderboard"
                       class="px-6 py-3 bg-gray-800 rounded-xl text-xl w-full max-w-md"
                       @keyup.enter="submitScore">
            </div>

            <!-- Actions -->
            <div class="flex gap-4 justify-center">
                <button @click="submitScore"
                        :disabled="!playerName"
                        :class="!playerName ? ''opacity-50'' : ''hover:bg-green-700''"
                        class="px-8 py-3 bg-green-600 rounded-xl font-bold">
                    Submit Score 📊
                </button>
                <button @click="startGame"
                        class="px-8 py-3 bg-blue-600 hover:bg-blue-700 rounded-xl font-bold">
                    Play Again 🔄
                </button>
                <button @click="gameState = ''menu''"
                        class="px-8 py-3 bg-gray-600 hover:bg-gray-700 rounded-xl font-bold">
                    Main Menu 🏠
                </button>
            </div>
        </div>
    </div>

    <!-- Leaderboard Screen -->
    <div x-show="gameState === ''leaderboard''" x-transition class="min-h-screen flex items-center justify-center">
        <div class="max-w-4xl w-full mx-auto px-8">
            <h1 class="text-5xl font-bold text-center mb-8">🏆 LEADERBOARD</h1>

            <div class="bg-gray-900 rounded-3xl p-8">
                <div class="space-y-4">
                    <template x-for="(entry, index) in leaderboard" :key="index">
                        <div class="flex items-center justify-between bg-gray-800 rounded-xl p-4"
                             :class="{
                                 ''bg-gradient-to-r from-yellow-600 to-yellow-800'': index === 0,
                                 ''bg-gradient-to-r from-gray-600 to-gray-700'': index === 1,
                                 ''bg-gradient-to-r from-orange-700 to-orange-800'': index === 2
                             }">
                            <div class="flex items-center gap-4">
                                <div class="text-2xl font-bold w-12">
                                    <span x-show="index === 0">🥇</span>
                                    <span x-show="index === 1">🥈</span>
                                    <span x-show="index === 2">🥉</span>
                                    <span x-show="index > 2" x-text="index + 1"></span>
                                </div>
                                <div>
                                    <div class="font-bold text-xl" x-text="entry.name"></div>
                                    <div class="text-sm text-gray-300">
                                        Time: <span x-text="entry.time"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="text-3xl font-bold text-yellow-400">
                                <span x-text="entry.score.toLocaleString()"></span>
                            </div>
                        </div>
                    </template>
                </div>
            </div>

            <div class="text-center mt-8">
                <button @click="gameState = ''menu''"
                        class="px-8 py-3 bg-purple-600 hover:bg-purple-700 rounded-xl font-bold">
                    Back to Menu
                </button>
            </div>
        </div>
    </div>

    <style>
        /* Custom animations */
        @keyframes spin-slow {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .animate-spin-slow {
            animation: spin-slow 20s linear infinite;
        }

        /* Retro/Pixelated effect */
        .pixelated {
            image-rendering: pixelated;
            font-family: ''Courier New'', monospace;
        }

        /* Confetti animation */
        @keyframes confetti-fall {
            0% { transform: translateY(-100vh) rotate(0deg); opacity: 1; }
            100% { transform: translateY(100vh) rotate(720deg); opacity: 0; }
        }

        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: linear-gradient(45deg, #ff0080, #ff8c00, #ffd700, #00ff00, #00ffff, #0080ff, #8000ff);
            animation: confetti-fall 3s linear infinite;
        }

        .confetti:nth-child(1) { left: 10%; animation-delay: 0s; }
        .confetti:nth-child(2) { left: 30%; animation-delay: 0.5s; }
        .confetti:nth-child(3) { left: 50%; animation-delay: 1s; }
        .confetti:nth-child(4) { left: 70%; animation-delay: 1.5s; }
        .confetti:nth-child(5) { left: 90%; animation-delay: 2s; }

        /* Fire effect */
        .fire-effect {
            width: 100%;
            height: 100%;
            background: linear-gradient(to top, #ff0000, #ff8c00, transparent);
            filter: blur(8px);
            animation: fire-flicker 0.5s ease-in-out infinite alternate;
        }

        @keyframes fire-flicker {
            0% { opacity: 0.8; transform: scaleY(1); }
            100% { opacity: 1; transform: scaleY(1.1); }
        }

        /* Lightning effect */
        @keyframes lightning-flash {
            0%, 90% { opacity: 0; }
            95% { opacity: 1; }
            100% { opacity: 0; }
        }

        .lightning-flash {
            position: absolute;
            inset: 0;
            background: white;
            animation: lightning-flash 2s infinite;
        }

        /* Wave effect */
        @keyframes wave {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        .wave-effect {
            position: absolute;
            inset: 0;
            background: repeating-linear-gradient(
                90deg,
                transparent,
                transparent 50px,
                rgba(0, 150, 255, 0.5) 50px,
                rgba(0, 150, 255, 0.5) 100px
            );
            animation: wave 3s linear infinite;
        }
    </style>
</body>
</html>', '', '', 'gamified', true, 1, '{"level": 1, "duration": "5-10 min", "skills": ["Speed", "Commands", "Visual Effects"]}'),

-- Template 2: Design Psychology Lab
('🧠 Design Psychology Lab', 'Wissenschaftlich fundierte Design-Prinzipien spielerisch lernen',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Design Psychology Lab</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        /* Research scanner effect */
        @keyframes scan {
            0% { transform: translateY(-100%); }
            100% { transform: translateY(100%); }
        }

        .scanner {
            background: linear-gradient(to bottom, transparent, rgba(59, 130, 246, 0.5), transparent);
            animation: scan 2s linear infinite;
        }

        /* Mind expansion effect */
        @keyframes mind-expand {
            0% { transform: scale(0) rotate(0deg); opacity: 0; }
            50% { transform: scale(1.2) rotate(180deg); opacity: 1; }
            100% { transform: scale(1) rotate(360deg); opacity: 0; }
        }

        .mind-expand {
            animation: mind-expand 1s ease-out;
        }
    </style>
</head>
<body class="bg-gray-900 text-white min-h-screen" x-data="{
    // Lab state
    currentModule: ''intro'',
    labScore: 0,
    researchPoints: 0,
    unlockedPrinciples: [],
    currentExperiment: null,

    // User profile
    designPersonality: null,
    learningPath: []
    culturalContext: ''western'',

    // Research data
    principles: {
        gestalt: {
            id: ''gestalt'',
            name: ''Gestalt Principles'',
            icon: ''🧩'',
            research: ''Wertheimer (1923): Human brain organizes visual elements into unified wholes'',
            experiments: [
                {
                    name: ''Proximity Test'',
                    description: ''Elements close together are perceived as related'',
                    interactive: true
                },
                {
                    name: ''Similarity Scanner'',
                    description: ''Similar elements are grouped by the brain'',
                    interactive: true
                }
            ],
            unlocked: false
        },
        color: {
            id: ''color'',
            name: ''Color Psychology'',
            icon: ''🎨'',
            research: ''Elliot & Maier (2014): Colors trigger specific psychological and physiological responses'',
            experiments: [
                {
                    name: ''Emotion Color Map'',
                    description: ''Map colors to emotional responses'',
                    interactive: true
                },
                {
                    name: ''Cultural Color Test'',
                    description: ''How color meanings change across cultures'',
                    interactive: true
                }
            ],
            unlocked: false
        },
        typography: {
            id: ''typography'',
            name: ''Typography Science'',
            icon: ''🔤'',
            research: ''Larson et al. (2006): Typography affects reading speed and comprehension by up to 35%'',
            experiments: [
                {
                    name: ''Readability Analyzer'',
                    description: ''Test reading speed with different fonts'',
                    interactive: true
                },
                {
                    name: ''Personality Fonts'',
                    description: ''How fonts convey personality traits'',
                    interactive: true
                }
            ],
            unlocked: false
        },
        whitespace: {
            id: ''whitespace'',
            name: ''Spatial Dynamics'',
            icon: ''📐'',
            research: ''Pracejus et al. (2013): White space directly correlates with perceived value and luxury'',
            experiments: [
                {
                    name: ''Luxury Perception Test'',
                    description: ''How spacing affects value perception'',
                    interactive: true
                },
                {
                    name: ''Cognitive Load Reducer'',
                    description: ''Optimize spacing for mental processing'',
                    interactive: true
                }
            ],
            unlocked: false
        },
        attention: {
            id: ''attention'',
            name: ''Attention Engineering'',
            icon: ''👁️'',
            research: ''Itti & Koch (2001): Visual attention follows predictable patterns based on contrast and motion'',
            experiments: [
                {
                    name: ''Eye Tracking Simulator'',
                    description: ''Predict where users look first'',
                    interactive: true
                },
                {
                    name: ''Attention Heatmap'',
                    description: ''Create optimal visual hierarchies'',
                    interactive: true
                }
            ],
            unlocked: false
        }
    },

    // Interactive experiments
    experiments: {
        proximityTest: {
            dots: [],
            userGroups: 0,
            actualGroups: 3
        },
        colorEmotion: {
            emotions: [''Happy'', ''Sad'', ''Energetic'', ''Calm'', ''Angry'', ''Peaceful''],
            colorMap: {}
        },
        readabilityTest: {
            fonts: [''Arial'', ''Times New Roman'', ''Comic Sans'', ''Georgia'', ''Helvetica''],
            readingTimes: {},
            currentFont: ''Arial'',
            startTime: null
        }
    },

    // Methods
    startLab() {
        this.currentModule = ''personality-test'';
    },

    setPersonality(type) {
        this.designPersonality = type;
        this.labScore += 100;
        this.showNotification(`Design Personality: ${type}!`, ''success'');
        this.currentModule = ''research-hub'';
    },

    unlockPrinciple(principleId) {
        if (!this.principles[principleId].unlocked && this.researchPoints >= 50) {
            this.principles[principleId].unlocked = true;
            this.researchPoints -= 50;
            this.unlockedPrinciples.push(principleId);
            this.showNotification(`Unlocked: ${this.principles[principleId].name}!`, ''unlock'');
        }
    },

    startExperiment(principleId, experimentIndex) {
        this.currentExperiment = {
            principle: principleId,
            experiment: this.principles[principleId].experiments[experimentIndex],
            index: experimentIndex
        };
        this.currentModule = ''experiment'';
    },

    completeExperiment(score) {
        this.labScore += score;
        this.researchPoints += Math.floor(score / 10);
        this.learningPath.push(this.currentExperiment);
        this.showNotification(`Experiment Complete! +${score} points`, ''success'');
        this.currentModule = ''research-hub'';
    },

    showNotification(message, type) {
        // This would show animated notifications
        console.log(`[${type}] ${message}`);
    },

    // Experiment: Proximity Test
    initProximityTest() {
        // Generate dots in groups
        this.experiments.proximityTest.dots = [
            // Group 1
            { x: 20, y: 20, group: 1 },
            { x: 25, y: 25, group: 1 },
            { x: 30, y: 20, group: 1 },
            // Group 2
            { x: 60, y: 30, group: 2 },
            { x: 65, y: 35, group: 2 },
            { x: 70, y: 30, group: 2 },
            // Group 3
            { x: 40, y: 60, group: 3 },
            { x: 45, y: 65, group: 3 },
            { x: 50, y: 60, group: 3 }
        ];
    },

    // Initialize
    init() {
        this.initProximityTest();
    }
}">
    <!-- Lab Header -->
    <header class="fixed top-0 left-0 right-0 bg-black bg-opacity-90 backdrop-blur-lg z-50 border-b border-blue-500">
        <div class="max-w-7xl mx-auto px-4 py-4">
            <div class="flex justify-between items-center">
                <div class="flex items-center gap-4">
                    <h1 class="text-2xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
                        Design Psychology Lab
                    </h1>
                    <div class="text-sm text-gray-400">
                        <span x-show="designPersonality">
                            <span class="text-green-400">●</span> <span x-text="designPersonality"></span>
                        </span>
                    </div>
                </div>

                <div class="flex items-center gap-6">
                    <div class="text-center">
                        <div class="text-2xl font-bold text-yellow-400" x-text="labScore"></div>
                        <div class="text-xs text-gray-400">Lab Score</div>
                    </div>
                    <div class="text-center">
                        <div class="text-2xl font-bold text-blue-400" x-text="researchPoints"></div>
                        <div class="text-xs text-gray-400">Research Points</div>
                    </div>
                    <div class="text-center">
                        <div class="text-2xl font-bold text-purple-400" x-text="unlockedPrinciples.length"></div>
                        <div class="text-xs text-gray-400">Discoveries</div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="pt-20 min-h-screen">
        <!-- Intro Module -->
        <section x-show="currentModule === ''intro''" x-transition
                 class="flex items-center justify-center min-h-screen">
            <div class="text-center max-w-4xl mx-auto px-8">
                <div class="mb-8">
                    <div class="text-8xl mb-4 animate-pulse">🧠</div>
                    <h1 class="text-6xl font-bold mb-4 bg-gradient-to-r from-cyan-400 to-purple-400 bg-clip-text text-transparent">
                        Design Psychology Lab
                    </h1>
                    <p class="text-2xl text-gray-400">Where Science Meets Creativity</p>
                </div>

                <div class="bg-gray-800 rounded-3xl p-8 mb-8 backdrop-blur-lg bg-opacity-80">
                    <h2 class="text-2xl font-bold mb-6 text-blue-400">🔬 Your Mission</h2>
                    <div class="grid md:grid-cols-3 gap-6">
                        <div class="bg-gray-900 rounded-xl p-6">
                            <div class="text-3xl mb-3">🧪</div>
                            <h3 class="font-bold mb-2">Experiment</h3>
                            <p class="text-sm text-gray-400">Conduct interactive design experiments</p>
                        </div>
                        <div class="bg-gray-900 rounded-xl p-6">
                            <div class="text-3xl mb-3">📊</div>
                            <h3 class="font-bold mb-2">Analyze</h3>
                            <p class="text-sm text-gray-400">Understand the psychology behind design</p>
                        </div>
                        <div class="bg-gray-900 rounded-xl p-6">
                            <div class="text-3xl mb-3">🏆</div>
                            <h3 class="font-bold mb-2">Master</h3>
                            <p class="text-sm text-gray-400">Apply principles to create better designs</p>
                        </div>
                    </div>
                </div>

                <button @click="startLab"
                        class="px-12 py-6 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full text-2xl font-bold hover:scale-110 transform transition">
                    Enter the Lab 🔬
                </button>
            </div>
        </section>

        <!-- Personality Test Module -->
        <section x-show="currentModule === ''personality-test''" x-transition
                 class="max-w-4xl mx-auto px-8 py-12">
            <h2 class="text-4xl font-bold text-center mb-12">Design Personality Assessment</h2>

            <div class="bg-gray-800 rounded-3xl p-8">
                <p class="text-xl text-center mb-8 text-gray-300">
                    Choose the design that speaks to you most:
                </p>

                <div class="grid md:grid-cols-2 gap-6">
                    <!-- Minimalist -->
                    <button @click="setPersonality(''Minimalist'')"
                            class="group relative overflow-hidden rounded-xl bg-white p-8 hover:scale-105 transition transform">
                        <div class="absolute inset-0 bg-gradient-to-br from-gray-50 to-gray-100"></div>
                        <div class="relative z-10">
                            <div class="h-32 flex items-center justify-center">
                                <div class="w-16 h-16 bg-black rounded"></div>
                            </div>
                            <h3 class="text-black font-bold text-xl">Minimalist</h3>
                            <p class="text-gray-600 text-sm mt-2">Less is more. Clean, simple, purposeful.</p>
                        </div>
                    </button>

                    <!-- Maximalist -->
                    <button @click="setPersonality(''Maximalist'')"
                            class="group relative overflow-hidden rounded-xl bg-gradient-to-br from-pink-500 via-purple-500 to-indigo-500 p-8 hover:scale-105 transition transform">
                        <div class="absolute inset-0 opacity-50">
                            <div class="absolute top-4 left-4 w-8 h-8 bg-yellow-400 rounded-full"></div>
                            <div class="absolute bottom-4 right-4 w-12 h-12 bg-green-400 rounded-full"></div>
                            <div class="absolute top-1/2 left-1/2 w-6 h-6 bg-red-400 rounded-full"></div>
                        </div>
                        <div class="relative z-10">
                            <div class="h-32 flex items-center justify-center">
                                <div class="text-6xl">🎨</div>
                            </div>
                            <h3 class="text-white font-bold text-xl">Maximalist</h3>
                            <p class="text-white text-sm mt-2">More is more! Bold, colorful, expressive.</p>
                        </div>
                    </button>

                    <!-- Systematic -->
                    <button @click="setPersonality(''Systematic'')"
                            class="group relative overflow-hidden rounded-xl bg-gray-900 p-8 hover:scale-105 transition transform">
                        <div class="absolute inset-0 grid grid-cols-4 gap-2 p-4">
                            <div class="bg-blue-500 opacity-20"></div>
                            <div class="bg-blue-500 opacity-20"></div>
                            <div class="bg-blue-500 opacity-20"></div>
                            <div class="bg-blue-500 opacity-20"></div>
                            <div class="bg-blue-500 opacity-20"></div>
                            <div class="bg-blue-500 opacity-20"></div>
                            <div class="bg-blue-500 opacity-20"></div>
                            <div class="bg-blue-500 opacity-20"></div>
                        </div>
                        <div class="relative z-10">
                            <div class="h-32 flex items-center justify-center">
                                <div class="text-6xl">📐</div>
                            </div>
                            <h3 class="text-white font-bold text-xl">Systematic</h3>
                            <p class="text-gray-300 text-sm mt-2">Grid-based, logical, structured design.</p>
                        </div>
                    </button>

                    <!-- Experimental -->
                    <button @click="setPersonality(''Experimental'')"
                            class="group relative overflow-hidden rounded-xl bg-black p-8 hover:scale-105 transition transform">
                        <div class="absolute inset-0">
                            <div class="absolute inset-0 bg-gradient-to-r from-red-600 via-yellow-500 to-green-500 opacity-30 blur-xl animate-pulse"></div>
                        </div>
                        <div class="relative z-10">
                            <div class="h-32 flex items-center justify-center">
                                <div class="text-6xl animate-spin-slow">🚀</div>
                            </div>
                            <h3 class="text-white font-bold text-xl">Experimental</h3>
                            <p class="text-gray-300 text-sm mt-2">Push boundaries, break rules, innovate.</p>
                        </div>
                    </button>
                </div>
            </div>
        </section>

        <!-- Research Hub -->
        <section x-show="currentModule === ''research-hub''" x-transition
                 class="max-w-7xl mx-auto px-8 py-12">
            <h2 class="text-4xl font-bold text-center mb-12">Research Hub</h2>

            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                <template x-for="(principle, key) in principles" :key="key">
                    <div class="bg-gray-800 rounded-2xl overflow-hidden"
                         :class="principle.unlocked ? ''border-2 border-blue-500'' : ''opacity-75''">
                        <!-- Header -->
                        <div class="p-6 border-b border-gray-700">
                            <div class="flex items-center justify-between mb-4">
                                <div class="text-4xl" x-text="principle.icon"></div>
                                <div x-show="!principle.unlocked"
                                     class="bg-gray-700 px-3 py-1 rounded-full text-sm">
                                    🔒 50 RP to unlock
                                </div>
                                <div x-show="principle.unlocked"
                                     class="bg-green-600 px-3 py-1 rounded-full text-sm">
                                    ✅ Unlocked
                                </div>
                            </div>
                            <h3 class="text-xl font-bold mb-2" x-text="principle.name"></h3>
                            <p class="text-sm text-gray-400" x-text="principle.research"></p>
                        </div>

                        <!-- Experiments -->
                        <div class="p-6">
                            <h4 class="font-semibold mb-3 text-blue-400">Experiments:</h4>
                            <div class="space-y-3">
                                <template x-for="(exp, index) in principle.experiments" :key="index">
                                    <button @click="principle.unlocked && startExperiment(key, index)"
                                            :disabled="!principle.unlocked"
                                            :class="principle.unlocked ? ''hover:bg-gray-700'' : ''opacity-50 cursor-not-allowed''"
                                            class="w-full text-left p-3 bg-gray-900 rounded-lg transition">
                                        <div class="font-semibold" x-text="exp.name"></div>
                                        <div class="text-sm text-gray-400" x-text="exp.description"></div>
                                    </button>
                                </template>
                            </div>
                        </div>

                        <!-- Unlock Button -->
                        <div x-show="!principle.unlocked" class="p-6 pt-0">
                            <button @click="unlockPrinciple(key)"
                                    :disabled="researchPoints < 50"
                                    :class="researchPoints >= 50 ? ''bg-blue-600 hover:bg-blue-700'' : ''bg-gray-700 opacity-50 cursor-not-allowed''"
                                    class="w-full py-3 rounded-lg font-bold transition">
                                Unlock Principle
                            </button>
                        </div>
                    </div>
                </template>
            </div>

            <!-- Quick Actions -->
            <div class="mt-12 text-center">
                <p class="text-gray-400 mb-4">Need more Research Points?</p>
                <button class="px-8 py-3 bg-purple-600 hover:bg-purple-700 rounded-lg font-bold">
                    Run Quick Experiments (+10 RP)
                </button>
            </div>
        </section>

        <!-- Experiment Module -->
        <section x-show="currentModule === ''experiment''" x-transition
                 class="max-w-6xl mx-auto px-8 py-12">
            <div x-show="currentExperiment">
                <h2 class="text-3xl font-bold text-center mb-8">
                    <span x-text="currentExperiment?.experiment?.name"></span>
                </h2>

                <!-- Proximity Test -->
                <div x-show="currentExperiment?.principle === ''gestalt'' && currentExperiment?.index === 0"
                     class="bg-gray-800 rounded-3xl p-8">
                    <p class="text-lg mb-6 text-center">
                        How many groups do you see? Click to select your answer.
                    </p>

                    <!-- Dot Display -->
                    <div class="relative bg-white rounded-xl h-96 mb-6">
                        <template x-for="dot in experiments.proximityTest.dots" :key="dot">
                            <div class="absolute w-4 h-4 bg-black rounded-full"
                                 :style="`left: ${dot.x}%; top: ${dot.y}%`"></div>
                        </template>
                    </div>

                    <!-- Answer Options -->
                    <div class="grid grid-cols-5 gap-4">
                        <template x-for="n in 5" :key="n">
                            <button @click="experiments.proximityTest.userGroups = n;
                                           completeExperiment(n === experiments.proximityTest.actualGroups ? 100 : 50)"
                                    class="py-3 bg-gray-700 hover:bg-gray-600 rounded-lg font-bold">
                                <span x-text="n"></span> Groups
                            </button>
                        </template>
                    </div>
                </div>

                <!-- Color Emotion Mapping -->
                <div x-show="currentExperiment?.principle === ''color'' && currentExperiment?.index === 0"
                     class="bg-gray-800 rounded-3xl p-8">
                    <p class="text-lg mb-6 text-center">
                        Match colors to emotions based on your perception
                    </p>

                    <div class="grid md:grid-cols-2 gap-8">
                        <!-- Colors -->
                        <div>
                            <h3 class="font-bold mb-4">Colors</h3>
                            <div class="grid grid-cols-3 gap-3">
                                <div class="h-20 bg-red-500 rounded-lg cursor-pointer hover:scale-105 transition"></div>
                                <div class="h-20 bg-blue-500 rounded-lg cursor-pointer hover:scale-105 transition"></div>
                                <div class="h-20 bg-yellow-500 rounded-lg cursor-pointer hover:scale-105 transition"></div>
                                <div class="h-20 bg-green-500 rounded-lg cursor-pointer hover:scale-105 transition"></div>
                                <div class="h-20 bg-purple-500 rounded-lg cursor-pointer hover:scale-105 transition"></div>
                                <div class="h-20 bg-gray-500 rounded-lg cursor-pointer hover:scale-105 transition"></div>
                            </div>
                        </div>

                        <!-- Emotions -->
                        <div>
                            <h3 class="font-bold mb-4">Emotions</h3>
                            <div class="space-y-3">
                                <template x-for="emotion in experiments.colorEmotion.emotions" :key="emotion">
                                    <div class="bg-gray-900 rounded-lg p-3 hover:bg-gray-700 cursor-pointer transition">
                                        <span x-text="emotion"></span>
                                    </div>
                                </template>
                            </div>
                        </div>
                    </div>

                    <button @click="completeExperiment(150)"
                            class="mt-8 w-full py-3 bg-green-600 hover:bg-green-700 rounded-lg font-bold">
                        Submit Mapping
                    </button>
                </div>

                <!-- Back Button -->
                <div class="text-center mt-8">
                    <button @click="currentModule = ''research-hub''"
                            class="px-6 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg">
                        Back to Research Hub
                    </button>
                </div>
            </div>
        </section>
    </main>

    <!-- Background Effects -->
    <div class="fixed inset-0 pointer-events-none">
        <!-- Scanning Effect -->
        <div class="absolute inset-0 overflow-hidden opacity-20">
            <div class="scanner absolute inset-x-0 h-32"></div>
        </div>

        <!-- Particle Effect -->
        <div class="absolute inset-0">
            <div class="absolute top-1/4 left-1/4 w-2 h-2 bg-blue-400 rounded-full animate-pulse"></div>
            <div class="absolute top-3/4 right-1/4 w-2 h-2 bg-purple-400 rounded-full animate-pulse animation-delay-1000"></div>
            <div class="absolute bottom-1/4 left-1/2 w-2 h-2 bg-cyan-400 rounded-full animate-pulse animation-delay-2000"></div>
        </div>
    </div>

    <style>
        @keyframes spin-slow {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .animate-spin-slow {
            animation: spin-slow 10s linear infinite;
        }

        .animation-delay-1000 {
            animation-delay: 1s;
        }

        .animation-delay-2000 {
            animation-delay: 2s;
        }
    </style>
</body>
</html>', '', '', 'gamified', true, 2, '{"level": 3, "duration": "20-30 min", "skills": ["Design Psychology", "Research", "Analysis"]}'),

-- Template 3: Interaction Playground
('🎯 Interaction Playground', 'Master Touch, Click & Hover - Das ultimative UX Training',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interaction Playground</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-900 text-white min-h-screen overflow-x-hidden" x-data="{
    // Game state
    currentLevel: 1,
    score: 0,
    lives: 3,
    combo: 0,
    gameMode: ''menu'', // menu, playing, complete

    // Interaction types discovered
    interactions: {
        click: { discovered: false, count: 0, mastery: 0 },
        doubleClick: { discovered: false, count: 0, mastery: 0 },
        hover: { discovered: false, count: 0, mastery: 0 },
        drag: { discovered: false, count: 0, mastery: 0 },
        swipe: { discovered: false, count: 0, mastery: 0 },
        pinch: { discovered: false, count: 0, mastery: 0 },
        rotate: { discovered: false, count: 0, mastery: 0 },
        shake: { discovered: false, count: 0, mastery: 0 },
        longPress: { discovered: false, count: 0, mastery: 0 },
        scroll: { discovered: false, count: 0, mastery: 0 }
    },

    // Challenges
    challenges: [
        {
            level: 1,
            name: ''Click Master'',
            description: ''Master the art of clicking'',
            tasks: [
                { type: ''click'', target: ''button'', count: 5, completed: false },
                { type: ''doubleClick'', target: ''card'', count: 3, completed: false },
                { type: ''click'', target: ''small'', count: 10, completed: false }
            ]
        },
        {
            level: 2,
            name: ''Hover Hero'',
            description: ''Discover the power of hovering'',
            tasks: [
                { type: ''hover'', target: ''menu'', duration: 2000, completed: false },
                { type: ''hover'', target: ''tooltip'', count: 5, completed: false },
                { type: ''hover'', target: ''reveal'', count: 8, completed: false }
            ]
        },
        {
            level: 3,
            name: ''Drag & Drop Dynasty'',
            description: ''Move elements with precision'',
            tasks: [
                { type: ''drag'', target: ''card'', count: 5, completed: false },
                { type: ''drag'', target: ''sort'', count: 3, completed: false },
                { type: ''drag'', target: ''puzzle'', count: 1, completed: false }
            ]
        }
    ],

    // Current challenge
    get currentChallenge() {
        return this.challenges[this.currentLevel - 1];
    },

    // Interactive elements on screen
    interactiveElements: [],

    // Touch/Mouse tracking
    touchStart: { x: 0, y: 0 },
    touchEnd: { x: 0, y: 0 },
    isDragging: false,
    draggedElement: null,

    // Methods
    startGame() {
        this.gameMode = ''playing'';
        this.score = 0;
        this.lives = 3;
        this.combo = 0;
        this.generateInteractiveElements();
    },

    generateInteractiveElements() {
        this.interactiveElements = [];
        const challenge = this.currentChallenge;

        // Generate elements based on current challenge
        challenge.tasks.forEach((task, index) => {
            for (let i = 0; i < (task.count || 1); i++) {
                this.interactiveElements.push({
                    id: `elem-${index}-${i}`,
                    type: task.target,
                    interactionType: task.type,
                    x: Math.random() * 80 + 10,
                    y: Math.random() * 60 + 20,
                    completed: false,
                    size: task.target === ''small'' ? ''small'' : ''normal''
                });
            }
        });
    },

    handleInteraction(type, elementId) {
        const element = this.interactiveElements.find(e => e.id === elementId);
        if (!element || element.completed) return;

        if (element.interactionType === type) {
            // Correct interaction
            element.completed = true;
            this.score += 100 * (this.combo + 1);
            this.combo++;
            this.interactions[type].count++;
            this.interactions[type].mastery = Math.min(100, this.interactions[type].mastery + 10);

            if (!this.interactions[type].discovered) {
                this.interactions[type].discovered = true;
                this.showDiscovery(type);
            }

            this.checkLevelComplete();
        } else {
            // Wrong interaction
            this.combo = 0;
            this.lives--;
            this.showFeedback(''wrong'', element);

            if (this.lives <= 0) {
                this.gameOver();
            }
        }
    },

    checkLevelComplete() {
        const allComplete = this.interactiveElements.every(e => e.completed);
        if (allComplete) {
            this.levelComplete();
        }
    },

    levelComplete() {
        this.score += 1000 * this.currentLevel;
        if (this.currentLevel < this.challenges.length) {
            this.currentLevel++;
            this.generateInteractiveElements();
            this.showLevelUp();
        } else {
            this.gameComplete();
        }
    },

    gameComplete() {
        this.gameMode = ''complete'';
    },

    gameOver() {
        this.gameMode = ''gameover'';
    },

    showDiscovery(type) {
        // Animation for discovering new interaction
        console.log(`Discovered: ${type}!`);
    },

    showFeedback(type, element) {
        // Visual feedback for interactions
        console.log(`Feedback: ${type} on ${element.id}`);
    },

    showLevelUp() {
        // Level up animation
        console.log(''Level Up!'');
    },

    // Touch handlers
    handleTouchStart(e) {
        this.touchStart = {
            x: e.touches[0].clientX,
            y: e.touches[0].clientY
        };
    },

    handleTouchEnd(e) {
        this.touchEnd = {
            x: e.changedTouches[0].clientX,
            y: e.changedTouches[0].clientY
        };

        const deltaX = this.touchEnd.x - this.touchStart.x;
        const deltaY = this.touchEnd.y - this.touchStart.y;

        // Detect swipe
        if (Math.abs(deltaX) > 50 || Math.abs(deltaY) > 50) {
            this.handleInteraction(''swipe'', e.target.id);
        }
    },

    // Get interaction icon
    getInteractionIcon(type) {
        const icons = {
            click: ''👆'',
            doubleClick: ''👆👆'',
            hover: ''👋'',
            drag: ''✊'',
            swipe: ''👉'',
            pinch: ''🤏'',
            rotate: ''🔄'',
            shake: ''🫨'',
            longPress: ''⏱️'',
            scroll: ''📜''
        };
        return icons[type] || ''❓'';
    },

    // Initialize
    init() {
        // Add global event listeners
        document.addEventListener(''touchstart'', this.handleTouchStart.bind(this));
        document.addEventListener(''touchend'', this.handleTouchEnd.bind(this));
    }
}">
    <!-- Menu Screen -->
    <div x-show="gameMode === ''menu''" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-4xl mx-auto px-8">
            <div class="mb-12">
                <h1 class="text-7xl font-bold mb-4 bg-gradient-to-r from-purple-400 via-pink-400 to-red-400 bg-clip-text text-transparent">
                    Interaction Playground
                </h1>
                <p class="text-2xl text-gray-400">Master Every Click, Touch & Gesture</p>
            </div>

            <!-- Interaction Types Preview -->
            <div class="bg-gray-800 rounded-3xl p-8 mb-8">
                <h2 class="text-2xl font-bold mb-6 text-yellow-400">🎮 Discover 10 Interaction Types</h2>
                <div class="grid grid-cols-5 gap-4">
                    <template x-for="(data, type) in interactions" :key="type">
                        <div class="bg-gray-900 rounded-xl p-4 text-center">
                            <div class="text-3xl mb-2" x-text="getInteractionIcon(type)"></div>
                            <div class="text-xs capitalize" x-text="type"></div>
                        </div>
                    </template>
                </div>
            </div>

            <!-- How to Play -->
            <div class="grid md:grid-cols-3 gap-6 mb-8">
                <div class="bg-gray-800 rounded-xl p-6">
                    <div class="text-3xl mb-3">🎯</div>
                    <h3 class="font-bold mb-2">Find & Interact</h3>
                    <p class="text-sm text-gray-400">Discover elements and interact correctly</p>
                </div>
                <div class="bg-gray-800 rounded-xl p-6">
                    <div class="text-3xl mb-3">⚡</div>
                    <h3 class="font-bold mb-2">Build Combos</h3>
                    <p class="text-sm text-gray-400">Chain correct interactions for bonus points</p>
                </div>
                <div class="bg-gray-800 rounded-xl p-6">
                    <div class="text-3xl mb-3">🏆</div>
                    <h3 class="font-bold mb-2">Master All</h3>
                    <p class="text-sm text-gray-400">Unlock and master every interaction type</p>
                </div>
            </div>

            <button @click="startGame"
                    class="px-12 py-6 bg-gradient-to-r from-purple-500 to-pink-500 rounded-full text-3xl font-bold hover:scale-110 transform transition">
                Start Playing! 🎮
            </button>
        </div>
    </div>

    <!-- Game Screen -->
    <div x-show="gameMode === ''playing''" x-transition class="relative min-h-screen">
        <!-- Game HUD -->
        <div class="fixed top-0 left-0 right-0 bg-black bg-opacity-90 p-4 z-50">
            <div class="max-w-6xl mx-auto">
                <!-- Top Stats -->
                <div class="flex justify-between items-center mb-4">
                    <div class="flex gap-6">
                        <!-- Lives -->
                        <div class="flex gap-1">
                            <template x-for="i in 3" :key="i">
                                <span class="text-2xl"
                                      :class="i <= lives ? ''text-red-500'' : ''text-gray-600''">
                                    ❤️
                                </span>
                            </template>
                        </div>

                        <!-- Score -->
                        <div>
                            <span class="text-sm text-gray-400">Score</span>
                            <span class="text-2xl font-bold text-yellow-400 ml-2" x-text="score"></span>
                        </div>

                        <!-- Combo -->
                        <div x-show="combo > 0">
                            <span class="text-sm text-gray-400">Combo</span>
                            <span class="text-2xl font-bold text-orange-400 ml-2" x-text="combo + ''x''"></span>
                        </div>
                    </div>

                    <!-- Level Info -->
                    <div class="text-center">
                        <div class="text-sm text-gray-400">Level <span x-text="currentLevel"></span></div>
                        <div class="text-xl font-bold" x-text="currentChallenge?.name"></div>
                    </div>
                </div>

                <!-- Progress Bar -->
                <div class="bg-gray-700 rounded-full h-2">
                    <div class="bg-gradient-to-r from-purple-500 to-pink-500 h-full rounded-full transition-all duration-300"
                         :style="`width: ${(interactiveElements.filter(e => e.completed).length / interactiveElements.length) * 100}%`"></div>
                </div>
            </div>
        </div>

        <!-- Challenge Instructions -->
        <div class="fixed top-24 left-1/2 transform -translate-x-1/2 bg-gray-800 rounded-lg px-6 py-3 z-40">
            <p class="text-lg" x-text="currentChallenge?.description"></p>
        </div>

        <!-- Interactive Playground -->
        <div class="pt-40 px-8 pb-20">
            <!-- Interactive Elements -->
            <template x-for="element in interactiveElements" :key="element.id">
                <div :id="element.id"
                     class="absolute transition-all duration-300"
                     :style="`left: ${element.x}%; top: ${element.y}%`"
                     :class="{
                         ''opacity-30'': element.completed,
                         ''cursor-pointer'': element.interactionType === ''click'',
                         ''cursor-move'': element.interactionType === ''drag''
                     }">

                    <!-- Click Elements -->
                    <div x-show="element.type === ''button''"
                         @click="handleInteraction(''click'', element.id)"
                         class="bg-blue-600 hover:bg-blue-700 px-6 py-3 rounded-lg font-bold transform hover:scale-105 transition">
                        Click Me!
                    </div>

                    <!-- Double Click Elements -->
                    <div x-show="element.type === ''card''"
                         @dblclick="handleInteraction(''doubleClick'', element.id)"
                         class="bg-gradient-to-br from-purple-600 to-pink-600 w-32 h-32 rounded-xl flex items-center justify-center shadow-lg">
                        <p class="text-center">Double Click</p>
                    </div>

                    <!-- Small Click Targets -->
                    <div x-show="element.type === ''small''"
                         @click="handleInteraction(''click'', element.id)"
                         class="w-8 h-8 bg-yellow-500 rounded-full hover:bg-yellow-600 transition"></div>

                    <!-- Hover Elements -->
                    <div x-show="element.type === ''menu''"
                         @mouseenter="handleInteraction(''hover'', element.id)"
                         class="bg-gray-800 rounded-lg p-4 hover:bg-gray-700 transition">
                        <p class="mb-2">Hover Menu</p>
                        <div class="space-y-1 text-sm text-gray-400">
                            <p>Option 1</p>
                            <p>Option 2</p>
                            <p>Option 3</p>
                        </div>
                    </div>

                    <!-- Tooltip Elements -->
                    <div x-show="element.type === ''tooltip''"
                         @mouseenter="handleInteraction(''hover'', element.id)"
                         class="relative group">
                        <div class="bg-green-600 px-4 py-2 rounded">
                            Hover for tip
                        </div>
                        <div class="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 px-3 py-1 bg-black rounded opacity-0 group-hover:opacity-100 transition">
                            Tooltip!
                        </div>
                    </div>

                    <!-- Reveal Elements -->
                    <div x-show="element.type === ''reveal''"
                         @mouseenter="handleInteraction(''hover'', element.id)"
                         class="relative w-40 h-40 bg-gray-800 rounded-lg overflow-hidden group">
                        <div class="absolute inset-0 bg-gradient-to-t from-black to-transparent opacity-0 group-hover:opacity-100 transition"></div>
                        <p class="absolute bottom-2 left-2 right-2 text-center opacity-0 group-hover:opacity-100 transition">
                            Revealed!
                        </p>
                    </div>

                    <!-- Completion Indicator -->
                    <div x-show="element.completed"
                         class="absolute inset-0 flex items-center justify-center pointer-events-none">
                        <span class="text-4xl">✅</span>
                    </div>
                </div>
            </template>
        </div>

        <!-- Interaction Discovery Panel -->
        <div class="fixed bottom-0 left-0 right-0 bg-gray-800 p-4">
            <div class="max-w-6xl mx-auto">
                <h3 class="text-sm font-bold mb-2 text-gray-400">Discovered Interactions</h3>
                <div class="flex gap-4 overflow-x-auto">
                    <template x-for="(data, type) in interactions" :key="type">
                        <div x-show="data.discovered"
                             class="bg-gray-900 rounded-lg p-3 min-w-[120px]">
                            <div class="flex items-center gap-2 mb-2">
                                <span class="text-2xl" x-text="getInteractionIcon(type)"></span>
                                <span class="text-sm capitalize" x-text="type"></span>
                            </div>
                            <div class="text-xs text-gray-400">
                                Mastery: <span x-text="data.mastery"></span>%
                            </div>
                            <div class="bg-gray-700 rounded-full h-1 mt-1">
                                <div class="bg-green-500 h-full rounded-full transition-all duration-300"
                                     :style="`width: ${data.mastery}%`"></div>
                            </div>
                        </div>
                    </template>
                </div>
            </div>
        </div>
    </div>

    <!-- Game Complete Screen -->
    <div x-show="gameMode === ''complete''" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-2xl mx-auto px-8">
            <div class="mb-8">
                <div class="text-8xl mb-4">🏆</div>
                <h1 class="text-5xl font-bold mb-4">Interaction Master!</h1>
                <p class="text-2xl text-gray-400">You''ve mastered all interaction types!</p>
            </div>

            <!-- Final Score -->
            <div class="bg-gray-800 rounded-3xl p-8 mb-8">
                <div class="text-6xl font-bold text-yellow-400 mb-4" x-text="score.toLocaleString()"></div>
                <p class="text-xl text-gray-400">Final Score</p>
            </div>

            <!-- Mastery Summary -->
            <div class="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
                <template x-for="(data, type) in interactions" :key="type">
                    <div class="bg-gray-800 rounded-lg p-4 text-center">
                        <div class="text-3xl mb-2" x-text="getInteractionIcon(type)"></div>
                        <div class="text-sm capitalize" x-text="type"></div>
                        <div class="text-xs text-gray-400 mt-1">
                            <span x-text="data.count"></span> uses
                        </div>
                    </div>
                </template>
            </div>

            <!-- Actions -->
            <div class="flex gap-4 justify-center">
                <button @click="startGame"
                        class="px-8 py-3 bg-gradient-to-r from-purple-500 to-pink-500 rounded-lg font-bold hover:scale-105 transition">
                    Play Again
                </button>
                <button @click="gameMode = ''menu''"
                        class="px-8 py-3 bg-gray-700 hover:bg-gray-600 rounded-lg font-bold transition">
                    Main Menu
                </button>
            </div>
        </div>
    </div>

    <!-- Game Over Screen -->
    <div x-show="gameMode === ''gameover''" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-2xl mx-auto px-8">
            <div class="mb-8">
                <div class="text-8xl mb-4">💔</div>
                <h1 class="text-5xl font-bold mb-4">Game Over</h1>
                <p class="text-2xl text-gray-400">Keep practicing!</p>
            </div>

            <div class="bg-gray-800 rounded-3xl p-8 mb-8">
                <p class="text-xl mb-4">Final Score</p>
                <div class="text-4xl font-bold text-yellow-400" x-text="score"></div>
            </div>

            <div class="flex gap-4 justify-center">
                <button @click="startGame"
                        class="px-8 py-3 bg-blue-600 hover:bg-blue-700 rounded-lg font-bold">
                    Try Again
                </button>
                <button @click="gameMode = ''menu''"
                        class="px-8 py-3 bg-gray-700 hover:bg-gray-600 rounded-lg font-bold">
                    Main Menu
                </button>
            </div>
        </div>
    </div>
</body>
</html>', '', '', 'gamified', true, 3, '{"level": 2, "duration": "15-20 min", "skills": ["UX", "Interactions", "Touch", "Gestures"]}'),

-- Template 4: Code Combat
('⚔️ Code Combat', 'Programming als RPG - Kämpfe mit Code!',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code Combat - Programming RPG</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-black text-white min-h-screen" x-data="{
    // Player stats
    player: {
        name: ''CodeWarrior'',
        level: 1,
        hp: 100,
        maxHp: 100,
        mp: 50,
        maxMp: 50,
        exp: 0,
        expToNext: 100,
        class: ''Frontend Mage'',
        skills: []
    },

    // Enemy data
    currentEnemy: null,
    enemies: [
        {
            name: ''Bug Swarm'',
            hp: 50,
            maxHp: 50,
            weakness: ''debugging'',
            image: ''🐛'',
            attacks: [''Syntax Error'', ''Null Reference''],
            rewards: { exp: 25, skill: ''console.log()'' }
        },
        {
            name: ''CSS Chaos'',
            hp: 75,
            maxHp: 75,
            weakness: ''styling'',
            image: ''🎨'',
            attacks: [''Z-Index Nightmare'', ''Flexbox Confusion''],
            rewards: { exp: 50, skill: ''display: flex'' }
        },
        {
            name: ''Async Dragon'',
            hp: 100,
            maxHp: 100,
            weakness: ''promises'',
            image: ''🐉'',
            attacks: [''Callback Hell'', ''Race Condition''],
            rewards: { exp: 100, skill: ''async/await'' }
        }
    ],

    // Game state
    gameState: ''menu'', // menu, battle, victory, defeat, skillTree
    battleLog: [],
    currentTurn: ''player'',

    // Skills/Spells
    availableSkills: [
        {
            id: ''basic_attack'',
            name: ''Basic Attack'',
            type: ''damage'',
            power: 20,
            mpCost: 0,
            description: ''A simple code strike'',
            code: ''enemy.hp -= 20;'',
            unlocked: true
        },
        {
            id: ''console_log'',
            name: ''Console.log()'',
            type: ''debug'',
            power: 30,
            mpCost: 10,
            description: ''Debug attack - super effective against bugs'',
            code: ''console.log(enemy.weakness);'',
            unlocked: false
        },
        {
            id: ''flex_shield'',
            name: ''Flexbox Shield'',
            type: ''defense'',
            power: 0,
            mpCost: 15,
            description: ''Reduces incoming damage'',
            code: ''display: flex; align-items: center;'',
            unlocked: false
        },
        {
            id: ''async_heal'',
            name: ''Async Heal'',
            type: ''heal'',
            power: 40,
            mpCost: 20,
            description: ''Restore HP over time'',
            code: ''await healPlayer(40);'',
            unlocked: false
        }
    ],

    // Inventory
    inventory: {
        potions: 3,
        ethers: 2,
        debuggers: 1
    },

    // Methods
    startBattle() {
        this.gameState = ''battle'';
        this.currentEnemy = {...this.enemies[0]};
        this.battleLog = [''A wild '' + this.currentEnemy.name + '' appears!''];
        this.currentTurn = ''player'';
    },

    useSkill(skill) {
        if (this.currentTurn !== ''player'') return;
        if (this.player.mp < skill.mpCost) {
            this.addBattleLog(''Not enough MP!'');
            return;
        }

        this.player.mp -= skill.mpCost;

        switch(skill.type) {
            case ''damage'':
            case ''debug'':
                const damage = skill.power * (skill.type === ''debug'' && this.currentEnemy.weakness === ''debugging'' ? 2 : 1);
                this.currentEnemy.hp = Math.max(0, this.currentEnemy.hp - damage);
                this.addBattleLog(`${skill.name} deals ${damage} damage!`);
                break;
            case ''heal'':
                const healAmount = Math.min(skill.power, this.player.maxHp - this.player.hp);
                this.player.hp += healAmount;
                this.addBattleLog(`${skill.name} heals ${healAmount} HP!`);
                break;
            case ''defense'':
                this.addBattleLog(`${skill.name} activated! Defense increased!`);
                break;
        }

        this.checkBattleEnd();
        if (this.gameState === ''battle'') {
            this.enemyTurn();
        }
    },

    useItem(item) {
        if (this.currentTurn !== ''player'' || this.inventory[item] <= 0) return;

        this.inventory[item]--;

        switch(item) {
            case ''potions'':
                const healAmount = Math.min(50, this.player.maxHp - this.player.hp);
                this.player.hp += healAmount;
                this.addBattleLog(`Potion restores ${healAmount} HP!`);
                break;
            case ''ethers'':
                const mpAmount = Math.min(25, this.player.maxMp - this.player.mp);
                this.player.mp += mpAmount;
                this.addBattleLog(`Ether restores ${mpAmount} MP!`);
                break;
            case ''debuggers'':
                this.currentEnemy.hp = Math.max(0, this.currentEnemy.hp - 50);
                this.addBattleLog(`Debugger deals 50 damage to bugs!`);
                break;
        }

        this.checkBattleEnd();
        if (this.gameState === ''battle'') {
            this.enemyTurn();
        }
    },

    enemyTurn() {
        this.currentTurn = ''enemy'';

        setTimeout(() => {
            const attack = this.currentEnemy.attacks[Math.floor(Math.random() * this.currentEnemy.attacks.length)];
            const damage = Math.floor(Math.random() * 20) + 10;
            this.player.hp = Math.max(0, this.player.hp - damage);
            this.addBattleLog(`${this.currentEnemy.name} uses ${attack} for ${damage} damage!`);

            this.checkBattleEnd();
            this.currentTurn = ''player'';
        }, 1500);
    },

    checkBattleEnd() {
        if (this.currentEnemy.hp <= 0) {
            this.victory();
        } else if (this.player.hp <= 0) {
            this.defeat();
        }
    },

    victory() {
        this.gameState = ''victory'';
        this.player.exp += this.currentEnemy.rewards.exp;

        // Check level up
        if (this.player.exp >= this.player.expToNext) {
            this.levelUp();
        }

        // Unlock new skill
        const rewardSkill = this.currentEnemy.rewards.skill;
        const skill = this.availableSkills.find(s => s.name === rewardSkill);
        if (skill && !skill.unlocked) {
            skill.unlocked = true;
            this.player.skills.push(skill.id);
        }
    },

    defeat() {
        this.gameState = ''defeat'';
    },

    levelUp() {
        this.player.level++;
        this.player.exp -= this.player.expToNext;
        this.player.expToNext = this.player.level * 100;
        this.player.maxHp += 20;
        this.player.maxMp += 10;
        this.player.hp = this.player.maxHp;
        this.player.mp = this.player.maxMp;
    },

    addBattleLog(message) {
        this.battleLog.push(message);
        // Keep only last 5 messages
        if (this.battleLog.length > 5) {
            this.battleLog.shift();
        }
    },

    nextBattle() {
        // Move to next enemy
        const currentIndex = this.enemies.findIndex(e => e.name === this.currentEnemy.name);
        if (currentIndex < this.enemies.length - 1) {
            this.currentEnemy = {...this.enemies[currentIndex + 1]};
            this.gameState = ''battle'';
            this.battleLog = [''A wild '' + this.currentEnemy.name + '' appears!''];
            this.currentTurn = ''player'';
        } else {
            this.gameState = ''complete'';
        }
    },

    get unlockedSkills() {
        return this.availableSkills.filter(s => s.unlocked);
    }
}">
    <!-- Menu Screen -->
    <div x-show="gameState === ''menu''" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-4xl mx-auto px-8">
            <div class="mb-12">
                <h1 class="text-8xl font-bold mb-4 bg-gradient-to-r from-red-500 via-yellow-500 to-green-500 bg-clip-text text-transparent">
                    CODE COMBAT
                </h1>
                <p class="text-3xl text-gray-400">Programming RPG Adventure</p>
            </div>

            <!-- Game Features -->
            <div class="bg-gray-900 rounded-3xl p-8 mb-8">
                <div class="grid md:grid-cols-3 gap-6">
                    <div class="bg-gray-800 rounded-xl p-6">
                        <div class="text-4xl mb-3">⚔️</div>
                        <h3 class="text-xl font-bold mb-2">Battle with Code</h3>
                        <p class="text-sm text-gray-400">Use programming skills as spells</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-6">
                        <div class="text-4xl mb-3">📈</div>
                        <h3 class="text-xl font-bold mb-2">Level Up</h3>
                        <p class="text-sm text-gray-400">Gain experience and unlock new abilities</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-6">
                        <div class="text-4xl mb-3">🏆</div>
                        <h3 class="text-xl font-bold mb-2">Defeat Bugs</h3>
                        <p class="text-sm text-gray-400">Fight bugs, errors, and code monsters</p>
                    </div>
                </div>
            </div>

            <!-- Character Creation -->
            <div class="bg-gray-800 rounded-2xl p-6 mb-8 max-w-md mx-auto">
                <h3 class="text-xl font-bold mb-4">Choose Your Class</h3>
                <div class="space-y-3">
                    <button @click="player.class = ''Frontend Mage''; player.skills = [''basic_attack'']"
                            :class="player.class === ''Frontend Mage'' ? ''ring-2 ring-blue-500'' : ''''"
                            class="w-full p-3 bg-gray-700 rounded-lg hover:bg-gray-600 transition text-left">
                        <span class="text-lg font-bold">🧙‍♂️ Frontend Mage</span>
                        <p class="text-sm text-gray-400">Master of UI spells and CSS magic</p>
                    </button>
                    <button @click="player.class = ''Backend Warrior''; player.skills = [''basic_attack'']"
                            :class="player.class === ''Backend Warrior'' ? ''ring-2 ring-red-500'' : ''''"
                            class="w-full p-3 bg-gray-700 rounded-lg hover:bg-gray-600 transition text-left">
                        <span class="text-lg font-bold">⚔️ Backend Warrior</span>
                        <p class="text-sm text-gray-400">Database defender and API fighter</p>
                    </button>
                    <button @click="player.class = ''Full-Stack Paladin''; player.skills = [''basic_attack'']"
                            :class="player.class === ''Full-Stack Paladin'' ? ''ring-2 ring-yellow-500'' : ''''"
                            class="w-full p-3 bg-gray-700 rounded-lg hover:bg-gray-600 transition text-left">
                        <span class="text-lg font-bold">🛡️ Full-Stack Paladin</span>
                        <p class="text-sm text-gray-400">Balanced fighter with diverse skills</p>
                    </button>
                </div>
            </div>

            <button @click="startBattle"
                    class="px-12 py-6 bg-gradient-to-r from-red-600 to-orange-600 rounded-full text-3xl font-bold hover:scale-110 transform transition">
                Start Adventure! ⚔️
            </button>
        </div>
    </div>

    <!-- Battle Screen -->
    <div x-show="gameState === ''battle''" x-transition class="min-h-screen p-8">
        <div class="max-w-6xl mx-auto">
            <!-- Battle Arena -->
            <div class="grid md:grid-cols-2 gap-8 mb-8">
                <!-- Player Side -->
                <div class="bg-gray-800 rounded-2xl p-6">
                    <h3 class="text-xl font-bold mb-4">
                        <span x-text="player.name"></span>
                        <span class="text-sm text-gray-400">(Lv.<span x-text="player.level"></span> <span x-text="player.class"></span>)</span>
                    </h3>

                    <!-- HP Bar -->
                    <div class="mb-3">
                        <div class="flex justify-between text-sm mb-1">
                            <span>HP</span>
                            <span><span x-text="player.hp"></span>/<span x-text="player.maxHp"></span></span>
                        </div>
                        <div class="bg-gray-700 rounded-full h-4">
                            <div class="bg-red-500 h-full rounded-full transition-all duration-300"
                                 :style="`width: ${(player.hp / player.maxHp) * 100}%`"></div>
                        </div>
                    </div>

                    <!-- MP Bar -->
                    <div class="mb-4">
                        <div class="flex justify-between text-sm mb-1">
                            <span>MP</span>
                            <span><span x-text="player.mp"></span>/<span x-text="player.maxMp"></span></span>
                        </div>
                        <div class="bg-gray-700 rounded-full h-4">
                            <div class="bg-blue-500 h-full rounded-full transition-all duration-300"
                                 :style="`width: ${(player.mp / player.maxMp) * 100}%`"></div>
                        </div>
                    </div>

                    <!-- Player Avatar -->
                    <div class="text-center">
                        <div class="text-8xl mb-4">🧙‍♂️</div>
                    </div>
                </div>

                <!-- Enemy Side -->
                <div class="bg-gray-800 rounded-2xl p-6">
                    <h3 class="text-xl font-bold mb-4" x-text="currentEnemy?.name"></h3>

                    <!-- HP Bar -->
                    <div class="mb-4">
                        <div class="flex justify-between text-sm mb-1">
                            <span>HP</span>
                            <span><span x-text="currentEnemy?.hp"></span>/<span x-text="currentEnemy?.maxHp"></span></span>
                        </div>
                        <div class="bg-gray-700 rounded-full h-4">
                            <div class="bg-red-500 h-full rounded-full transition-all duration-300"
                                 :style="`width: ${(currentEnemy?.hp / currentEnemy?.maxHp) * 100}%`"></div>
                        </div>
                    </div>

                    <!-- Enemy Avatar -->
                    <div class="text-center">
                        <div class="text-8xl mb-4" x-text="currentEnemy?.image"></div>
                        <p class="text-sm text-gray-400">
                            Weakness: <span class="text-yellow-400" x-text="currentEnemy?.weakness"></span>
                        </p>
                    </div>
                </div>
            </div>

            <!-- Battle Log -->
            <div class="bg-gray-900 rounded-xl p-4 mb-6 h-32 overflow-y-auto">
                <h4 class="text-sm font-bold text-gray-400 mb-2">Battle Log</h4>
                <div class="space-y-1">
                    <template x-for="log in battleLog" :key="log">
                        <p class="text-sm" x-text="log"></p>
                    </template>
                </div>
            </div>

            <!-- Action Panel -->
            <div class="bg-gray-800 rounded-2xl p-6">
                <div class="grid md:grid-cols-2 gap-6">
                    <!-- Skills -->
                    <div>
                        <h3 class="text-lg font-bold mb-3">Skills</h3>
                        <div class="grid grid-cols-2 gap-3">
                            <template x-for="skill in unlockedSkills" :key="skill.id">
                                <button @click="useSkill(skill)"
                                        :disabled="currentTurn !== ''player'' || player.mp < skill.mpCost"
                                        :class="currentTurn !== ''player'' || player.mp < skill.mpCost ? ''opacity-50 cursor-not-allowed'' : ''hover:bg-gray-600''"
                                        class="bg-gray-700 rounded-lg p-3 text-left transition">
                                    <div class="font-semibold" x-text="skill.name"></div>
                                    <div class="text-xs text-gray-400">
                                        MP: <span x-text="skill.mpCost"></span>
                                    </div>
                                    <div class="text-xs text-blue-400 font-mono mt-1" x-text="skill.code"></div>
                                </button>
                            </template>
                        </div>
                    </div>

                    <!-- Items -->
                    <div>
                        <h3 class="text-lg font-bold mb-3">Items</h3>
                        <div class="space-y-2">
                            <button @click="useItem(''potions'')"
                                    :disabled="currentTurn !== ''player'' || inventory.potions <= 0"
                                    :class="currentTurn !== ''player'' || inventory.potions <= 0 ? ''opacity-50 cursor-not-allowed'' : ''hover:bg-gray-600''"
                                    class="w-full bg-gray-700 rounded-lg p-3 text-left transition flex justify-between">
                                <span>🧪 Potion</span>
                                <span x-text="inventory.potions"></span>
                            </button>
                            <button @click="useItem(''ethers'')"
                                    :disabled="currentTurn !== ''player'' || inventory.ethers <= 0"
                                    :class="currentTurn !== ''player'' || inventory.ethers <= 0 ? ''opacity-50 cursor-not-allowed'' : ''hover:bg-gray-600''"
                                    class="w-full bg-gray-700 rounded-lg p-3 text-left transition flex justify-between">
                                <span>💙 Ether</span>
                                <span x-text="inventory.ethers"></span>
                            </button>
                            <button @click="useItem(''debuggers'')"
                                    :disabled="currentTurn !== ''player'' || inventory.debuggers <= 0"
                                    :class="currentTurn !== ''player'' || inventory.debuggers <= 0 ? ''opacity-50 cursor-not-allowed'' : ''hover:bg-gray-600''"
                                    class="w-full bg-gray-700 rounded-lg p-3 text-left transition flex justify-between">
                                <span>🔍 Debugger</span>
                                <span x-text="inventory.debuggers"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Victory Screen -->
    <div x-show="gameState === ''victory''" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-2xl mx-auto px-8">
            <div class="mb-8">
                <div class="text-8xl mb-4">🎉</div>
                <h1 class="text-5xl font-bold mb-4 text-yellow-400">Victory!</h1>
                <p class="text-2xl text-gray-400">You defeated <span x-text="currentEnemy?.name"></span>!</p>
            </div>

            <!-- Rewards -->
            <div class="bg-gray-800 rounded-2xl p-6 mb-8">
                <h3 class="text-xl font-bold mb-4">Rewards</h3>
                <div class="space-y-3">
                    <div class="flex justify-between">
                        <span>Experience</span>
                        <span class="text-yellow-400">+<span x-text="currentEnemy?.rewards.exp"></span> EXP</span>
                    </div>
                    <div class="flex justify-between">
                        <span>New Skill</span>
                        <span class="text-green-400" x-text="currentEnemy?.rewards.skill"></span>
                    </div>
                </div>

                <!-- EXP Bar -->
                <div class="mt-4">
                    <div class="flex justify-between text-sm mb-1">
                        <span>Level <span x-text="player.level"></span></span>
                        <span><span x-text="player.exp"></span>/<span x-text="player.expToNext"></span> EXP</span>
                    </div>
                    <div class="bg-gray-700 rounded-full h-3">
                        <div class="bg-yellow-500 h-full rounded-full transition-all duration-300"
                             :style="`width: ${(player.exp / player.expToNext) * 100}%`"></div>
                    </div>
                </div>
            </div>

            <button @click="nextBattle"
                    class="px-8 py-3 bg-blue-600 hover:bg-blue-700 rounded-lg font-bold text-xl">
                Next Battle →
            </button>
        </div>
    </div>

    <!-- Defeat Screen -->
    <div x-show="gameState === ''defeat''" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-2xl mx-auto px-8">
            <div class="mb-8">
                <div class="text-8xl mb-4">💀</div>
                <h1 class="text-5xl font-bold mb-4 text-red-500">Defeated...</h1>
                <p class="text-2xl text-gray-400">The bugs were too strong!</p>
            </div>

            <button @click="gameState = ''menu''; player.hp = player.maxHp; player.mp = player.maxMp"
                    class="px-8 py-3 bg-red-600 hover:bg-red-700 rounded-lg font-bold text-xl">
                Try Again
            </button>
        </div>
    </div>

    <!-- Complete Screen -->
    <div x-show="gameState === ''complete''" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-2xl mx-auto px-8">
            <div class="mb-8">
                <div class="text-8xl mb-4">👑</div>
                <h1 class="text-6xl font-bold mb-4 bg-gradient-to-r from-yellow-400 to-yellow-600 bg-clip-text text-transparent">
                    Code Champion!
                </h1>
                <p class="text-2xl text-gray-400">You''ve mastered the art of Code Combat!</p>
            </div>

            <div class="bg-gray-800 rounded-2xl p-8 mb-8">
                <h3 class="text-2xl font-bold mb-4">Final Stats</h3>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <p class="text-gray-400">Level</p>
                        <p class="text-3xl font-bold" x-text="player.level"></p>
                    </div>
                    <div>
                        <p class="text-gray-400">Skills Unlocked</p>
                        <p class="text-3xl font-bold" x-text="unlockedSkills.length"></p>
                    </div>
                </div>
            </div>

            <button @click="location.reload()"
                    class="px-8 py-3 bg-gradient-to-r from-purple-600 to-pink-600 rounded-lg font-bold text-xl">
                New Game+
            </button>
        </div>
    </div>
</body>
</html>', '', '', 'gamified', true, 4, '{"level": 3, "duration": "20-30 min", "skills": ["Programming", "Problem Solving", "RPG Mechanics"]}'),

-- Template 5: Final Boss - Launch Day
('🚀 Final Boss: Launch Day', 'Der ultimative Test - Launche dein eigenes Projekt!',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Final Boss: Launch Day</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-black text-white min-h-screen" x-data="{
    // Game phases
    currentPhase: ''intro'', // intro, planning, building, testing, launch, success

    // Project data
    project: {
        name: '''',
        type: '''',
        features: [],
        techStack: [],
        design: {
            style: '''',
            primaryColor: '''',
            darkMode: false
        }
    },

    // Progress tracking
    progress: {
        planning: 0,
        development: 0,
        testing: 0,
        deployment: 0
    },

    // Challenges to overcome
    challenges: {
        bugs: 5,
        performance: 3,
        responsive: 4,
        accessibility: 3
    },

    // Resources
    resources: {
        time: 100,
        energy: 100,
        motivation: 100
    },

    // Skills from previous levels
    unlockedSkills: [
        ''HTML Mastery'',
        ''CSS Wizardry'',
        ''JavaScript Ninja'',
        ''Design Psychology'',
        ''Interaction Expert''
    ],

    // Launch metrics
    launchMetrics: {
        users: 0,
        rating: 0,
        feedback: []
    },

    // Available project types
    projectTypes: [
        { id: ''portfolio'', name: ''Portfolio Website'', icon: ''💼'', difficulty: ''medium'' },
        { id: ''ecommerce'', name: ''Online Shop'', icon: ''🛍️'', difficulty: ''hard'' },
        { id: ''social'', name: ''Social Platform'', icon: ''💬'', difficulty: ''very hard'' },
        { id: ''game'', name: ''Web Game'', icon: ''🎮'', difficulty: ''hard'' },
        { id: ''saas'', name: ''SaaS Tool'', icon: ''⚡'', difficulty: ''very hard'' },
        { id: ''blog'', name: ''Blog Platform'', icon: ''📝'', difficulty: ''easy'' }
    ],

    // Tech stack options
    techOptions: {
        frontend: [''React'', ''Vue'', ''Alpine.js'', ''Vanilla JS''],
        styling: [''Tailwind'', ''Bootstrap'', ''Custom CSS'', ''Styled Components''],
        backend: [''Node.js'', ''Firebase'', ''Supabase'', ''Static''],
        database: [''PostgreSQL'', ''MongoDB'', ''LocalStorage'', ''None'']
    },

    // Methods
    startPlanning() {
        this.currentPhase = ''planning'';
    },

    selectProjectType(type) {
        this.project.type = type;
        this.progress.planning += 25;
    },

    addFeature(feature) {
        if (this.project.features.length < 5) {
            this.project.features.push(feature);
            this.progress.planning += 15;
            this.resources.time -= 5;
        }
    },

    selectTech(category, tech) {
        this.project.techStack.push({ category, tech });
        this.progress.planning += 10;
    },

    startBuilding() {
        if (this.progress.planning >= 60) {
            this.currentPhase = ''building'';
            this.simulateBuilding();
        }
    },

    simulateBuilding() {
        const buildInterval = setInterval(() => {
            if (this.progress.development < 100 && this.resources.energy > 0) {
                this.progress.development += 5;
                this.resources.energy -= 2;
                this.resources.time -= 1;

                // Random challenges appear
                if (Math.random() < 0.1) {
                    this.showChallenge();
                }
            } else {
                clearInterval(buildInterval);
                if (this.progress.development >= 100) {
                    this.currentPhase = ''testing'';
                }
            }
        }, 500);
    },

    showChallenge() {
        // Random bug or issue appears
        const challengeTypes = Object.keys(this.challenges);
        const challenge = challengeTypes[Math.floor(Math.random() * challengeTypes.length)];
        console.log(`New ${challenge} challenge!`);
    },

    fixBug(type) {
        if (this.challenges[type] > 0) {
            this.challenges[type]--;
            this.progress.testing += 10;
            this.resources.energy -= 5;
        }
    },

    startTesting() {
        this.currentPhase = ''testing'';
    },

    deployProject() {
        if (this.progress.testing >= 80) {
            this.currentPhase = ''launch'';
            this.simulateLaunch();
        }
    },

    simulateLaunch() {
        // Simulate user growth
        let userGrowth = setInterval(() => {
            this.launchMetrics.users += Math.floor(Math.random() * 50) + 10;
            this.launchMetrics.rating = Math.min(5, this.launchMetrics.rating + 0.1);

            if (this.launchMetrics.users >= 1000) {
                clearInterval(userGrowth);
                this.currentPhase = ''success'';
            }
        }, 300);

        // Generate feedback
        const feedbackOptions = [
            ''Amazing design! 🎨'',
            ''Super fast and responsive! ⚡'',
            ''Love the user experience! 💖'',
            ''This is exactly what I needed! 🎯'',
            ''Incredible work! 🚀''
        ];

        setInterval(() => {
            if (this.launchMetrics.feedback.length < 10) {
                this.launchMetrics.feedback.push(
                    feedbackOptions[Math.floor(Math.random() * feedbackOptions.length)]
                );
            }
        }, 1000);
    },

    get overallProgress() {
        return (this.progress.planning + this.progress.development + this.progress.testing + this.progress.deployment) / 4;
    },

    get totalChallenges() {
        return Object.values(this.challenges).reduce((a, b) => a + b, 0);
    }
}">
    <!-- Intro Phase -->
    <div x-show="currentPhase === ''intro''" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-4xl mx-auto px-8">
            <div class="mb-12">
                <h1 class="text-7xl font-bold mb-6 bg-gradient-to-r from-blue-400 via-purple-500 to-pink-500 bg-clip-text text-transparent animate-pulse">
                    FINAL BOSS: LAUNCH DAY
                </h1>
                <p class="text-2xl text-gray-400 mb-8">The Ultimate Web Developer Challenge</p>
            </div>

            <div class="bg-gray-900 rounded-3xl p-8 mb-8 backdrop-blur-lg bg-opacity-80">
                <h2 class="text-3xl font-bold mb-6 text-yellow-400">🎯 Your Mission</h2>
                <p class="text-xl mb-6">
                    Use everything you''ve learned to plan, build, test, and launch a real project!
                </p>

                <div class="grid md:grid-cols-4 gap-4 mb-8">
                    <div class="bg-gray-800 rounded-xl p-4">
                        <div class="text-3xl mb-2">📋</div>
                        <h3 class="font-bold">Plan</h3>
                        <p class="text-sm text-gray-400">Choose your project</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <div class="text-3xl mb-2">🛠️</div>
                        <h3 class="font-bold">Build</h3>
                        <p class="text-sm text-gray-400">Code your vision</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <div class="text-3xl mb-2">🧪</div>
                        <h3 class="font-bold">Test</h3>
                        <p class="text-sm text-gray-400">Fix all issues</p>
                    </div>
                    <div class="bg-gray-800 rounded-xl p-4">
                        <div class="text-3xl mb-2">🚀</div>
                        <h3 class="font-bold">Launch</h3>
                        <p class="text-sm text-gray-400">Go live!</p>
                    </div>
                </div>

                <div class="bg-gray-800 rounded-xl p-6">
                    <h3 class="text-xl font-bold mb-4">Your Unlocked Skills</h3>
                    <div class="flex flex-wrap gap-2 justify-center">
                        <template x-for="skill in unlockedSkills" :key="skill">
                            <span class="bg-gradient-to-r from-blue-600 to-purple-600 px-3 py-1 rounded-full text-sm">
                                ✅ <span x-text="skill"></span>
                            </span>
                        </template>
                    </div>
                </div>
            </div>

            <button @click="startPlanning"
                    class="px-12 py-6 bg-gradient-to-r from-green-400 to-blue-500 rounded-full text-3xl font-bold hover:scale-110 transform transition animate-bounce">
                Accept Challenge! 🚀
            </button>
        </div>
    </div>

    <!-- Planning Phase -->
    <div x-show="currentPhase === ''planning''" x-transition class="min-h-screen p-8">
        <div class="max-w-6xl mx-auto">
            <!-- Progress Header -->
            <div class="mb-8">
                <h2 class="text-4xl font-bold mb-4">📋 Planning Phase</h2>
                <div class="bg-gray-800 rounded-full h-4">
                    <div class="bg-gradient-to-r from-blue-500 to-purple-500 h-full rounded-full transition-all duration-500"
                         :style="`width: ${progress.planning}%`"></div>
                </div>
                <p class="text-sm text-gray-400 mt-2">Planning Progress: <span x-text="progress.planning"></span>%</p>
            </div>

            <!-- Project Type Selection -->
            <div class="mb-8" x-show="!project.type">
                <h3 class="text-2xl font-bold mb-4">Choose Your Project Type</h3>
                <div class="grid md:grid-cols-3 gap-4">
                    <template x-for="type in projectTypes" :key="type.id">
                        <button @click="selectProjectType(type.id)"
                                class="bg-gray-800 hover:bg-gray-700 rounded-xl p-6 text-left transition transform hover:scale-105">
                            <div class="text-4xl mb-3" x-text="type.icon"></div>
                            <h4 class="text-xl font-bold mb-2" x-text="type.name"></h4>
                            <p class="text-sm text-gray-400">Difficulty: <span x-text="type.difficulty"></span></p>
                        </button>
                    </template>
                </div>
            </div>

            <!-- Feature Selection -->
            <div class="mb-8" x-show="project.type && project.features.length < 5">
                <h3 class="text-2xl font-bold mb-4">Select Features (Max 5)</h3>
                <div class="grid md:grid-cols-4 gap-3">
                    <button @click="addFeature('User Authentication')"
                            class="bg-gray-700 hover:bg-gray-600 rounded-lg p-3 transition">
                        🔐 User Auth
                    </button>
                    <button @click="addFeature('Real-time Updates')"
                            class="bg-gray-700 hover:bg-gray-600 rounded-lg p-3 transition">
                        ⚡ Real-time
                    </button>
                    <button @click="addFeature('Dark Mode')"
                            class="bg-gray-700 hover:bg-gray-600 rounded-lg p-3 transition">
                        🌙 Dark Mode
                    </button>
                    <button @click="addFeature('Mobile App')"
                            class="bg-gray-700 hover:bg-gray-600 rounded-lg p-3 transition">
                        📱 Mobile App
                    </button>
                    <button @click="addFeature('Analytics')"
                            class="bg-gray-700 hover:bg-gray-600 rounded-lg p-3 transition">
                        📊 Analytics
                    </button>
                    <button @click="addFeature('Social Sharing')"
                            class="bg-gray-700 hover:bg-gray-600 rounded-lg p-3 transition">
                        🔗 Social Share
                    </button>
                    <button @click="addFeature('Payment System')"
                            class="bg-gray-700 hover:bg-gray-600 rounded-lg p-3 transition">
                        💳 Payments
                    </button>
                    <button @click="addFeature('AI Features')"
                            class="bg-gray-700 hover:bg-gray-600 rounded-lg p-3 transition">
                        🤖 AI Features
                    </button>
                </div>
                <div class="mt-4">
                    <p class="text-sm text-gray-400">Selected Features:</p>
                    <div class="flex flex-wrap gap-2 mt-2">
                        <template x-for="feature in project.features" :key="feature">
                            <span class="bg-blue-600 px-3 py-1 rounded-full text-sm" x-text="feature"></span>
                        </template>
                    </div>
                </div>
            </div>

            <!-- Tech Stack Selection -->
            <div class="mb-8" x-show="project.type">
                <h3 class="text-2xl font-bold mb-4">Choose Your Tech Stack</h3>
                <div class="grid md:grid-cols-2 gap-6">
                    <template x-for="(options, category) in techOptions" :key="category">
                        <div class="bg-gray-800 rounded-xl p-6">
                            <h4 class="font-bold mb-3 capitalize" x-text="category"></h4>
                            <div class="grid grid-cols-2 gap-2">
                                <template x-for="tech in options" :key="tech">
                                    <button @click="selectTech(category, tech)"
                                            class="bg-gray-700 hover:bg-gray-600 rounded px-3 py-2 text-sm transition">
                                        <span x-text="tech"></span>
                                    </button>
                                </template>
                            </div>
                        </div>
                    </template>
                </div>
            </div>

            <!-- Start Building Button -->
            <div class="text-center mt-8">
                <button @click="startBuilding"
                        :disabled="progress.planning < 60"
                        :class="progress.planning >= 60 ? 'bg-green-600 hover:bg-green-700' : 'bg-gray-700 opacity-50 cursor-not-allowed'"
                        class="px-8 py-4 rounded-full text-xl font-bold transition">
                    Start Building! 🛠️
                </button>
                <p x-show="progress.planning < 60" class="text-sm text-gray-400 mt-2">
                    Complete more planning tasks to continue
                </p>
            </div>
        </div>
    </div>

    <!-- Building Phase -->
    <div x-show="currentPhase === 'building'" x-transition class="min-h-screen p-8">
        <div class="max-w-6xl mx-auto">
            <h2 class="text-4xl font-bold mb-8">🛠️ Building Phase</h2>

            <!-- Resource Bars -->
            <div class="grid md:grid-cols-3 gap-4 mb-8">
                <div class="bg-gray-800 rounded-xl p-4">
                    <div class="flex justify-between mb-2">
                        <span>⏱️ Time</span>
                        <span><span x-text="resources.time"></span>%</span>
                    </div>
                    <div class="bg-gray-700 rounded-full h-3">
                        <div class="bg-blue-500 h-full rounded-full transition-all"
                             :style="`width: ${resources.time}%`"></div>
                    </div>
                </div>
                <div class="bg-gray-800 rounded-xl p-4">
                    <div class="flex justify-between mb-2">
                        <span>⚡ Energy</span>
                        <span><span x-text="resources.energy"></span>%</span>
                    </div>
                    <div class="bg-gray-700 rounded-full h-3">
                        <div class="bg-yellow-500 h-full rounded-full transition-all"
                             :style="`width: ${resources.energy}%`"></div>
                    </div>
                </div>
                <div class="bg-gray-800 rounded-xl p-4">
                    <div class="flex justify-between mb-2">
                        <span>💪 Motivation</span>
                        <span><span x-text="resources.motivation"></span>%</span>
                    </div>
                    <div class="bg-gray-700 rounded-full h-3">
                        <div class="bg-green-500 h-full rounded-full transition-all"
                             :style="`width: ${resources.motivation}%`"></div>
                    </div>
                </div>
            </div>

            <!-- Code Editor Simulation -->
            <div class="bg-gray-900 rounded-2xl p-6 mb-8">
                <div class="flex items-center gap-3 mb-4">
                    <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                    <div class="w-3 h-3 bg-yellow-500 rounded-full"></div>
                    <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                    <span class="text-sm text-gray-400 ml-4">main.js</span>
                </div>

                <div class="font-mono text-sm space-y-2">
                    <p><span class="text-purple-400">const</span> <span class="text-blue-400">app</span> = <span class="text-yellow-400">createApp</span>({</p>
                    <p class="ml-4"><span class="text-blue-400">name:</span> <span class="text-green-400">'<span x-text="project.name || 'My Awesome Project'"></span>'</span>,</p>
                    <p class="ml-4"><span class="text-blue-400">features:</span> [<span class="text-green-400" x-text="project.features.map(f => `'${f}'`).join(', ')"></span>],</p>
                    <p class="ml-4"><span class="text-blue-400">progress:</span> <span class="text-orange-400" x-text="progress.development"></span>%</p>
                    <p>});</p>
                </div>
            </div>

            <!-- Development Progress -->
            <div class="bg-gray-800 rounded-xl p-6">
                <h3 class="text-xl font-bold mb-4">Development Progress</h3>
                <div class="mb-4">
                    <div class="bg-gray-700 rounded-full h-6">
                        <div class="bg-gradient-to-r from-green-500 to-blue-500 h-full rounded-full transition-all duration-500 flex items-center justify-center text-xs font-bold"
                             :style="`width: ${progress.development}%`">
                            <span x-show="progress.development > 10" x-text="progress.development + '%'"></span>
                        </div>
                    </div>
                </div>

                <div x-show="totalChallenges > 0" class="mt-4 p-4 bg-red-900 bg-opacity-50 rounded-lg">
                    <p class="font-bold mb-2">⚠️ Active Challenges:</p>
                    <div class="grid grid-cols-2 gap-2 text-sm">
                        <div x-show="challenges.bugs > 0">🐛 Bugs: <span x-text="challenges.bugs"></span></div>
                        <div x-show="challenges.performance > 0">⚡ Performance: <span x-text="challenges.performance"></span></div>
                        <div x-show="challenges.responsive > 0">📱 Responsive: <span x-text="challenges.responsive"></span></div>
                        <div x-show="challenges.accessibility > 0">♿ Accessibility: <span x-text="challenges.accessibility"></span></div>
                    </div>
                </div>
            </div>

            <div x-show="progress.development >= 100" class="text-center mt-8">
                <button @click="startTesting"
                        class="px-8 py-4 bg-purple-600 hover:bg-purple-700 rounded-full text-xl font-bold">
                    Move to Testing! 🧪
                </button>
            </div>
        </div>
    </div>

    <!-- Testing Phase -->
    <div x-show="currentPhase === 'testing'" x-transition class="min-h-screen p-8">
        <div class="max-w-6xl mx-auto">
            <h2 class="text-4xl font-bold mb-8">🧪 Testing Phase</h2>

            <div class="grid md:grid-cols-2 gap-8">
                <!-- Bug Fixing -->
                <div class="bg-gray-800 rounded-xl p-6">
                    <h3 class="text-xl font-bold mb-4">Fix Issues</h3>
                    <div class="space-y-3">
                        <button @click="fixBug('bugs')"
                                :disabled="challenges.bugs === 0"
                                :class="challenges.bugs > 0 ? 'bg-red-700 hover:bg-red-600' : 'bg-gray-700 opacity-50'"
                                class="w-full p-4 rounded-lg transition flex justify-between items-center">
                            <span>🐛 Fix Bugs</span>
                            <span class="text-2xl font-bold" x-text="challenges.bugs"></span>
                        </button>
                        <button @click="fixBug('performance')"
                                :disabled="challenges.performance === 0"
                                :class="challenges.performance > 0 ? 'bg-yellow-700 hover:bg-yellow-600' : 'bg-gray-700 opacity-50'"
                                class="w-full p-4 rounded-lg transition flex justify-between items-center">
                            <span>⚡ Optimize Performance</span>
                            <span class="text-2xl font-bold" x-text="challenges.performance"></span>
                        </button>
                        <button @click="fixBug('responsive')"
                                :disabled="challenges.responsive === 0"
                                :class="challenges.responsive > 0 ? 'bg-blue-700 hover:bg-blue-600' : 'bg-gray-700 opacity-50'"
                                class="w-full p-4 rounded-lg transition flex justify-between items-center">
                            <span>📱 Fix Responsive Issues</span>
                            <span class="text-2xl font-bold" x-text="challenges.responsive"></span>
                        </button>
                        <button @click="fixBug('accessibility')"
                                :disabled="challenges.accessibility === 0"
                                :class="challenges.accessibility > 0 ? 'bg-purple-700 hover:bg-purple-600' : 'bg-gray-700 opacity-50'"
                                class="w-full p-4 rounded-lg transition flex justify-between items-center">
                            <span>♿ Improve Accessibility</span>
                            <span class="text-2xl font-bold" x-text="challenges.accessibility"></span>
                        </button>
                    </div>
                </div>

                <!-- Test Results -->
                <div class="bg-gray-800 rounded-xl p-6">
                    <h3 class="text-xl font-bold mb-4">Test Results</h3>
                    <div class="space-y-4">
                        <div>
                            <p class="text-sm text-gray-400 mb-1">Overall Quality</p>
                            <div class="bg-gray-700 rounded-full h-4">
                                <div class="bg-green-500 h-full rounded-full transition-all"
                                     :style="`width: ${progress.testing}%`"></div>
                            </div>
                        </div>

                        <div class="bg-gray-900 rounded-lg p-4">
                            <p class="font-mono text-sm">
                                <span class="text-green-400">✓ Unit Tests: Passing</span><br>
                                <span :class="totalChallenges === 0 ? 'text-green-400' : 'text-red-400'">
                                    <span x-text="totalChallenges === 0 ? '✓' : '✗'"></span> Integration Tests:
                                    <span x-text="totalChallenges === 0 ? 'Passing' : `${totalChallenges} issues`"></span>
                                </span><br>
                                <span :class="challenges.performance === 0 ? 'text-green-400' : 'text-yellow-400'">
                                    <span x-text="challenges.performance === 0 ? '✓' : '⚠'"></span> Performance:
                                    <span x-text="challenges.performance === 0 ? 'Optimal' : 'Needs work'"></span>
                                </span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div x-show="progress.testing >= 80" class="text-center mt-8">
                <button @click="deployProject"
                        class="px-8 py-4 bg-gradient-to-r from-green-500 to-blue-500 rounded-full text-xl font-bold hover:scale-110 transition">
                    Deploy to Production! 🚀
                </button>
            </div>
        </div>
    </div>

    <!-- Launch Phase -->
    <div x-show="currentPhase === 'launch'" x-transition class="min-h-screen p-8">
        <div class="max-w-6xl mx-auto text-center">
            <h2 class="text-5xl font-bold mb-8">🚀 LAUNCH DAY!</h2>

            <!-- Launch Metrics -->
            <div class="grid md:grid-cols-3 gap-8 mb-8">
                <div class="bg-gray-800 rounded-xl p-6">
                    <div class="text-5xl font-bold text-green-400 mb-2" x-text="launchMetrics.users.toLocaleString()"></div>
                    <p class="text-gray-400">Active Users</p>
                </div>
                <div class="bg-gray-800 rounded-xl p-6">
                    <div class="text-5xl font-bold text-yellow-400 mb-2">
                        <span x-text="launchMetrics.rating.toFixed(1)"></span>⭐
                    </div>
                    <p class="text-gray-400">User Rating</p>
                </div>
                <div class="bg-gray-800 rounded-xl p-6">
                    <div class="text-5xl font-bold text-purple-400 mb-2" x-text="launchMetrics.feedback.length"></div>
                    <p class="text-gray-400">Reviews</p>
                </div>
            </div>

            <!-- Live Feed -->
            <div class="bg-gray-800 rounded-xl p-6 mb-8">
                <h3 class="text-xl font-bold mb-4">📊 Live User Feedback</h3>
                <div class="space-y-2 max-h-60 overflow-y-auto">
                    <template x-for="feedback in launchMetrics.feedback" :key="feedback">
                        <div class="bg-gray-900 rounded-lg p-3 text-left">
                            <p x-text="feedback"></p>
                        </div>
                    </template>
                </div>
            </div>

            <div class="text-6xl mb-4">🎊</div>
            <p class="text-2xl text-gray-400">Your project is live and growing!</p>
        </div>
    </div>

    <!-- Success Phase -->
    <div x-show="currentPhase === 'success'" x-transition
         class="min-h-screen flex items-center justify-center">
        <div class="text-center max-w-4xl mx-auto px-8">
            <div class="mb-8">
                <div class="text-8xl mb-4">👑</div>
                <h1 class="text-7xl font-bold mb-4 bg-gradient-to-r from-yellow-400 via-orange-400 to-red-400 bg-clip-text text-transparent">
                    LEGENDARY LAUNCH!
                </h1>
                <p class="text-3xl text-gray-400 mb-8">You are now a Full-Stack Master!</p>
            </div>

            <div class="bg-gray-800 rounded-3xl p-8 mb-8">
                <h3 class="text-2xl font-bold mb-6">🏆 Final Achievement</h3>
                <div class="grid md:grid-cols-2 gap-6">
                    <div>
                        <p class="text-gray-400">Project Launched</p>
                        <p class="text-3xl font-bold text-green-400">Successfully! ✅</p>
                    </div>
                    <div>
                        <p class="text-gray-400">Users Reached</p>
                        <p class="text-3xl font-bold text-yellow-400" x-text="launchMetrics.users.toLocaleString()"></p>
                    </div>
                </div>
            </div>

            <div class="bg-gradient-to-r from-purple-800 to-pink-800 rounded-2xl p-8">
                <h3 class="text-2xl font-bold mb-4">🎯 Skills Mastered</h3>
                <div class="flex flex-wrap gap-3 justify-center">
                    <span class="bg-white bg-opacity-20 px-4 py-2 rounded-full">Planning & Architecture</span>
                    <span class="bg-white bg-opacity-20 px-4 py-2 rounded-full">Full-Stack Development</span>
                    <span class="bg-white bg-opacity-20 px-4 py-2 rounded-full">Testing & Debugging</span>
                    <span class="bg-white bg-opacity-20 px-4 py-2 rounded-full">Deployment & DevOps</span>
                    <span class="bg-white bg-opacity-20 px-4 py-2 rounded-full">User Experience</span>
                    <span class="bg-white bg-opacity-20 px-4 py-2 rounded-full">Project Management</span>
                </div>
            </div>

            <button class="mt-8 px-12 py-6 bg-gradient-to-r from-green-400 to-blue-500 rounded-full text-3xl font-bold hover:scale-110 transform transition">
                Start Your Next Adventure! 🚀
            </button>
        </div>
    </div>

    <!-- Background Effects -->
    <div class="fixed inset-0 pointer-events-none -z-10">
        <div class="absolute top-0 left-0 w-full h-full">
            <div class="absolute top-20 left-20 w-64 h-64 bg-purple-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-pulse"></div>
            <div class="absolute bottom-20 right-20 w-64 h-64 bg-pink-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-pulse animation-delay-2000"></div>
            <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-blue-500 rounded-full mix-blend-multiply filter blur-3xl opacity-10 animate-pulse animation-delay-4000"></div>
        </div>
    </div>

    <style>
        .animation-delay-2000 {
            animation-delay: 2s;
        }

        .animation-delay-4000 {
            animation-delay: 4s;
        }
    </style>
</body>
</html>', '', '', 'gamified', true, 5, '{"level": 5, "duration": "30-45 min", "skills": ["Project Management", "Full-Stack", "Deployment", "Testing"]}');