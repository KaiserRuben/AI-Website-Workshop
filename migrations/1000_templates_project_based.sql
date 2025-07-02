-- Migration: Project Based Templates
-- Category: project_based
-- Purpose: Learn by building real-world projects

INSERT INTO templates (name, description, html, css, js, category, is_active, order_index, template_metadata) VALUES

-- Template 1: Modern Blog (Beginner)
('📝 Modern Blog mit CMS', 'Erstelle einen professionellen Blog mit Content Management',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Ein moderner Blog mit CMS-Features">
    <title>Modern Blog - Learn by Building</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50" x-data="{
    // Blog state management
    currentView: ''home'', // home, post, editor, dashboard
    isAdmin: false,
    searchQuery: '''',
    selectedCategory: ''all'',

    // Blog posts data
    posts: [
        {
            id: 1,
            title: ''Getting Started with Web Development'',
            excerpt: ''A comprehensive guide to beginning your journey in web development...'',
            content: ''Full article content here with **markdown** support and code examples...'',
            author: {
                name: ''Sarah Johnson'',
                avatar: ''https://ui-avatars.com/api/?name=Sarah+Johnson'',
                bio: ''Full-stack developer and technical writer''
            },
            date: new Date(''2024-01-15''),
            readTime: 5,
            category: ''Tutorial'',
            tags: [''HTML'', ''CSS'', ''JavaScript''],
            featured: true,
            published: true,
            views: 1234,
            likes: 89,
            comments: [
                {
                    id: 1,
                    author: ''John Doe'',
                    content: ''Great article! Very helpful for beginners.'',
                    date: new Date(''2024-01-16''),
                    likes: 5
                }
            ]
        },
        {
            id: 2,
            title: ''Modern CSS Techniques You Should Know'',
            excerpt: ''Explore the latest CSS features that will transform your styling workflow...'',
            content: ''Deep dive into modern CSS with Grid, Flexbox, and custom properties...'',
            author: {
                name: ''Mike Chen'',
                avatar: ''https://ui-avatars.com/api/?name=Mike+Chen'',
                bio: ''CSS specialist and UI designer''
            },
            date: new Date(''2024-01-20''),
            readTime: 8,
            category: ''Design'',
            tags: [''CSS'', ''Design'', ''Frontend''],
            featured: false,
            published: true,
            views: 892,
            likes: 67,
            comments: []
        }
    ],

    // New post draft
    draft: {
        title: '''',
        excerpt: '''',
        content: '''',
        category: ''Tutorial'',
        tags: [],
        featured: false
    },

    // Analytics data
    analytics: {
        totalViews: 15420,
        totalLikes: 892,
        totalComments: 234,
        growthRate: 12.5
    },

    // Categories
    categories: [''all'', ''Tutorial'', ''Design'', ''Development'', ''News'', ''Opinion''],

    // Computed properties
    get filteredPosts() {
        let filtered = this.posts.filter(post => post.published);

        // Category filter
        if (this.selectedCategory !== ''all'') {
            filtered = filtered.filter(post => post.category === this.selectedCategory);
        }

        // Search filter
        if (this.searchQuery) {
            const query = this.searchQuery.toLowerCase();
            filtered = filtered.filter(post =>
                post.title.toLowerCase().includes(query) ||
                post.excerpt.toLowerCase().includes(query) ||
                post.tags.some(tag => tag.toLowerCase().includes(query))
            );
        }

        // Sort by date
        return filtered.sort((a, b) => b.date - a.date);
    },

    get featuredPosts() {
        return this.posts.filter(post => post.featured && post.published);
    },

    // Methods
    viewPost(postId) {
        const post = this.posts.find(p => p.id === postId);
        if (post) {
            post.views++;
            this.currentView = ''post'';
            this.currentPost = post;
        }
    },

    likePost(postId) {
        const post = this.posts.find(p => p.id === postId);
        if (post) {
            post.likes++;
        }
    },

    addComment(postId, commentText) {
        const post = this.posts.find(p => p.id === postId);
        if (post && commentText.trim()) {
            post.comments.push({
                id: Date.now(),
                author: ''Guest User'',
                content: commentText,
                date: new Date(),
                likes: 0
            });
        }
    },

    publishPost() {
        if (this.draft.title && this.draft.content) {
            this.posts.unshift({
                id: Date.now(),
                ...this.draft,
                author: {
                    name: ''You'',
                    avatar: ''https://ui-avatars.com/api/?name=You'',
                    bio: ''Blog author''
                },
                date: new Date(),
                readTime: Math.ceil(this.draft.content.split('' '').length / 200),
                published: true,
                views: 0,
                likes: 0,
                comments: []
            });

            // Reset draft
            this.draft = {
                title: '''',
                excerpt: '''',
                content: '''',
                category: ''Tutorial'',
                tags: [],
                featured: false
            };

            this.currentView = ''home'';
        }
    },

    formatDate(date) {
        return new Intl.DateTimeFormat(''de-DE'', {
            year: ''numeric'',
            month: ''long'',
            day: ''numeric''
        }).format(date);
    }
}">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <h1 class="text-2xl font-bold text-gray-900">ModernBlog</h1>

                    <!-- Navigation Links -->
                    <div class="hidden md:ml-10 md:flex items-center space-x-4">
                        <button @click="currentView = ''home''; selectedCategory = ''all''"
                                :class="currentView === ''home'' ? ''text-indigo-600'' : ''text-gray-700''"
                                class="hover:text-indigo-600 px-3 py-2 text-sm font-medium transition">
                            Home
                        </button>
                        <template x-for="cat in categories.slice(1)" :key="cat">
                            <button @click="selectedCategory = cat; currentView = ''home''"
                                    :class="selectedCategory === cat ? ''text-indigo-600'' : ''text-gray-700''"
                                    class="hover:text-indigo-600 px-3 py-2 text-sm font-medium transition"
                                    x-text="cat">
                            </button>
                        </template>
                    </div>
                </div>

                <div class="flex items-center space-x-4">
                    <!-- Search -->
                    <div class="relative">
                        <input type="text"
                               x-model="searchQuery"
                               placeholder="Search posts..."
                               class="w-64 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                        <svg class="absolute right-3 top-2.5 h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>

                    <!-- Admin Toggle -->
                    <button @click="isAdmin = !isAdmin"
                            :class="isAdmin ? ''bg-indigo-600 text-white'' : ''bg-gray-200 text-gray-700''"
                            class="px-4 py-2 rounded-lg font-medium transition">
                        <span x-text="isAdmin ? ''Admin Mode'' : ''Reader Mode''"></span>
                    </button>

                    <!-- New Post Button -->
                    <button x-show="isAdmin"
                            @click="currentView = ''editor''"
                            class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition">
                        + New Post
                    </button>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Home View -->
        <div x-show="currentView === ''home''" x-transition>
            <!-- Featured Posts Carousel -->
            <div x-show="featuredPosts.length > 0" class="mb-12">
                <h2 class="text-3xl font-bold text-gray-900 mb-6">Featured Posts</h2>
                <div class="grid md:grid-cols-2 gap-6">
                    <template x-for="post in featuredPosts.slice(0, 2)" :key="post.id">
                        <article @click="viewPost(post.id)"
                                 class="bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer hover:shadow-xl transition group">
                            <div class="h-48 bg-gradient-to-br from-indigo-500 to-purple-600"></div>
                            <div class="p-6">
                                <div class="flex items-center mb-4">
                                    <span class="text-sm font-medium text-indigo-600" x-text="post.category"></span>
                                    <span class="mx-2 text-gray-300">•</span>
                                    <time class="text-sm text-gray-500" x-text="formatDate(post.date)"></time>
                                </div>
                                <h3 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-indigo-600 transition"
                                    x-text="post.title"></h3>
                                <p class="text-gray-600 mb-4" x-text="post.excerpt"></p>
                                <div class="flex items-center">
                                    <img :src="post.author.avatar" :alt="post.author.name"
                                         class="w-10 h-10 rounded-full mr-3">
                                    <div>
                                        <p class="text-sm font-medium text-gray-900" x-text="post.author.name"></p>
                                        <p class="text-sm text-gray-500">
                                            <span x-text="post.readTime"></span> min read
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </article>
                    </template>
                </div>
            </div>

            <!-- Recent Posts Grid -->
            <div>
                <h2 class="text-3xl font-bold text-gray-900 mb-6">Recent Posts</h2>
                <div class="grid md:grid-cols-3 gap-6">
                    <template x-for="post in filteredPosts" :key="post.id">
                        <article @click="viewPost(post.id)"
                                 class="bg-white rounded-lg shadow hover:shadow-lg transition cursor-pointer">
                            <div class="h-40 bg-gradient-to-br from-gray-200 to-gray-300 rounded-t-lg"></div>
                            <div class="p-6">
                                <div class="flex items-center mb-3">
                                    <span class="text-xs font-medium text-indigo-600 uppercase tracking-wide"
                                          x-text="post.category"></span>
                                </div>
                                <h3 class="text-lg font-semibold text-gray-900 mb-2 hover:text-indigo-600 transition"
                                    x-text="post.title"></h3>
                                <p class="text-gray-600 text-sm mb-4 line-clamp-3" x-text="post.excerpt"></p>

                                <!-- Tags -->
                                <div class="flex flex-wrap gap-2 mb-4">
                                    <template x-for="tag in post.tags" :key="tag">
                                        <span class="px-2 py-1 bg-gray-100 text-gray-600 text-xs rounded-full"
                                              x-text="tag"></span>
                                    </template>
                                </div>

                                <!-- Stats -->
                                <div class="flex items-center justify-between text-sm text-gray-500">
                                    <div class="flex items-center space-x-4">
                                        <span>👁️ <span x-text="post.views"></span></span>
                                        <span>❤️ <span x-text="post.likes"></span></span>
                                        <span>💬 <span x-text="post.comments.length"></span></span>
                                    </div>
                                    <time x-text="formatDate(post.date)"></time>
                                </div>
                            </div>
                        </article>
                    </template>
                </div>

                <!-- Empty State -->
                <div x-show="filteredPosts.length === 0"
                     class="text-center py-12">
                    <p class="text-gray-500 text-lg">No posts found matching your criteria.</p>
                </div>
            </div>
        </div>

        <!-- Post View -->
        <div x-show="currentView === ''post''" x-transition>
            <article class="max-w-4xl mx-auto" x-show="currentPost">
                <!-- Post Header -->
                <header class="mb-8">
                    <div class="mb-4">
                        <button @click="currentView = ''home''"
                                class="text-indigo-600 hover:text-indigo-800 font-medium">
                            ← Back to posts
                        </button>
                    </div>

                    <h1 class="text-4xl font-bold text-gray-900 mb-4" x-text="currentPost?.title"></h1>

                    <div class="flex items-center justify-between flex-wrap gap-4">
                        <div class="flex items-center">
                            <img :src="currentPost?.author.avatar" :alt="currentPost?.author.name"
                                 class="w-12 h-12 rounded-full mr-4">
                            <div>
                                <p class="font-medium text-gray-900" x-text="currentPost?.author.name"></p>
                                <p class="text-sm text-gray-500">
                                    <time x-text="formatDate(currentPost?.date)"></time> ·
                                    <span x-text="currentPost?.readTime"></span> min read
                                </p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-4">
                            <button @click="likePost(currentPost.id)"
                                    class="flex items-center space-x-2 text-gray-500 hover:text-red-600 transition">
                                <span class="text-2xl">❤️</span>
                                <span x-text="currentPost?.likes"></span>
                            </button>
                            <div class="flex items-center space-x-2 text-gray-500">
                                <span class="text-2xl">👁️</span>
                                <span x-text="currentPost?.views"></span>
                            </div>
                        </div>
                    </div>
                </header>

                <!-- Post Content -->
                <div class="prose prose-lg max-w-none mb-12">
                    <div class="bg-gradient-to-br from-indigo-500 to-purple-600 h-96 rounded-xl mb-8"></div>
                    <div x-html="currentPost?.content" class="text-gray-700"></div>
                </div>

                <!-- Tags -->
                <div class="flex flex-wrap gap-2 mb-8">
                    <template x-for="tag in currentPost?.tags" :key="tag">
                        <span class="px-3 py-1 bg-indigo-100 text-indigo-700 rounded-full" x-text="tag"></span>
                    </template>
                </div>

                <!-- Author Bio -->
                <div class="bg-gray-50 rounded-lg p-6 mb-12">
                    <h3 class="font-bold text-lg mb-3">About the Author</h3>
                    <div class="flex items-start">
                        <img :src="currentPost?.author.avatar" :alt="currentPost?.author.name"
                             class="w-16 h-16 rounded-full mr-4">
                        <div>
                            <p class="font-medium text-gray-900" x-text="currentPost?.author.name"></p>
                            <p class="text-gray-600" x-text="currentPost?.author.bio"></p>
                        </div>
                    </div>
                </div>

                <!-- Comments Section -->
                <div class="border-t pt-8">
                    <h3 class="text-2xl font-bold mb-6">
                        Comments (<span x-text="currentPost?.comments.length"></span>)
                    </h3>

                    <!-- Comment Form -->
                    <div class="bg-gray-50 rounded-lg p-6 mb-8">
                        <textarea placeholder="Share your thoughts..."
                                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                                  rows="4"
                                  x-model="commentText"></textarea>
                        <button @click="addComment(currentPost.id, commentText); commentText = ''''"
                                class="mt-3 bg-indigo-600 text-white px-6 py-2 rounded-lg hover:bg-indigo-700 transition">
                            Post Comment
                        </button>
                    </div>

                    <!-- Comments List -->
                    <div class="space-y-6">
                        <template x-for="comment in currentPost?.comments" :key="comment.id">
                            <div class="bg-white rounded-lg p-6 shadow">
                                <div class="flex items-start">
                                    <img :src="`https://ui-avatars.com/api/?name=${comment.author}`"
                                         :alt="comment.author"
                                         class="w-10 h-10 rounded-full mr-4">
                                    <div class="flex-1">
                                        <div class="flex items-center justify-between mb-2">
                                            <p class="font-medium" x-text="comment.author"></p>
                                            <time class="text-sm text-gray-500" x-text="formatDate(comment.date)"></time>
                                        </div>
                                        <p class="text-gray-700" x-text="comment.content"></p>
                                        <button class="mt-2 text-sm text-gray-500 hover:text-indigo-600">
                                            👍 <span x-text="comment.likes"></span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </div>
                </div>
            </article>
        </div>

        <!-- Editor View -->
        <div x-show="currentView === ''editor''" x-transition>
            <div class="max-w-4xl mx-auto">
                <h2 class="text-3xl font-bold mb-8">Create New Post</h2>

                <div class="bg-white rounded-lg shadow-lg p-8">
                    <div class="space-y-6">
                        <!-- Title -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Title</label>
                            <input type="text"
                                   x-model="draft.title"
                                   placeholder="Enter your post title..."
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                        </div>

                        <!-- Excerpt -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Excerpt</label>
                            <textarea x-model="draft.excerpt"
                                      placeholder="Brief description of your post..."
                                      rows="3"
                                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"></textarea>
                        </div>

                        <!-- Category -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Category</label>
                            <select x-model="draft.category"
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                                <template x-for="cat in categories.slice(1)" :key="cat">
                                    <option :value="cat" x-text="cat"></option>
                                </template>
                            </select>
                        </div>

                        <!-- Content -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Content</label>
                            <textarea x-model="draft.content"
                                      placeholder="Write your post content here..."
                                      rows="15"
                                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent font-mono"></textarea>
                        </div>

                        <!-- Tags -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Tags</label>
                            <input type="text"
                                   placeholder="Add tags separated by commas..."
                                   @keyup.enter="draft.tags = $event.target.value.split('','').map(t => t.trim())"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                        </div>

                        <!-- Featured Toggle -->
                        <div class="flex items-center">
                            <input type="checkbox"
                                   x-model="draft.featured"
                                   class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
                            <label class="ml-2 text-sm text-gray-700">Feature this post</label>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="flex justify-end space-x-4 mt-8">
                        <button @click="currentView = ''home''"
                                class="px-6 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 transition">
                            Cancel
                        </button>
                        <button @click="publishPost"
                                class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition">
                            Publish Post
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Admin Dashboard -->
        <div x-show="isAdmin && currentView === ''home''" x-transition>
            <div class="bg-white rounded-lg shadow-lg p-6 mb-8">
                <h3 class="text-xl font-bold mb-6">Analytics Dashboard</h3>
                <div class="grid md:grid-cols-4 gap-6">
                    <div class="text-center">
                        <p class="text-3xl font-bold text-indigo-600" x-text="analytics.totalViews.toLocaleString()"></p>
                        <p class="text-gray-600">Total Views</p>
                    </div>
                    <div class="text-center">
                        <p class="text-3xl font-bold text-green-600" x-text="analytics.totalLikes"></p>
                        <p class="text-gray-600">Total Likes</p>
                    </div>
                    <div class="text-center">
                        <p class="text-3xl font-bold text-blue-600" x-text="analytics.totalComments"></p>
                        <p class="text-gray-600">Total Comments</p>
                    </div>
                    <div class="text-center">
                        <p class="text-3xl font-bold text-purple-600">
                            +<span x-text="analytics.growthRate"></span>%
                        </p>
                        <p class="text-gray-600">Growth Rate</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-12 mt-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center">
                <h3 class="text-2xl font-bold mb-4">ModernBlog</h3>
                <p class="text-gray-400 mb-6">Built with Alpine.js and Tailwind CSS</p>
                <div class="flex justify-center space-x-6">
                    <a href="#" class="hover:text-indigo-400 transition">About</a>
                    <a href="#" class="hover:text-indigo-400 transition">Contact</a>
                    <a href="#" class="hover:text-indigo-400 transition">Privacy</a>
                    <a href="#" class="hover:text-indigo-400 transition">Terms</a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>', '', '', 'project_based', true, 1, '{"level": "beginner", "duration": "45 min", "skills": ["Blog", "CMS", "CRUD", "Responsive"]}'),

-- Template 2: Photography Portfolio (Beginner)
('📸 Photography Portfolio mit Lightbox', 'Professionelles Fotografie-Portfolio mit Filter und Lightbox',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Professional photography portfolio with advanced features">
    <title>Photography Portfolio</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        ::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #555;
        }

        /* Image loading animation */
        @keyframes imageLoad {
            from {
                opacity: 0;
                transform: scale(0.8);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .image-load {
            animation: imageLoad 0.5s ease-out;
        }
    </style>
</head>
<body class="bg-black text-white" x-data="{
    // Portfolio state
    currentView: ''gallery'', // gallery, about, contact
    lightboxOpen: false,
    currentImageIndex: 0,
    selectedCategory: ''all'',
    viewMode: ''grid'', // grid, masonry, carousel

    // Gallery data
    photos: [
        {
            id: 1,
            src: ''https://picsum.photos/800/1200?random=1'',
            thumb: ''https://picsum.photos/400/600?random=1'',
            title: ''Mountain Sunrise'',
            category: ''landscape'',
            tags: [''nature'', ''mountains'', ''sunrise''],
            camera: ''Canon EOS R5'',
            lens: ''RF 24-70mm F2.8'',
            settings: ''f/8, 1/125s, ISO 100'',
            location: ''Swiss Alps'',
            date: new Date(''2024-01-15''),
            likes: 234,
            description: ''Captured during an early morning hike in the Swiss Alps. The golden hour light created perfect conditions for this dramatic landscape shot.''
        },
        {
            id: 2,
            src: ''https://picsum.photos/1200/800?random=2'',
            thumb: ''https://picsum.photos/600/400?random=2'',
            title: ''Urban Reflection'',
            category: ''street'',
            tags: [''urban'', ''architecture'', ''reflection''],
            camera: ''Fujifilm X-T4'',
            lens: ''XF 35mm F1.4'',
            settings: ''f/2.8, 1/250s, ISO 400'',
            location: ''Tokyo, Japan'',
            date: new Date(''2024-01-20''),
            likes: 189,
            description: ''Street photography in the heart of Tokyo. The rain created beautiful reflections on the pavement.''
        },
        {
            id: 3,
            src: ''https://picsum.photos/800/800?random=3'',
            thumb: ''https://picsum.photos/400/400?random=3'',
            title: ''Portrait in Natural Light'',
            category: ''portrait'',
            tags: [''portrait'', ''people'', ''natural light''],
            camera: ''Sony A7R IV'',
            lens: ''FE 85mm F1.4 GM'',
            settings: ''f/1.8, 1/500s, ISO 200'',
            location: ''Studio'',
            date: new Date(''2024-01-25''),
            likes: 456,
            description: ''Natural light portrait session using window light as the main light source.''
        },
        {
            id: 4,
            src: ''https://picsum.photos/1200/800?random=4'',
            thumb: ''https://picsum.photos/600/400?random=4'',
            title: ''Wildlife Encounter'',
            category: ''wildlife'',
            tags: [''wildlife'', ''nature'', ''animals''],
            camera: ''Nikon Z9'',
            lens: ''NIKKOR Z 400mm f/2.8'',
            settings: ''f/4, 1/1000s, ISO 800'',
            location: ''Serengeti National Park'',
            date: new Date(''2024-02-01''),
            likes: 567,
            description: ''An incredible wildlife encounter during a safari in Tanzania.''
        },
        {
            id: 5,
            src: ''https://picsum.photos/800/1200?random=5'',
            thumb: ''https://picsum.photos/400/600?random=5'',
            title: ''Abstract Architecture'',
            category: ''architecture'',
            tags: [''architecture'', ''abstract'', ''modern''],
            camera: ''Leica Q2'',
            lens: ''28mm Summilux'',
            settings: ''f/5.6, 1/500s, ISO 200'',
            location: ''Barcelona, Spain'',
            date: new Date(''2024-02-05''),
            likes: 234,
            description: ''Modern architecture captured from an unusual angle to create an abstract composition.''
        },
        {
            id: 6,
            src: ''https://picsum.photos/800/800?random=6'',
            thumb: ''https://picsum.photos/400/400?random=6'',
            title: ''Food Photography'',
            category: ''commercial'',
            tags: [''food'', ''commercial'', ''product''],
            camera: ''Hasselblad X2D'',
            lens: ''XCD 80mm'',
            settings: ''f/11, 1/60s, ISO 100'',
            location: ''Studio'',
            date: new Date(''2024-02-10''),
            likes: 123,
            description: ''Commercial food photography for a high-end restaurant menu.''
        }
    ],

    // Categories
    categories: [
        { id: ''all'', name: ''All'', icon: ''📷'' },
        { id: ''landscape'', name: ''Landscape'', icon: ''🏔️'' },
        { id: ''portrait'', name: ''Portrait'', icon: ''👤'' },
        { id: ''street'', name: ''Street'', icon: ''🏙️'' },
        { id: ''wildlife'', name: ''Wildlife'', icon: ''🦁'' },
        { id: ''architecture'', name: ''Architecture'', icon: ''🏛️'' },
        { id: ''commercial'', name: ''Commercial'', icon: ''💼'' }
    ],

    // Photographer info
    photographer: {
        name: ''Alex Photography'',
        bio: ''Professional photographer specializing in landscape and portrait photography. Available for commercial projects and workshops.'',
        email: ''contact@alexphotography.com'',
        instagram: ''@alexphoto'',
        awards: [
            ''International Photography Awards 2023'',
            ''National Geographic Contributor'',
            ''Sony World Photography Awards Finalist''
        ]
    },

    // Computed properties
    get filteredPhotos() {
        if (this.selectedCategory === ''all'') {
            return this.photos;
        }
        return this.photos.filter(photo => photo.category === this.selectedCategory);
    },

    get currentPhoto() {
        return this.photos[this.currentImageIndex];
    },

    // Methods
    openLightbox(index) {
        this.currentImageIndex = index;
        this.lightboxOpen = true;
        document.body.style.overflow = ''hidden'';
    },

    closeLightbox() {
        this.lightboxOpen = false;
        document.body.style.overflow = ''auto'';
    },

    nextImage() {
        this.currentImageIndex = (this.currentImageIndex + 1) % this.photos.length;
    },

    previousImage() {
        this.currentImageIndex = (this.currentImageIndex - 1 + this.photos.length) % this.photos.length;
    },

    likePhoto(photoId) {
        const photo = this.photos.find(p => p.id === photoId);
        if (photo) {
            photo.likes++;
        }
    },

    formatDate(date) {
        return new Intl.DateTimeFormat(''en-US'', {
            year: ''numeric'',
            month: ''long'',
            day: ''numeric''
        }).format(date);
    },

    // Keyboard navigation
    handleKeydown(e) {
        if (this.lightboxOpen) {
            if (e.key === ''ArrowRight'') this.nextImage();
            if (e.key === ''ArrowLeft'') this.previousImage();
            if (e.key === ''Escape'') this.closeLightbox();
        }
    }
}"
@keydown.window="handleKeydown">
    <!-- Navigation -->
    <nav class="fixed top-0 left-0 right-0 bg-black bg-opacity-90 backdrop-blur-sm z-40 border-b border-gray-800">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center space-x-8">
                    <h1 class="text-2xl font-bold">ALEX PHOTOGRAPHY</h1>

                    <div class="hidden md:flex space-x-6">
                        <button @click="currentView = ''gallery''"
                                :class="currentView === ''gallery'' ? ''text-white'' : ''text-gray-400''"
                                class="hover:text-white transition">
                            Gallery
                        </button>
                        <button @click="currentView = ''about''"
                                :class="currentView === ''about'' ? ''text-white'' : ''text-gray-400''"
                                class="hover:text-white transition">
                            About
                        </button>
                        <button @click="currentView = ''contact''"
                                :class="currentView === ''contact'' ? ''text-white'' : ''text-gray-400''"
                                class="hover:text-white transition">
                            Contact
                        </button>
                    </div>
                </div>

                <!-- View Mode Toggle -->
                <div class="flex items-center space-x-4">
                    <div class="flex bg-gray-800 rounded-lg p-1">
                        <button @click="viewMode = ''grid''"
                                :class="viewMode === ''grid'' ? ''bg-gray-600'' : ''''"
                                class="p-2 rounded transition">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M5 3a2 2 0 00-2 2v2a2 2 0 002 2h2a2 2 0 002-2V5a2 2 0 00-2-2H5zM5 11a2 2 0 00-2 2v2a2 2 0 002 2h2a2 2 0 002-2v-2a2 2 0 00-2-2H5zM11 5a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V5zM13 11a2 2 0 00-2 2v2a2 2 0 002 2h2a2 2 0 002-2v-2a2 2 0 00-2-2h-2z"></path>
                            </svg>
                        </button>
                        <button @click="viewMode = ''masonry''"
                                :class="viewMode === ''masonry'' ? ''bg-gray-600'' : ''''"
                                class="p-2 rounded transition">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M3 4a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 12a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1H4a1 1 0 01-1-1v-4zM11 4a1 1 0 011-1h4a1 1 0 011 1v8a1 1 0 01-1 1h-4a1 1 0 01-1-1V4z"></path>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="pt-16">
        <!-- Gallery View -->
        <div x-show="currentView === ''gallery''" x-transition>
            <!-- Category Filter -->
            <div class="sticky top-16 bg-black bg-opacity-90 backdrop-blur-sm z-30 border-b border-gray-800">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
                    <div class="flex items-center space-x-4 overflow-x-auto">
                        <template x-for="category in categories" :key="category.id">
                            <button @click="selectedCategory = category.id"
                                    :class="selectedCategory === category.id ?
                                           ''bg-white text-black'' :
                                           ''bg-gray-800 text-gray-300 hover:bg-gray-700''"
                                    class="flex items-center space-x-2 px-4 py-2 rounded-full whitespace-nowrap transition">
                                <span x-text="category.icon"></span>
                                <span x-text="category.name"></span>
                            </button>
                        </template>
                    </div>
                </div>
            </div>

            <!-- Gallery Grid -->
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <!-- Grid View -->
                <div x-show="viewMode === ''grid''"
                     class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <template x-for="(photo, index) in filteredPhotos" :key="photo.id">
                        <div @click="openLightbox(index)"
                             class="group cursor-pointer overflow-hidden rounded-lg bg-gray-900">
                            <div class="relative aspect-w-4 aspect-h-3 overflow-hidden">
                                <img :src="photo.thumb"
                                     :alt="photo.title"
                                     class="w-full h-full object-cover group-hover:scale-110 transition duration-500 image-load">

                                <!-- Overlay -->
                                <div class="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent opacity-0 group-hover:opacity-100 transition duration-300">
                                    <div class="absolute bottom-0 left-0 right-0 p-6">
                                        <h3 class="text-xl font-semibold mb-2" x-text="photo.title"></h3>
                                        <div class="flex items-center justify-between">
                                            <span class="text-sm text-gray-300" x-text="photo.category"></span>
                                            <div class="flex items-center space-x-2">
                                                <span class="text-sm">❤️</span>
                                                <span class="text-sm" x-text="photo.likes"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </template>
                </div>

                <!-- Masonry View -->
                <div x-show="viewMode === ''masonry''"
                     class="columns-1 md:columns-2 lg:columns-3 xl:columns-4 gap-6 space-y-6">
                    <template x-for="(photo, index) in filteredPhotos" :key="photo.id">
                        <div @click="openLightbox(index)"
                             class="group cursor-pointer break-inside-avoid">
                            <div class="relative overflow-hidden rounded-lg bg-gray-900">
                                <img :src="photo.thumb"
                                     :alt="photo.title"
                                     class="w-full h-auto group-hover:scale-110 transition duration-500 image-load">

                                <!-- Overlay -->
                                <div class="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent opacity-0 group-hover:opacity-100 transition duration-300">
                                    <div class="absolute bottom-0 left-0 right-0 p-4">
                                        <h3 class="text-lg font-semibold" x-text="photo.title"></h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </template>
                </div>
            </div>
        </div>

        <!-- About View -->
        <div x-show="currentView === ''about''" x-transition>
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
                <div class="text-center mb-12">
                    <h2 class="text-4xl font-bold mb-4">About</h2>
                    <p class="text-xl text-gray-400">Capturing moments that last forever</p>
                </div>

                <div class="grid md:grid-cols-2 gap-12 items-center">
                    <div>
                        <div class="aspect-w-3 aspect-h-4 rounded-lg overflow-hidden">
                            <img src="https://picsum.photos/600/800?random=99"
                                 alt="Photographer"
                                 class="w-full h-full object-cover">
                        </div>
                    </div>

                    <div>
                        <h3 class="text-2xl font-bold mb-4" x-text="photographer.name"></h3>
                        <p class="text-gray-300 mb-6" x-text="photographer.bio"></p>

                        <div class="mb-8">
                            <h4 class="text-lg font-semibold mb-3">Awards & Recognition</h4>
                            <ul class="space-y-2">
                                <template x-for="award in photographer.awards" :key="award">
                                    <li class="flex items-start">
                                        <span class="text-yellow-500 mr-2">🏆</span>
                                        <span class="text-gray-300" x-text="award"></span>
                                    </li>
                                </template>
                            </ul>
                        </div>

                        <div class="flex space-x-4">
                            <a href="#" class="text-gray-400 hover:text-white transition">
                                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                    <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zM5.838 12a6.162 6.162 0 1112.324 0 6.162 6.162 0 01-12.324 0zM12 16a4 4 0 110-8 4 4 0 010 8zm4.965-10.405a1.44 1.44 0 112.881.001 1.44 1.44 0 01-2.881-.001z"/>
                                </svg>
                            </a>
                            <a href="#" class="text-gray-400 hover:text-white transition">
                                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                    <path d="M23 3a10.9 10.9 0 01-3.14 1.53 4.48 4.48 0 00-7.86 3v1A10.66 10.66 0 013 4s-4 9 5 13a11.64 11.64 0 01-7 2c9 5 20 0 20-11.5a4.5 4.5 0 00-.08-.83A7.72 7.72 0 0023 3z"/>
                                </svg>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Contact View -->
        <div x-show="currentView === ''contact''" x-transition>
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
                <div class="text-center mb-12">
                    <h2 class="text-4xl font-bold mb-4">Get in Touch</h2>
                    <p class="text-xl text-gray-400">Let''s create something amazing together</p>
                </div>

                <div class="bg-gray-900 rounded-lg p-8">
                    <form class="space-y-6">
                        <div class="grid md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-medium mb-2">Name</label>
                                <input type="text"
                                       class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-2">Email</label>
                                <input type="email"
                                       class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-2">Project Type</label>
                            <select class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                                <option>Portrait Session</option>
                                <option>Wedding Photography</option>
                                <option>Commercial Project</option>
                                <option>Event Coverage</option>
                                <option>Other</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-2">Message</label>
                            <textarea rows="6"
                                      class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"></textarea>
                        </div>

                        <button type="submit"
                                class="w-full bg-white text-black py-3 rounded-lg font-semibold hover:bg-gray-200 transition">
                            Send Message
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <!-- Lightbox -->
    <div x-show="lightboxOpen"
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="fixed inset-0 bg-black bg-opacity-95 z-50 flex items-center justify-center"
         @click="closeLightbox">

        <!-- Close Button -->
        <button @click="closeLightbox"
                class="absolute top-4 right-4 text-white text-4xl hover:text-gray-300 transition z-50">
            &times;
        </button>

        <!-- Navigation Arrows -->
        <button @click.stop="previousImage"
                class="absolute left-4 top-1/2 transform -translate-y-1/2 text-white text-4xl hover:text-gray-300 transition">
            ‹
        </button>
        <button @click.stop="nextImage"
                class="absolute right-4 top-1/2 transform -translate-y-1/2 text-white text-4xl hover:text-gray-300 transition">
            ›
        </button>

        <!-- Image Container -->
        <div class="max-w-7xl mx-auto px-4 flex items-center justify-center" @click.stop>
            <div class="flex flex-col lg:flex-row items-center gap-8">
                <!-- Main Image -->
                <div class="flex-1 max-h-screen">
                    <img :src="currentPhoto?.src"
                         :alt="currentPhoto?.title"
                         class="max-w-full max-h-[80vh] object-contain">
                </div>

                <!-- Photo Info -->
                <div class="lg:w-96 bg-gray-900 p-6 rounded-lg max-h-[80vh] overflow-y-auto">
                    <h3 class="text-2xl font-bold mb-4" x-text="currentPhoto?.title"></h3>

                    <p class="text-gray-300 mb-6" x-text="currentPhoto?.description"></p>

                    <div class="space-y-4 text-sm">
                        <div class="flex justify-between">
                            <span class="text-gray-400">Camera</span>
                            <span x-text="currentPhoto?.camera"></span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-400">Lens</span>
                            <span x-text="currentPhoto?.lens"></span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-400">Settings</span>
                            <span x-text="currentPhoto?.settings"></span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-400">Location</span>
                            <span x-text="currentPhoto?.location"></span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-400">Date</span>
                            <span x-text="formatDate(currentPhoto?.date)"></span>
                        </div>
                    </div>

                    <div class="mt-6 pt-6 border-t border-gray-700">
                        <div class="flex items-center justify-between">
                            <button @click.stop="likePhoto(currentPhoto.id)"
                                    class="flex items-center space-x-2 text-gray-400 hover:text-red-500 transition">
                                <span class="text-2xl">❤️</span>
                                <span x-text="currentPhoto?.likes"></span>
                            </button>
                            <div class="flex gap-2">
                                <template x-for="tag in currentPhoto?.tags" :key="tag">
                                    <span class="px-3 py-1 bg-gray-800 rounded-full text-xs" x-text="tag"></span>
                                </template>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>', '', '', 'project_based', true, 2, '{"level": "beginner", "duration": "40 min", "skills": ["Portfolio", "Lightbox", "Filter", "Gallery"]}'),

-- Template 3: Mini Shop (Intermediate)
('🛍️ Mini Shop mit Warenkorb', 'E-Commerce Grundlagen mit funktionalem Warenkorb',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Modern e-commerce shop with cart functionality">
    <title>Mini Shop - E-Commerce Basics</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50" x-data="{
    // Shop state
    currentView: ''shop'', // shop, product, cart, checkout
    cartOpen: false,
    searchQuery: '''',
    selectedCategory: ''all'',
    sortBy: ''featured'',

    // Products data
    products: [
        {
            id: 1,
            name: ''Wireless Headphones'',
            price: 89.99,
            originalPrice: 129.99,
            description: ''Premium noise-cancelling wireless headphones with 30-hour battery life.'',
            category: ''electronics'',
            images: [
                ''https://picsum.photos/600/600?random=10'',
                ''https://picsum.photos/600/600?random=11'',
                ''https://picsum.photos/600/600?random=12''
            ],
            inStock: true,
            stockCount: 15,
            rating: 4.5,
            reviews: 234,
            features: [
                ''Active Noise Cancellation'',
                ''30-hour battery life'',
                ''Premium comfort padding'',
                ''Bluetooth 5.0''
            ],
            badge: ''bestseller'',
            colors: [''Black'', ''Silver'', ''Navy''],
            sizes: null
        },
        {
            id: 2,
            name: ''Organic Cotton T-Shirt'',
            price: 24.99,
            originalPrice: null,
            description: ''Sustainable and comfortable organic cotton t-shirt. Perfect for everyday wear.'',
            category: ''clothing'',
            images: [
                ''https://picsum.photos/600/600?random=20'',
                ''https://picsum.photos/600/600?random=21''
            ],
            inStock: true,
            stockCount: 50,
            rating: 4.8,
            reviews: 89,
            features: [
                ''100% Organic Cotton'',
                ''Sustainable production'',
                ''Machine washable'',
                ''Unisex fit''
            ],
            badge: ''eco-friendly'',
            colors: [''White'', ''Black'', ''Gray'', ''Navy''],
            sizes: [''XS'', ''S'', ''M'', ''L'', ''XL'', ''XXL'']
        },
        {
            id: 3,
            name: ''Smart Watch Pro'',
            price: 299.99,
            originalPrice: 399.99,
            description: ''Advanced fitness tracking and smart notifications in a sleek design.'',
            category: ''electronics'',
            images: [
                ''https://picsum.photos/600/600?random=30'',
                ''https://picsum.photos/600/600?random=31''
            ],
            inStock: true,
            stockCount: 8,
            rating: 4.3,
            reviews: 567,
            features: [
                ''Heart rate monitoring'',
                ''GPS tracking'',
                ''Water resistant'',
                ''7-day battery''
            ],
            badge: ''new'',
            colors: [''Black'', ''White'', ''Rose Gold''],
            sizes: [''40mm'', ''44mm'']
        },
        {
            id: 4,
            name: ''Eco Water Bottle'',
            price: 19.99,
            originalPrice: null,
            description: ''Reusable stainless steel water bottle that keeps drinks cold for 24 hours.'',
            category: ''accessories'',
            images: [
                ''https://picsum.photos/600/600?random=40''
            ],
            inStock: true,
            stockCount: 100,
            rating: 4.7,
            reviews: 45,
            features: [
                ''24-hour cold retention'',
                ''BPA-free'',
                ''Leak-proof design'',
                ''1 liter capacity''
            ],
            badge: ''eco-friendly'',
            colors: [''Blue'', ''Green'', ''Pink'', ''Black''],
            sizes: [''500ml'', ''750ml'', ''1L'']
        },
        {
            id: 5,
            name: ''Yoga Mat Premium'',
            price: 49.99,
            originalPrice: 69.99,
            description: ''Extra thick premium yoga mat with excellent grip and cushioning.'',
            category: ''fitness'',
            images: [
                ''https://picsum.photos/600/600?random=50'',
                ''https://picsum.photos/600/600?random=51''
            ],
            inStock: false,
            stockCount: 0,
            rating: 4.9,
            reviews: 178,
            features: [
                ''6mm thickness'',
                ''Non-slip surface'',
                ''Eco-friendly materials'',
                ''Carrying strap included''
            ],
            badge: null,
            colors: [''Purple'', ''Blue'', ''Green''],
            sizes: null
        },
        {
            id: 6,
            name: ''Leather Wallet'',
            price: 39.99,
            originalPrice: null,
            description: ''Genuine leather wallet with RFID protection and multiple card slots.'',
            category: ''accessories'',
            images: [
                ''https://picsum.photos/600/600?random=60''
            ],
            inStock: true,
            stockCount: 25,
            rating: 4.4,
            reviews: 92,
            features: [
                ''Genuine leather'',
                ''RFID protection'',
                ''8 card slots'',
                ''Bill compartment''
            ],
            badge: null,
            colors: [''Brown'', ''Black''],
            sizes: null
        }
    ],

    // Cart
    cart: [],

    // User preferences
    selectedProduct: null,
    selectedColor: {},
    selectedSize: {},

    // Categories
    categories: [
        { id: ''all'', name: ''All Products'', icon: ''📦'' },
        { id: ''electronics'', name: ''Electronics'', icon: ''📱'' },
        { id: ''clothing'', name: ''Clothing'', icon: ''👕'' },
        { id: ''accessories'', name: ''Accessories'', icon: ''👜'' },
        { id: ''fitness'', name: ''Fitness'', icon: ''💪'' }
    ],

    // Computed properties
    get filteredProducts() {
        let filtered = this.products;

        // Category filter
        if (this.selectedCategory !== ''all'') {
            filtered = filtered.filter(p => p.category === this.selectedCategory);
        }

        // Search filter
        if (this.searchQuery) {
            const query = this.searchQuery.toLowerCase();
            filtered = filtered.filter(p =>
                p.name.toLowerCase().includes(query) ||
                p.description.toLowerCase().includes(query)
            );
        }

        // Sort
        switch(this.sortBy) {
            case ''price-low'':
                filtered.sort((a, b) => a.price - b.price);
                break;
            case ''price-high'':
                filtered.sort((a, b) => b.price - a.price);
                break;
            case ''rating'':
                filtered.sort((a, b) => b.rating - a.rating);
                break;
            case ''featured'':
            default:
                // Keep original order
                break;
        }

        return filtered;
    },

    get cartTotal() {
        return this.cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    },

    get cartItemsCount() {
        return this.cart.reduce((sum, item) => sum + item.quantity, 0);
    },

    get savings() {
        return this.cart.reduce((sum, item) => {
            if (item.originalPrice) {
                return sum + ((item.originalPrice - item.price) * item.quantity);
            }
            return sum;
        }, 0);
    },

    // Methods
    viewProduct(product) {
        this.selectedProduct = product;
        this.selectedColor[product.id] = product.colors ? product.colors[0] : null;
        this.selectedSize[product.id] = product.sizes ? product.sizes[0] : null;
        this.currentView = ''product'';
    },

    addToCart(product, quantity = 1) {
        const cartItem = this.cart.find(item =>
            item.id === product.id &&
            item.color === this.selectedColor[product.id] &&
            item.size === this.selectedSize[product.id]
        );

        if (cartItem) {
            cartItem.quantity += quantity;
        } else {
            this.cart.push({
                ...product,
                quantity,
                color: this.selectedColor[product.id],
                size: this.selectedSize[product.id]
            });
        }

        this.showNotification(''Added to cart!'');
    },

    removeFromCart(index) {
        this.cart.splice(index, 1);
    },

    updateQuantity(index, quantity) {
        if (quantity <= 0) {
            this.removeFromCart(index);
        } else {
            this.cart[index].quantity = quantity;
        }
    },

    showNotification(message) {
        // Simple notification (in real app, use proper toast library)
        const notification = document.createElement(''div'');
        notification.className = ''fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50'';
        notification.textContent = message;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 3000);
    },

    formatPrice(price) {
        return new Intl.NumberFormat(''de-DE'', {
            style: ''currency'',
            currency: ''EUR''
        }).format(price);
    }
}">
    <!-- Header -->
    <header class="bg-white shadow-sm sticky top-0 z-40">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center">
                    <h1 class="text-2xl font-bold text-gray-900">MiniShop</h1>
                </div>

                <!-- Search Bar -->
                <div class="flex-1 max-w-lg mx-8">
                    <div class="relative">
                        <input type="text"
                               x-model="searchQuery"
                               placeholder="Search products..."
                               class="w-full px-4 py-2 pl-10 pr-4 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        <svg class="absolute left-3 top-2.5 h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                </div>

                <!-- Cart Button -->
                <button @click="cartOpen = !cartOpen"
                        class="relative p-2 text-gray-600 hover:text-gray-900">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path>
                    </svg>
                    <span x-show="cartItemsCount > 0"
                          class="absolute -top-1 -right-1 bg-blue-600 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center"
                          x-text="cartItemsCount"></span>
                </button>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Shop View -->
        <div x-show="currentView === ''shop''" x-transition>
            <div class="flex gap-8">
                <!-- Sidebar -->
                <aside class="w-64 flex-shrink-0">
                    <!-- Categories -->
                    <div class="bg-white rounded-lg p-6 mb-6">
                        <h3 class="font-semibold text-gray-900 mb-4">Categories</h3>
                        <div class="space-y-2">
                            <template x-for="category in categories" :key="category.id">
                                <button @click="selectedCategory = category.id"
                                        :class="selectedCategory === category.id ?
                                               ''bg-blue-50 text-blue-600'' :
                                               ''text-gray-700 hover:bg-gray-50''"
                                        class="w-full flex items-center gap-2 px-3 py-2 rounded-lg text-left transition">
                                    <span x-text="category.icon"></span>
                                    <span x-text="category.name"></span>
                                </button>
                            </template>
                        </div>
                    </div>

                    <!-- Sort Options -->
                    <div class="bg-white rounded-lg p-6">
                        <h3 class="font-semibold text-gray-900 mb-4">Sort By</h3>
                        <select x-model="sortBy"
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="featured">Featured</option>
                            <option value="price-low">Price: Low to High</option>
                            <option value="price-high">Price: High to Low</option>
                            <option value="rating">Highest Rated</option>
                        </select>
                    </div>
                </aside>

                <!-- Product Grid -->
                <div class="flex-1">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <template x-for="product in filteredProducts" :key="product.id">
                            <div class="bg-white rounded-lg shadow hover:shadow-lg transition">
                                <div class="relative">
                                    <img :src="product.images[0]"
                                         :alt="product.name"
                                         class="w-full h-64 object-cover rounded-t-lg">

                                    <!-- Badge -->
                                    <div x-show="product.badge"
                                         class="absolute top-2 left-2">
                                        <span class="px-3 py-1 text-xs font-semibold rounded-full"
                                              :class="{
                                                  ''bg-red-500 text-white'': product.badge === ''bestseller'',
                                                  ''bg-green-500 text-white'': product.badge === ''eco-friendly'',
                                                  ''bg-blue-500 text-white'': product.badge === ''new''
                                              }"
                                              x-text="product.badge?.toUpperCase()"></span>
                                    </div>

                                    <!-- Out of Stock Overlay -->
                                    <div x-show="!product.inStock"
                                         class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center rounded-t-lg">
                                        <span class="text-white font-semibold">Out of Stock</span>
                                    </div>
                                </div>

                                <div class="p-4">
                                    <h3 class="font-semibold text-gray-900 mb-2" x-text="product.name"></h3>

                                    <!-- Rating -->
                                    <div class="flex items-center gap-2 mb-2">
                                        <div class="flex">
                                            <template x-for="i in 5" :key="i">
                                                <svg class="w-4 h-4"
                                                     :class="i <= Math.floor(product.rating) ? ''text-yellow-400'' : ''text-gray-300''"
                                                     fill="currentColor" viewBox="0 0 20 20">
                                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path>
                                                </svg>
                                            </template>
                                        </div>
                                        <span class="text-sm text-gray-500">(<span x-text="product.reviews"></span>)</span>
                                    </div>

                                    <!-- Price -->
                                    <div class="flex items-center gap-2 mb-4">
                                        <span class="text-xl font-bold text-gray-900" x-text="formatPrice(product.price)"></span>
                                        <span x-show="product.originalPrice"
                                              class="text-sm text-gray-500 line-through"
                                              x-text="formatPrice(product.originalPrice)"></span>
                                    </div>

                                    <!-- Actions -->
                                    <div class="flex gap-2">
                                        <button @click="viewProduct(product)"
                                                class="flex-1 px-4 py-2 bg-gray-100 text-gray-900 rounded-lg hover:bg-gray-200 transition">
                                            View Details
                                        </button>
                                        <button @click="addToCart(product)"
                                                :disabled="!product.inStock"
                                                :class="product.inStock ?
                                                       ''bg-blue-600 text-white hover:bg-blue-700'' :
                                                       ''bg-gray-300 text-gray-500 cursor-not-allowed''"
                                                class="px-4 py-2 rounded-lg transition">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path>
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </div>

                    <!-- Empty State -->
                    <div x-show="filteredProducts.length === 0"
                         class="text-center py-12">
                        <p class="text-gray-500">No products found matching your criteria.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Detail View -->
        <div x-show="currentView === ''product''" x-transition>
            <button @click="currentView = ''shop''"
                    class="mb-4 text-blue-600 hover:text-blue-800 font-medium">
                ← Back to shop
            </button>

            <div class="bg-white rounded-lg shadow-lg p-8" x-show="selectedProduct">
                <div class="grid md:grid-cols-2 gap-8">
                    <!-- Product Images -->
                    <div>
                        <img :src="selectedProduct?.images[0]"
                             :alt="selectedProduct?.name"
                             class="w-full rounded-lg">

                        <!-- Image Thumbnails -->
                        <div class="flex gap-2 mt-4">
                            <template x-for="(image, index) in selectedProduct?.images" :key="index">
                                <img :src="image"
                                     :alt="`${selectedProduct?.name} ${index + 1}`"
                                     class="w-20 h-20 object-cover rounded cursor-pointer hover:opacity-80 transition">
                            </template>
                        </div>
                    </div>

                    <!-- Product Info -->
                    <div>
                        <h1 class="text-3xl font-bold text-gray-900 mb-4" x-text="selectedProduct?.name"></h1>

                        <!-- Rating -->
                        <div class="flex items-center gap-2 mb-4">
                            <div class="flex">
                                <template x-for="i in 5" :key="i">
                                    <svg class="w-5 h-5"
                                         :class="i <= Math.floor(selectedProduct?.rating) ? ''text-yellow-400'' : ''text-gray-300''"
                                         fill="currentColor" viewBox="0 0 20 20">
                                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path>
                                    </svg>
                                </template>
                            </div>
                            <span class="text-gray-600">
                                <span x-text="selectedProduct?.rating"></span>
                                (<span x-text="selectedProduct?.reviews"></span> reviews)
                            </span>
                        </div>

                        <!-- Price -->
                        <div class="mb-6">
                            <div class="flex items-center gap-3">
                                <span class="text-3xl font-bold text-gray-900" x-text="formatPrice(selectedProduct?.price)"></span>
                                <span x-show="selectedProduct?.originalPrice"
                                      class="text-xl text-gray-500 line-through"
                                      x-text="formatPrice(selectedProduct?.originalPrice)"></span>
                            </div>
                            <p x-show="selectedProduct?.originalPrice" class="text-green-600 font-medium">
                                You save <span x-text="formatPrice(selectedProduct?.originalPrice - selectedProduct?.price)"></span>
                            </p>
                        </div>

                        <!-- Description -->
                        <p class="text-gray-600 mb-6" x-text="selectedProduct?.description"></p>

                        <!-- Color Selection -->
                        <div x-show="selectedProduct?.colors" class="mb-6">
                            <h3 class="font-medium text-gray-900 mb-2">Color</h3>
                            <div class="flex gap-2">
                                <template x-for="color in selectedProduct?.colors" :key="color">
                                    <button @click="selectedColor[selectedProduct.id] = color"
                                            :class="selectedColor[selectedProduct.id] === color ?
                                                   ''ring-2 ring-blue-500'' : ''''"
                                            class="px-4 py-2 border border-gray-300 rounded-lg hover:border-gray-400 transition"
                                            x-text="color">
                                    </button>
                                </template>
                            </div>
                        </div>

                        <!-- Size Selection -->
                        <div x-show="selectedProduct?.sizes" class="mb-6">
                            <h3 class="font-medium text-gray-900 mb-2">Size</h3>
                            <div class="flex gap-2">
                                <template x-for="size in selectedProduct?.sizes" :key="size">
                                    <button @click="selectedSize[selectedProduct.id] = size"
                                            :class="selectedSize[selectedProduct.id] === size ?
                                                   ''ring-2 ring-blue-500'' : ''''"
                                            class="px-4 py-2 border border-gray-300 rounded-lg hover:border-gray-400 transition"
                                            x-text="size">
                                    </button>
                                </template>
                            </div>
                        </div>

                        <!-- Stock Status -->
                        <div class="mb-6">
                            <p x-show="selectedProduct?.inStock" class="text-green-600">
                                ✓ In Stock (<span x-text="selectedProduct?.stockCount"></span> available)
                            </p>
                            <p x-show="!selectedProduct?.inStock" class="text-red-600">
                                ✗ Out of Stock
                            </p>
                        </div>

                        <!-- Add to Cart -->
                        <button @click="addToCart(selectedProduct); currentView = ''shop''"
                                :disabled="!selectedProduct?.inStock"
                                :class="selectedProduct?.inStock ?
                                       ''bg-blue-600 text-white hover:bg-blue-700'' :
                                       ''bg-gray-300 text-gray-500 cursor-not-allowed''"
                                class="w-full py-3 rounded-lg font-semibold transition">
                            Add to Cart
                        </button>

                        <!-- Features -->
                        <div class="mt-8 border-t pt-8">
                            <h3 class="font-semibold text-gray-900 mb-4">Key Features</h3>
                            <ul class="space-y-2">
                                <template x-for="feature in selectedProduct?.features" :key="feature">
                                    <li class="flex items-start gap-2">
                                        <svg class="w-5 h-5 text-green-500 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
                                        </svg>
                                        <span x-text="feature"></span>
                                    </li>
                                </template>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cart Sidebar -->
    <div x-show="cartOpen"
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="translate-x-full"
         x-transition:enter-end="translate-x-0"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="translate-x-0"
         x-transition:leave-end="translate-x-full"
         class="fixed right-0 top-0 h-full w-96 bg-white shadow-xl z-50 overflow-y-auto">

        <div class="p-6">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">Shopping Cart</h2>
                <button @click="cartOpen = false"
                        class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>

            <!-- Cart Items -->
            <div x-show="cart.length > 0" class="space-y-4 mb-6">
                <template x-for="(item, index) in cart" :key="index">
                    <div class="flex gap-4 bg-gray-50 p-4 rounded-lg">
                        <img :src="item.images[0]"
                             :alt="item.name"
                             class="w-20 h-20 object-cover rounded">

                        <div class="flex-1">
                            <h4 class="font-semibold" x-text="item.name"></h4>
                            <p class="text-sm text-gray-600">
                                <span x-show="item.color" x-text="item.color"></span>
                                <span x-show="item.color && item.size"> • </span>
                                <span x-show="item.size" x-text="item.size"></span>
                            </p>

                            <div class="flex items-center justify-between mt-2">
                                <div class="flex items-center gap-2">
                                    <button @click="updateQuantity(index, item.quantity - 1)"
                                            class="w-8 h-8 rounded-full bg-gray-200 hover:bg-gray-300 flex items-center justify-center">
                                        -
                                    </button>
                                    <span x-text="item.quantity"></span>
                                    <button @click="updateQuantity(index, item.quantity + 1)"
                                            class="w-8 h-8 rounded-full bg-gray-200 hover:bg-gray-300 flex items-center justify-center">
                                        +
                                    </button>
                                </div>

                                <span class="font-semibold" x-text="formatPrice(item.price * item.quantity)"></span>
                            </div>
                        </div>

                        <button @click="removeFromCart(index)"
                                class="text-gray-400 hover:text-red-600">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                            </svg>
                        </button>
                    </div>
                </template>
            </div>

            <!-- Empty Cart -->
            <div x-show="cart.length === 0" class="text-center py-12">
                <svg class="w-24 h-24 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path>
                </svg>
                <p class="text-gray-500">Your cart is empty</p>
            </div>

            <!-- Cart Summary -->
            <div x-show="cart.length > 0" class="border-t pt-6">
                <div class="space-y-2 mb-4">
                    <div class="flex justify-between">
                        <span>Subtotal</span>
                        <span x-text="formatPrice(cartTotal)"></span>
                    </div>
                    <div x-show="savings > 0" class="flex justify-between text-green-600">
                        <span>You save</span>
                        <span x-text="formatPrice(savings)"></span>
                    </div>
                    <div class="flex justify-between font-semibold text-lg">
                        <span>Total</span>
                        <span x-text="formatPrice(cartTotal)"></span>
                    </div>
                </div>

                <button class="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition font-semibold">
                    Proceed to Checkout
                </button>

                <button @click="cartOpen = false"
                        class="w-full mt-2 text-gray-600 hover:text-gray-800 transition">
                    Continue Shopping
                </button>
            </div>
        </div>
    </div>

    <!-- Cart Overlay -->
    <div x-show="cartOpen"
         @click="cartOpen = false"
         class="fixed inset-0 bg-black bg-opacity-50 z-40"></div>
</body>
</html>', '', '', 'project_based', true, 3, '{"level": "intermediate", "duration": "50 min", "skills": ["E-Commerce", "Cart", "Product Management", "UI/UX"]}'),

-- Template 4: Social Feed (Intermediate)
('💬 Social Feed mit Posts & Likes', 'Interaktive Social Media Platform mit Echtzeit-Features',
'<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Interactive social media feed with real-time features">
    <title>Social Feed - Interactive Platform</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-100" x-data="{
    // User state
    currentUser: {
        id: 1,
        username: ''johndoe'',
        name: ''John Doe'',
        avatar: ''https://ui-avatars.com/api/?name=John+Doe&background=6366f1&color=fff'',
        bio: ''Web developer | Coffee enthusiast | Dog lover 🐕'',
        followers: 542,
        following: 321
    },

    // App state
    currentView: ''feed'', // feed, profile, explore, messages
    showCreatePost: false,
    showStory: false,
    currentStory: null,

    // Posts data
    posts: [
        {
            id: 1,
            author: {
                id: 2,
                username: ''sarahsmith'',
                name: ''Sarah Smith'',
                avatar: ''https://ui-avatars.com/api/?name=Sarah+Smith'',
                verified: true
            },
            content: ''Just launched my new portfolio website! 🚀 Check it out and let me know what you think. #webdev #design'',
            image: ''https://picsum.photos/600/400?random=1'',
            timestamp: new Date(Date.now() - 3600000),
            likes: 124,
            comments: [
                {
                    id: 1,
                    author: ''mikejones'',
                    content: ''Looks amazing! Great work! 🔥'',
                    timestamp: new Date(Date.now() - 1800000)
                },
                {
                    id: 2,
                    author: ''alexchen'',
                    content: ''The animations are so smooth!'',
                    timestamp: new Date(Date.now() - 900000)
                }
            ],
            bookmarked: false,
            liked: false,
            shares: 23
        },
        {
            id: 2,
            author: {
                id: 3,
                username: ''techguru'',
                name: ''Tech Guru'',
                avatar: ''https://ui-avatars.com/api/?name=Tech+Guru'',
                verified: false
            },
            content: ''10 JavaScript tips that will blow your mind! 🤯\\n\\n1. Use destructuring for cleaner code\\n2. Master the spread operator\\n3. Understand closures\\n\\nThread below 👇'',
            image: null,
            timestamp: new Date(Date.now() - 7200000),
            likes: 456,
            comments: [],
            bookmarked: true,
            liked: true,
            shares: 89
        }
    ],

    // Stories
    stories: [
        {
            id: 1,
            author: {
                username: ''alexchen'',
                avatar: ''https://ui-avatars.com/api/?name=Alex+Chen''
            },
            items: [
                {
                    type: ''image'',
                    url: ''https://picsum.photos/400/600?random=10'',
                    duration: 5000
                }
            ],
            viewed: false
        },
        {
            id: 2,
            author: {
                username: ''designqueen'',
                avatar: ''https://ui-avatars.com/api/?name=Design+Queen''
            },
            items: [
                {
                    type: ''image'',
                    url: ''https://picsum.photos/400/600?random=11'',
                    duration: 5000
                }
            ],
            viewed: false
        }
    ],

    // Trending topics
    trending: [
        { tag: ''#webdev'', posts: 1234 },
        { tag: ''#javascript'', posts: 892 },
        { tag: ''#design'', posts: 756 },
        { tag: ''#coding'', posts: 654 },
        { tag: ''#tech'', posts: 543 }
    ],

    // Suggested users
    suggestedUsers: [
        {
            id: 4,
            username: ''creativecoder'',
            name: ''Creative Coder'',
            avatar: ''https://ui-avatars.com/api/?name=Creative+Coder'',
            followers: 1234
        },
        {
            id: 5,
            username: ''uxmaster'',
            name: ''UX Master'',
            avatar: ''https://ui-avatars.com/api/?name=UX+Master'',
            followers: 2341
        }
    ],

    // New post draft
    newPost: {
        content: '''',
        image: null
    },

    // Methods
    createPost() {
        if (this.newPost.content.trim()) {
            this.posts.unshift({
                id: Date.now(),
                author: this.currentUser,
                content: this.newPost.content,
                image: this.newPost.image,
                timestamp: new Date(),
                likes: 0,
                comments: [],
                bookmarked: false,
                liked: false,
                shares: 0
            });

            this.newPost = { content: '''', image: null };
            this.showCreatePost = false;
        }
    },

    likePost(postId) {
        const post = this.posts.find(p => p.id === postId);
        if (post) {
            post.liked = !post.liked;
            post.likes += post.liked ? 1 : -1;
        }
    },

    bookmarkPost(postId) {
        const post = this.posts.find(p => p.id === postId);
        if (post) {
            post.bookmarked = !post.bookmarked;
        }
    },

    addComment(postId, comment) {
        const post = this.posts.find(p => p.id === postId);
        if (post && comment.trim()) {
            post.comments.push({
                id: Date.now(),
                author: this.currentUser.username,
                content: comment,
                timestamp: new Date()
            });
        }
    },

    viewStory(story) {
        this.currentStory = story;
        this.showStory = true;
        story.viewed = true;

        // Auto close after duration
        setTimeout(() => {
            this.showStory = false;
            this.currentStory = null;
        }, story.items[0].duration);
    },

    formatTimestamp(date) {
        const now = new Date();
        const diff = now - date;
        const minutes = Math.floor(diff / 60000);
        const hours = Math.floor(diff / 3600000);
        const days = Math.floor(diff / 86400000);

        if (minutes < 1) return ''just now'';
        if (minutes < 60) return `${minutes}m ago`;
        if (hours < 24) return `${hours}h ago`;
        if (days < 7) return `${days}d ago`;

        return date.toLocaleDateString();
    }
}">
    <!-- Header -->
    <header class="bg-white shadow-sm sticky top-0 z-40">
        <div class="max-w-6xl mx-auto px-4">
            <div class="flex justify-between items-center h-16">
                <h1 class="text-2xl font-bold text-indigo-600">SocialFeed</h1>

                <!-- Navigation -->
                <nav class="hidden md:flex items-center space-x-8">
                    <button @click="currentView = ''feed''"
                            :class="currentView === ''feed'' ? ''text-indigo-600'' : ''text-gray-700''"
                            class="hover:text-indigo-600 transition">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                        </svg>
                    </button>
                    <button @click="currentView = ''explore''"
                            :class="currentView === ''explore'' ? ''text-indigo-600'' : ''text-gray-700''"
                            class="hover:text-indigo-600 transition">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </button>
                    <button @click="currentView = ''messages''"
                            :class="currentView === ''messages'' ? ''text-indigo-600'' : ''text-gray-700''"
                            class="hover:text-indigo-600 transition relative">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
                        </svg>
                        <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">3</span>
                    </button>
                    <button @click="currentView = ''profile''"
                            :class="currentView === ''profile'' ? ''text-indigo-600'' : ''text-gray-700''"
                            class="hover:text-indigo-600 transition">
                        <img :src="currentUser.avatar" :alt="currentUser.name"
                             class="w-8 h-8 rounded-full">
                    </button>
                </nav>

                <!-- Create Post Button -->
                <button @click="showCreatePost = true"
                        class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 transition">
                    + Create
                </button>
            </div>
        </div>
    </header>

    <!-- Main Layout -->
    <div class="max-w-6xl mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Main Feed -->
            <div class="lg:col-span-2">
                <!-- Stories -->
                <div x-show="currentView === ''feed''" class="bg-white rounded-lg p-4 mb-6">
                    <div class="flex space-x-4 overflow-x-auto">
                        <!-- Add Story -->
                        <button class="flex-shrink-0">
                            <div class="relative">
                                <div class="w-16 h-16 rounded-full bg-gray-200 flex items-center justify-center">
                                    <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                                    </svg>
                                </div>
                                <span class="absolute bottom-0 right-0 bg-indigo-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs">+</span>
                            </div>
                            <p class="text-xs mt-1">Your Story</p>
                        </button>

                        <!-- Stories -->
                        <template x-for="story in stories" :key="story.id">
                            <button @click="viewStory(story)" class="flex-shrink-0">
                                <div class="relative">
                                    <div class="w-16 h-16 rounded-full p-0.5"
                                         :class="story.viewed ? ''bg-gray-300'' : ''bg-gradient-to-r from-indigo-500 to-purple-500''">
                                        <img :src="story.author.avatar" :alt="story.author.username"
                                             class="w-full h-full rounded-full border-2 border-white">
                                    </div>
                                </div>
                                <p class="text-xs mt-1 truncate w-16" x-text="story.author.username"></p>
                            </button>
                        </template>
                    </div>
                </div>

                <!-- Posts Feed -->
                <div x-show="currentView === ''feed''" class="space-y-6">
                    <template x-for="post in posts" :key="post.id">
                        <article class="bg-white rounded-lg shadow">
                            <!-- Post Header -->
                            <div class="p-4 flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <img :src="post.author.avatar" :alt="post.author.name"
                                         class="w-10 h-10 rounded-full">
                                    <div>
                                        <div class="flex items-center space-x-1">
                                            <h3 class="font-semibold" x-text="post.author.name"></h3>
                                            <svg x-show="post.author.verified" class="w-4 h-4 text-blue-500" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                                            </svg>
                                        </div>
                                        <p class="text-sm text-gray-500">
                                            @<span x-text="post.author.username"></span> ·
                                            <span x-text="formatTimestamp(post.timestamp)"></span>
                                        </p>
                                    </div>
                                </div>

                                <button class="text-gray-400 hover:text-gray-600">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path>
                                    </svg>
                                </button>
                            </div>

                            <!-- Post Content -->
                            <div class="px-4 pb-3">
                                <p class="text-gray-800 whitespace-pre-wrap" x-text="post.content"></p>
                            </div>

                            <!-- Post Image -->
                            <div x-show="post.image">
                                <img :src="post.image" :alt="''Post by '' + post.author.name"
                                     class="w-full">
                            </div>

                            <!-- Post Actions -->
                            <div class="p-4 border-t">
                                <div class="flex items-center justify-between mb-3">
                                    <div class="flex space-x-4">
                                        <button @click="likePost(post.id)"
                                                class="flex items-center space-x-2 hover:text-red-600 transition"
                                                :class="post.liked ? ''text-red-600'' : ''text-gray-500''">
                                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"></path>
                                            </svg>
                                            <span x-text="post.likes"></span>
                                        </button>

                                        <button class="flex items-center space-x-2 text-gray-500 hover:text-indigo-600 transition">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
                                            </svg>
                                            <span x-text="post.comments.length"></span>
                                        </button>

                                        <button class="flex items-center space-x-2 text-gray-500 hover:text-green-600 transition">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m9.032 4.026a9.001 9.001 0 01-7.432 0m9.032-4.026A9.001 9.001 0 0112 3c-2.432 0-4.641.97-6.284 2.542m9.032 4.026A8.962 8.962 0 0118 12a9 9 0 01-9 9 8.962 8.962 0 01-3.716-.784M3.716 18.216A9.001 9.001 0 013 12c0-1.876.575-3.619 1.558-5.064"></path>
                                            </svg>
                                            <span x-text="post.shares"></span>
                                        </button>
                                    </div>

                                    <button @click="bookmarkPost(post.id)"
                                            class="hover:text-indigo-600 transition"
                                            :class="post.bookmarked ? ''text-indigo-600'' : ''text-gray-500''">
                                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                            <path d="M5 4a2 2 0 012-2h6a2 2 0 012 2v14l-5-2.5L5 18V4z"></path>
                                        </svg>
                                    </button>
                                </div>

                                <!-- Comments -->
                                <div x-show="post.comments.length > 0" class="space-y-2 mb-3">
                                    <template x-for="comment in post.comments.slice(0, 2)" :key="comment.id">
                                        <div class="text-sm">
                                            <span class="font-semibold" x-text="comment.author"></span>
                                            <span class="text-gray-700" x-text="'' '' + comment.content"></span>
                                        </div>
                                    </template>
                                    <button x-show="post.comments.length > 2"
                                            class="text-sm text-gray-500 hover:text-gray-700">
                                        View all <span x-text="post.comments.length"></span> comments
                                    </button>
                                </div>

                                <!-- Add Comment -->
                                <div class="flex items-center space-x-2">
                                    <img :src="currentUser.avatar" :alt="currentUser.name"
                                         class="w-8 h-8 rounded-full">
                                    <input type="text"
                                           placeholder="Add a comment..."
                                           @keyup.enter="addComment(post.id, $event.target.value); $event.target.value = ''''"
                                           class="flex-1 px-3 py-1 border border-gray-300 rounded-full text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                </div>
                            </div>
                        </article>
                    </template>
                </div>

                <!-- Profile View -->
                <div x-show="currentView === ''profile''" x-transition>
                    <div class="bg-white rounded-lg shadow p-6 mb-6">
                        <div class="flex items-center space-x-4 mb-6">
                            <img :src="currentUser.avatar" :alt="currentUser.name"
                                 class="w-24 h-24 rounded-full">
                            <div class="flex-1">
                                <h2 class="text-2xl font-bold" x-text="currentUser.name"></h2>
                                <p class="text-gray-500">@<span x-text="currentUser.username"></span></p>
                                <p class="text-gray-700 mt-2" x-text="currentUser.bio"></p>
                            </div>
                            <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition">
                                Edit Profile
                            </button>
                        </div>

                        <div class="flex justify-around text-center">
                            <div>
                                <p class="text-2xl font-bold" x-text="posts.filter(p => p.author.id === currentUser.id).length"></p>
                                <p class="text-gray-500">Posts</p>
                            </div>
                            <div>
                                <p class="text-2xl font-bold" x-text="currentUser.followers"></p>
                                <p class="text-gray-500">Followers</p>
                            </div>
                            <div>
                                <p class="text-2xl font-bold" x-text="currentUser.following"></p>
                                <p class="text-gray-500">Following</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <aside class="lg:col-span-1">
                <!-- Trending -->
                <div class="bg-white rounded-lg shadow p-6 mb-6">
                    <h3 class="text-lg font-bold mb-4">Trending</h3>
                    <div class="space-y-3">
                        <template x-for="topic in trending" :key="topic.tag">
                            <button class="block w-full text-left hover:bg-gray-50 p-2 rounded transition">
                                <p class="font-semibold text-indigo-600" x-text="topic.tag"></p>
                                <p class="text-sm text-gray-500">
                                    <span x-text="topic.posts.toLocaleString()"></span> posts
                                </p>
                            </button>
                        </template>
                    </div>
                </div>

                <!-- Suggested Users -->
                <div class="bg-white rounded-lg shadow p-6">
                    <h3 class="text-lg font-bold mb-4">Who to follow</h3>
                    <div class="space-y-4">
                        <template x-for="user in suggestedUsers" :key="user.id">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <img :src="user.avatar" :alt="user.name"
                                         class="w-10 h-10 rounded-full">
                                    <div>
                                        <p class="font-semibold" x-text="user.name"></p>
                                        <p class="text-sm text-gray-500">
                                            <span x-text="user.followers.toLocaleString()"></span> followers
                                        </p>
                                    </div>
                                </div>
                                <button class="px-3 py-1 border border-indigo-600 text-indigo-600 rounded-full hover:bg-indigo-50 transition text-sm">
                                    Follow
                                </button>
                            </div>
                        </template>
                    </div>
                </div>
            </aside>
        </div>
    </div>

    <!-- Create Post Modal -->
    <div x-show="showCreatePost"
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"
         @click.self="showCreatePost = false">

        <div class="bg-white rounded-lg shadow-xl max-w-lg w-full"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0 transform scale-90"
             x-transition:enter-end="opacity-100 transform scale-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100 transform scale-100"
             x-transition:leave-end="opacity-0 transform scale-90">

            <div class="p-6">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-xl font-bold">Create Post</h2>
                    <button @click="showCreatePost = false"
                            class="text-gray-400 hover:text-gray-600">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>
                </div>

                <div class="flex items-start space-x-3">
                    <img :src="currentUser.avatar" :alt="currentUser.name"
                         class="w-10 h-10 rounded-full">
                    <div class="flex-1">
                        <textarea x-model="newPost.content"
                                  placeholder="What''s on your mind?"
                                  rows="4"
                                  class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent resize-none"></textarea>

                        <div class="flex items-center justify-between mt-4">
                            <div class="flex items-center space-x-4">
                                <button class="text-gray-500 hover:text-indigo-600 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                    </svg>
                                </button>
                                <button class="text-gray-500 hover:text-indigo-600 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 4v16M17 4v16M3 8h4m10 0h4M3 16h4m10 0h4"></path>
                                    </svg>
                                </button>
                                <button class="text-gray-500 hover:text-indigo-600 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                    </svg>
                                </button>
                            </div>

                            <button @click="createPost"
                                    :disabled="!newPost.content.trim()"
                                    :class="newPost.content.trim() ?
                                           ''bg-indigo-600 text-white hover:bg-indigo-700'' :
                                           ''bg-gray-300 text-gray-500 cursor-not-allowed''"
                                    class="px-6 py-2 rounded-lg font-medium transition">
                                Post
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Story Viewer -->
    <div x-show="showStory"
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="fixed inset-0 bg-black z-50 flex items-center justify-center"
         @click="showStory = false">

        <div class="relative w-full max-w-md h-full max-h-[600px]">
            <img :src="currentStory?.items[0].url"
                 class="w-full h-full object-contain">

            <!-- Story Header -->
            <div class="absolute top-0 left-0 right-0 p-4 bg-gradient-to-b from-black to-transparent">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-3">
                        <img :src="currentStory?.author.avatar"
                             :alt="currentStory?.author.username"
                             class="w-10 h-10 rounded-full">
                        <p class="text-white font-medium" x-text="currentStory?.author.username"></p>
                    </div>
                    <button @click="showStory = false"
                            class="text-white text-2xl">
                        &times;
                    </button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>', '', '', 'project_based', true, 4, '{"level": "intermediate", "duration": "60 min", "skills": ["Social Media", "Real-time", "Posts", "Interactions"]}');

-- End of Migration