// SkillSpace Workshop Application
const MAX_IMAGES_PER_USER = 50;

function workshopApp() {
    return {
        // User & Session
        user: {
            id: null,
            username: '',
            role: 'student',
            displayName: ''
        },

        // WebSocket
        ws: null,
        connected: false,
        reconnectAttempts: 0,
        maxReconnectAttempts: 5,

        // UI State
        activePanel: 'chat',
        activeCodeTab: 'html',
        showSettings: false,
        showHelp: false,
        showGallery: false,
        showAchievement: false,
        showAllActions: false,
        showCreateProject: false,
        previewDevice: 'desktop',

        // Chat State
        messages: [],
        currentMessage: '',
        isAiThinking: false,
        followUpSuggestions: [],

        // Code State
        code: {
            html: '<div class="container mx-auto px-4 py-8">\n    <h1 class="text-4xl font-bold text-center text-gray-800 mb-4">Willkommen auf meiner Website!</h1>\n    <p class="text-lg text-center text-gray-600">Hier kannst du deine eigene Website gestalten.</p>\n</div>',
            css: '/* Dein eigenes CSS hier */',
            js: '// Dein JavaScript Code hier'
        },
        codeErrors: {
            html: null,
            css: null,
            js: null
        },
        lastSaved: 'Noch nicht gespeichert',
        autoSaveTimer: null,

        // Cost Tracking
        totalCost: 0,
        maxCost: 0,
        costPercentage: 0,

        // Settings
        settings: {
            theme: 'light',
            autoSave: true,
            fontSize: 14
        },

        // Achievements
        currentAchievement: {},
        unlockedAchievements: [],

        // Projects
        projects: [],
        currentProject: {},
        projectTemplates: [],
        newProject: {
            name: '',
            template_id: 0,
            is_public: false
        },

        // Images
        images: [],
        showImageLibrary: false,
        imageUploadProgress: 0,
        isUploading: false,
        dragOver: false,

        // Quick Actions with improved prompts
        quickActions: [
            { icon: '🌈', title: 'Farbverlauf', prompt: 'Füge einen schönen Farbverlauf als Hintergrund hinzu - nutze moderne Gradient-Effekte mit Tailwind' },
            { icon: '✨', title: 'Animationen', prompt: 'Füge coole Hover-Animationen zu allen Buttons und Links hinzu' },
            { icon: '📱', title: 'Responsive', prompt: 'Mache die Website responsive für mobile Geräte mit Tailwind' },
            { icon: '🌙', title: 'Dark Mode', prompt: 'Füge einen Dark Mode Toggle hinzu mit Alpine.js' }
        ],

        quickActionCategories: [
            {
                name: 'Stil & Design',
                actions: [
                    { icon: '🌈', title: 'Farbverlauf', prompt: 'Füge einen schönen Farbverlauf als Hintergrund hinzu - nutze moderne Gradient-Effekte mit Tailwind' },
                    { icon: '🌟', title: 'Glassmorphism', prompt: 'Mache die Container glasartig mit Blur-Effekt und semi-transparenten Hintergründen' },
                    { icon: '🌙', title: 'Dark Mode', prompt: 'Füge einen Dark Mode Toggle hinzu mit Alpine.js, der zwischen hellem und dunklem Design wechselt' },
                    { icon: '🎨', title: 'Farbschema', prompt: 'Erstelle ein professionelles Farbschema mit Tailwind - nutze komplementäre Farben' }
                ]
            },
            {
                name: 'Animationen & Effekte',
                actions: [
                    { icon: '✨', title: 'Hover-Effekte', prompt: 'Füge coole Hover-Animationen zu allen Buttons und Links hinzu' },
                    { icon: '🎭', title: 'Fade-In', prompt: 'Lass Elemente beim Scrollen sanft einblenden mit Alpine.js Intersection Observer' },
                    { icon: '🎪', title: 'Konfetti', prompt: 'Füge einen Konfetti-Effekt hinzu, der bei Klick auf einen Button ausgelöst wird' },
                    { icon: '💫', title: 'Parallax', prompt: 'Erstelle einen Parallax-Scrolling Effekt für Hintergrundbilder' }
                ]
            },
            {
                name: 'Komponenten',
                actions: [
                    { icon: '📝', title: 'Kontaktformular', prompt: 'Erstelle ein schönes Kontaktformular mit Validierung (nur Frontend)' },
                    { icon: '🖼️', title: 'Bildergalerie', prompt: 'Baue eine interaktive Bildergalerie mit Lightbox-Effekt' },
                    { icon: '📊', title: 'Statistiken', prompt: 'Füge animierte Statistik-Karten mit Zahlen und Prozentbalken hinzu' },
                    { icon: '💬', title: 'Testimonials', prompt: 'Erstelle einen Testimonials-Bereich mit Kundenbewertungen' }
                ]
            },
            {
                name: 'Interaktivität',
                actions: [
                    { icon: '🎮', title: 'Mini-Spiel', prompt: 'Füge ein einfaches Click-Counter Spiel hinzu mit Highscore' },
                    { icon: '⏱️', title: 'Countdown', prompt: 'Erstelle einen animierten Countdown-Timer mit Alpine.js' },
                    { icon: '📋', title: 'To-Do Liste', prompt: 'Baue eine interaktive To-Do Liste mit Alpine.js' },
                    { icon: '🎵', title: 'Sound-Effekte', prompt: 'Füge Sound-Effekte bei Interaktionen hinzu' }
                ]
            }
        ],

        // Computed Properties
        get connectionStatus() {
            return this.connected ? '🟢 Verbunden' : '🔴 Getrennt';
        },

        get costIndicatorClass() {
            if (this.costPercentage < 50) return 'bg-gradient-to-r from-green-400 to-green-500';
            if (this.costPercentage < 80) return 'bg-gradient-to-r from-yellow-400 to-orange-500';
            return 'bg-gradient-to-r from-red-400 to-red-500';
        },

        get costTextClass() {
            if (this.costPercentage < 50) return 'text-green-600';
            if (this.costPercentage < 80) return 'text-orange-600';
            return 'text-red-600';
        },

        get lineNumbers() {
            const lines = this.code[this.activeCodeTab].split('\n').length;
            return Array.from({ length: lines }, (_, i) => i + 1);
        },

        get previewContainerClass() {
            const baseClass = 'bg-white rounded-lg shadow-2xl overflow-hidden transition-all';
            switch (this.previewDevice) {
                case 'mobile':
                    return `${baseClass} w-[375px] h-[667px]`;
                case 'tablet':
                    return `${baseClass} w-[768px] h-[1024px]`;
                default:
                    return `${baseClass} w-full h-full`;
            }
        },

        get previewContent() {
            return `
                <!DOCTYPE html>
                <html lang="de">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Meine Website - SkillSpace</title>
                    <script src="https://cdn.tailwindcss.com"><\/script>
                    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"><\/script>
                    <style>${this.code.css}</style>
                </head>
                <body>
                    ${this.code.html}
                    <script>${this.codeErrors.js ? '// JavaScript hat Fehler und wurde deaktiviert' : this.code.js}<\/script>
                </body>
                </html>
            `;
        },

        // Initialization
        async init() {
            try {
                await this.loadUserInfo();
                await this.loadSavedState();
                await this.initWebSocket();
                // Images will be loaded after WebSocket connection confirms project data
                this.startAutoSave();

                // Set up global keyboard shortcuts
                this.setupKeyboardShortcuts();

            } catch (error) {
                console.error('Initialization error:', error);
                this.showNotification('Fehler beim Laden. Bitte lade die Seite neu.', 'error');
            }
        },

        async loadUserInfo() {
            const response = await fetch('/api/workshop/stats');
            if (!response.ok) {
                throw new Error('Not authenticated');
            }

            const data = await response.json();
            this.user = {
                id: data.user_id,
                username: data.username,
                role: data.role,
                displayName: data.username
            };
            this.totalCost = data.total_cost;
            this.costPercentage = data.cost_percentage;
            this.maxCost = data.cost_limit;
        },

        async loadSavedState() {
            // Load from localStorage
            const savedSettings = localStorage.getItem('workshopSettings');
            if (savedSettings) {
                this.settings = { ...this.settings, ...JSON.parse(savedSettings) };
            }

            const savedAchievements = localStorage.getItem('unlockedAchievements');
            if (savedAchievements) {
                this.unlockedAchievements = JSON.parse(savedAchievements);
            }

            // Load project templates
            await this.loadProjectTemplates();
        },

        async loadProjectTemplates() {
            try {
                const response = await fetch('/api/templates');
                if (response.ok) {
                    this.projectTemplates = await response.json();
                }
            } catch (error) {
                console.error('Failed to load templates:', error);
            }
        },

        // Project Management Methods
        openCreateProjectModal() {
            // First project should be public by default
            const isFirstProject = this.projects.length === 0;
            
            this.newProject = {
                name: '',
                template_id: 0,
                is_public: isFirstProject
            };
            this.showCreateProject = true;
        },

        async createProject() {
            if (!this.newProject.name.trim()) return;

            try {
                const response = await fetch('/api/websites', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        name: this.newProject.name,
                        template_id: this.newProject.template_id,
                        is_public: this.newProject.is_public
                    })
                });

                if (response.ok) {
                    const project = await response.json();
                    this.projects.unshift(project);
                    this.switchProject(project.id);
                    this.showCreateProject = false;
                    this.showNotification('Projekt erfolgreich erstellt!', 'success');
                } else {
                    throw new Error('Failed to create project');
                }
            } catch (error) {
                console.error('Create project error:', error);
                this.showNotification('Fehler beim Erstellen des Projekts', 'error');
            }
        },

        switchProject(projectId) {
            if (this.ws && this.ws.readyState === WebSocket.OPEN) {
                this.ws.send(JSON.stringify({
                    type: 'switch_project',
                    project_id: projectId
                }));
            }
        },

        toggleProjectPublic(projectId) {
            if (this.ws && this.ws.readyState === WebSocket.OPEN) {
                this.ws.send(JSON.stringify({
                    type: 'toggle_project_public',
                    project_id: projectId
                }));
            }
        },

        formatTimeAgo(dateString) {
            const date = new Date(dateString);
            const now = new Date();
            const diffMs = now - date;
            const diffMins = Math.floor(diffMs / 60000);
            const diffHours = Math.floor(diffMs / 3600000);
            const diffDays = Math.floor(diffMs / 86400000);

            if (diffMins < 1) return 'gerade eben';
            if (diffMins < 60) return `vor ${diffMins}m`;
            if (diffHours < 24) return `vor ${diffHours}h`;
            if (diffDays < 7) return `vor ${diffDays}d`;
            return date.toLocaleDateString('de-DE');
        },


        // WebSocket Management
        async initWebSocket() {
            const sessionResponse = await fetch('/api/workshop/session');
            if (!sessionResponse.ok) {
                throw new Error('Failed to get session');
            }

            const { session_token } = await sessionResponse.json();
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const wsUrl = `${protocol}//${window.location.host}/ws/${session_token}`;

            this.ws = new WebSocket(wsUrl);

            this.ws.onopen = () => {
                this.connected = true;
                this.reconnectAttempts = 0;
                console.log('WebSocket connected');
            };

            this.ws.onmessage = (event) => {
                const message = JSON.parse(event.data);
                this.handleWebSocketMessage(message);
            };

            this.ws.onclose = () => {
                this.connected = false;
                this.attemptReconnect();
            };

            this.ws.onerror = (error) => {
                console.error('WebSocket error:', error);
            };

            // Heartbeat
            setInterval(() => {
                if (this.connected && this.ws.readyState === WebSocket.OPEN) {
                    this.ws.send(JSON.stringify({ type: 'ping' }));
                }
            }, 30000);
        },

        attemptReconnect() {
            if (this.reconnectAttempts < this.maxReconnectAttempts) {
                this.reconnectAttempts++;
                setTimeout(() => this.initWebSocket(), 1000 * Math.pow(2, this.reconnectAttempts));
            }
        },

        handleWebSocketMessage(message) {
            switch (message.type) {
                case 'pong':
                    break;

                case 'connection_status':
                    if (message.status === 'connected') {
                        this.projects = message.projects || [];
                        this.currentProject = this.projects.find(p => p.is_active) || {};
                        // Now that we have project data, load images for the active project
                        this.loadImages();
                    }
                    break;

                case 'chat_message':
                    this.addMessage(message.role, message.content);
                    this.isAiThinking = false;

                    // Handle follow-up suggestions
                    if (message.follow_up_suggestions) {
                        this.followUpSuggestions = message.follow_up_suggestions;
                    }
                    break;

                case 'code_update':
                    // Only update if this is a sync message (from server) or if code differs
                    if (message.sync || message.project_id === this.currentProject.id) {
                        console.log('Syncing code from server...');
                        this.code = message.code;
                        this.refreshPreview();
                        this.lastSaved = this.formatTime(new Date());
                    }
                    break;

                case 'project_switched':
                    const switchedProject = this.projects.find(p => p.id === message.project_id);
                    if (switchedProject) {
                        // Update active status
                        this.projects.forEach(p => p.is_active = false);
                        switchedProject.is_active = true;
                        this.currentProject = switchedProject;
                        
                        // Update code
                        this.code = message.code;
                        this.refreshPreview();
                        this.lastSaved = this.formatTime(new Date());
                        
                        // Reload images for the new project
                        this.loadImages();
                        
                        this.showNotification(`Zu Projekt "${message.project_name}" gewechselt`, 'success');
                    }
                    break;

                case 'project_created':
                    this.projects.unshift(message.project);
                    // Update active status
                    this.projects.forEach(p => p.is_active = false);
                    message.project.is_active = true;
                    this.currentProject = message.project;
                    
                    // Update code
                    this.code = message.code;
                    this.refreshPreview();
                    this.lastSaved = this.formatTime(new Date());
                    
                    // Reload images for the new project
                    this.loadImages();
                    break;

                case 'project_visibility_updated':
                    const updatedProject = this.projects.find(p => p.id === message.project_id);
                    if (updatedProject) {
                        updatedProject.is_public = message.is_public;
                        if (this.currentProject.id === message.project_id) {
                            this.currentProject.is_public = message.is_public;
                        }
                    }
                    this.showNotification(message.message, 'success');
                    break;

                case 'cost_update':
                    this.totalCost = message.totalCost;
                    this.costPercentage = message.costPercentage;
                    break;

                case 'error':
                    this.addMessage('system', `❌ Fehler: ${message.message}`);
                    this.isAiThinking = false;
                    break;

                case 'save_confirmation':
                    this.lastSaved = this.formatTime(new Date(message.timestamp));
                    if (window.DEBUG_AUTOSAVE) {
                        console.log('Save confirmed by server:', message.message);
                    }
                    break;

                case 'gallery_batch_update':
                    this.processGalleryUpdates(message.updates);
                    break;

                case 'image_uploaded':
                    // Handle image upload notification
                    this.images.unshift(message.image);
                    this.showNotification('Bild erfolgreich hochgeladen!', 'success');
                    break;

                case 'image_deleted':
                    // Handle image deletion notification
                    this.images = this.images.filter(img => img.id !== message.image_id);
                    this.showNotification('Bild gelöscht', 'success');
                    break;
            }
        },

        sendWebSocketMessage(data) {
            if (this.connected && this.ws.readyState === WebSocket.OPEN) {
                this.ws.send(JSON.stringify(data));
            }
        },

        // Chat Functions
        async sendMessage() {
            if (!this.currentMessage.trim() || this.isAiThinking) return;

            const message = this.currentMessage.trim();
            this.addMessage('user', message);
            this.currentMessage = '';
            this.isAiThinking = true;
            this.followUpSuggestions = [];

            this.sendWebSocketMessage({
                type: 'ai_request',
                prompt: message,
                currentCode: this.code,
                project_id: this.currentProject.id
            });

            // Check for achievements
            this.checkAchievements('message_sent');
        },

        sendQuickAction(action) {
            this.currentMessage = action.prompt;
            this.sendMessage();
        },

        addMessage(role, content) {
            this.messages.push({
                id: Date.now() + Math.random(),
                role,
                content,
                timestamp: new Date()
            });

            // Limit to last 20 messages
            if (this.messages.length > 20) {
                this.messages = this.messages.slice(-20);
            }

            // Auto scroll to bottom
            this.scrollChatToBottom();
        },

        scrollChatToBottom() {
            this.$nextTick(() => {
                if (this.$refs.chatContainer) {
                    // Use setTimeout to ensure DOM is fully updated
                    setTimeout(() => {
                        this.$refs.chatContainer.scrollTop = this.$refs.chatContainer.scrollHeight;
                    }, 50);
                }
            });
        },

        // Code Management
        handleCodeChange() {
            // Clear previous error
            this.codeErrors[this.activeCodeTab] = null;

            // Validate if it's JavaScript
            if (this.activeCodeTab === 'js') {
                this.validateJavaScript();
            }

            // Always auto-save code changes via WebSocket
            this.scheduleSave();

            // Refresh preview
            this.refreshPreview();
        },

        validateJavaScript() {
            try {
                if (this.code.js.trim()) {
                    new Function(this.code.js);
                }
                this.codeErrors.js = null;
            } catch (error) {
                this.codeErrors.js = error.message;
            }
        },

        validateCode() {
            // Validate all code
            this.validateJavaScript();

            // Show success if no errors
            if (!Object.values(this.codeErrors).some(e => e)) {
                this.showNotification('✅ Code ist fehlerfrei!', 'success');
            }
        },

        formatCode() {
            // Simple formatting (in production, use a proper formatter)
            if (this.activeCodeTab === 'html') {
                // Basic HTML formatting
                this.code.html = this.code.html
                    .replace(/></g, '>\n<')
                    .replace(/(\n\s*)+/g, '\n');
            } else if (this.activeCodeTab === 'css') {
                // Basic CSS formatting
                this.code.css = this.code.css
                    .replace(/;/g, ';\n')
                    .replace(/\{/g, ' {\n')
                    .replace(/\}/g, '\n}\n')
                    .replace(/(\n\s*)+/g, '\n');
            }

            this.refreshPreview();
            this.showNotification('✨ Code formatiert!', 'success');
        },

        syncLineNumbers(event) {
            const lineNumbersEl = event.target.previousElementSibling;
            if (lineNumbersEl) {
                lineNumbersEl.scrollTop = event.target.scrollTop;
            }
        },

        // Save & Load
        scheduleSave() {
            clearTimeout(this.autoSaveTimer);
            this.autoSaveTimer = setTimeout(() => {
                this.saveCode();
            }, 1500); // Reduced delay for more responsive auto-save
        },

        saveCode() {
            console.log('Saving code via WebSocket...');
            this.sendWebSocketMessage({
                type: 'code_update',
                code: this.code,
                project_id: this.currentProject.id
            });
            this.lastSaved = this.formatTime(new Date());
            
            // Optional: Show brief save indicator
            if (window.DEBUG_AUTOSAVE) {
                console.log('Code saved at:', this.lastSaved);
            }
        },

        startAutoSave() {
            // Fallback auto-save every 30 seconds if there are unsaved changes
            setInterval(() => {
                if (this.hasUnsavedChanges()) {
                    console.log('Fallback auto-save triggered');
                    this.saveCode();
                }
            }, 30000); // Every 30 seconds
        },

        hasUnsavedChanges() {
            // Check if code has changed since last save
            // This is a simplified check - in production you'd compare actual content hashes
            return this.lastSaved === 'Noch nicht gespeichert';
        },

        // Preview Management
        refreshPreview() {
            if (this.$refs.previewFrame) {
                this.$refs.previewFrame.srcdoc = this.previewContent;
            }
        },

        // Download & Reset
        downloadWebsite() {
            const blob = new Blob([this.previewContent], { type: 'text/html' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `meine-website-${Date.now()}.html`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);

            this.checkAchievements('download');
            this.showNotification('✅ Website heruntergeladen!', 'success');
        },

        async rollbackWebsite() {
            if (!confirm('Möchtest du zur vorherigen Version zurückkehren?')) return;

            try {
                // First get user's websites to find the active one
                const websitesResponse = await fetch('/api/websites');
                if (!websitesResponse.ok) {
                    throw new Error('Websites konnten nicht geladen werden');
                }
                
                const websites = await websitesResponse.json();
                const activeWebsite = websites.find(w => w.is_active);
                
                if (!activeWebsite) {
                    throw new Error('Keine aktive Website gefunden');
                }

                // Now perform rollback with the correct website ID
                const response = await fetch(`/api/websites/${activeWebsite.id}/rollback`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ steps: 1 })
                });

                if (!response.ok) {
                    const error = await response.json();
                    throw new Error(error.message || 'Rollback fehlgeschlagen');
                }

                const result = await response.json();
                
                // Update local code state - get the updated website
                const updatedWebsiteResponse = await fetch(`/api/websites/${activeWebsite.id}`);
                if (updatedWebsiteResponse.ok) {
                    const updatedWebsite = await updatedWebsiteResponse.json();
                    this.code = {
                        html: updatedWebsite.html,
                        css: updatedWebsite.css,
                        js: updatedWebsite.js
                    };
                }

                this.refreshPreview();
                this.lastSaved = this.formatTime(new Date(result.rollback_to));
                
                this.showNotification(`↶ Zurückgesetzt auf Version vom ${this.formatTime(new Date(result.rollback_to))}`, 'success');
                
                // Add system message to chat
                this.addMessage('system', `✅ Website wurde zur vorherigen Version zurückgesetzt (${this.formatTime(new Date(result.rollback_to))})`);

            } catch (error) {
                console.error('Rollback error:', error);
                this.showNotification(`❌ Rollback fehlgeschlagen: ${error.message}`, 'error');
            }
        },

        resetWebsite() {
            if (!confirm('Wirklich alles löschen und neu anfangen?')) return;

            this.code = {
                html: '<div class="container mx-auto px-4 py-8">\n    <h1 class="text-4xl font-bold text-center text-gray-800 mb-4">Willkommen auf meiner Website!</h1>\n    <p class="text-lg text-center text-gray-600">Hier kannst du deine eigene Website gestalten.</p>\n</div>',
                css: '/* Dein eigenes CSS hier */',
                js: '// Dein JavaScript Code hier'
            };

            this.messages = [];
            this.followUpSuggestions = [];
            this.refreshPreview();
            this.saveCode();

            this.showNotification('🚀 Neustart erfolgreich!', 'info');
        },

        // Achievements
        checkAchievements(action) {
            const achievements = {
                first_message: {
                    condition: () => this.messages.filter(m => m.role === 'user').length === 1,
                    data: { icon: '🎉', title: 'Erste Nachricht!', description: 'Du hast deine erste Anfrage gestellt!' }
                },
                ten_messages: {
                    condition: () => this.messages.filter(m => m.role === 'user').length === 10,
                    data: { icon: '⚡', title: 'KI-Profi!', description: '10 Anfragen gemeistert!' }
                },
                first_download: {
                    condition: () => action === 'download' && !this.unlockedAchievements.includes('first_download'),
                    data: { icon: '💾', title: 'Website gesichert!', description: 'Erste Website heruntergeladen!' }
                },
                dark_mode: {
                    condition: () => this.code.html.includes('dark:') || this.code.css.includes('dark'),
                    data: { icon: '🌙', title: 'Nachtmodus!', description: 'Dark Mode aktiviert!' }
                }
            };

            for (const [key, achievement] of Object.entries(achievements)) {
                if (achievement.condition() && !this.unlockedAchievements.includes(key)) {
                    this.unlockAchievement(key, achievement.data);
                }
            }
        },

        unlockAchievement(key, data) {
            this.unlockedAchievements.push(key);
            localStorage.setItem('unlockedAchievements', JSON.stringify(this.unlockedAchievements));

            this.currentAchievement = data;
            this.showAchievement = true;

            setTimeout(() => {
                this.showAchievement = false;
            }, 5000);
        },

        // Keyboard Shortcuts
        setupKeyboardShortcuts() {
            // Handled by Alpine @keydown.window
        },

        handleGlobalKeydown(event) {
            // Ctrl/Cmd + Enter: Send message
            if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
                if (this.activePanel === 'chat' && this.currentMessage.trim()) {
                    event.preventDefault();
                    this.sendMessage();
                }
            }

            // Ctrl/Cmd + K: Toggle code editor
            if ((event.ctrlKey || event.metaKey) && event.key === 'k') {
                event.preventDefault();
                this.activePanel = this.activePanel === 'chat' ? 'code' : 'chat';
            }

            // Ctrl/Cmd + S: Save
            if ((event.ctrlKey || event.metaKey) && event.key === 's') {
                event.preventDefault();
                this.saveCode();
                this.showNotification('💾 Gespeichert!', 'success');
            }
        },

        handleInputKeydown(event) {
            // Arrow up for last message
            if (event.key === 'ArrowUp' && this.currentMessage === '') {
                const lastUserMessage = this.messages
                    .filter(m => m.role === 'user')
                    .pop();
                if (lastUserMessage) {
                    this.currentMessage = lastUserMessage.content;
                    event.preventDefault();
                }
            }
        },

        // Utility Functions
        formatTime(date) {
            return new Intl.DateTimeFormat('de-DE', {
                hour: '2-digit',
                minute: '2-digit'
            }).format(date);
        },

        showNotification(message, type = 'info') {
            // Simple notification system
            const notification = {
                info: { icon: 'ℹ️', title: 'Info' },
                success: { icon: '✅', title: 'Erfolg' },
                error: { icon: '❌', title: 'Fehler' }
            }[type];

            this.currentAchievement = {
                ...notification,
                description: message
            };
            this.showAchievement = true;

            setTimeout(() => {
                this.showAchievement = false;
            }, 3000);
        },

        processGalleryUpdates(updates) {
            // Process gallery updates received via WebSocket
            if (!updates || typeof updates !== 'object') return;

            // Store gallery updates for when gallery is shown
            this.galleryUpdates = this.galleryUpdates || {};
            
            Object.entries(updates).forEach(([userId, preview]) => {
                this.galleryUpdates[userId] = {
                    ...preview,
                    timestamp: new Date().toISOString()
                };
            });

            // Dispatch custom event for gallery component if it exists
            if (window.galleryApp && typeof window.galleryApp.processUpdates === 'function') {
                window.galleryApp.processUpdates(updates);
            }

            console.log('Gallery updates processed:', Object.keys(updates).length, 'projects');
        },

        async logout() {
            if (confirm('Möchtest du dich wirklich abmelden?')) {
                await fetch('/api/logout', { method: 'POST' });
                window.location.href = '/';
            }
        },

        // Image Functions
        async loadImages() {
            try {
                // Skip loading if no current project is available
                if (!this.currentProject || !this.currentProject.id) {
                    console.log('No active project, skipping image loading');
                    this.images = [];
                    return;
                }
                
                const response = await fetch(`/api/images/?website_id=${this.currentProject.id}`);
                if (response.ok) {
                    const data = await response.json();
                    this.images = data.images || [];
                    console.log('Loaded images for project', this.currentProject.id, ':', this.images.length);
                } else {
                    console.error('Failed to load images:', response.statusText);
                    this.images = [];
                }
            } catch (error) {
                console.error('Error loading images:', error);
                this.images = [];
            }
        },

        async uploadImage(file) {
            if (!this.currentProject.id) {
                this.showNotification('Bitte wähle zuerst ein Projekt aus', 'error');
                return;
            }

            const formData = new FormData();
            formData.append('file', file);
            formData.append('website_id', this.currentProject.id);
            formData.append('alt_text', `Uploaded image: ${file.name}`);

            this.isUploading = true;
            this.imageUploadProgress = 0;

            try {
                const response = await fetch('/api/images/upload', {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    const data = await response.json();
                    this.showNotification('Bild erfolgreich hochgeladen!', 'success');
                    
                    // Add to images list
                    this.images.unshift(data.image);
                    
                    // Ask AI about image placement
                    this.currentMessage = `Ich habe ein Bild hochgeladen: ${file.name}. Wo und wie soll ich es auf meiner Website verwenden?`;
                    this.sendMessage();
                } else {
                    const error = await response.json();
                    this.showNotification(error.detail || 'Fehler beim Hochladen', 'error');
                }
            } catch (error) {
                console.error('Upload error:', error);
                this.showNotification('Fehler beim Hochladen des Bildes', 'error');
            } finally {
                this.isUploading = false;
                this.imageUploadProgress = 0;
            }
        },

        handleImageDrop(event) {
            event.preventDefault();
            this.dragOver = false;

            const files = Array.from(event.dataTransfer.files);
            const imageFiles = files.filter(file => file.type.startsWith('image/'));

            if (imageFiles.length === 0) {
                this.showNotification('Bitte nur Bilddateien hochladen', 'error');
                return;
            }

            // Upload first image (or could loop for multiple)
            if (imageFiles[0]) {
                this.uploadImage(imageFiles[0]);
            }
        },

        handleImageSelect(event) {
            const file = event.target.files[0];
            if (file) {
                this.uploadImage(file);
            }
            // Reset input
            event.target.value = '';
        },

        insertImageIntoCode(image) {
            const imageUrl = `/api/images/public/${image.id}/data`;
            const imageHtml = `<img src="${imageUrl}" alt="${image.alt_text || image.original_name}" class="w-full h-auto rounded-lg shadow-lg">`;
            
            // Insert at current cursor position or append to HTML
            const currentHtml = this.code.html;
            this.code.html = currentHtml + '\n' + imageHtml;
            
            // Save the updated code to the server
            this.saveCode();
            
            this.showNotification('Bild in Code eingefügt!', 'success');
            this.showImageLibrary = false;
        },

        async deleteImage(imageId) {
            if (!confirm('Bild wirklich löschen?')) return;

            try {
                const response = await fetch(`/api/images/${imageId}`, {
                    method: 'DELETE'
                });

                if (response.ok) {
                    this.images = this.images.filter(img => img.id !== imageId);
                    this.showNotification('Bild gelöscht', 'success');
                } else {
                    this.showNotification('Fehler beim Löschen', 'error');
                }
            } catch (error) {
                console.error('Delete error:', error);
                this.showNotification('Fehler beim Löschen des Bildes', 'error');
            }
        },

        renderMarkdown(text) {
            if (!text || typeof marked === 'undefined') {
                return text || '';
            }
            
            try {
                // Configure marked options for better rendering
                marked.setOptions({
                    breaks: true, // Support line breaks
                    gfm: true, // GitHub flavored markdown
                    sanitize: false, // We trust the AI content
                    smartLists: true,
                    smartypants: true
                });
                
                return marked.parse(text);
            } catch (error) {
                console.warn('Markdown rendering error:', error);
                // Fallback to plain text with basic formatting
                return text.replace(/\n/g, '<br>');
            }
        },

        formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }
    };
}

// Make function globally available
window.workshopApp = workshopApp;