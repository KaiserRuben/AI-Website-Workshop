# Interactive Learning Templates - Erweiterte Sammlung
# Für verschiedene Altersgruppen und Skill-Level
# Alle Templates nutzen Tailwind CSS und Alpine.js
from sqlalchemy.ext.asyncio.session import AsyncSession

from app.models import Template

templates = [
    # ===== ANFÄNGER TEMPLATES =====
    {
        "id": 1,
        "name": "Anfänger: Meine erste Website",
        "category": "learning_beginner",
        "description": "Der perfekte Start - Lerne HTML Grundlagen",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meine erste Website</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-4xl mx-auto">
        <div class="bg-white rounded-lg shadow-lg p-8 mb-8">
            <h1 class="text-4xl font-bold text-center mb-6 text-blue-600">
                Willkommen zu deiner ersten Website! 🎉
            </h1>
            <p class="text-xl text-center text-gray-700 mb-8">
                Hier lernst du die Grundlagen des Web-Designs
            </p>
        </div>

        <div class="bg-yellow-50 border-l-4 border-yellow-400 p-6 mb-8">
            <h2 class="text-2xl font-bold mb-4">📚 Was du hier lernst:</h2>
            <div class="grid md:grid-cols-2 gap-4">
                <div class="bg-white p-4 rounded shadow">
                    <h3 class="font-bold text-lg mb-2">HTML Basics</h3>
                    <p>Überschriften, Texte und Struktur</p>
                </div>
                <div class="bg-white p-4 rounded shadow">
                    <h3 class="font-bold text-lg mb-2">Erste Schritte</h3>
                    <p>Wie du mit der KI zusammenarbeitest</p>
                </div>
            </div>
        </div>

        <div class="bg-green-50 border-l-4 border-green-400 p-6">
            <h2 class="text-2xl font-bold mb-4">🎯 Deine ersten Aufgaben:</h2>
            <ol class="space-y-3 text-lg">
                <li>1️⃣ Sage: <span class="bg-green-200 px-2 py-1 rounded">"Ändere die Überschrift zu meinem Namen"</span></li>
                <li>2️⃣ Sage: <span class="bg-green-200 px-2 py-1 rounded">"Füge ein Bild von einer Katze hinzu"</span></li>
                <li>3️⃣ Sage: <span class="bg-green-200 px-2 py-1 rounded">"Mache den Hintergrund blau"</span></li>
            </ol>
            <p class="mt-4 text-gray-600">💡 Tipp: Du kannst die KI alles fragen!</p>
        </div>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    {
        "id": 2,
        "name": "Anfänger: Mein erstes Fotoalbum",
        "category": "learning_beginner",
        "description": "Erstelle eine Bildergalerie mit Tailwind",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mein Fotoalbum</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-900 text-white">
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-5xl font-bold text-center mb-12 bg-gradient-to-r from-pink-500 to-purple-500 bg-clip-text text-transparent">
            Mein Fotoalbum 📸
        </h1>

        <div class="bg-gray-800 rounded-lg p-6 mb-8">
            <h2 class="text-2xl font-bold mb-4">🖼️ Meine Lieblingsbilder</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="relative overflow-hidden rounded-lg group">
                    <img src="https://picsum.photos/400/300?random=1" alt="Bild 1" 
                         class="w-full h-48 object-cover group-hover:scale-110 transition duration-300">
                    <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 p-2 text-white">
                        <p>Mein erstes Bild</p>
                    </div>
                </div>

                <div class="relative overflow-hidden rounded-lg group">
                    <img src="https://picsum.photos/400/300?random=2" alt="Bild 2" 
                         class="w-full h-48 object-cover group-hover:scale-110 transition duration-300">
                    <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 p-2 text-white">
                        <p>Urlaubserinnerung</p>
                    </div>
                </div>

                <div class="relative overflow-hidden rounded-lg group">
                    <img src="https://picsum.photos/400/300?random=3" alt="Bild 3" 
                         class="w-full h-48 object-cover group-hover:scale-110 transition duration-300">
                    <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 p-2 text-white">
                        <p>Mit Freunden</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-purple-900 rounded-lg p-6" x-data="{ showTip: false }">
            <h2 class="text-2xl font-bold mb-4">🎨 Gestalte dein Album!</h2>
            <div class="space-y-3">
                <p>Probiere diese Befehle aus:</p>
                <ul class="space-y-2">
                    <li>• "Füge 3 weitere Bilder hinzu"</li>
                    <li>• "Ändere die Bildunterschriften"</li>
                    <li>• "Mache die Bilder rund"</li>
                    <li>• "Füge einen Filter-Effekt hinzu"</li>
                </ul>

                <button @click="showTip = !showTip" 
                        class="bg-purple-600 hover:bg-purple-700 px-4 py-2 rounded mt-4">
                    💡 Geheimer Tipp
                </button>

                <div x-show="showTip" x-transition class="bg-purple-800 p-4 rounded mt-2">
                    <p>Sage: "Mache aus dem Album eine Instagram-ähnliche Galerie mit Likes!"</p>
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
        "name": "Anfänger: Mein Gaming-Profil",
        "category": "learning_beginner",
        "description": "Erstelle deine Gaming-Visitenkarte",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gaming Profil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-900 text-white min-h-screen" x-data="{ 
    level: 1,
    xp: 0,
    games: ['Fortnite', 'Minecraft', 'Among Us'],
    selectedGame: 0
}">
    <div class="container mx-auto px-4 py-8">
        <!-- Header -->
        <div class="bg-gradient-to-r from-purple-600 to-pink-600 rounded-lg p-8 mb-8 text-center">
            <h1 class="text-5xl font-bold mb-4">🎮 GAMER PROFILE</h1>
            <p class="text-2xl">Level <span x-text="level"></span> Player</p>
        </div>

        <!-- Stats -->
        <div class="grid md:grid-cols-3 gap-6 mb-8">
            <div class="bg-gray-800 rounded-lg p-6 text-center hover:bg-gray-700 transition">
                <div class="text-4xl mb-2">🏆</div>
                <h3 class="text-xl font-bold">Achievements</h3>
                <p class="text-3xl text-yellow-400">0</p>
            </div>

            <div class="bg-gray-800 rounded-lg p-6 text-center hover:bg-gray-700 transition">
                <div class="text-4xl mb-2">⚔️</div>
                <h3 class="text-xl font-bold">Battles Won</h3>
                <p class="text-3xl text-green-400">0</p>
            </div>

            <div class="bg-gray-800 rounded-lg p-6 text-center hover:bg-gray-700 transition">
                <div class="text-4xl mb-2">👥</div>
                <h3 class="text-xl font-bold">Friends</h3>
                <p class="text-3xl text-blue-400">0</p>
            </div>
        </div>

        <!-- XP Bar -->
        <div class="bg-gray-800 rounded-lg p-6 mb-8">
            <h3 class="text-xl font-bold mb-4">Experience Points</h3>
            <div class="bg-gray-700 rounded-full h-8 relative overflow-hidden">
                <div class="bg-gradient-to-r from-green-400 to-blue-500 h-full transition-all duration-500"
                     :style="'width: ' + (xp) + '%'"></div>
            </div>
            <p class="text-center mt-2"><span x-text="xp"></span>/100 XP</p>

            <button @click="xp = Math.min(100, xp + 10); if(xp >= 100) { level++; xp = 0; }"
                    class="bg-green-600 hover:bg-green-700 px-6 py-3 rounded-lg mt-4 w-full font-bold">
                + 10 XP bekommen!
            </button>
        </div>

        <!-- Favorite Games -->
        <div class="bg-gray-800 rounded-lg p-6 mb-8">
            <h3 class="text-xl font-bold mb-4">🎯 Lieblingsspiele</h3>
            <div class="flex gap-4 flex-wrap">
                <template x-for="(game, index) in games" :key="index">
                    <button @click="selectedGame = index"
                            :class="selectedGame === index ? 'bg-purple-600' : 'bg-gray-700'"
                            class="px-4 py-2 rounded hover:bg-purple-700 transition">
                        <span x-text="game"></span>
                    </button>
                </template>
            </div>
        </div>

        <!-- Aufgaben -->
        <div class="bg-gradient-to-r from-yellow-600 to-orange-600 rounded-lg p-6">
            <h2 class="text-2xl font-bold mb-4">🚀 Level Up Aufgaben!</h2>
            <div class="space-y-3">
                <p class="text-lg">Mache dein Profil einzigartig:</p>
                <ul class="space-y-2">
                    <li>• "Füge meine echten Lieblingsspiele hinzu"</li>
                    <li>• "Erstelle einen Avatar-Bereich"</li>
                    <li>• "Füge Sound-Effekte beim XP sammeln hinzu"</li>
                    <li>• "Mache ein Achievements-System mit Badges"</li>
                    <li>• "Füge eine Bestenliste hinzu"</li>
                </ul>

                <div class="bg-yellow-700 bg-opacity-50 p-4 rounded mt-4">
                    <p class="font-bold">⚡ POWER-UP TIPP:</p>
                    <p>Sage: "Verwandle das in ein RPG-Charakterblatt mit Stats!"</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    # ===== FORTGESCHRITTEN TEMPLATES =====
    {
        "id": 4,
        "name": "Fortgeschritten: Social Media Profil",
        "category": "learning_intermediate",
        "description": "Baue dein eigenes Social Network Profil",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Social Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-100" x-data="{
    followers: 142,
    following: 89,
    posts: 24,
    likes: 0,
    showStory: false,
    storyViews: 0,
    bio: 'Digital Creator 🎨 | Gamer 🎮 | Student 📚',
    posts_data: [
        { id: 1, likes: 45, liked: false, image: 'https://picsum.photos/400/400?random=1' },
        { id: 2, likes: 89, liked: false, image: 'https://picsum.photos/400/400?random=2' },
        { id: 3, likes: 123, liked: false, image: 'https://picsum.photos/400/400?random=3' }
    ]
}">
    <div class="max-w-4xl mx-auto bg-white min-h-screen">
        <!-- Header -->
        <div class="bg-gradient-to-r from-purple-500 to-pink-500 p-4">
            <div class="flex justify-between items-center text-white">
                <h1 class="text-2xl font-bold">@username</h1>
                <button class="bg-white bg-opacity-20 px-4 py-2 rounded-full hover:bg-opacity-30">
                    Settings ⚙️
                </button>
            </div>
        </div>

        <!-- Profile Info -->
        <div class="p-6">
            <div class="flex items-center mb-6">
                <div class="relative">
                    <img src="https://ui-avatars.com/api/?name=User&size=128&background=random" 
                         class="w-32 h-32 rounded-full border-4 border-white shadow-lg">
                    <button @click="showStory = true; setTimeout(() => { storyViews++; showStory = false }, 3000)"
                            class="absolute bottom-0 right-0 bg-blue-500 text-white rounded-full w-10 h-10 flex items-center justify-center">
                        +
                    </button>
                </div>

                <div class="ml-8 flex-1">
                    <h2 class="text-2xl font-bold mb-2">Your Name</h2>
                    <p class="text-gray-600 mb-4" x-text="bio"></p>

                    <div class="flex gap-6 text-center">
                        <div>
                            <p class="font-bold text-xl" x-text="posts"></p>
                            <p class="text-gray-500">Posts</p>
                        </div>
                        <div>
                            <p class="font-bold text-xl" x-text="followers"></p>
                            <p class="text-gray-500">Followers</p>
                        </div>
                        <div>
                            <p class="font-bold text-xl" x-text="following"></p>
                            <p class="text-gray-500">Following</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Story Modal -->
            <div x-show="showStory" x-transition
                 class="fixed inset-0 bg-black bg-opacity-90 flex items-center justify-center z-50">
                <div class="bg-white rounded-lg p-8 text-center">
                    <h3 class="text-2xl font-bold mb-4">Story wird angezeigt!</h3>
                    <p class="text-6xl mb-4">📸</p>
                    <p>Views: <span x-text="storyViews"></span></p>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex gap-4 mb-8">
                <button @click="followers++" 
                        class="flex-1 bg-blue-500 text-white py-3 rounded-lg hover:bg-blue-600 font-bold">
                    Follow
                </button>
                <button class="flex-1 bg-gray-200 py-3 rounded-lg hover:bg-gray-300 font-bold">
                    Message
                </button>
            </div>

            <!-- Posts Grid -->
            <div class="grid grid-cols-3 gap-1">
                <template x-for="post in posts_data" :key="post.id">
                    <div class="relative group cursor-pointer">
                        <img :src="post.image" class="w-full aspect-square object-cover">
                        <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-50 transition flex items-center justify-center">
                            <button @click="post.liked = !post.liked; post.likes += post.liked ? 1 : -1"
                                    class="text-white opacity-0 group-hover:opacity-100 transition">
                                <span x-text="post.liked ? '❤️' : '🤍'" class="text-3xl"></span>
                                <p x-text="post.likes" class="text-sm"></p>
                            </button>
                        </div>
                    </div>
                </template>
            </div>
        </div>

        <!-- Tasks -->
        <div class="bg-yellow-50 p-6 m-6 rounded-lg">
            <h3 class="text-xl font-bold mb-4">📱 Social Media Features hinzufügen:</h3>
            <ul class="space-y-2">
                <li>• "Füge ein Kommentar-System zu den Posts hinzu"</li>
                <li>• "Erstelle einen Feed mit Timeline"</li>
                <li>• "Füge Stories mit Ablaufzeit hinzu"</li>
                <li>• "Mache ein Direct Message System"</li>
                <li>• "Füge Hashtags und Suchfunktion hinzu"</li>
            </ul>

            <div class="bg-yellow-200 p-3 rounded mt-4">
                <p class="font-bold">🔥 VIRAL-TIPP:</p>
                <p>Sage: "Füge TikTok-ähnliche Video-Features hinzu!"</p>
            </div>
        </div>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    {
        "id": 5,
        "name": "Fortgeschritten: Online-Shop Basics",
        "category": "learning_intermediate",
        "description": "Lerne die Grundlagen eines Online-Shops",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mein Shop</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50" x-data="{
    cart: [],
    showCart: false,
    products: [
        { id: 1, name: 'Cool T-Shirt', price: 19.99, image: '👕', category: 'clothing' },
        { id: 2, name: 'Gaming Headset', price: 59.99, image: '🎧', category: 'tech' },
        { id: 3, name: 'Sneakers', price: 79.99, image: '👟', category: 'shoes' },
        { id: 4, name: 'Smartphone Case', price: 14.99, image: '📱', category: 'tech' },
        { id: 5, name: 'Rucksack', price: 39.99, image: '🎒', category: 'accessories' },
        { id: 6, name: 'Cap', price: 24.99, image: '🧢', category: 'accessories' }
    ],
    selectedCategory: 'all',
    get filteredProducts() {
        if (this.selectedCategory === 'all') return this.products;
        return this.products.filter(p => p.category === this.selectedCategory);
    },
    get cartTotal() {
        return this.cart.reduce((sum, item) => sum + (item.price * item.quantity), 0).toFixed(2);
    },
    get cartCount() {
        return this.cart.reduce((sum, item) => sum + item.quantity, 0);
    },
    addToCart(product) {
        const existing = this.cart.find(item => item.id === product.id);
        if (existing) {
            existing.quantity++;
        } else {
            this.cart.push({...product, quantity: 1});
        }
    }
}">
    <!-- Header -->
    <header class="bg-white shadow-sm sticky top-0 z-40">
        <div class="max-w-6xl mx-auto px-4 py-4">
            <div class="flex justify-between items-center">
                <h1 class="text-2xl font-bold text-purple-600">🛍️ MyShop</h1>

                <button @click="showCart = !showCart" class="relative bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700">
                    🛒 Warenkorb
                    <span x-show="cartCount > 0" 
                          class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm"
                          x-text="cartCount"></span>
                </button>
            </div>
        </div>
    </header>

    <!-- Cart Sidebar -->
    <div x-show="showCart" 
         x-transition
         class="fixed right-0 top-0 h-full w-80 bg-white shadow-2xl z-50 overflow-y-auto">
        <div class="p-6">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-xl font-bold">Warenkorb</h2>
                <button @click="showCart = false" class="text-2xl">&times;</button>
            </div>

            <div class="space-y-4">
                <template x-for="item in cart" :key="item.id">
                    <div class="flex items-center justify-between bg-gray-50 p-3 rounded">
                        <div>
                            <span x-text="item.image" class="text-2xl mr-2"></span>
                            <span x-text="item.name"></span>
                        </div>
                        <div class="text-right">
                            <p x-text="'€' + item.price"></p>
                            <p class="text-sm text-gray-500">Menge: <span x-text="item.quantity"></span></p>
                        </div>
                    </div>
                </template>

                <div x-show="cart.length === 0" class="text-center py-8 text-gray-500">
                    Dein Warenkorb ist leer 🛒
                </div>
            </div>

            <div x-show="cart.length > 0" class="mt-6 pt-6 border-t">
                <div class="flex justify-between text-xl font-bold mb-4">
                    <span>Gesamt:</span>
                    <span x-text="'€' + cartTotal"></span>
                </div>
                <button class="w-full bg-green-600 text-white py-3 rounded-lg hover:bg-green-700 font-bold">
                    Zur Kasse 💳
                </button>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <main class="max-w-6xl mx-auto px-4 py-8">
        <!-- Category Filter -->
        <div class="mb-8">
            <div class="flex gap-2 flex-wrap">
                <button @click="selectedCategory = 'all'" 
                        :class="selectedCategory === 'all' ? 'bg-purple-600 text-white' : 'bg-gray-200'"
                        class="px-4 py-2 rounded-lg hover:bg-purple-700">
                    Alle Produkte
                </button>
                <button @click="selectedCategory = 'clothing'" 
                        :class="selectedCategory === 'clothing' ? 'bg-purple-600 text-white' : 'bg-gray-200'"
                        class="px-4 py-2 rounded-lg">
                    Kleidung
                </button>
                <button @click="selectedCategory = 'tech'" 
                        :class="selectedCategory === 'tech' ? 'bg-purple-600 text-white' : 'bg-gray-200'"
                        class="px-4 py-2 rounded-lg">
                    Technik
                </button>
                <button @click="selectedCategory = 'shoes'" 
                        :class="selectedCategory === 'shoes' ? 'bg-purple-600 text-white' : 'bg-gray-200'"
                        class="px-4 py-2 rounded-lg">
                    Schuhe
                </button>
                <button @click="selectedCategory = 'accessories'" 
                        :class="selectedCategory === 'accessories' ? 'bg-purple-600 text-white' : 'bg-gray-200'"
                        class="px-4 py-2 rounded-lg">
                    Zubehör
                </button>
            </div>
        </div>

        <!-- Products Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <template x-for="product in filteredProducts" :key="product.id">
                <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition">
                    <div class="aspect-square bg-gray-100 flex items-center justify-center text-6xl">
                        <span x-text="product.image"></span>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-lg mb-2" x-text="product.name"></h3>
                        <div class="flex justify-between items-center">
                            <span class="text-2xl font-bold text-purple-600" x-text="'€' + product.price"></span>
                            <button @click="addToCart(product)" 
                                    class="bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700">
                                In den Warenkorb
                            </button>
                        </div>
                    </div>
                </div>
            </template>
        </div>

        <!-- Learning Tasks -->
        <div class="bg-gradient-to-r from-blue-100 to-purple-100 rounded-lg p-8">
            <h2 class="text-2xl font-bold mb-6">🚀 Shop-Features zum Hinzufügen:</h2>
            <div class="grid md:grid-cols-2 gap-6">
                <div>
                    <h3 class="font-bold mb-3">Basis Features:</h3>
                    <ul class="space-y-2">
                        <li>• "Füge eine Produktsuche hinzu"</li>
                        <li>• "Erstelle Produktdetailseiten"</li>
                        <li>• "Füge Produktbewertungen hinzu"</li>
                        <li>• "Mache einen Wunschzettel"</li>
                    </ul>
                </div>
                <div>
                    <h3 class="font-bold mb-3">Erweiterte Features:</h3>
                    <ul class="space-y-2">
                        <li>• "Füge Rabattcodes hinzu"</li>
                        <li>• "Erstelle ein Kundenkonto-System"</li>
                        <li>• "Füge Versandoptionen hinzu"</li>
                        <li>• "Mache Produktempfehlungen"</li>
                    </ul>
                </div>
            </div>

            <div class="bg-purple-200 p-4 rounded-lg mt-6">
                <p class="font-bold">💎 PREMIUM-TIPP:</p>
                <p>Sage: "Verwandle den Shop in einen modernen Fashion-Store mit Size-Guide!"</p>
            </div>
        </div>
    </main>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    {
        "id": 6,
        "name": "Fortgeschritten: Band/Musik Website",
        "category": "learning_intermediate",
        "description": "Erstelle eine Website für deine Band oder Musik",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Band Website</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-black text-white" x-data="{
    currentTrack: 0,
    isPlaying: false,
    volume: 70,
    tracks: [
        { title: 'Summer Vibes', artist: 'My Band', duration: '3:24' },
        { title: 'Night Drive', artist: 'My Band', duration: '4:12' },
        { title: 'City Lights', artist: 'My Band', duration: '3:45' }
    ],
    tourDates: [
        { date: '15.03.2024', city: 'Berlin', venue: 'Club Matrix', soldOut: false },
        { date: '22.03.2024', city: 'Hamburg', venue: 'Docks', soldOut: true },
        { date: '29.03.2024', city: 'München', venue: 'Backstage', soldOut: false }
    ]
}">
    <!-- Hero Section -->
    <div class="relative h-screen flex items-center justify-center overflow-hidden">
        <div class="absolute inset-0 bg-gradient-to-b from-purple-900 to-black opacity-75"></div>
        <div class="relative z-10 text-center px-4">
            <h1 class="text-6xl md:text-8xl font-bold mb-4 bg-gradient-to-r from-pink-500 to-purple-500 bg-clip-text text-transparent">
                MY BAND
            </h1>
            <p class="text-2xl mb-8">Electronic • Indie • Alternative</p>
            <button class="bg-purple-600 hover:bg-purple-700 px-8 py-4 rounded-full text-lg font-bold transition transform hover:scale-105">
                🎵 Neue Single anhören
            </button>
        </div>

        <!-- Animated Background -->
        <div class="absolute inset-0 overflow-hidden">
            <div class="absolute w-96 h-96 bg-purple-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-pulse"></div>
            <div class="absolute right-0 w-96 h-96 bg-pink-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-pulse animation-delay-2000"></div>
        </div>
    </div>

    <!-- Music Player -->
    <div class="bg-gray-900 p-8">
        <div class="max-w-4xl mx-auto">
            <h2 class="text-3xl font-bold mb-6">🎧 Unsere Musik</h2>

            <div class="bg-gray-800 rounded-lg p-6">
                <!-- Current Track -->
                <div class="mb-6">
                    <h3 class="text-xl font-bold" x-text="tracks[currentTrack].title"></h3>
                    <p class="text-gray-400" x-text="tracks[currentTrack].artist"></p>
                </div>

                <!-- Player Controls -->
                <div class="flex items-center justify-center gap-6 mb-6">
                    <button @click="currentTrack = Math.max(0, currentTrack - 1)" 
                            class="text-3xl hover:text-purple-400 transition">
                        ⏮️
                    </button>
                    <button @click="isPlaying = !isPlaying" 
                            class="text-5xl hover:text-purple-400 transition">
                        <span x-text="isPlaying ? '⏸️' : '▶️'"></span>
                    </button>
                    <button @click="currentTrack = Math.min(tracks.length - 1, currentTrack + 1)" 
                            class="text-3xl hover:text-purple-400 transition">
                        ⏭️
                    </button>
                </div>

                <!-- Progress Bar -->
                <div class="bg-gray-700 h-2 rounded-full mb-4">
                    <div class="bg-purple-500 h-full rounded-full transition-all duration-300" 
                         :style="'width: ' + (isPlaying ? '100%' : '0%')"></div>
                </div>

                <!-- Track List -->
                <div class="space-y-2">
                    <template x-for="(track, index) in tracks" :key="index">
                        <div @click="currentTrack = index" 
                             :class="currentTrack === index ? 'bg-purple-800' : 'bg-gray-700'"
                             class="p-3 rounded cursor-pointer hover:bg-purple-700 transition flex justify-between">
                            <span x-text="track.title"></span>
                            <span class="text-gray-400" x-text="track.duration"></span>
                        </div>
                    </template>
                </div>
            </div>
        </div>
    </div>

    <!-- Tour Dates -->
    <div class="max-w-4xl mx-auto px-4 py-12">
        <h2 class="text-3xl font-bold mb-8">🎸 Tour Dates</h2>

        <div class="space-y-4">
            <template x-for="show in tourDates" :key="show.date">
                <div class="bg-gray-800 rounded-lg p-6 flex justify-between items-center hover:bg-gray-700 transition">
                    <div>
                        <p class="text-xl font-bold" x-text="show.date"></p>
                        <p class="text-purple-400" x-text="show.city + ' - ' + show.venue"></p>
                    </div>
                    <button :class="show.soldOut ? 'bg-red-600 cursor-not-allowed' : 'bg-green-600 hover:bg-green-700'"
                            :disabled="show.soldOut"
                            class="px-6 py-2 rounded-full font-bold">
                        <span x-text="show.soldOut ? 'AUSVERKAUFT' : 'TICKETS'"></span>
                    </button>
                </div>
            </template>
        </div>
    </div>

    <!-- Tasks -->
    <div class="bg-gradient-to-r from-purple-900 to-pink-900 p-8 mt-12">
        <div class="max-w-4xl mx-auto">
            <h2 class="text-2xl font-bold mb-6">🎸 Band-Website Features:</h2>
            <div class="grid md:grid-cols-2 gap-6">
                <div>
                    <h3 class="font-bold mb-3">Musik Features:</h3>
                    <ul class="space-y-2">
                        <li>• "Füge einen echten Music Player hinzu"</li>
                        <li>• "Erstelle eine Diskografie-Seite"</li>
                        <li>• "Füge Spotify/YouTube Integration hinzu"</li>
                        <li>• "Mache ein Lyrics-Display"</li>
                    </ul>
                </div>
                <div>
                    <h3 class="font-bold mb-3">Fan Features:</h3>
                    <ul class="space-y-2">
                        <li>• "Erstelle eine Fotogalerie"</li>
                        <li>• "Füge einen Merch-Shop hinzu"</li>
                        <li>• "Mache einen Newsletter-Bereich"</li>
                        <li>• "Füge Social Media Links hinzu"</li>
                    </ul>
                </div>
            </div>

            <div class="bg-purple-800 p-4 rounded-lg mt-6">
                <p class="font-bold">🔥 ROCKSTAR-TIPP:</p>
                <p>Sage: "Mache daraus eine Festival-Website mit Line-Up und Countdown!"</p>
            </div>
        </div>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    # ===== PROFI TEMPLATES =====
    {
        "id": 7,
        "name": "Profi: Portfolio für Bewerbung",
        "category": "learning_advanced",
        "description": "Professionelles Portfolio für Praktikum/Job",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mein Portfolio</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50" x-data="{
    activeSection: 'about',
    skills: [
        { name: 'HTML/CSS', level: 90 },
        { name: 'JavaScript', level: 75 },
        { name: 'Photoshop', level: 85 },
        { name: 'Teamwork', level: 95 }
    ],
    projects: [
        { 
            title: 'Website Redesign',
            description: 'Modernes Redesign für lokales Unternehmen',
            tags: ['Web Design', 'UX/UI'],
            link: '#'
        },
        {
            title: 'Mobile App Konzept',
            description: 'Konzeption einer Fitness-Tracking App',
            tags: ['App Design', 'Prototyping'],
            link: '#'
        }
    ],
    contactForm: { name: '', email: '', message: '' },
    showThankYou: false
}">
    <!-- Navigation -->
    <nav class="bg-white shadow-md sticky top-0 z-50">
        <div class="max-w-6xl mx-auto px-4">
            <div class="flex justify-between items-center h-16">
                <h1 class="text-xl font-bold">Portfolio</h1>

                <div class="hidden md:flex space-x-8">
                    <button @click="activeSection = 'about'" 
                            :class="activeSection === 'about' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-700'"
                            class="hover:text-blue-600 transition pb-1">
                        Über mich
                    </button>
                    <button @click="activeSection = 'skills'" 
                            :class="activeSection === 'skills' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-700'"
                            class="hover:text-blue-600 transition pb-1">
                        Skills
                    </button>
                    <button @click="activeSection = 'projects'" 
                            :class="activeSection === 'projects' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-700'"
                            class="hover:text-blue-600 transition pb-1">
                        Projekte
                    </button>
                    <button @click="activeSection = 'contact'" 
                            :class="activeSection === 'contact' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-700'"
                            class="hover:text-blue-600 transition pb-1">
                        Kontakt
                    </button>
                </div>

                <a href="#" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">
                    CV Download
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero -->
    <section class="bg-gradient-to-br from-blue-50 to-indigo-100 py-20">
        <div class="max-w-6xl mx-auto px-4 text-center">
            <img src="https://ui-avatars.com/api/?name=Max+Mustermann&size=150&background=3B82F6&color=fff" 
                 class="w-32 h-32 rounded-full mx-auto mb-6 shadow-lg">
            <h1 class="text-4xl font-bold mb-4">Max Mustermann</h1>
            <p class="text-xl text-gray-600 mb-6">Web Developer & Designer</p>
            <div class="flex justify-center gap-4">
                <a href="#" class="text-gray-600 hover:text-blue-600 transition">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                    </svg>
                </a>
                <a href="#" class="text-gray-600 hover:text-blue-600 transition">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
                    </svg>
                </a>
            </div>
        </div>
    </section>

    <!-- Content Sections -->
    <div class="max-w-6xl mx-auto px-4 py-12">
        <!-- About Section -->
        <section x-show="activeSection === 'about'" x-transition>
            <h2 class="text-3xl font-bold mb-8">Über mich</h2>
            <div class="bg-white rounded-lg shadow-md p-8">
                <p class="text-lg text-gray-700 mb-4">
                    Ich bin ein motivierter und kreativer Web Developer mit Leidenschaft für modernes Design 
                    und benutzerfreundliche Interfaces. Aktuell suche ich nach einem Praktikum, um meine 
                    Fähigkeiten in einem professionellen Umfeld weiterzuentwickeln.
                </p>
                <p class="text-lg text-gray-700 mb-6">
                    In meiner Freizeit arbeite ich an persönlichen Projekten und lerne ständig neue 
                    Technologien. Besonders interessiere ich mich für Frontend-Entwicklung und UX Design.
                </p>

                <div class="grid md:grid-cols-2 gap-6 mt-8">
                    <div>
                        <h3 class="font-bold text-xl mb-4">Ausbildung</h3>
                        <div class="space-y-3">
                            <div class="border-l-4 border-blue-500 pl-4">
                                <p class="font-semibold">Realschulabschluss</p>
                                <p class="text-gray-600">Realschule München • 2024</p>
                            </div>
                        </div>
                    </div>
                    <div>
                        <h3 class="font-bold text-xl mb-4">Interessen</h3>
                        <div class="flex flex-wrap gap-2">
                            <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full">Web Design</span>
                            <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full">Gaming</span>
                            <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full">Fotografie</span>
                            <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full">Musik</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Skills Section -->
        <section x-show="activeSection === 'skills'" x-transition>
            <h2 class="text-3xl font-bold mb-8">Meine Skills</h2>
            <div class="bg-white rounded-lg shadow-md p-8">
                <div class="space-y-6">
                    <template x-for="skill in skills" :key="skill.name">
                        <div>
                            <div class="flex justify-between mb-2">
                                <span class="font-semibold" x-text="skill.name"></span>
                                <span class="text-gray-600" x-text="skill.level + '%'"></span>
                            </div>
                            <div class="bg-gray-200 rounded-full h-3">
                                <div class="bg-blue-600 h-3 rounded-full transition-all duration-1000" 
                                     :style="'width: ' + skill.level + '%'"></div>
                            </div>
                        </div>
                    </template>
                </div>

                <div class="mt-8 grid md:grid-cols-2 gap-6">
                    <div>
                        <h3 class="font-bold text-xl mb-4">Technische Skills</h3>
                        <ul class="space-y-2 text-gray-700">
                            <li>• HTML5 & CSS3</li>
                            <li>• JavaScript Grundlagen</li>
                            <li>• Responsive Design</li>
                            <li>• Git Basics</li>
                        </ul>
                    </div>
                    <div>
                        <h3 class="font-bold text-xl mb-4">Soft Skills</h3>
                        <ul class="space-y-2 text-gray-700">
                            <li>• Teamfähigkeit</li>
                            <li>• Kreatives Denken</li>
                            <li>• Schnelle Auffassungsgabe</li>
                            <li>• Zuverlässigkeit</li>
                        </ul>
                    </div>
                </div>
            </div>
        </section>

        <!-- Projects Section -->
        <section x-show="activeSection === 'projects'" x-transition>
            <h2 class="text-3xl font-bold mb-8">Meine Projekte</h2>
            <div class="grid md:grid-cols-2 gap-6">
                <template x-for="project in projects" :key="project.title">
                    <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition">
                        <div class="h-48 bg-gradient-to-br from-blue-400 to-purple-600"></div>
                        <div class="p-6">
                            <h3 class="font-bold text-xl mb-2" x-text="project.title"></h3>
                            <p class="text-gray-600 mb-4" x-text="project.description"></p>
                            <div class="flex flex-wrap gap-2 mb-4">
                                <template x-for="tag in project.tags" :key="tag">
                                    <span class="bg-gray-100 text-gray-700 px-2 py-1 rounded text-sm" x-text="tag"></span>
                                </template>
                            </div>
                            <a :href="project.link" class="text-blue-600 hover:text-blue-800 font-semibold">
                                Projekt ansehen →
                            </a>
                        </div>
                    </div>
                </template>
            </div>
        </section>

        <!-- Contact Section -->
        <section x-show="activeSection === 'contact'" x-transition>
            <h2 class="text-3xl font-bold mb-8">Kontakt</h2>
            <div class="bg-white rounded-lg shadow-md p-8">
                <div x-show="!showThankYou">
                    <p class="text-lg text-gray-700 mb-6">
                        Ich freue mich über Ihre Nachricht! Gerne können wir über Praktikumsmöglichkeiten 
                        oder Projekte sprechen.
                    </p>

                    <form @submit.prevent="showThankYou = true" class="space-y-4">
                        <div>
                            <label class="block font-semibold mb-2">Name</label>
                            <input type="text" x-model="contactForm.name" required
                                   class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:border-blue-500">
                        </div>
                        <div>
                            <label class="block font-semibold mb-2">E-Mail</label>
                            <input type="email" x-model="contactForm.email" required
                                   class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:border-blue-500">
                        </div>
                        <div>
                            <label class="block font-semibold mb-2">Nachricht</label>
                            <textarea x-model="contactForm.message" rows="4" required
                                      class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:border-blue-500"></textarea>
                        </div>
                        <button type="submit" 
                                class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition font-semibold">
                            Nachricht senden
                        </button>
                    </form>
                </div>

                <div x-show="showThankYou" class="text-center py-12">
                    <div class="text-6xl mb-4">✅</div>
                    <h3 class="text-2xl font-bold mb-2">Vielen Dank!</h3>
                    <p class="text-gray-600">Ihre Nachricht wurde gesendet. Ich melde mich bald bei Ihnen!</p>
                </div>
            </div>
        </section>
    </div>

    <!-- Tasks -->
    <div class="bg-gray-100 py-12 mt-12">
        <div class="max-w-6xl mx-auto px-4">
            <div class="bg-white rounded-lg shadow-md p-8">
                <h2 class="text-2xl font-bold mb-6">💼 Portfolio erweitern:</h2>
                <div class="grid md:grid-cols-2 gap-6">
                    <div>
                        <h3 class="font-bold mb-3">Professionelle Features:</h3>
                        <ul class="space-y-2">
                            <li>• "Füge einen Download-Button für meinen Lebenslauf hinzu"</li>
                            <li>• "Erstelle eine Timeline für meinen Werdegang"</li>
                            <li>• "Füge Zertifikate und Auszeichnungen hinzu"</li>
                            <li>• "Mache ein Testimonials-Bereich"</li>
                        </ul>
                    </div>
                    <div>
                        <h3 class="font-bold mb-3">Interaktive Elemente:</h3>
                        <ul class="space-y-2">
                            <li>• "Füge Animationen beim Scrollen hinzu"</li>
                            <li>• "Erstelle einen Dark Mode Toggle"</li>
                            <li>• "Füge einen Blog-Bereich hinzu"</li>
                            <li>• "Mache die Skills animiert beim Laden"</li>
                        </ul>
                    </div>
                </div>

                <div class="bg-blue-100 p-4 rounded-lg mt-6">
                    <p class="font-bold">🚀 KARRIERE-TIPP:</p>
                    <p>Sage: "Optimiere mein Portfolio für Recruiter mit ATS-Keywords!"</p>
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
        "id": 8,
        "name": "Profi: SEO & Performance",
        "category": "learning_advanced",
        "description": "Lerne SEO und Performance-Optimierung",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Lerne SEO und Performance-Optimierung für bessere Rankings">
    <meta name="keywords" content="SEO, Performance, Webentwicklung, Tutorial">
    <meta name="author" content="Dein Name">

    <!-- Open Graph Tags für Social Media -->
    <meta property="og:title" content="SEO & Performance Guide">
    <meta property="og:description" content="Professioneller Guide für SEO und Web-Performance">
    <meta property="og:type" content="website">

    <title>SEO & Performance Guide - Profi Level</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>

    <!-- Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Article",
      "headline": "SEO & Performance Guide",
      "author": {
        "@type": "Person",
        "name": "Dein Name"
      }
    }
    </script>
</head>
<body class="bg-gray-50" x-data="{
    seoScore: 0,
    performanceScore: 0,
    checklist: [
        { id: 1, task: 'Title Tag optimiert', done: true, impact: 'high' },
        { id: 2, task: 'Meta Description vorhanden', done: true, impact: 'medium' },
        { id: 3, task: 'Heading-Struktur korrekt', done: false, impact: 'high' },
        { id: 4, task: 'Alt-Texte bei Bildern', done: false, impact: 'medium' },
        { id: 5, task: 'Mobile-Friendly', done: true, impact: 'critical' },
        { id: 6, task: 'Ladezeit unter 3 Sekunden', done: false, impact: 'critical' }
    ],
    get completedTasks() {
        return this.checklist.filter(item => item.done).length;
    },
    get totalScore() {
        return Math.round((this.completedTasks / this.checklist.length) * 100);
    }
}">
    <!-- Skip to Content (Accessibility) -->
    <a href="#main-content" class="sr-only focus:not-sr-only focus:absolute focus:top-4 focus:left-4 bg-blue-600 text-white px-4 py-2 rounded">
        Zum Hauptinhalt springen
    </a>

    <!-- Header with Navigation -->
    <header class="bg-white shadow-sm">
        <nav class="max-w-7xl mx-auto px-4 py-4">
            <div class="flex justify-between items-center">
                <h1 class="text-2xl font-bold text-gray-900">SEO & Performance Pro</h1>
                <div class="flex gap-4">
                    <a href="#seo" class="text-gray-700 hover:text-blue-600">SEO</a>
                    <a href="#performance" class="text-gray-700 hover:text-blue-600">Performance</a>
                    <a href="#tools" class="text-gray-700 hover:text-blue-600">Tools</a>
                </div>
            </div>
        </nav>
    </header>

    <!-- Main Content -->
    <main id="main-content" class="max-w-7xl mx-auto px-4 py-8">
        <!-- SEO Score Dashboard -->
        <section class="bg-white rounded-lg shadow-md p-8 mb-8">
            <h2 class="text-3xl font-bold mb-6">📊 Dein SEO & Performance Score</h2>

            <div class="grid md:grid-cols-3 gap-6 mb-8">
                <!-- Overall Score -->
                <div class="text-center">
                    <div class="relative inline-flex items-center justify-center w-32 h-32">
                        <svg class="w-32 h-32 transform -rotate-90">
                            <circle cx="64" cy="64" r="56" stroke="#e5e7eb" stroke-width="8" fill="none"></circle>
                            <circle cx="64" cy="64" r="56" stroke="#3b82f6" stroke-width="8" fill="none"
                                    :stroke-dasharray="351.86" 
                                    :stroke-dashoffset="351.86 - (351.86 * totalScore / 100)"></circle>
                        </svg>
                        <span class="absolute text-3xl font-bold" x-text="totalScore + '%'"></span>
                    </div>
                    <p class="mt-2 font-semibold">Gesamt-Score</p>
                </div>

                <!-- Completed Tasks -->
                <div class="text-center">
                    <p class="text-5xl font-bold text-green-600" x-text="completedTasks"></p>
                    <p class="text-gray-600">von <span x-text="checklist.length"></span> erledigt</p>
                </div>

                <!-- Recommendations -->
                <div class="text-center">
                    <p class="text-5xl font-bold text-orange-600" x-text="checklist.length - completedTasks"></p>
                    <p class="text-gray-600">Verbesserungen nötig</p>
                </div>
            </div>

            <!-- Checklist -->
            <div class="space-y-3">
                <template x-for="item in checklist" :key="item.id">
                    <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                        <div class="flex items-center gap-3">
                            <input type="checkbox" x-model="item.done" 
                                   class="w-5 h-5 text-blue-600 rounded focus:ring-blue-500">
                            <span x-text="item.task" :class="item.done ? 'line-through text-gray-500' : ''"></span>
                        </div>
                        <span :class="{
                            'bg-red-100 text-red-800': item.impact === 'critical',
                            'bg-orange-100 text-orange-800': item.impact === 'high',
                            'bg-yellow-100 text-yellow-800': item.impact === 'medium'
                        }" class="px-2 py-1 rounded text-sm font-semibold">
                            <span x-text="item.impact.toUpperCase()"></span>
                        </span>
                    </div>
                </template>
            </div>
        </section>

        <!-- SEO Section -->
        <section id="seo" class="bg-white rounded-lg shadow-md p-8 mb-8">
            <h2 class="text-2xl font-bold mb-6">🔍 SEO Grundlagen</h2>

            <div class="grid md:grid-cols-2 gap-8">
                <div>
                    <h3 class="text-xl font-semibold mb-4">On-Page SEO</h3>
                    <ul class="space-y-3">
                        <li class="flex items-start gap-2">
                            <span class="text-green-500">✓</span>
                            <div>
                                <strong>Title Tags:</strong> 50-60 Zeichen, Keyword am Anfang
                            </div>
                        </li>
                        <li class="flex items-start gap-2">
                            <span class="text-green-500">✓</span>
                            <div>
                                <strong>Meta Description:</strong> 150-160 Zeichen, Call-to-Action
                            </div>
                        </li>
                        <li class="flex items-start gap-2">
                            <span class="text-green-500">✓</span>
                            <div>
                                <strong>Heading-Struktur:</strong> Nur ein H1, logische Hierarchie
                            </div>
                        </li>
                        <li class="flex items-start gap-2">
                            <span class="text-green-500">✓</span>
                            <div>
                                <strong>URL-Struktur:</strong> Kurz, sprechend, mit Bindestrichen
                            </div>
                        </li>
                    </ul>
                </div>

                <div>
                    <h3 class="text-xl font-semibold mb-4">Technical SEO</h3>
                    <ul class="space-y-3">
                        <li class="flex items-start gap-2">
                            <span class="text-blue-500">⚡</span>
                            <div>
                                <strong>Ladegeschwindigkeit:</strong> Core Web Vitals optimieren
                            </div>
                        </li>
                        <li class="flex items-start gap-2">
                            <span class="text-blue-500">📱</span>
                            <div>
                                <strong>Mobile-First:</strong> Responsive Design ist Pflicht
                            </div>
                        </li>
                        <li class="flex items-start gap-2">
                            <span class="text-blue-500">🔒</span>
                            <div>
                                <strong>HTTPS:</strong> SSL-Zertifikat für Sicherheit
                            </div>
                        </li>
                        <li class="flex items-start gap-2">
                            <span class="text-blue-500">🗺️</span>
                            <div>
                                <strong>Sitemap:</strong> XML-Sitemap für Suchmaschinen
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </section>

        <!-- Performance Section -->
        <section id="performance" class="bg-white rounded-lg shadow-md p-8 mb-8">
            <h2 class="text-2xl font-bold mb-6">⚡ Performance Optimierung</h2>

            <div class="space-y-6">
                <!-- Loading Speed Visualization -->
                <div class="bg-gray-50 p-6 rounded-lg">
                    <h3 class="font-semibold mb-4">Ladezeit-Analyse</h3>
                    <div class="space-y-3">
                        <div>
                            <div class="flex justify-between mb-1">
                                <span>First Contentful Paint (FCP)</span>
                                <span class="font-semibold">1.2s</span>
                            </div>
                            <div class="bg-gray-200 rounded-full h-2">
                                <div class="bg-green-500 h-2 rounded-full" style="width: 80%"></div>
                            </div>
                        </div>
                        <div>
                            <div class="flex justify-between mb-1">
                                <span>Largest Contentful Paint (LCP)</span>
                                <span class="font-semibold">2.5s</span>
                            </div>
                            <div class="bg-gray-200 rounded-full h-2">
                                <div class="bg-yellow-500 h-2 rounded-full" style="width: 60%"></div>
                            </div>
                        </div>
                        <div>
                            <div class="flex justify-between mb-1">
                                <span>Time to Interactive (TTI)</span>
                                <span class="font-semibold">3.8s</span>
                            </div>
                            <div class="bg-gray-200 rounded-full h-2">
                                <div class="bg-red-500 h-2 rounded-full" style="width: 40%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Optimization Tips -->
                <div class="grid md:grid-cols-2 gap-6">
                    <div class="bg-blue-50 p-6 rounded-lg">
                        <h4 class="font-semibold mb-3">🖼️ Bilder optimieren</h4>
                        <ul class="space-y-2 text-sm">
                            <li>• WebP Format verwenden</li>
                            <li>• Lazy Loading implementieren</li>
                            <li>• Responsive Images (srcset)</li>
                            <li>• Bilder komprimieren</li>
                        </ul>
                    </div>
                    <div class="bg-green-50 p-6 rounded-lg">
                        <h4 class="font-semibold mb-3">📦 Code optimieren</h4>
                        <ul class="space-y-2 text-sm">
                            <li>• CSS/JS minifizieren</li>
                            <li>• Kritisches CSS inline</li>
                            <li>• JavaScript async/defer</li>
                            <li>• Tree Shaking nutzen</li>
                        </ul>
                    </div>
                </div>
            </div>
        </section>

        <!-- Tools Section -->
        <section id="tools" class="bg-white rounded-lg shadow-md p-8 mb-8">
            <h2 class="text-2xl font-bold mb-6">🛠️ Wichtige SEO & Performance Tools</h2>

            <div class="grid md:grid-cols-3 gap-6">
                <div class="border rounded-lg p-4 hover:shadow-lg transition">
                    <h3 class="font-semibold mb-2">Google PageSpeed Insights</h3>
                    <p class="text-sm text-gray-600 mb-3">Performance-Analyse mit Core Web Vitals</p>
                    <a href="#" class="text-blue-600 hover:underline">Tool öffnen →</a>
                </div>
                <div class="border rounded-lg p-4 hover:shadow-lg transition">
                    <h3 class="font-semibold mb-2">Google Search Console</h3>
                    <p class="text-sm text-gray-600 mb-3">Überwache deine Suchmaschinen-Performance</p>
                    <a href="#" class="text-blue-600 hover:underline">Tool öffnen →</a>
                </div>
                <div class="border rounded-lg p-4 hover:shadow-lg transition">
                    <h3 class="font-semibold mb-2">GTmetrix</h3>
                    <p class="text-sm text-gray-600 mb-3">Detaillierte Performance-Berichte</p>
                    <a href="#" class="text-blue-600 hover:underline">Tool öffnen →</a>
                </div>
            </div>
        </section>

        <!-- Advanced Tasks -->
        <section class="bg-gradient-to-r from-purple-100 to-blue-100 rounded-lg p-8">
            <h2 class="text-2xl font-bold mb-6">🚀 Profi-Level Aufgaben</h2>

            <div class="grid md:grid-cols-2 gap-8">
                <div>
                    <h3 class="font-bold mb-4">SEO-Optimierungen:</h3>
                    <ul class="space-y-2">
                        <li>• "Implementiere Schema.org Markup für Rich Snippets"</li>
                        <li>• "Erstelle eine automatische XML-Sitemap"</li>
                        <li>• "Füge Open Graph Tags für Social Media hinzu"</li>
                        <li>• "Implementiere Breadcrumb-Navigation"</li>
                        <li>• "Optimiere für Voice Search"</li>
                    </ul>
                </div>
                <div>
                    <h3 class="font-bold mb-4">Performance-Features:</h3>
                    <ul class="space-y-2">
                        <li>• "Implementiere Service Worker für Offline-Funktionalität"</li>
                        <li>• "Füge Resource Hints (preload, prefetch) hinzu"</li>
                        <li>• "Erstelle Critical CSS Extraction"</li>
                        <li>• "Implementiere Image CDN Integration"</li>
                        <li>• "Füge Web Vitals Monitoring hinzu"</li>
                    </ul>
                </div>
            </div>

            <div class="bg-purple-200 p-4 rounded-lg mt-6">
                <p class="font-bold">🏆 EXPERT-CHALLENGE:</p>
                <p>Sage: "Erstelle ein vollständiges SEO-Audit-Tool mit Echtzeit-Analyse!"</p>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-8 mt-12">
        <div class="max-w-7xl mx-auto px-4 text-center">
            <p>SEO & Performance Guide • Optimiert für beste Rankings</p>
            <p class="text-sm text-gray-400 mt-2">Ladezeit dieser Seite: <span class="font-mono">0.8s</span></p>
        </div>
    </footer>
</body>
</html>""",
        "css": "",
        "js": ""
    },

    {
        "id": 9,
        "name": "Profi: Fitness & Sport Tracker",
        "category": "learning_advanced",
        "description": "Erstelle einen interaktiven Fitness-Tracker",
        "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fitness Tracker Pro</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-900 text-white" x-data="{
    activeTab: 'dashboard',
    currentWeight: 75,
    targetWeight: 70,
    dailySteps: 8432,
    stepsGoal: 10000,
    waterIntake: 1.5,
    waterGoal: 2.5,
    workouts: [
        { id: 1, name: 'Morgen-Lauf', duration: 30, calories: 250, type: 'cardio', completed: true },
        { id: 2, name: 'Krafttraining', duration: 45, calories: 300, type: 'strength', completed: false },
        { id: 3, name: 'Yoga', duration: 20, calories: 100, type: 'flexibility', completed: false }
    ],
    meals: [
        { time: 'Frühstück', calories: 450, logged: true },
        { time: 'Mittagessen', calories: 650, logged: true },
        { time: 'Abendessen', calories: 0, logged: false },
        { time: 'Snacks', calories: 200, logged: true }
    ],
    achievements: [
        { name: '7 Tage Streak', icon: '🔥', unlocked: true },
        { name: '10k Schritte', icon: '👟', unlocked: false },
        { name: 'Wasser-Champion', icon: '💧', unlocked: false },
        { name: 'Früher Vogel', icon: '🌅', unlocked: true }
    ],
    get totalCaloriesBurned() {
        return this.workouts.filter(w => w.completed).reduce((sum, w) => sum + w.calories, 0);
    },
    get totalCaloriesConsumed() {
        return this.meals.filter(m => m.logged).reduce((sum, m) => sum + m.calories, 0);
    },
    get calorieBalance() {
        return this.totalCaloriesConsumed - this.totalCaloriesBurned;
    },
    get stepsProgress() {
        return Math.min(100, (this.dailySteps / this.stepsGoal) * 100);
    },
    get waterProgress() {
        return Math.min(100, (this.waterIntake / this.waterGoal) * 100);
    },
    addWater() {
        this.waterIntake = Math.min(this.waterGoal + 0.5, this.waterIntake + 0.25);
    }
}">
    <!-- Header Navigation -->
    <header class="bg-gray-800 shadow-lg">
        <div class="max-w-7xl mx-auto px-4 py-4">
            <div class="flex justify-between items-center">
                <h1 class="text-2xl font-bold flex items-center gap-2">
                    <span class="text-3xl">💪</span> Fitness Tracker Pro
                </h1>
                <div class="flex gap-4">
                    <button @click="activeTab = 'dashboard'" 
                            :class="activeTab === 'dashboard' ? 'text-green-400' : 'text-gray-400'"
                            class="hover:text-white transition">
                        Dashboard
                    </button>
                    <button @click="activeTab = 'workouts'" 
                            :class="activeTab === 'workouts' ? 'text-green-400' : 'text-gray-400'"
                            class="hover:text-white transition">
                        Workouts
                    </button>
                    <button @click="activeTab = 'nutrition'" 
                            :class="activeTab === 'nutrition' ? 'text-green-400' : 'text-gray-400'"
                            class="hover:text-white transition">
                        Ernährung
                    </button>
                    <button @click="activeTab = 'progress'" 
                            :class="activeTab === 'progress' ? 'text-green-400' : 'text-gray-400'"
                            class="hover:text-white transition">
                        Fortschritt
                    </button>
                </div>
            </div>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 py-8">
        <!-- Dashboard Tab -->
        <div x-show="activeTab === 'dashboard'" x-transition>
            <!-- Today's Stats -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <!-- Steps Card -->
                <div class="bg-gray-800 rounded-lg p-6">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <p class="text-gray-400 text-sm">Schritte heute</p>
                            <p class="text-3xl font-bold" x-text="dailySteps.toLocaleString()"></p>
                        </div>
                        <span class="text-3xl">👟</span>
                    </div>
                    <div class="bg-gray-700 rounded-full h-2">
                        <div class="bg-green-500 h-2 rounded-full transition-all duration-500" 
                             :style="'width: ' + stepsProgress + '%'"></div>
                    </div>
                    <p class="text-xs text-gray-400 mt-2">Ziel: <span x-text="stepsGoal.toLocaleString()"></span></p>
                </div>

                <!-- Calories Card -->
                <div class="bg-gray-800 rounded-lg p-6">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <p class="text-gray-400 text-sm">Kalorien-Bilanz</p>
                            <p class="text-3xl font-bold" 
                               :class="calorieBalance > 0 ? 'text-red-400' : 'text-green-400'"
                               x-text="(calorieBalance > 0 ? '+' : '') + calorieBalance"></p>
                        </div>
                        <span class="text-3xl">🔥</span>
                    </div>
                    <p class="text-xs text-gray-400">Gegessen: <span x-text="totalCaloriesConsumed"></span> kcal</p>
                    <p class="text-xs text-gray-400">Verbrannt: <span x-text="totalCaloriesBurned"></span> kcal</p>
                </div>

                <!-- Water Card -->
                <div class="bg-gray-800 rounded-lg p-6">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <p class="text-gray-400 text-sm">Wasser getrunken</p>
                            <p class="text-3xl font-bold"><span x-text="waterIntake"></span>L</p>
                        </div>
                        <span class="text-3xl">💧</span>
                    </div>
                    <div class="bg-gray-700 rounded-full h-2 mb-2">
                        <div class="bg-blue-500 h-2 rounded-full transition-all duration-500" 
                             :style="'width: ' + waterProgress + '%'"></div>
                    </div>
                    <button @click="addWater" 
                            class="w-full bg-blue-600 hover:bg-blue-700 py-1 rounded text-sm transition">
                        +250ml hinzufügen
                    </button>
                </div>

                <!-- Weight Card -->
                <div class="bg-gray-800 rounded-lg p-6">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <p class="text-gray-400 text-sm">Aktuelles Gewicht</p>
                            <p class="text-3xl font-bold"><span x-text="currentWeight"></span> kg</p>
                        </div>
                        <span class="text-3xl">⚖️</span>
                    </div>
                    <p class="text-xs text-gray-400">Ziel: <span x-text="targetWeight"></span> kg</p>
                    <p class="text-xs" :class="currentWeight > targetWeight ? 'text-orange-400' : 'text-green-400'">
                        <span x-text="Math.abs(currentWeight - targetWeight)"></span> kg bis zum Ziel
                    </p>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="bg-gray-800 rounded-lg p-6 mb-8">
                <h2 class="text-xl font-bold mb-4">⚡ Schnellaktionen</h2>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <button class="bg-purple-600 hover:bg-purple-700 p-4 rounded-lg transition">
                        <span class="text-2xl mb-2 block">🏃</span>
                        Workout starten
                    </button>
                    <button class="bg-green-600 hover:bg-green-700 p-4 rounded-lg transition">
                        <span class="text-2xl mb-2 block">🥗</span>
                        Mahlzeit loggen
                    </button>
                    <button class="bg-blue-600 hover:bg-blue-700 p-4 rounded-lg transition">
                        <span class="text-2xl mb-2 block">😴</span>
                        Schlaf tracken
                    </button>
                    <button class="bg-orange-600 hover:bg-orange-700 p-4 rounded-lg transition">
                        <span class="text-2xl mb-2 block">📊</span>
                        Stats ansehen
                    </button>
                </div>
            </div>

            <!-- Achievements -->
            <div class="bg-gray-800 rounded-lg p-6">
                <h2 class="text-xl font-bold mb-4">🏆 Erfolge</h2>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <template x-for="achievement in achievements" :key="achievement.name">
                        <div :class="achievement.unlocked ? 'bg-gray-700' : 'bg-gray-900 opacity-50'"
                             class="p-4 rounded-lg text-center">
                            <span class="text-3xl mb-2 block" x-text="achievement.icon"></span>
                            <p class="text-sm" x-text="achievement.name"></p>
                            <p class="text-xs mt-1" 
                               :class="achievement.unlocked ? 'text-green-400' : 'text-gray-500'"
                               x-text="achievement.unlocked ? 'Freigeschaltet!' : 'Gesperrt'"></p>
                        </div>
                    </template>
                </div>
            </div>
        </div>

        <!-- Workouts Tab -->
        <div x-show="activeTab === 'workouts'" x-transition>
            <h2 class="text-2xl font-bold mb-6">💪 Heutige Workouts</h2>

            <div class="space-y-4 mb-8">
                <template x-for="workout in workouts" :key="workout.id">
                    <div class="bg-gray-800 rounded-lg p-6 flex items-center justify-between">
                        <div class="flex items-center gap-4">
                            <div class="w-16 h-16 rounded-full flex items-center justify-center"
                                 :class="{
                                     'bg-blue-600': workout.type === 'cardio',
                                     'bg-red-600': workout.type === 'strength',
                                     'bg-green-600': workout.type === 'flexibility'
                                 }">
                                <span class="text-2xl">
                                    <span x-show="workout.type === 'cardio'">🏃</span>
                                    <span x-show="workout.type === 'strength'">🏋️</span>
                                    <span x-show="workout.type === 'flexibility'">🧘</span>
                                </span>
                            </div>
                            <div>
                                <h3 class="font-bold text-lg" x-text="workout.name"></h3>
                                <p class="text-gray-400">
                                    <span x-text="workout.duration"></span> Min • 
                                    <span x-text="workout.calories"></span> kcal
                                </p>
                            </div>
                        </div>
                        <button @click="workout.completed = !workout.completed"
                                :class="workout.completed ? 'bg-green-600' : 'bg-gray-600'"
                                class="px-6 py-3 rounded-lg font-bold transition">
                            <span x-text="workout.completed ? '✓ Erledigt' : 'Start'"></span>
                        </button>
                    </div>
                </template>
            </div>

            <button class="w-full bg-purple-600 hover:bg-purple-700 py-4 rounded-lg font-bold transition">
                + Neues Workout hinzufügen
            </button>
        </div>

        <!-- Nutrition Tab -->
        <div x-show="activeTab === 'nutrition'" x-transition>
            <h2 class="text-2xl font-bold mb-6">🥗 Ernährung heute</h2>

            <div class="grid md:grid-cols-2 gap-8">
                <div>
                    <h3 class="text-xl font-semibold mb-4">Mahlzeiten</h3>
                    <div class="space-y-3">
                        <template x-for="meal in meals" :key="meal.time">
                            <div class="bg-gray-800 rounded-lg p-4">
                                <div class="flex justify-between items-center">
                                    <div>
                                        <p class="font-semibold" x-text="meal.time"></p>
                                        <p class="text-gray-400">
                                            <span x-text="meal.calories"></span> kcal
                                            <span x-show="!meal.logged" class="text-orange-400"> • Nicht geloggt</span>
                                        </p>
                                    </div>
                                    <button class="text-blue-400 hover:text-blue-300">
                                        <span x-text="meal.logged ? 'Bearbeiten' : 'Hinzufügen'"></span>
                                    </button>
                                </div>
                            </div>
                        </template>
                    </div>
                </div>

                <div>
                    <h3 class="text-xl font-semibold mb-4">Makros Übersicht</h3>
                    <div class="bg-gray-800 rounded-lg p-6">
                        <div class="space-y-4">
                            <div>
                                <div class="flex justify-between mb-1">
                                    <span>Proteine</span>
                                    <span>75g / 120g</span>
                                </div>
                                <div class="bg-gray-700 rounded-full h-3">
                                    <div class="bg-blue-500 h-3 rounded-full" style="width: 62%"></div>
                                </div>
                            </div>
                            <div>
                                <div class="flex justify-between mb-1">
                                    <span>Kohlenhydrate</span>
                                    <span>180g / 250g</span>
                                </div>
                                <div class="bg-gray-700 rounded-full h-3">
                                    <div class="bg-green-500 h-3 rounded-full" style="width: 72%"></div>
                                </div>
                            </div>
                            <div>
                                <div class="flex justify-between mb-1">
                                    <span>Fette</span>
                                    <span>55g / 80g</span>
                                </div>
                                <div class="bg-gray-700 rounded-full h-3">
                                    <div class="bg-yellow-500 h-3 rounded-full" style="width: 69%"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Progress Tab -->
        <div x-show="activeTab === 'progress'" x-transition>
            <h2 class="text-2xl font-bold mb-6">📈 Dein Fortschritt</h2>

            <div class="grid md:grid-cols-2 gap-8">
                <div class="bg-gray-800 rounded-lg p-6">
                    <h3 class="text-xl font-semibold mb-4">Gewichtsverlauf</h3>
                    <div class="h-64 flex items-end justify-between gap-2">
                        <div class="bg-blue-600 w-full rounded-t" style="height: 80%"></div>
                        <div class="bg-blue-600 w-full rounded-t" style="height: 75%"></div>
                        <div class="bg-blue-600 w-full rounded-t" style="height: 72%"></div>
                        <div class="bg-blue-600 w-full rounded-t" style="height: 70%"></div>
                        <div class="bg-green-500 w-full rounded-t" style="height: 68%"></div>
                    </div>
                    <p class="text-center text-gray-400 mt-2">Letzte 5 Wochen</p>
                </div>

                <div class="bg-gray-800 rounded-lg p-6">
                    <h3 class="text-xl font-semibold mb-4">Statistiken</h3>
                    <div class="space-y-4">
                        <div class="flex justify-between">
                            <span>Trainingstage diese Woche</span>
                            <span class="font-bold text-green-400">5/7</span>
                        </div>
                        <div class="flex justify-between">
                            <span>Durchschn. Schritte/Tag</span>
                            <span class="font-bold">8,245</span>
                        </div>
                        <div class="flex justify-between">
                            <span>Kalorien verbrannt (Woche)</span>
                            <span class="font-bold text-orange-400">2,450 kcal</span>
                        </div>
                        <div class="flex justify-between">
                            <span>Aktuelle Serie</span>
                            <span class="font-bold text-red-400">7 Tage 🔥</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Tasks Section -->
    <div class="bg-gradient-to-r from-green-900 to-blue-900 py-12 mt-12">
        <div class="max-w-7xl mx-auto px-4">
            <h2 class="text-2xl font-bold mb-8">🚀 Fitness-App Features zum Hinzufügen:</h2>

            <div class="grid md:grid-cols-3 gap-6">
                <div>
                    <h3 class="font-bold mb-4">Tracking Features:</h3>
                    <ul class="space-y-2">
                        <li>• "Füge GPS-Tracking für Läufe hinzu"</li>
                        <li>• "Erstelle einen Herzfrequenz-Monitor"</li>
                        <li>• "Implementiere Schlaf-Tracking"</li>
                        <li>• "Füge Körpermaße-Tracking hinzu"</li>
                    </ul>
                </div>
                <div>
                    <h3 class="font-bold mb-4">Social Features:</h3>
                    <ul class="space-y-2">
                        <li>• "Erstelle Challenges mit Freunden"</li>
                        <li>• "Füge eine Bestenliste hinzu"</li>
                        <li>• "Implementiere Workout-Sharing"</li>
                        <li>• "Mache einen Trainingspartner-Finder"</li>
                    </ul>
                </div>
                <div>
                    <h3 class="font-bold mb-4">Advanced Features:</h3>
                    <ul class="space-y-2">
                        <li>• "Erstelle KI-basierte Trainingspläne"</li>
                        <li>• "Füge Barcode-Scanner für Lebensmittel hinzu"</li>
                        <li>• "Implementiere Workout-Videos"</li>
                        <li>• "Mache Wearable-Integration"</li>
                    </ul>
                </div>
            </div>

            <div class="bg-green-800 bg-opacity-50 p-4 rounded-lg mt-6">
                <p class="font-bold">💎 PREMIUM-CHALLENGE:</p>
                <p>Sage: "Verwandle das in eine vollständige Fitness-App mit 3D-Körper-Visualisierung!"</p>
            </div>
        </div>
    </div>
</body>
</html>""",
        "css": "",
        "js": ""
    }
]


# Database integration function remains the same
async def save_templates_to_db(db: AsyncSession):
    """Save all learning templates to database"""
    for template_data in templates:
        template = Template(
            name=template_data["name"],
            category=template_data["category"],
            description=template_data["description"],
            html=template_data["html"],
            css=template_data["css"],
            js=template_data["js"],
            is_active=True,
            order_index=template_data["id"]
        )
        db.add(template)
    await db.commit()