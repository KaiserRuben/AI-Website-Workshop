-- Migration: Quick Start Templates
-- Category: quick_start
-- Purpose: Immediate success for absolute beginners

INSERT INTO templates (name, description, html, css, js, category, is_active, order_index, template_metadata) VALUES

-- Template 1: Hello Web - HTML/CSS Basics
('🌟 Hello Web - Dein erster Schritt', 'HTML & CSS Grundlagen in 15 Minuten verstehen',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Lerne die Grundlagen von HTML und CSS">
    <title>Hello Web - Mein Start ins Web</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen" x-data="{
    currentStep: 0,
    userName: '''',
    favoriteColor: ''blue'',
    showCelebration: false,
    completedSteps: [],

    steps: [
        {
            title: ''👋 Willkommen im Web!'',
            instruction: ''Lass uns gemeinsam deine erste Website bauen!'',
            task: ''Klicke auf Weiter, um zu starten'',
            completed: false
        },
        {
            title: ''📝 HTML verstehen'',
            instruction: ''HTML sind die Bausteine deiner Website'',
            task: ''Gib deinen Namen ein'',
            completed: false
        },
        {
            title: ''🎨 CSS macht es schön'',
            instruction: ''CSS ist wie die Farbe und das Design'',
            task: ''Wähle deine Lieblingsfarbe'',
            completed: false
        },
        {
            title: ''✨ Deine erste Website!'',
            instruction: ''Glückwunsch! Du hast es geschafft!'',
            task: ''Bewundere dein Werk'',
            completed: false
        }
    ],

    nextStep() {
        if (this.currentStep < this.steps.length - 1) {
            this.steps[this.currentStep].completed = true;
            this.completedSteps.push(this.currentStep);
            this.currentStep++;

            if (this.currentStep === this.steps.length - 1) {
                this.showCelebration = true;
                setTimeout(() => this.showCelebration = false, 3000);
            }
        }
    },

    get progress() {
        return Math.round((this.completedSteps.length / this.steps.length) * 100);
    }
}">
    <!-- Progress Bar -->
    <div class="fixed top-0 left-0 right-0 h-2 bg-gray-200">
        <div class="h-full bg-gradient-to-r from-blue-500 to-purple-500 transition-all duration-500"
             :style="`width: ${progress}%`"></div>
    </div>

    <!-- Main Container -->
    <div class="container mx-auto px-4 pt-12 pb-8">
        <!-- Header -->
        <header class="text-center mb-12">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">
                <span class="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                    Hello Web!
                </span>
            </h1>
            <p class="text-xl text-gray-700">Lerne HTML & CSS in nur 15 Minuten</p>
        </header>

        <!-- Learning Interface -->
        <div class="max-w-4xl mx-auto">
            <!-- Step Indicator -->
            <div class="flex justify-center mb-8">
                <div class="flex items-center space-x-2">
                    <template x-for="(step, index) in steps" :key="index">
                        <div class="flex items-center">
                            <div class="w-10 h-10 rounded-full flex items-center justify-center font-bold transition-all duration-300"
                                 :class="{
                                     ''bg-green-500 text-white'': step.completed,
                                     ''bg-blue-500 text-white'': currentStep === index && !step.completed,
                                     ''bg-gray-300 text-gray-600'': currentStep < index
                                 }">
                                <span x-show="!step.completed" x-text="index + 1"></span>
                                <span x-show="step.completed">✓</span>
                            </div>
                            <div x-show="index < steps.length - 1"
                                 class="w-12 h-1 transition-all duration-300"
                                 :class="step.completed ? ''bg-green-500'' : ''bg-gray-300''"></div>
                        </div>
                    </template>
                </div>
            </div>

            <!-- Content Area -->
            <div class="bg-white rounded-2xl shadow-xl p-8 mb-8">
                <!-- Step Content -->
                <div class="text-center mb-8">
                    <h2 class="text-3xl font-bold mb-4" x-text="steps[currentStep].title"></h2>
                    <p class="text-xl text-gray-600 mb-2" x-text="steps[currentStep].instruction"></p>
                    <p class="text-lg text-blue-600 font-semibold" x-text="steps[currentStep].task"></p>
                </div>

                <!-- Interactive Elements -->
                <div class="space-y-6">
                    <!-- Step 0: Welcome -->
                    <div x-show="currentStep === 0" x-transition>
                        <div class="text-center space-y-4">
                            <div class="text-6xl animate-bounce">🚀</div>
                            <p class="text-lg">Bereit, deine eigene Website zu erstellen?</p>
                            <p class="text-gray-600">In den nächsten 15 Minuten lernst du:</p>
                            <ul class="text-left max-w-md mx-auto space-y-2">
                                <li class="flex items-center gap-2">
                                    <span class="text-green-500">✓</span>
                                    Was HTML ist und wie es funktioniert
                                </li>
                                <li class="flex items-center gap-2">
                                    <span class="text-green-500">✓</span>
                                    Wie CSS deine Website schön macht
                                </li>
                                <li class="flex items-center gap-2">
                                    <span class="text-green-500">✓</span>
                                    Wie du interaktive Elemente hinzufügst
                                </li>
                            </ul>
                        </div>
                    </div>

                    <!-- Step 1: HTML Basics -->
                    <div x-show="currentStep === 1" x-transition>
                        <div class="space-y-6">
                            <div class="bg-gray-50 p-6 rounded-lg">
                                <h3 class="font-bold text-lg mb-4">📚 Was ist HTML?</h3>
                                <p class="mb-4">HTML ist wie LEGO für Websites. Jeder Block hat eine Funktion:</p>
                                <div class="space-y-3">
                                    <div class="flex items-center gap-3 bg-white p-3 rounded">
                                        <code class="bg-blue-100 px-2 py-1 rounded text-blue-700">&lt;h1&gt;</code>
                                        <span>Große Überschrift</span>
                                    </div>
                                    <div class="flex items-center gap-3 bg-white p-3 rounded">
                                        <code class="bg-blue-100 px-2 py-1 rounded text-blue-700">&lt;p&gt;</code>
                                        <span>Normaler Text</span>
                                    </div>
                                    <div class="flex items-center gap-3 bg-white p-3 rounded">
                                        <code class="bg-blue-100 px-2 py-1 rounded text-blue-700">&lt;img&gt;</code>
                                        <span>Bilder</span>
                                    </div>
                                </div>
                            </div>

                            <div class="text-center">
                                <label class="block text-lg font-semibold mb-3">Wie heißt du?</label>
                                <input type="text"
                                       x-model="userName"
                                       placeholder="Dein Name"
                                       class="px-4 py-3 text-lg border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none">
                                <p class="mt-3 text-gray-600">
                                    Dieser Text wird in einem <code class="bg-gray-100 px-2 py-1 rounded">&lt;h1&gt;</code> Tag angezeigt
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Step 2: CSS Basics -->
                    <div x-show="currentStep === 2" x-transition>
                        <div class="space-y-6">
                            <div class="bg-gray-50 p-6 rounded-lg">
                                <h3 class="font-bold text-lg mb-4">🎨 Was ist CSS?</h3>
                                <p class="mb-4">CSS ist wie die Farbe und das Design für deine HTML-Bausteine:</p>
                                <div class="space-y-3">
                                    <div class="flex items-center justify-between bg-white p-3 rounded">
                                        <code class="bg-purple-100 px-2 py-1 rounded text-purple-700">color</code>
                                        <span>Textfarbe ändern</span>
                                    </div>
                                    <div class="flex items-center justify-between bg-white p-3 rounded">
                                        <code class="bg-purple-100 px-2 py-1 rounded text-purple-700">background</code>
                                        <span>Hintergrundfarbe</span>
                                    </div>
                                    <div class="flex items-center justify-between bg-white p-3 rounded">
                                        <code class="bg-purple-100 px-2 py-1 rounded text-purple-700">font-size</code>
                                        <span>Textgröße</span>
                                    </div>
                                </div>
                            </div>

                            <div class="text-center">
                                <label class="block text-lg font-semibold mb-3">Wähle deine Lieblingsfarbe:</label>
                                <div class="flex justify-center gap-4">
                                    <button @click="favoriteColor = ''blue''"
                                            class="w-16 h-16 bg-blue-500 rounded-lg transition-transform hover:scale-110"
                                            :class="favoriteColor === ''blue'' ? ''ring-4 ring-blue-300'' : ''''">
                                    </button>
                                    <button @click="favoriteColor = ''green''"
                                            class="w-16 h-16 bg-green-500 rounded-lg transition-transform hover:scale-110"
                                            :class="favoriteColor === ''green'' ? ''ring-4 ring-green-300'' : ''''">
                                    </button>
                                    <button @click="favoriteColor = ''purple''"
                                            class="w-16 h-16 bg-purple-500 rounded-lg transition-transform hover:scale-110"
                                            :class="favoriteColor === ''purple'' ? ''ring-4 ring-purple-300'' : ''''">
                                    </button>
                                    <button @click="favoriteColor = ''red''"
                                            class="w-16 h-16 bg-red-500 rounded-lg transition-transform hover:scale-110"
                                            :class="favoriteColor === ''red'' ? ''ring-4 ring-red-300'' : ''''">
                                    </button>
                                </div>
                                <p class="mt-3 text-gray-600">
                                    Diese Farbe wird mit CSS angewendet:
                                    <code class="bg-gray-100 px-2 py-1 rounded">color: <span x-text="favoriteColor"></span></code>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Step 3: Your Website -->
                    <div x-show="currentStep === 3" x-transition>
                        <div class="text-center space-y-6">
                            <div class="text-6xl animate-bounce">🎉</div>

                            <!-- Preview of their website -->
                            <div class="bg-gray-50 rounded-lg p-8 shadow-inner">
                                <div class="bg-white rounded-lg p-6 shadow-lg max-w-md mx-auto">
                                    <h1 class="text-3xl font-bold mb-4"
                                        :class="{
                                            ''text-blue-600'': favoriteColor === ''blue'',
                                            ''text-green-600'': favoriteColor === ''green'',
                                            ''text-purple-600'': favoriteColor === ''purple'',
                                            ''text-red-600'': favoriteColor === ''red''
                                        }">
                                        Hallo, <span x-text="userName || ''Web Developer''"></span>!
                                    </h1>
                                    <p class="text-gray-700 mb-4">Dies ist deine erste Website!</p>
                                    <div class="flex gap-2 justify-center">
                                        <div class="w-3 h-3 rounded-full animate-pulse"
                                             :class="{
                                                 ''bg-blue-500'': favoriteColor === ''blue'',
                                                 ''bg-green-500'': favoriteColor === ''green'',
                                                 ''bg-purple-500'': favoriteColor === ''purple'',
                                                 ''bg-red-500'': favoriteColor === ''red''
                                             }"></div>
                                        <div class="w-3 h-3 rounded-full animate-pulse animation-delay-200"
                                             :class="{
                                                 ''bg-blue-500'': favoriteColor === ''blue'',
                                                 ''bg-green-500'': favoriteColor === ''green'',
                                                 ''bg-purple-500'': favoriteColor === ''purple'',
                                                 ''bg-red-500'': favoriteColor === ''red''
                                             }"></div>
                                        <div class="w-3 h-3 rounded-full animate-pulse animation-delay-400"
                                             :class="{
                                                 ''bg-blue-500'': favoriteColor === ''blue'',
                                                 ''bg-green-500'': favoriteColor === ''green'',
                                                 ''bg-purple-500'': favoriteColor === ''purple'',
                                                 ''bg-red-500'': favoriteColor === ''red''
                                             }"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-green-50 border-2 border-green-300 rounded-lg p-6">
                                <h3 class="text-xl font-bold text-green-800 mb-3">🏆 Du hast gelernt:</h3>
                                <ul class="text-left max-w-md mx-auto space-y-2 text-green-700">
                                    <li>✅ HTML-Tags erstellen Struktur</li>
                                    <li>✅ CSS macht alles schön</li>
                                    <li>✅ Websites sind interaktiv</li>
                                    <li>✅ Du kannst jetzt loslegen!</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Navigation -->
                <div class="flex justify-between mt-8">
                    <button x-show="currentStep > 0 && currentStep < steps.length - 1"
                            @click="currentStep--"
                            class="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
                        ← Zurück
                    </button>

                    <button x-show="currentStep < steps.length - 1"
                            @click="nextStep"
                            :disabled="currentStep === 1 && !userName"
                            :class="(currentStep === 1 && !userName) ? ''opacity-50 cursor-not-allowed'' : ''hover:bg-blue-700''"
                            class="ml-auto px-6 py-3 bg-blue-600 text-white rounded-lg transition">
                        Weiter →
                    </button>

                    <button x-show="currentStep === steps.length - 1"
                            class="mx-auto px-8 py-3 bg-gradient-to-r from-green-500 to-blue-500 text-white rounded-lg hover:scale-105 transition transform">
                        🚀 Nächstes Level starten!
                    </button>
                </div>
            </div>

            <!-- Tips Box -->
            <div class="bg-blue-50 border-2 border-blue-200 rounded-xl p-6">
                <h3 class="text-lg font-bold text-blue-800 mb-3">💡 Wusstest du?</h3>
                <div x-show="currentStep === 0">
                    <p class="text-blue-700">Jede Website die du besuchst ist mit HTML gebaut - sogar YouTube und Instagram!</p>
                </div>
                <div x-show="currentStep === 1">
                    <p class="text-blue-700">HTML wurde 1993 erfunden. Es ist älter als Google!</p>
                </div>
                <div x-show="currentStep === 2">
                    <p class="text-blue-700">Mit CSS kannst du sogar Animationen erstellen - ganz ohne JavaScript!</p>
                </div>
                <div x-show="currentStep === 3">
                    <p class="text-blue-700">Du kannst jetzt die KI bitten, deine Website zu erweitern. Probier: "Füge ein Kontaktformular hinzu"</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Celebration Effect -->
    <div x-show="showCelebration" x-transition class="fixed inset-0 pointer-events-none z-50">
        <div class="flex items-center justify-center h-full">
            <div class="text-center">
                <div class="text-8xl mb-4 animate-bounce">🎊</div>
                <div class="text-4xl font-bold text-blue-600">Geschafft!</div>
            </div>
        </div>

        <!-- Confetti animation -->
        <div class="absolute inset-0">
            <div class="absolute top-0 left-1/4 w-4 h-4 bg-yellow-400 rounded-full animate-fall"></div>
            <div class="absolute top-0 left-1/2 w-4 h-4 bg-pink-400 rounded-full animate-fall animation-delay-200"></div>
            <div class="absolute top-0 left-3/4 w-4 h-4 bg-blue-400 rounded-full animate-fall animation-delay-400"></div>
        </div>
    </div>

    <style>
        @keyframes fall {
            to {
                transform: translateY(100vh) rotate(360deg);
            }
        }

        .animate-fall {
            animation: fall 3s ease-in-out;
        }

        .animation-delay-200 {
            animation-delay: 200ms;
        }

        .animation-delay-400 {
            animation-delay: 400ms;
        }
    </style>
</body>
</html>', '', '', 'quick_start', true, 1, '{"level": 1, "duration": "15 min", "skills": ["HTML", "CSS", "Web Basics"]}'),

-- Template 2: About Me - Personal Page
('👤 About Me - Persönliche Website', 'Erstelle deine persönliche Präsenz im Web',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Meine persönliche Website">
    <title>About Me - Persönliche Website</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50" x-data="{
    // Profile data
    profile: {
        name: ''Max Mustermann'',
        title: ''Web Enthusiast'',
        bio: ''Ich liebe es, neue Dinge zu lernen und kreative Projekte zu entwickeln.'',
        location: ''München, Deutschland'',
        avatar: ''https://ui-avatars.com/api/?name=Max+Mustermann&size=200&background=6366f1&color=fff''
    },

    // Interactive features
    darkMode: false,
    activeSection: ''about'',
    editMode: false,
    showContactForm: false,
    messageSent: false,

    // Skills with progress
    skills: [
        { name: ''HTML'', level: 90, color: ''orange'' },
        { name: ''CSS'', level: 85, color: ''blue'' },
        { name: ''JavaScript'', level: 70, color: ''yellow'' },
        { name: ''Design'', level: 80, color: ''purple'' }
    ],

    // Hobbies/Interests
    interests: [
        { emoji: ''💻'', name: ''Coding'', description: ''Neue Technologien erkunden'' },
        { emoji: ''📸'', name: ''Fotografie'', description: ''Momente festhalten'' },
        { emoji: ''🎮'', name: ''Gaming'', description: ''Strategiespiele und RPGs'' },
        { emoji: ''📚'', name: ''Lesen'', description: ''Science Fiction und Sachbücher'' }
    ],

    // Social links
    socials: [
        { platform: ''GitHub'', icon: ''🐙'', url: ''#'', color: ''gray'' },
        { platform: ''LinkedIn'', icon: ''💼'', url: ''#'', color: ''blue'' },
        { platform: ''Twitter'', icon: ''🐦'', url: ''#'', color: ''sky'' },
        { platform: ''Instagram'', icon: ''📷'', url: ''#'', color: ''pink'' }
    ],

    // Methods
    toggleDarkMode() {
        this.darkMode = !this.darkMode;
        document.documentElement.classList.toggle(''dark'');
    },

    sendMessage() {
        // Simulate sending message
        setTimeout(() => {
            this.messageSent = true;
            this.showContactForm = false;
            setTimeout(() => this.messageSent = false, 3000);
        }, 1000);
    },

    updateAvatar() {
        this.profile.avatar = `https://ui-avatars.com/api/?name=${this.profile.name}&size=200&background=6366f1&color=fff`;
    }
}"
:class="darkMode ? ''dark'' : ''''">
    <!-- Navigation Header -->
    <header class="bg-white dark:bg-gray-900 shadow-sm sticky top-0 z-40 transition-colors">
        <nav class="container mx-auto px-4 py-4">
            <div class="flex justify-between items-center">
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                    <span x-text="profile.name"></span>
                </h1>

                <div class="flex items-center gap-6">
                    <!-- Navigation Links -->
                    <div class="hidden md:flex gap-6">
                        <button @click="activeSection = ''about''"
                                :class="activeSection === ''about'' ? ''text-indigo-600 dark:text-indigo-400'' : ''text-gray-600 dark:text-gray-300''"
                                class="hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                            Über mich
                        </button>
                        <button @click="activeSection = ''skills''"
                                :class="activeSection === ''skills'' ? ''text-indigo-600 dark:text-indigo-400'' : ''text-gray-600 dark:text-gray-300''"
                                class="hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                            Skills
                        </button>
                        <button @click="activeSection = ''interests''"
                                :class="activeSection === ''interests'' ? ''text-indigo-600 dark:text-indigo-400'' : ''text-gray-600 dark:text-gray-300''"
                                class="hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                            Interessen
                        </button>
                        <button @click="activeSection = ''contact''"
                                :class="activeSection === ''contact'' ? ''text-indigo-600 dark:text-indigo-400'' : ''text-gray-600 dark:text-gray-300''"
                                class="hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                            Kontakt
                        </button>
                    </div>

                    <!-- Dark Mode Toggle -->
                    <button @click="toggleDarkMode"
                            class="p-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition">
                        <span x-show="!darkMode">🌙</span>
                        <span x-show="darkMode">☀️</span>
                    </button>

                    <!-- Edit Mode Toggle -->
                    <button @click="editMode = !editMode"
                            class="px-4 py-2 rounded-lg bg-indigo-600 text-white hover:bg-indigo-700 transition">
                        <span x-text="editMode ? ''Speichern'' : ''Bearbeiten''"></span>
                    </button>
                </div>
            </div>
        </nav>
    </header>

    <!-- Hero Section -->
    <section class="bg-gradient-to-br from-indigo-50 to-purple-50 dark:from-gray-900 dark:to-gray-800 py-20 transition-colors">
        <div class="container mx-auto px-4">
            <div class="max-w-4xl mx-auto text-center">
                <!-- Avatar -->
                <div class="relative inline-block mb-8">
                    <img :src="profile.avatar"
                         alt="Profile Avatar"
                         class="w-40 h-40 rounded-full shadow-xl ring-4 ring-white dark:ring-gray-800">
                    <div class="absolute bottom-0 right-0 w-8 h-8 bg-green-500 rounded-full ring-4 ring-white dark:ring-gray-800"></div>
                </div>

                <!-- Profile Info -->
                <div x-show="!editMode">
                    <h2 class="text-4xl font-bold text-gray-900 dark:text-white mb-4" x-text="profile.name"></h2>
                    <p class="text-xl text-indigo-600 dark:text-indigo-400 mb-4" x-text="profile.title"></p>
                    <p class="text-lg text-gray-600 dark:text-gray-300 mb-6 max-w-2xl mx-auto" x-text="profile.bio"></p>
                    <p class="text-gray-500 dark:text-gray-400">
                        📍 <span x-text="profile.location"></span>
                    </p>
                </div>

                <!-- Edit Mode -->
                <div x-show="editMode" x-transition class="space-y-4 max-w-md mx-auto">
                    <input type="text" x-model="profile.name" @input="updateAvatar"
                           placeholder="Dein Name"
                           class="w-full px-4 py-2 rounded-lg border dark:bg-gray-800 dark:border-gray-700">
                    <input type="text" x-model="profile.title"
                           placeholder="Dein Titel"
                           class="w-full px-4 py-2 rounded-lg border dark:bg-gray-800 dark:border-gray-700">
                    <textarea x-model="profile.bio"
                              placeholder="Über dich..."
                              rows="3"
                              class="w-full px-4 py-2 rounded-lg border dark:bg-gray-800 dark:border-gray-700"></textarea>
                    <input type="text" x-model="profile.location"
                           placeholder="Dein Standort"
                           class="w-full px-4 py-2 rounded-lg border dark:bg-gray-800 dark:border-gray-700">
                </div>

                <!-- Social Links -->
                <div class="flex justify-center gap-4 mt-8">
                    <template x-for="social in socials" :key="social.platform">
                        <a :href="social.url"
                           class="w-12 h-12 rounded-full flex items-center justify-center transition transform hover:scale-110"
                           :class="{
                               ''bg-gray-600 hover:bg-gray-700'': social.color === ''gray'',
                               ''bg-blue-600 hover:bg-blue-700'': social.color === ''blue'',
                               ''bg-sky-500 hover:bg-sky-600'': social.color === ''sky'',
                               ''bg-pink-600 hover:bg-pink-700'': social.color === ''pink''
                           }">
                            <span class="text-white text-xl" x-text="social.icon"></span>
                        </a>
                    </template>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="container mx-auto px-4 py-12">
        <!-- About Section -->
        <section x-show="activeSection === ''about''" x-transition class="max-w-4xl mx-auto">
            <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-8 text-center">Über mich</h2>

            <div class="grid md:grid-cols-2 gap-8">
                <!-- Story Card -->
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
                    <h3 class="text-xl font-bold mb-4 text-gray-900 dark:text-white">Meine Geschichte</h3>
                    <p class="text-gray-600 dark:text-gray-300 leading-relaxed">
                        Ich habe meine Leidenschaft für Webentwicklung entdeckt, als ich meine erste Website
                        gebaut habe. Seitdem lerne ich ständig neue Technologien und liebe es, kreative
                        Lösungen für komplexe Probleme zu finden.
                    </p>
                </div>

                <!-- Mission Card -->
                <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
                    <h3 class="text-xl font-bold mb-4 text-gray-900 dark:text-white">Meine Mission</h3>
                    <p class="text-gray-600 dark:text-gray-300 leading-relaxed">
                        Ich möchte benutzerfreundliche und schöne Websites erstellen, die Menschen helfen
                        und inspirieren. Mein Ziel ist es, die digitale Welt ein bisschen besser zu machen.
                    </p>
                </div>
            </div>

            <!-- Timeline -->
            <div class="mt-12">
                <h3 class="text-2xl font-bold mb-6 text-gray-900 dark:text-white text-center">Mein Weg</h3>
                <div class="space-y-8">
                    <div class="flex gap-4">
                        <div class="flex-shrink-0 w-12 h-12 bg-indigo-600 rounded-full flex items-center justify-center text-white font-bold">
                            1
                        </div>
                        <div>
                            <h4 class="font-bold text-gray-900 dark:text-white">Erste Schritte</h4>
                            <p class="text-gray-600 dark:text-gray-300">HTML & CSS Grundlagen gelernt</p>
                        </div>
                    </div>
                    <div class="flex gap-4">
                        <div class="flex-shrink-0 w-12 h-12 bg-indigo-600 rounded-full flex items-center justify-center text-white font-bold">
                            2
                        </div>
                        <div>
                            <h4 class="font-bold text-gray-900 dark:text-white">JavaScript entdeckt</h4>
                            <p class="text-gray-600 dark:text-gray-300">Interaktivität und Dynamik hinzugefügt</p>
                        </div>
                    </div>
                    <div class="flex gap-4">
                        <div class="flex-shrink-0 w-12 h-12 bg-indigo-600 rounded-full flex items-center justify-center text-white font-bold">
                            3
                        </div>
                        <div>
                            <h4 class="font-bold text-gray-900 dark:text-white">Heute</h4>
                            <p class="text-gray-600 dark:text-gray-300">Lerne ständig neue Technologien</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Skills Section -->
        <section x-show="activeSection === ''skills''" x-transition class="max-w-4xl mx-auto">
            <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-8 text-center">Meine Skills</h2>

            <div class="space-y-6">
                <template x-for="skill in skills" :key="skill.name">
                    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
                        <div class="flex justify-between items-center mb-3">
                            <h3 class="text-xl font-bold text-gray-900 dark:text-white" x-text="skill.name"></h3>
                            <span class="text-lg font-semibold" x-text="skill.level + ''%''"></span>
                        </div>
                        <div class="bg-gray-200 dark:bg-gray-700 rounded-full h-4 overflow-hidden">
                            <div class="h-full rounded-full transition-all duration-1000 ease-out"
                                 :class="{
                                     ''bg-orange-500'': skill.color === ''orange'',
                                     ''bg-blue-500'': skill.color === ''blue'',
                                     ''bg-yellow-500'': skill.color === ''yellow'',
                                     ''bg-purple-500'': skill.color === ''purple''
                                 }"
                                 :style="`width: ${skill.level}%`"></div>
                        </div>
                    </div>
                </template>
            </div>

            <!-- Learning Goals -->
            <div class="mt-12 bg-indigo-50 dark:bg-indigo-900/20 rounded-xl p-8">
                <h3 class="text-2xl font-bold mb-4 text-gray-900 dark:text-white">🎯 Lernziele</h3>
                <ul class="space-y-3">
                    <li class="flex items-center gap-3">
                        <span class="text-2xl">🚀</span>
                        <span class="text-gray-700 dark:text-gray-300">React & Vue.js meistern</span>
                    </li>
                    <li class="flex items-center gap-3">
                        <span class="text-2xl">🎨</span>
                        <span class="text-gray-700 dark:text-gray-300">UI/UX Design vertiefen</span>
                    </li>
                    <li class="flex items-center gap-3">
                        <span class="text-2xl">⚡</span>
                        <span class="text-gray-700 dark:text-gray-300">Performance-Optimierung</span>
                    </li>
                </ul>
            </div>
        </section>

        <!-- Interests Section -->
        <section x-show="activeSection === ''interests''" x-transition class="max-w-4xl mx-auto">
            <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-8 text-center">Interessen & Hobbys</h2>

            <div class="grid md:grid-cols-2 gap-6">
                <template x-for="interest in interests" :key="interest.name">
                    <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                        <div class="flex items-start gap-4">
                            <span class="text-4xl" x-text="interest.emoji"></span>
                            <div>
                                <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2" x-text="interest.name"></h3>
                                <p class="text-gray-600 dark:text-gray-300" x-text="interest.description"></p>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </section>

        <!-- Contact Section -->
        <section x-show="activeSection === ''contact''" x-transition class="max-w-4xl mx-auto">
            <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-8 text-center">Kontakt</h2>

            <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-8">
                <p class="text-lg text-gray-600 dark:text-gray-300 mb-8 text-center">
                    Ich freue mich über deine Nachricht! Lass uns gemeinsam etwas Großartiges erschaffen.
                </p>

                <!-- Contact Form -->
                <div x-show="!showContactForm && !messageSent" class="text-center">
                    <button @click="showContactForm = true"
                            class="px-8 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition transform hover:scale-105">
                        Nachricht senden
                    </button>
                </div>

                <!-- Form -->
                <form x-show="showContactForm" x-transition @submit.prevent="sendMessage" class="space-y-4 max-w-md mx-auto">
                    <input type="text" placeholder="Dein Name" required
                           class="w-full px-4 py-3 rounded-lg border dark:bg-gray-700 dark:border-gray-600">
                    <input type="email" placeholder="Deine E-Mail" required
                           class="w-full px-4 py-3 rounded-lg border dark:bg-gray-700 dark:border-gray-600">
                    <textarea placeholder="Deine Nachricht" rows="4" required
                              class="w-full px-4 py-3 rounded-lg border dark:bg-gray-700 dark:border-gray-600"></textarea>
                    <div class="flex gap-4">
                        <button type="submit"
                                class="flex-1 px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition">
                            Absenden
                        </button>
                        <button type="button" @click="showContactForm = false"
                                class="px-6 py-3 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-300 dark:hover:bg-gray-600 transition">
                            Abbrechen
                        </button>
                    </div>
                </form>

                <!-- Success Message -->
                <div x-show="messageSent" x-transition class="text-center">
                    <div class="text-6xl mb-4">✅</div>
                    <p class="text-xl text-green-600 dark:text-green-400">Nachricht gesendet!</p>
                    <p class="text-gray-600 dark:text-gray-300 mt-2">Ich melde mich bald bei dir.</p>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-100 dark:bg-gray-900 py-8 mt-20 transition-colors">
        <div class="container mx-auto px-4 text-center">
            <p class="text-gray-600 dark:text-gray-400">
                Made with <span class="text-red-500">❤️</span> by <span x-text="profile.name"></span>
            </p>
            <p class="text-sm text-gray-500 dark:text-gray-500 mt-2">
                © 2024 - Built with HTML, CSS & Alpine.js
            </p>
        </div>
    </footer>
</body>
</html>', '', '', 'quick_start', true, 2, '{"level": 1, "duration": "20 min", "skills": ["HTML", "CSS", "Alpine.js", "Dark Mode"]}'),

-- Template 3: My First Portfolio
('🎨 My First Portfolio', 'Interaktives Portfolio mit modernen Features',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Mein erstes interaktives Portfolio">
    <title>My First Portfolio</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50" x-data="{
    // Portfolio data
    projects: [
        {
            id: 1,
            title: ''Wetter App'',
            description: ''Eine moderne Wetter-App mit Live-Daten'',
            image: ''https://picsum.photos/400/300?random=1'',
            tags: [''HTML'', ''CSS'', ''API''],
            link: ''#'',
            featured: true
        },
        {
            id: 2,
            title: ''Todo Liste'',
            description: ''Produktivitäts-App mit Local Storage'',
            image: ''https://picsum.photos/400/300?random=2'',
            tags: [''JavaScript'', ''LocalStorage''],
            link: ''#'',
            featured: false
        },
        {
            id: 3,
            title: ''Portfolio Website'',
            description: ''Diese Website die du gerade siehst!'',
            image: ''https://picsum.photos/400/300?random=3'',
            tags: [''Alpine.js'', ''Tailwind''],
            link: ''#'',
            featured: true
        }
    ],

    // Interactive features
    activeFilter: ''all'',
    showProjectModal: false,
    selectedProject: null,
    animateOnScroll: true,
    cursorPosition: { x: 0, y: 0 },

    // Stats
    stats: {
        projects: 3,
        technologies: 8,
        coffees: 127,
        hours: 300
    },

    // Available tags
    get allTags() {
        const tags = new Set();
        this.projects.forEach(project => {
            project.tags.forEach(tag => tags.add(tag));
        });
        return Array.from(tags);
    },

    // Filtered projects
    get filteredProjects() {
        if (this.activeFilter === ''all'') return this.projects;
        if (this.activeFilter === ''featured'') return this.projects.filter(p => p.featured);
        return this.projects.filter(p => p.tags.includes(this.activeFilter));
    },

    // Methods
    openProject(project) {
        this.selectedProject = project;
        this.showProjectModal = true;
    },

    handleMouseMove(e) {
        this.cursorPosition.x = e.clientX;
        this.cursorPosition.y = e.clientY;
    },

    // Initialize
    init() {
        // Add mouse move listener for cursor effect
        document.addEventListener(''mousemove'', this.handleMouseMove.bind(this));

        // Animate stats on scroll
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add(''animate-fade-in-up'');
                }
            });
        });

        document.querySelectorAll(''.animate-on-scroll'').forEach(el => {
            observer.observe(el);
        });
    }
}">
    <!-- Custom Cursor -->
    <div class="fixed w-6 h-6 bg-indigo-600 rounded-full pointer-events-none z-50 mix-blend-difference transition-transform duration-100 ease-out"
         :style="`transform: translate(${cursorPosition.x - 12}px, ${cursorPosition.y - 12}px)`"></div>

    <!-- Hero Section -->
    <section class="min-h-screen flex items-center justify-center relative overflow-hidden">
        <!-- Animated Background -->
        <div class="absolute inset-0 -z-10">
            <div class="absolute top-20 left-20 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob"></div>
            <div class="absolute top-40 right-20 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-2000"></div>
            <div class="absolute -bottom-8 left-40 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-4000"></div>
        </div>

        <div class="container mx-auto px-4 text-center">
            <h1 class="text-5xl md:text-7xl font-bold mb-6">
                <span class="bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                    Hallo, ich bin
                </span>
                <br>
                <span class="bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">
                    Creative Developer
                </span>
            </h1>
            <p class="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
                Ich erschaffe digitale Erlebnisse mit modernen Web-Technologien.
                Lass uns gemeinsam etwas Großartiges bauen!
            </p>
            <div class="flex gap-4 justify-center">
                <a href="#projects"
                   class="px-8 py-3 bg-indigo-600 text-white rounded-full hover:bg-indigo-700 transition transform hover:scale-105">
                    Projekte ansehen
                </a>
                <a href="#contact"
                   class="px-8 py-3 border-2 border-indigo-600 text-indigo-600 rounded-full hover:bg-indigo-600 hover:text-white transition">
                    Kontakt
                </a>
            </div>

            <!-- Scroll Indicator -->
            <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 animate-bounce">
                <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"></path>
                </svg>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="py-20 bg-white">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
                <div class="text-center animate-on-scroll">
                    <div class="text-4xl font-bold text-indigo-600 mb-2" x-text="stats.projects"></div>
                    <div class="text-gray-600">Projekte</div>
                </div>
                <div class="text-center animate-on-scroll">
                    <div class="text-4xl font-bold text-purple-600 mb-2" x-text="stats.technologies"></div>
                    <div class="text-gray-600">Technologien</div>
                </div>
                <div class="text-center animate-on-scroll">
                    <div class="text-4xl font-bold text-pink-600 mb-2" x-text="stats.coffees"></div>
                    <div class="text-gray-600">Kaffees ☕</div>
                </div>
                <div class="text-center animate-on-scroll">
                    <div class="text-4xl font-bold text-yellow-600 mb-2" x-text="stats.hours"></div>
                    <div class="text-gray-600">Stunden Coding</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Projects Section -->
    <section id="projects" class="py-20">
        <div class="container mx-auto px-4">
            <h2 class="text-4xl font-bold text-center mb-12">
                <span class="bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">
                    Meine Projekte
                </span>
            </h2>

            <!-- Filter Buttons -->
            <div class="flex flex-wrap justify-center gap-3 mb-12">
                <button @click="activeFilter = ''all''"
                        :class="activeFilter === ''all'' ? ''bg-indigo-600 text-white'' : ''bg-gray-200 text-gray-700''"
                        class="px-6 py-2 rounded-full transition hover:scale-105">
                    Alle
                </button>
                <button @click="activeFilter = ''featured''"
                        :class="activeFilter === ''featured'' ? ''bg-indigo-600 text-white'' : ''bg-gray-200 text-gray-700''"
                        class="px-6 py-2 rounded-full transition hover:scale-105">
                    ⭐ Featured
                </button>
                <template x-for="tag in allTags" :key="tag">
                    <button @click="activeFilter = tag"
                            :class="activeFilter === tag ? ''bg-indigo-600 text-white'' : ''bg-gray-200 text-gray-700''"
                            class="px-6 py-2 rounded-full transition hover:scale-105"
                            x-text="tag">
                    </button>
                </template>
            </div>

            <!-- Projects Grid -->
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
                <template x-for="project in filteredProjects" :key="project.id">
                    <div @click="openProject(project)"
                         class="bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer transform transition hover:scale-105 hover:shadow-xl animate-on-scroll">
                        <!-- Project Image -->
                        <div class="relative h-48 overflow-hidden">
                            <img :src="project.image" :alt="project.title"
                                 class="w-full h-full object-cover">
                            <div x-show="project.featured"
                                 class="absolute top-4 right-4 bg-yellow-400 text-yellow-900 px-3 py-1 rounded-full text-sm font-semibold">
                                ⭐ Featured
                            </div>
                        </div>

                        <!-- Project Info -->
                        <div class="p-6">
                            <h3 class="text-xl font-bold mb-2" x-text="project.title"></h3>
                            <p class="text-gray-600 mb-4" x-text="project.description"></p>

                            <!-- Tags -->
                            <div class="flex flex-wrap gap-2">
                                <template x-for="tag in project.tags" :key="tag">
                                    <span class="px-3 py-1 bg-indigo-100 text-indigo-700 rounded-full text-sm"
                                          x-text="tag"></span>
                                </template>
                            </div>
                        </div>
                    </div>
                </template>
            </div>
        </div>
    </section>

    <!-- Skills Section -->
    <section class="py-20 bg-gray-100">
        <div class="container mx-auto px-4">
            <h2 class="text-4xl font-bold text-center mb-12">
                <span class="bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                    Tech Stack
                </span>
            </h2>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto">
                <!-- Frontend -->
                <div class="bg-white rounded-xl p-6 text-center shadow-lg hover:shadow-xl transition animate-on-scroll">
                    <div class="text-4xl mb-3">🎨</div>
                    <h3 class="font-bold mb-2">Frontend</h3>
                    <p class="text-sm text-gray-600">HTML, CSS, JavaScript, Alpine.js</p>
                </div>

                <!-- Design -->
                <div class="bg-white rounded-xl p-6 text-center shadow-lg hover:shadow-xl transition animate-on-scroll">
                    <div class="text-4xl mb-3">🎯</div>
                    <h3 class="font-bold mb-2">Design</h3>
                    <p class="text-sm text-gray-600">Tailwind CSS, Figma, UI/UX</p>
                </div>

                <!-- Tools -->
                <div class="bg-white rounded-xl p-6 text-center shadow-lg hover:shadow-xl transition animate-on-scroll">
                    <div class="text-4xl mb-3">🛠️</div>
                    <h3 class="font-bold mb-2">Tools</h3>
                    <p class="text-sm text-gray-600">Git, VS Code, npm</p>
                </div>

                <!-- Learning -->
                <div class="bg-white rounded-xl p-6 text-center shadow-lg hover:shadow-xl transition animate-on-scroll">
                    <div class="text-4xl mb-3">📚</div>
                    <h3 class="font-bold mb-2">Learning</h3>
                    <p class="text-sm text-gray-600">React, Node.js, TypeScript</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="py-20">
        <div class="container mx-auto px-4">
            <h2 class="text-4xl font-bold text-center mb-12">
                <span class="bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">
                    Let''s Connect!
                </span>
            </h2>

            <div class="max-w-2xl mx-auto text-center">
                <p class="text-xl text-gray-600 mb-8">
                    Hast du ein Projekt im Kopf? Lass uns darüber sprechen!
                    Ich bin immer offen für neue Herausforderungen und Kollaborationen.
                </p>

                <div class="flex gap-4 justify-center">
                    <a href="mailto:hello@example.com"
                       class="px-8 py-3 bg-indigo-600 text-white rounded-full hover:bg-indigo-700 transition transform hover:scale-105">
                        📧 E-Mail senden
                    </a>
                    <a href="#"
                       class="px-8 py-3 border-2 border-indigo-600 text-indigo-600 rounded-full hover:bg-indigo-600 hover:text-white transition">
                        💬 Chat starten
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Project Modal -->
    <div x-show="showProjectModal"
         x-transition
         @click.self="showProjectModal = false"
         class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto"
             @click.stop>
            <div x-show="selectedProject">
                <!-- Modal Header -->
                <div class="relative h-64">
                    <img :src="selectedProject?.image" :alt="selectedProject?.title"
                         class="w-full h-full object-cover">
                    <button @click="showProjectModal = false"
                            class="absolute top-4 right-4 w-10 h-10 bg-white rounded-full flex items-center justify-center hover:bg-gray-100 transition">
                        ✕
                    </button>
                </div>

                <!-- Modal Content -->
                <div class="p-8">
                    <h3 class="text-3xl font-bold mb-4" x-text="selectedProject?.title"></h3>
                    <p class="text-gray-600 mb-6" x-text="selectedProject?.description"></p>

                    <div class="flex flex-wrap gap-2 mb-6">
                        <template x-for="tag in selectedProject?.tags" :key="tag">
                            <span class="px-3 py-1 bg-indigo-100 text-indigo-700 rounded-full text-sm"
                                  x-text="tag"></span>
                        </template>
                    </div>

                    <div class="space-y-4">
                        <h4 class="font-bold text-lg">Projekt Details</h4>
                        <p class="text-gray-600">
                            Dies ist ein Beispielprojekt, das meine Fähigkeiten in modernen Web-Technologien zeigt.
                            Es wurde mit Liebe zum Detail entwickelt und folgt den neuesten Best Practices.
                        </p>

                        <h4 class="font-bold text-lg">Technologien</h4>
                        <p class="text-gray-600">
                            Dieses Projekt nutzt modernste Technologien für optimale Performance und User Experience.
                        </p>

                        <div class="flex gap-4 pt-4">
                            <a :href="selectedProject?.link"
                               class="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition">
                                Live Demo →
                            </a>
                            <a href="#"
                               class="px-6 py-2 border-2 border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100 transition">
                                GitHub
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-12">
        <div class="container mx-auto px-4 text-center">
            <p class="mb-4">Built with 💜 and lots of ☕</p>
            <div class="flex justify-center gap-6">
                <a href="#" class="hover:text-indigo-400 transition">GitHub</a>
                <a href="#" class="hover:text-indigo-400 transition">LinkedIn</a>
                <a href="#" class="hover:text-indigo-400 transition">Twitter</a>
            </div>
        </div>
    </footer>

    <style>
        @keyframes blob {
            0% {
                transform: translate(0px, 0px) scale(1);
            }
            33% {
                transform: translate(30px, -50px) scale(1.1);
            }
            66% {
                transform: translate(-20px, 20px) scale(0.9);
            }
            100% {
                transform: translate(0px, 0px) scale(1);
            }
        }

        .animate-blob {
            animation: blob 7s infinite;
        }

        .animation-delay-2000 {
            animation-delay: 2s;
        }

        .animation-delay-4000 {
            animation-delay: 4s;
        }

        @keyframes fade-in-up {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-fade-in-up {
            animation: fade-in-up 0.6s ease-out;
        }
    </style>
</body>
</html>', '', '', 'quick_start', true, 3, '{"level": 2, "duration": "30 min", "skills": ["Portfolio", "Animations", "Interactions", "Modern Design"]}');