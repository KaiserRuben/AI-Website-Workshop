-- Migration: Interactive Learning Templates
-- Category: gamified
-- Purpose: Interactive learning experiences for kids with AI assistance

INSERT INTO templates (name, description, html, css, js, category, is_active, order_index, template_metadata) VALUES

-- Template 1: Mein erstes buntes Web
('01 - Mein erstes buntes Web', 'Lerne HTML und CSS Grundlagen - Mache das Web bunt! 🎨',
$$<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mein erstes buntes Web</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f0f0f0;
        }

        .lernbereich {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
        }

        .aufgabe {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 5px solid #2196f3;
        }

        .erfolg {
            background: #c8e6c9;
            padding: 15px;
            border-radius: 10px;
            margin: 10px 0;
            display: none;
        }

        .hilfe-button {
            background: #ff9800;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            margin: 10px 0;
        }

        .hilfe-button:hover {
            background: #f57c00;
            transform: scale(1.05);
        }

        /* Zu ändernde Elemente */
        #mein-titel {
            color: black; /* Aufgabe: Mache mich rot! */
        }

        #mein-text {
            color: black; /* Aufgabe: Mache mich blau! */
        }

        #meine-box {
            background-color: white; /* Aufgabe: Gib mir eine gelbe Hintergrundfarbe! */
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }

        .stern {
            font-size: 30px;
            color: #ddd;
            transition: color 0.3s;
        }

        .stern.aktiv {
            color: #ffd700;
        }
    </style>
</head>
<body>
    <div class="lernbereich">
        <h1>🎨 Willkommen beim bunten Web!</h1>

        <div class="fortschritt">
            <p>Dein Fortschritt:</p>
            <span class="stern" id="stern1">⭐</span>
            <span class="stern" id="stern2">⭐</span>
            <span class="stern" id="stern3">⭐</span>
        </div>

        <p>Hallo! Ich bin deine erste Webseite. Lass uns gemeinsam lernen, wie man mich bunt macht!</p>

        <div class="aufgabe">
            <h3>🎯 Aufgabe 1: Mache die Überschrift rot!</h3>
            <p>Siehst du die schwarze Überschrift unten? Die soll rot werden!</p>
            <button class="hilfe-button" onclick="zeigeHilfe1()">
                💡 Ich brauche Hilfe!
            </button>
            <p class="hilfe" id="hilfe1" style="display:none;">
                <strong>Tipp:</strong> Frage die KI: "Wie kann ich die Überschrift mit der ID 'mein-titel' rot machen?"<br>
                Die KI wird dir zeigen, wie du CSS verwendest! 🎨
            </p>
        </div>

        <h2 id="mein-titel">Ich bin eine langweilige schwarze Überschrift</h2>

        <div class="erfolg" id="erfolg1">
            🎉 Super! Du hast die Überschrift rot gemacht! Stern 1 verdient! ⭐
        </div>

        <div class="aufgabe">
            <h3>🎯 Aufgabe 2: Mache den Text blau!</h3>
            <p>Jetzt machen wir den Text unter mir blau!</p>
            <button class="hilfe-button" onclick="zeigeHilfe2()">
                💡 Ich brauche Hilfe!
            </button>
            <p class="hilfe" id="hilfe2" style="display:none;">
                <strong>Tipp:</strong> Frage die KI: "Wie ändere ich die Farbe vom Element mit der ID 'mein-text' zu blau?"<br>
                CSS kann viele Farben! Probiere auch mal 'darkblue' oder '#0000FF'! 🔵
            </p>
        </div>

        <p id="mein-text">Ich bin ein Text, der gerne blau wäre!</p>

        <div class="erfolg" id="erfolg2">
            🎉 Fantastisch! Der Text ist jetzt blau! Stern 2 verdient! ⭐⭐
        </div>

        <div class="aufgabe">
            <h3>🎯 Aufgabe 3: Gib der Box einen gelben Hintergrund!</h3>
            <p>Die Box unten braucht eine schöne gelbe Hintergrundfarbe!</p>
            <button class="hilfe-button" onclick="zeigeHilfe3()">
                💡 Ich brauche Hilfe!
            </button>
            <p class="hilfe" id="hilfe3" style="display:none;">
                <strong>Tipp:</strong> Frage die KI: "Wie gebe ich der Box mit der ID 'meine-box' einen gelben Hintergrund?"<br>
                Für Hintergründe benutzt man 'background-color'! 🟨
            </p>
        </div>

        <div id="meine-box">
            <h3>📦 Ich bin eine Box!</h3>
            <p>Gib mir eine schöne gelbe Hintergrundfarbe!</p>
        </div>

        <div class="erfolg" id="erfolg3">
            🎉 Wow! Du hast alle Aufgaben geschafft! Alle Sterne verdient! ⭐⭐⭐<br>
            <strong>Du hast gelernt:</strong>
            <ul>
                <li>Wie man Farben mit CSS ändert</li>
                <li>Was IDs sind (#mein-titel)</li>
                <li>Den Unterschied zwischen color und background-color</li>
            </ul>
            <p>Bereit für das nächste Level? 🚀</p>
        </div>

        <div style="margin-top: 40px; padding: 20px; background: #f5f5f5; border-radius: 10px;">
            <h3>🧪 Experimentier-Ecke</h3>
            <p>Probiere mal diese Farben aus:</p>
            <ul>
                <li><code>red</code>, <code>blue</code>, <code>green</code>, <code>yellow</code></li>
                <li><code>purple</code>, <code>orange</code>, <code>pink</code></li>
                <li>Hex-Farben: <code>#FF0000</code> (rot), <code>#00FF00</code> (grün)</li>
                <li>RGB: <code>rgb(255, 0, 0)</code> (rot)</li>
            </ul>
        </div>
    </div>

    <script>
        // Hilfe-Funktionen
        function zeigeHilfe1() {
            document.getElementById('hilfe1').style.display = 'block';
        }

        function zeigeHilfe2() {
            document.getElementById('hilfe2').style.display = 'block';
        }

        function zeigeHilfe3() {
            document.getElementById('hilfe3').style.display = 'block';
        }

        // Überprüfe Fortschritt
        function checkeFortschritt() {
            const titel = document.getElementById('mein-titel');
            const text = document.getElementById('mein-text');
            const box = document.getElementById('meine-box');

            // Check Aufgabe 1
            if (getComputedStyle(titel).color === 'rgb(255, 0, 0)' ||
                getComputedStyle(titel).color.includes('red')) {
                document.getElementById('erfolg1').style.display = 'block';
                document.getElementById('stern1').classList.add('aktiv');
            }

            // Check Aufgabe 2
            if (getComputedStyle(text).color === 'rgb(0, 0, 255)' ||
                getComputedStyle(text).color.includes('blue')) {
                document.getElementById('erfolg2').style.display = 'block';
                document.getElementById('stern2').classList.add('aktiv');
            }

            // Check Aufgabe 3
            if (getComputedStyle(box).backgroundColor === 'rgb(255, 255, 0)' ||
                getComputedStyle(box).backgroundColor.includes('yellow')) {
                document.getElementById('erfolg3').style.display = 'block';
                document.getElementById('stern3').classList.add('aktiv');
            }
        }

        // Überwache Änderungen
        setInterval(checkeFortschritt, 500);
    </script>
</body>
</html>$$, '', '', 'gamified', true, 1, '{"level": 1, "duration": "15-20 min", "skills": ["HTML Basics", "CSS Colors", "IDs"], "age": "8-12"}'),

-- Template 2: Button-Fabrik
('02 - Button-Fabrik', 'Erstelle coole Buttons mit CSS - Klick dich durchs Web! 🎯',
$$<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Button-Fabrik</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .fabrik {
            background: white;
            padding: 40px;
            border-radius: 20px;
            max-width: 900px;
            margin: 0 auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .maschine {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 15px;
            margin: 20px 0;
            border: 3px dashed #dee2e6;
        }

        .button-vorlage {
            display: inline-block;
            margin: 10px;
            transition: all 0.3s ease;
        }

        /* Buttons zum Bearbeiten */
        #button1 {
            background-color: gray;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            /* Aufgabe: Mache mich rund! */
        }

        #button2 {
            background-color: blue;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            /* Aufgabe: Gib mir einen Hover-Effekt! */
        }

        #button3 {
            background-color: white;
            color: black;
            padding: 10px 20px;
            border: 1px solid black;
            cursor: pointer;
            /* Aufgabe: Mache mich größer und bunter! */
        }

        .aufgaben-karte {
            background: #e8f5e9;
            padding: 20px;
            border-radius: 15px;
            margin: 15px 0;
            border-left: 5px solid #4caf50;
        }

        .erfolg-nachricht {
            background: #fff3cd;
            padding: 15px;
            border-radius: 10px;
            margin: 10px 0;
            display: none;
            animation: einblenden 0.5s ease;
        }

        @keyframes einblenden {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .punkte-anzeige {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            padding: 15px 25px;
            border-radius: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            font-size: 20px;
            font-weight: bold;
        }

        .hilfe-bereich {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 10px;
            margin: 10px 0;
            display: none;
        }

        .code-beispiel {
            background: #263238;
            color: #aed581;
            padding: 15px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            margin: 10px 0;
        }

        .werkzeugkasten {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
        }

        .werkzeug {
            display: inline-block;
            background: white;
            padding: 10px 15px;
            margin: 5px;
            border-radius: 20px;
            border: 2px solid #e0e0e0;
            cursor: pointer;
        }

        .werkzeug:hover {
            border-color: #4caf50;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="punkte-anzeige">
        <span id="punkte">0</span> 🏆 Punkte
    </div>

    <div class="fabrik">
        <h1>🏭 Willkommen in der Button-Fabrik!</h1>
        <p>Hier lernst du, wie man die coolsten Buttons des Internets baut! Jeder Button braucht deine Hilfe!</p>

        <div class="aufgaben-karte">
            <h3>🎯 Level 1: Der Runde Button</h3>
            <p>Unser erster Button ist noch sehr eckig. Kannst du ihn rund machen?</p>
            <button class="hilfe-button" onclick="zeigeHilfe('hilfe1')">
                💡 Zeig mir einen Tipp!
            </button>
            <div class="hilfe-bereich" id="hilfe1">
                <p><strong>Tipp:</strong> Frage die KI: "Wie mache ich Button1 mit border-radius rund?"</p>
                <div class="code-beispiel">
                    border-radius macht Ecken rund!<br>
                    Probiere: border-radius: 25px;
                </div>
            </div>
        </div>

        <div class="maschine">
            <h3>Button-Maschine 1</h3>
            <button id="button1" class="button-vorlage">Mach mich rund!</button>
            <div class="erfolg-nachricht" id="erfolg1">
                🎉 Super! Du hast deinen ersten runden Button erstellt! +100 Punkte!
            </div>
        </div>

        <div class="aufgaben-karte">
            <h3>🎯 Level 2: Der Hover-Button</h3>
            <p>Dieser Button soll sich verändern, wenn man mit der Maus drüber fährt!</p>
            <button class="hilfe-button" onclick="zeigeHilfe('hilfe2')">
                💡 Zeig mir einen Tipp!
            </button>
            <div class="hilfe-bereich" id="hilfe2">
                <p><strong>Tipp:</strong> Frage die KI: "Wie füge ich einen Hover-Effekt zu Button2 hinzu?"</p>
                <div class="code-beispiel">
                    #button2:hover {<br>
                    &nbsp;&nbsp;/* Hier kommt dein Hover-Style! */<br>
                    }
                </div>
                <p>Ideen: Ändere die Farbe, mache ihn größer, oder füge einen Schatten hinzu!</p>
            </div>
        </div>

        <div class="maschine">
            <h3>Button-Maschine 2</h3>
            <button id="button2" class="button-vorlage">Hover über mich!</button>
            <div class="erfolg-nachricht" id="erfolg2">
                🎉 Wow! Dein Button hat jetzt einen coolen Hover-Effekt! +150 Punkte!
            </div>
        </div>

        <div class="aufgaben-karte">
            <h3>🎯 Level 3: Der Mega-Button</h3>
            <p>Zeit für einen richtig coolen Button! Mache ihn größer, bunter und gib ihm einen Schatten!</p>
            <button class="hilfe-button" onclick="zeigeHilfe('hilfe3')">
                💡 Zeig mir einen Tipp!
            </button>
            <div class="hilfe-bereich" id="hilfe3">
                <p><strong>Tipp:</strong> Frage die KI nach diesen CSS-Eigenschaften:</p>
                <ul>
                    <li><code>padding</code> - für die Größe</li>
                    <li><code>background</code> - für coole Farben oder Verläufe</li>
                    <li><code>box-shadow</code> - für den Schatten</li>
                    <li><code>font-size</code> - für größeren Text</li>
                </ul>
            </div>
        </div>

        <div class="maschine">
            <h3>Button-Maschine 3</h3>
            <button id="button3" class="button-vorlage">Mach mich MEGA!</button>
            <div class="erfolg-nachricht" id="erfolg3">
                🎉 MEGA! Das ist der coolste Button ever! +200 Punkte!
                <br><br>
                <strong>Du hast gelernt:</strong>
                <ul>
                    <li>✅ border-radius für runde Ecken</li>
                    <li>✅ :hover für Maus-Effekte</li>
                    <li>✅ padding für Größe</li>
                    <li>✅ box-shadow für Schatten</li>
                </ul>
            </div>
        </div>

        <div class="werkzeugkasten">
            <h3>🧰 Dein CSS-Werkzeugkasten</h3>
            <p>Klicke auf ein Werkzeug, um mehr zu erfahren:</p>
            <span class="werkzeug" onclick="erklaereWerkzeug('padding')">📏 padding</span>
            <span class="werkzeug" onclick="erklaereWerkzeug('border-radius')">⭕ border-radius</span>
            <span class="werkzeug" onclick="erklaereWerkzeug('background')">🎨 background</span>
            <span class="werkzeug" onclick="erklaereWerkzeug('box-shadow')">🌑 box-shadow</span>
            <span class="werkzeug" onclick="erklaereWerkzeug('transform')">🔄 transform</span>
            <span class="werkzeug" onclick="erklaereWerkzeug('transition')">⏱️ transition</span>
        </div>

        <div class="maschine" style="background: #fff3cd;">
            <h3>🎪 Bonus-Spielplatz</h3>
            <p>Erstelle deinen eigenen Button! Frage die KI nach coolen Ideen!</p>
            <button id="mein-button" style="padding: 15px 30px; font-size: 18px;">
                Dein Button!
            </button>
        </div>
    </div>

    <script>
        let punkte = 0;
        let level1Fertig = false;
        let level2Fertig = false;
        let level3Fertig = false;

        function zeigeHilfe(hilfeId) {
            const hilfe = document.getElementById(hilfeId);
            hilfe.style.display = hilfe.style.display === 'none' ? 'block' : 'none';
        }

        function erklaereWerkzeug(werkzeug) {
            const erklaerungen = {
                'padding': 'padding macht den Button innen größer. Probiere: padding: 20px 40px;',
                'border-radius': 'border-radius macht Ecken rund. 50% macht einen Kreis!',
                'background': 'background kann eine Farbe oder ein Verlauf sein. Probiere: background: linear-gradient(45deg, #ff6b6b, #4ecdc4);',
                'box-shadow': 'box-shadow macht einen Schatten. Probiere: box-shadow: 0 4px 15px rgba(0,0,0,0.2);',
                'transform': 'transform kann Dinge drehen oder größer machen. Probiere: transform: scale(1.1);',
                'transition': 'transition macht Änderungen smooth. Probiere: transition: all 0.3s ease;'
            };

            alert('🛠️ ' + werkzeug + '\n\n' + erklaerungen[werkzeug]);
        }

        function aktualisiertePunkte(neuePunkte) {
            punkte += neuePunkte;
            document.getElementById('punkte').textContent = punkte;
        }

        function pruefeButton1() {
            const button = document.getElementById('button1');
            const style = getComputedStyle(button);

            if (!level1Fertig && style.borderRadius !== '0px') {
                document.getElementById('erfolg1').style.display = 'block';
                aktualisiertePunkte(100);
                level1Fertig = true;
            }
        }

        function pruefeButton2() {
            // Dies wird durch CSS :hover geprüft - zeige Erfolg nach erster Interaktion
            if (!level2Fertig) {
                const button = document.getElementById('button2');
                button.addEventListener('mouseenter', function() {
                    if (!level2Fertig) {
                        setTimeout(() => {
                            document.getElementById('erfolg2').style.display = 'block';
                            aktualisiertePunkte(150);
                            level2Fertig = true;
                        }, 500);
                    }
                });
            }
        }

        function pruefeButton3() {
            const button = document.getElementById('button3');
            const style = getComputedStyle(button);

            // Prüfe ob der Button verändert wurde
            if (!level3Fertig &&
                (style.padding !== '10px 20px' ||
                 style.backgroundColor !== 'rgb(255, 255, 255)' ||
                 style.boxShadow !== 'none')) {
                document.getElementById('erfolg3').style.display = 'block';
                aktualisiertePunkte(200);
                level3Fertig = true;
            }
        }

        // Überwache Änderungen
        setInterval(() => {
            pruefeButton1();
            pruefeButton3();
        }, 500);

        // Initialisiere Button 2 Hover-Check
        pruefeButton2();

        // Easter Egg für fleißige Schüler
        document.getElementById('mein-button').addEventListener('click', function() {
            this.textContent = 'Super! 🎉';
            this.style.background = 'linear-gradient(45deg, #ff6b6b, #4ecdc4)';
            this.style.color = 'white';
            this.style.transform = 'rotate(360deg)';
            this.style.transition = 'all 0.5s ease';
        });
    </script>
</body>
</html>$$, '', '', 'gamified', true, 2, '{"level": 2, "duration": "20-25 min", "skills": ["CSS Styling", "Hover Effects", "Button Design"], "age": "8-12"}'),

-- Template 3: Box-Baumeister
('03 - Box-Baumeister', 'Verstehe das Box-Modell und baue coole Layouts! 📦',
$$<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Box-Baumeister</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f4f8;
            margin: 0;
            padding: 20px;
        }

        .baustelle {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .bauplan {
            background: #e8eaf6;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            position: relative;
        }

        .box-visualizer {
            background: #fff;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
            border: 2px dashed #9e9e9e;
        }

        /* Level 1: Padding verstehen */
        #box1 {
            background-color: #ffeb3b;
            border: 2px solid #333;
            /* Aufgabe: Gib mir padding! */
        }

        #box1-inhalt {
            background-color: #fff3e0;
        }

        /* Level 2: Margin meistern */
        #box2 {
            background-color: #4caf50;
            padding: 20px;
            /* Aufgabe: Gib mir margin! */
        }

        #box3 {
            background-color: #2196f3;
            padding: 20px;
            /* Die Boxen sollen Abstand haben! */
        }

        /* Level 3: Flexbox Layout */
        #container {
            border: 3px solid #333;
            padding: 10px;
            /* Aufgabe: Mache mich zu einer Flexbox! */
        }

        .flex-kind {
            background-color: #ff9800;
            padding: 20px;
            margin: 5px;
            text-align: center;
        }

        .mission-karte {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin: 20px 0;
        }

        .hilfe-popup {
            background: #fff;
            color: #333;
            padding: 15px;
            border-radius: 10px;
            margin: 10px 0;
            display: none;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }

        .erfolg-animation {
            animation: erfolg 0.5s ease;
            background: #c8e6c9 !important;
        }

        @keyframes erfolg {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .level-anzeige {
            position: fixed;
            top: 20px;
            left: 20px;
            background: white;
            padding: 15px 25px;
            border-radius: 50px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .messwerkzeug {
            background: #263238;
            color: #81c784;
            padding: 10px;
            border-radius: 8px;
            font-family: monospace;
            margin: 10px 0;
            font-size: 14px;
        }

        .baukasten {
            background: #fafafa;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }

        .werkzeug-karte {
            background: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            border: 2px solid #e0e0e0;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .werkzeug-karte:hover {
            border-color: #4caf50;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .erklaerung {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 10px;
            margin: 15px 0;
            border-left: 5px solid #2196f3;
        }

        .sandbox {
            background: #f5f5f5;
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
        }
    </style>
</head>
<body>
    <div class="level-anzeige">
        <span style="font-size: 24px;">📦</span> Level <span id="level">1</span>/3
    </div>

    <div class="baustelle">
        <h1>🏗️ Box-Baumeister - Meistere das Box-Modell!</h1>
        <p>Willkommen auf der Baustelle! Hier lernst du, wie Boxen im Web funktionieren.</p>

        <div class="erklaerung">
            <h3>📐 Das Box-Modell</h3>
            <p>Jedes Element im Web ist eine Box mit:</p>
            <ul>
                <li><strong>Content</strong> - Der Inhalt (Text, Bilder)</li>
                <li><strong>Padding</strong> - Der Innenabstand</li>
                <li><strong>Border</strong> - Der Rahmen</li>
                <li><strong>Margin</strong> - Der Außenabstand</li>
            </ul>
        </div>

        <!-- Level 1: Padding -->
        <div class="mission-karte">
            <h2>🎯 Mission 1: Padding Power!</h2>
            <p>Die gelbe Box ist zu eng! Der Text klebt am Rand. Gib ihr etwas Luft mit padding!</p>
            <button onclick="zeigeHilfe('hilfe1')" style="background: white; color: #333; padding: 10px 20px; border: none; border-radius: 20px; cursor: pointer;">
                💡 Hilfe!
            </button>
            <div class="hilfe-popup" id="hilfe1">
                <strong>Tipp:</strong> Frage die KI: "Wie gebe ich box1 ein padding von 20px?"
                <div class="messwerkzeug">
                    padding: 20px; /* Alle Seiten */<br>
                    padding: 10px 20px; /* Oben/Unten Links/Rechts */
                </div>
            </div>
        </div>

        <div class="box-visualizer">
            <div id="box1">
                <div id="box1-inhalt">
                    Ich bin Text in einer Box! Gib mir mehr Platz!
                </div>
            </div>
            <div class="messwerkzeug" id="box1-messen">
                Aktuell: padding: 0px;
            </div>
        </div>

        <!-- Level 2: Margin -->
        <div class="mission-karte" id="mission2" style="display: none;">
            <h2>🎯 Mission 2: Margin Magie!</h2>
            <p>Die grünen und blauen Boxen kleben aneinander! Gib ihnen Abstand mit margin!</p>
            <button onclick="zeigeHilfe('hilfe2')" style="background: white; color: #333; padding: 10px 20px; border: none; border-radius: 20px; cursor: pointer;">
                💡 Hilfe!
            </button>
            <div class="hilfe-popup" id="hilfe2">
                <strong>Tipp:</strong> Frage die KI: "Wie gebe ich box2 und box3 einen margin?"
                <div class="messwerkzeug">
                    margin: 20px; /* Abstand zu allen Seiten */<br>
                    margin-bottom: 30px; /* Nur unten */
                </div>
            </div>
        </div>

        <div class="box-visualizer" id="level2-bereich" style="display: none;">
            <div id="box2">Ich bin Box 2 - Grün!</div>
            <div id="box3">Ich bin Box 3 - Blau!</div>
            <div class="messwerkzeug" id="margin-messen">
                Abstand zwischen Boxen: 0px
            </div>
        </div>

        <!-- Level 3: Flexbox -->
        <div class="mission-karte" id="mission3" style="display: none;">
            <h2>🎯 Mission 3: Flexbox Finale!</h2>
            <p>Ordne die orangen Boxen nebeneinander an mit Flexbox!</p>
            <button onclick="zeigeHilfe('hilfe3')" style="background: white; color: #333; padding: 10px 20px; border: none; border-radius: 20px; cursor: pointer;">
                💡 Hilfe!
            </button>
            <div class="hilfe-popup" id="hilfe3">
                <strong>Tipp:</strong> Frage die KI nach:
                <div class="messwerkzeug">
                    display: flex;<br>
                    justify-content: space-between;<br>
                    align-items: center;
                </div>
            </div>
        </div>

        <div class="box-visualizer" id="level3-bereich" style="display: none;">
            <div id="container">
                <div class="flex-kind">Box A</div>
                <div class="flex-kind">Box B</div>
                <div class="flex-kind">Box C</div>
            </div>
        </div>

        <!-- Werkzeugkasten -->
        <div class="baukasten">
            <div class="werkzeug-karte" onclick="erklaere('padding')">
                <h3>📏 Padding</h3>
                <p>Innenabstand</p>
            </div>
            <div class="werkzeug-karte" onclick="erklaere('margin')">
                <h3>🔲 Margin</h3>
                <p>Außenabstand</p>
            </div>
            <div class="werkzeug-karte" onclick="erklaere('border')">
                <h3>🖼️ Border</h3>
                <p>Rahmen</p>
            </div>
            <div class="werkzeug-karte" onclick="erklaere('flexbox')">
                <h3>💪 Flexbox</h3>
                <p>Layout-Power</p>
            </div>
        </div>

        <!-- Sandbox -->
        <div class="sandbox">
            <h3>🎨 Experimentier-Bereich</h3>
            <p>Baue deine eigene Box-Komposition!</p>
            <div style="border: 2px dashed #666; padding: 20px; min-height: 200px;">
                <div id="sandbox-box" style="background: #e91e63; color: white; padding: 20px;">
                    Ich bin deine Sandbox-Box! Style mich!
                </div>
            </div>
        </div>

        <div id="abschluss" style="display: none;" class="mission-karte" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <h2>🏆 Herzlichen Glückwunsch!</h2>
            <p>Du bist jetzt ein Box-Modell-Meister!</p>
            <p><strong>Du hast gelernt:</strong></p>
            <ul>
                <li>✅ Padding für Innenabstand</li>
                <li>✅ Margin für Außenabstand</li>
                <li>✅ Flexbox für moderne Layouts</li>
                <li>✅ Das komplette Box-Modell!</li>
            </ul>
        </div>
    </div>

    <script>
        let aktuellesLevel = 1;
        let level1Fertig = false;
        let level2Fertig = false;
        let level3Fertig = false;

        function zeigeHilfe(id) {
            const hilfe = document.getElementById(id);
            hilfe.style.display = hilfe.style.display === 'none' ? 'block' : 'none';
        }

        function erklaere(thema) {
            const erklaerungen = {
                'padding': 'Padding ist wie ein Kissen in der Box!\n\nBeispiele:\npadding: 20px; (alle Seiten)\npadding-top: 10px; (nur oben)\npadding: 10px 20px; (oben/unten links/rechts)',
                'margin': 'Margin ist der Abstand zwischen Boxen!\n\nBeispiele:\nmargin: 20px; (alle Seiten)\nmargin-bottom: 30px; (nur unten)\nmargin: auto; (zentrieren)',
                'border': 'Border ist der Rahmen der Box!\n\nBeispiele:\nborder: 2px solid black;\nborder-radius: 10px; (runde Ecken)\nborder-style: dashed; (gestrichelt)',
                'flexbox': 'Flexbox macht Layout einfach!\n\nHauptbefehle:\ndisplay: flex; (aktivieren)\njustify-content: center; (horizontal)\nalign-items: center; (vertikal)'
            };

            alert('📚 ' + thema.toUpperCase() + '\n\n' + erklaerungen[thema]);
        }

        function pruefeLevel1() {
            const box = document.getElementById('box1');
            const style = getComputedStyle(box);
            const padding = parseInt(style.padding);

            if (!level1Fertig && padding > 0) {
                level1Fertig = true;
                box.classList.add('erfolg-animation');
                document.getElementById('box1-messen').textContent = `Super! padding: ${style.padding}`;

                setTimeout(() => {
                    document.getElementById('mission2').style.display = 'block';
                    document.getElementById('level2-bereich').style.display = 'block';
                    document.getElementById('level').textContent = '2';
                    aktuellesLevel = 2;
                }, 1000);
            } else if (padding > 0) {
                document.getElementById('box1-messen').textContent = `Aktuell: padding: ${style.padding}`;
            }
        }

        function pruefeLevel2() {
            const box2 = document.getElementById('box2');
            const box3 = document.getElementById('box3');
            const style2 = getComputedStyle(box2);
            const style3 = getComputedStyle(box3);

            const margin2 = parseInt(style2.marginBottom) || parseInt(style2.margin) || 0;
            const margin3 = parseInt(style3.marginTop) || parseInt(style3.margin) || 0;

            if (!level2Fertig && (margin2 > 0 || margin3 > 0)) {
                level2Fertig = true;
                box2.classList.add('erfolg-animation');
                box3.classList.add('erfolg-animation');
                document.getElementById('margin-messen').textContent = `Super! Abstand: ${margin2 + margin3}px`;

                setTimeout(() => {
                    document.getElementById('mission3').style.display = 'block';
                    document.getElementById('level3-bereich').style.display = 'block';
                    document.getElementById('level').textContent = '3';
                    aktuellesLevel = 3;
                }, 1000);
            }
        }

        function pruefeLevel3() {
            const container = document.getElementById('container');
            const style = getComputedStyle(container);

            if (!level3Fertig && style.display === 'flex') {
                level3Fertig = true;
                container.classList.add('erfolg-animation');

                setTimeout(() => {
                    document.getElementById('abschluss').style.display = 'block';
                }, 1000);
            }
        }

        // Überwache Änderungen
        setInterval(() => {
            if (aktuellesLevel === 1) pruefeLevel1();
            else if (aktuellesLevel === 2) pruefeLevel2();
            else if (aktuellesLevel === 3) pruefeLevel3();
        }, 500);
    </script>
</body>
</html>$$, '', '', 'gamified', true, 3, '{"level": 2, "duration": "25-30 min", "skills": ["Box Model", "Padding", "Margin", "Flexbox Basics"], "age": "9-13"}'),

-- Template 4: Bilder-Galerie
('04 - Bilder-Galerie', 'Erstelle eine coole Fotogalerie mit Grid und Effekten! 🖼️',
$$<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bilder-Galerie</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, #1e3c72, #2a5298);
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            color: white;
        }

        .galerie-studio {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }

        .werkbank {
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            padding: 30px;
            border-radius: 15px;
            margin: 20px 0;
        }

        /* Galerie zum Bearbeiten */
        #galerie {
            /* Aufgabe 1: Mache mich zu einem Grid! */
            background: rgba(0, 0, 0, 0.3);
            padding: 20px;
            border-radius: 10px;
            min-height: 300px;
        }

        .bild {
            background: #666;
            border-radius: 8px;
            overflow: hidden;
            /* Aufgabe 2: Gib mir coole Hover-Effekte! */
        }

        .bild img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            /* Aufgabe 3: Füge Übergangseffekte hinzu! */
        }

        .aufgabe-panel {
            background: rgba(255, 255, 255, 0.2);
            padding: 25px;
            border-radius: 15px;
            margin: 20px 0;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .fortschrittsbalken {
            background: rgba(255, 255, 255, 0.2);
            height: 30px;
            border-radius: 15px;
            overflow: hidden;
            margin: 20px 0;
        }

        .fortschritt {
            background: linear-gradient(90deg, #4caf50, #81c784);
            height: 100%;
            width: 0%;
            transition: width 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .hilfe-box {
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            padding: 20px;
            border-radius: 10px;
            margin: 15px 0;
            display: none;
        }

        .code-snippet {
            background: #263238;
            color: #aed581;
            padding: 15px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            margin: 10px 0;
            overflow-x: auto;
        }

        .filter-sammlung {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 20px 0;
        }

        .filter-button {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid white;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-button:hover {
            background: white;
            color: #333;
            transform: translateY(-2px);
        }

        .erfolgs-nachricht {
            background: #4caf50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            display: none;
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .bild-platzhalter {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 50px;
        }

        .werkzeug-leiste {
            background: rgba(0, 0, 0, 0.3);
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
        }

        .werkzeug {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px 25px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .werkzeug:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="galerie-studio">
        <h1>🖼️ Bilder-Galerie Studio</h1>
        <p>Willkommen im Galerie-Studio! Hier lernst du, wie man professionelle Bildergalerien baut!</p>

        <div class="fortschrittsbalken">
            <div class="fortschritt" id="fortschritt">0%</div>
        </div>

        <!-- Level 1: Grid Layout -->
        <div class="aufgabe-panel">
            <h2>📐 Level 1: Grid-Meister werden</h2>
            <p>Deine Bilder stapeln sich übereinander! Ordne sie in einem schönen Grid an!</p>
            <button onclick="zeigeHilfe('grid-hilfe')" style="background: #ff9800; color: white; padding: 10px 20px; border: none; border-radius: 20px; cursor: pointer;">
                💡 Zeig mir wie!
            </button>
            <div class="hilfe-box" id="grid-hilfe">
                <p><strong>CSS Grid macht's möglich!</strong> Frage die KI:</p>
                <p>"Wie mache ich aus #galerie ein Grid mit 3 Spalten?"</p>
                <div class="code-snippet">
display: grid;<br>
grid-template-columns: repeat(3, 1fr);<br>
gap: 20px;
                </div>
                <p>🎯 Tipp: <code>1fr</code> bedeutet "ein Teil des verfügbaren Platzes"</p>
            </div>
        </div>

        <div class="werkbank">
            <div id="galerie">
                <div class="bild">
                    <div class="bild-platzhalter">🏔️</div>
                </div>
                <div class="bild">
                    <div class="bild-platzhalter">🌅</div>
                </div>
                <div class="bild">
                    <div class="bild-platzhalter">🏖️</div>
                </div>
                <div class="bild">
                    <div class="bild-platzhalter">🌸</div>
                </div>
                <div class="bild">
                    <div class="bild-platzhalter">🌊</div>
                </div>
                <div class="bild">
                    <div class="bild-platzhalter">🌳</div>
                </div>
            </div>
        </div>

        <div class="erfolgs-nachricht" id="erfolg1">
            ✨ Perfekt! Dein Grid sieht fantastisch aus!
        </div>

        <!-- Level 2: Hover-Effekte -->
        <div class="aufgabe-panel" id="level2" style="display: none;">
            <h2>✨ Level 2: Magische Hover-Effekte</h2>
            <p>Lass die Bilder reagieren, wenn man mit der Maus drüber fährt!</p>
            <button onclick="zeigeHilfe('hover-hilfe')" style="background: #ff9800; color: white; padding: 10px 20px; border: none; border-radius: 20px; cursor: pointer;">
                💡 Zeig mir Ideen!
            </button>
            <div class="hilfe-box" id="hover-hilfe">
                <p><strong>Hover-Magie!</strong> Probiere diese Effekte:</p>
                <div class="code-snippet">
.bild:hover {<br>
&nbsp;&nbsp;transform: scale(1.05);<br>
&nbsp;&nbsp;box-shadow: 0 10px 30px rgba(0,0,0,0.3);<br>
}<br><br>
.bild:hover img {<br>
&nbsp;&nbsp;filter: brightness(1.2);<br>
}
                </div>
                <p>🎨 Oder frage die KI nach "coolen CSS Hover-Effekten für Bilder"!</p>
            </div>
        </div>

        <!-- Level 3: Filter und Effekte -->
        <div class="aufgabe-panel" id="level3" style="display: none;">
            <h2>🎨 Level 3: Instagram-Filter mit CSS</h2>
            <p>Verleihe deinen Bildern coole Filter-Effekte!</p>
            <div class="filter-sammlung">
                <button class="filter-button" onclick="setzeFilter('grayscale')">⚫ Schwarz-Weiß</button>
                <button class="filter-button" onclick="setzeFilter('sepia')">🟤 Sepia</button>
                <button class="filter-button" onclick="setzeFilter('blur')">💨 Weichzeichner</button>
                <button class="filter-button" onclick="setzeFilter('brightness')">☀️ Helligkeit</button>
                <button class="filter-button" onclick="setzeFilter('contrast')">🎯 Kontrast</button>
            </div>
            <div class="hilfe-box" style="display: block; background: rgba(255, 255, 255, 0.1); color: white;">
                <p>Klicke auf die Filter-Buttons oder erstelle eigene mit CSS!</p>
                <div class="code-snippet">
filter: grayscale(100%);<br>
filter: sepia(50%);<br>
filter: blur(5px);<br>
filter: brightness(1.5) contrast(1.2);
                </div>
            </div>
        </div>

        <!-- Werkzeug-Leiste -->
        <div class="werkzeug-leiste">
            <div class="werkzeug" onclick="erklaereWerkzeug('grid')">
                📐 Grid
            </div>
            <div class="werkzeug" onclick="erklaereWerkzeug('transform')">
                🔄 Transform
            </div>
            <div class="werkzeug" onclick="erklaereWerkzeug('filter')">
                🎨 Filter
            </div>
            <div class="werkzeug" onclick="erklaereWerkzeug('transition')">
                ⏱️ Transition
            </div>
            <div class="werkzeug" onclick="erklaereWerkzeug('responsive')">
                📱 Responsive
            </div>
        </div>

        <!-- Bonus: Eigene Galerie -->
        <div class="aufgabe-panel" id="bonus" style="display: none; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <h2>🏆 Bonus: Deine Traum-Galerie!</h2>
            <p>Du hast alle Werkzeuge gemeistert! Jetzt kannst du:</p>
            <ul>
                <li>✅ Bilder in einem Grid anordnen</li>
                <li>✅ Coole Hover-Effekte hinzufügen</li>
                <li>✅ Filter und Transformationen anwenden</li>
                <li>✅ Alles responsive machen</li>
            </ul>
            <p><strong>Challenge:</strong> Frage die KI nach einer "Masonry-Galerie" oder "Lightbox-Effekt"!</p>
        </div>

        <div class="erfolgs-nachricht" id="erfolg-final" style="display: none;">
            🎉 Herzlichen Glückwunsch! Du bist jetzt ein Galerie-Profi!
        </div>
    </div>

    <script>
        let fortschritt = 0;
        let gridFertig = false;
        let hoverFertig = false;
        let filterFertig = false;

        function zeigeHilfe(id) {
            const hilfe = document.getElementById(id);
            hilfe.style.display = hilfe.style.display === 'none' ? 'block' : 'none';
        }

        function aktualisierteFortschritt() {
            document.getElementById('fortschritt').style.width = fortschritt + '%';
            document.getElementById('fortschritt').textContent = fortschritt + '%';
        }

        function erklaereWerkzeug(werkzeug) {
            const erklaerungen = {
                'grid': 'CSS Grid:\n\nErstelle 2D-Layouts!\n- display: grid\n- grid-template-columns\n- grid-gap\n- grid-area',
                'transform': 'Transform:\n\nBewege und drehe Elemente!\n- scale() - Größe ändern\n- rotate() - Drehen\n- translate() - Verschieben\n- skew() - Verzerren',
                'filter': 'CSS Filter:\n\nBildeffekte direkt im Browser!\n- blur() - Weichzeichner\n- brightness() - Helligkeit\n- contrast() - Kontrast\n- grayscale() - Schwarz-Weiß',
                'transition': 'Transitions:\n\nSanfte Übergänge!\n- transition: all 0.3s ease\n- transition-property\n- transition-duration\n- transition-timing-function',
                'responsive': 'Responsive Design:\n\nFür alle Bildschirme!\n- Media Queries\n- Flexible Units (%, vw, vh)\n- Mobile First\n- Grid/Flexbox'
            };

            alert('🛠️ ' + werkzeug.toUpperCase() + '\n\n' + erklaerungen[werkzeug]);
        }

        function setzeFilter(filterTyp) {
            const bilder = document.querySelectorAll('.bild img, .bild-platzhalter');
            const filterWerte = {
                'grayscale': 'grayscale(100%)',
                'sepia': 'sepia(80%)',
                'blur': 'blur(3px)',
                'brightness': 'brightness(1.3)',
                'contrast': 'contrast(1.5)'
            };

            bilder.forEach(bild => {
                bild.style.filter = filterWerte[filterTyp];
                bild.style.transition = 'filter 0.3s ease';
            });

            if (!filterFertig) {
                filterFertig = true;
                fortschritt = 100;
                aktualisierteFortschritt();
                document.getElementById('bonus').style.display = 'block';
                document.getElementById('erfolg-final').style.display = 'block';
            }
        }

        function pruefeGrid() {
            const galerie = document.getElementById('galerie');
            const style = getComputedStyle(galerie);

            if (!gridFertig && style.display === 'grid') {
                gridFertig = true;
                fortschritt = 33;
                aktualisierteFortschritt();
                document.getElementById('erfolg1').style.display = 'block';

                setTimeout(() => {
                    document.getElementById('level2').style.display = 'block';
                }, 1000);
            }
        }

        function pruefeHover() {
            if (gridFertig && !hoverFertig) {
                // Prüfe ob Hover-Styles existieren
                const testElement = document.querySelector('.bild');
                testElement.addEventListener('mouseenter', function() {
                    const style = getComputedStyle(this);
                    if (style.transform !== 'none' || style.boxShadow !== 'none') {
                        if (!hoverFertig) {
                            hoverFertig = true;
                            fortschritt = 66;
                            aktualisierteFortschritt();

                            setTimeout(() => {
                                document.getElementById('level3').style.display = 'block';
                            }, 500);
                        }
                    }
                });
            }
        }

        // Überwache Änderungen
        setInterval(() => {
            pruefeGrid();
            if (gridFertig) {
                pruefeHover();
            }
        }, 500);

        // Easter Egg: Geheime Tastenkombination
        let konamiCode = [];
        const geheimCode = ['ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown'];

        document.addEventListener('keydown', (e) => {
            konamiCode.push(e.key);
            konamiCode = konamiCode.slice(-4);

            if (konamiCode.join(',') === geheimCode.join(',')) {
                alert('🎉 Geheim-Code aktiviert! Du hast den Matrix-Filter freigeschaltet!');
                const bilder = document.querySelectorAll('.bild');
                bilder.forEach(bild => {
                    bild.style.animation = 'matrix 2s infinite';
                });
            }
        });
    </script>
</body>
</html>$$, '', '', 'gamified', true, 4, '{"level": 3, "duration": "25-30 min", "skills": ["CSS Grid", "Image Handling", "Filters", "Hover Effects"], "age": "10-14"}'),

-- Template 5: Mein erstes Spiel
('05 - Mein erstes Spiel', 'Programmiere ein einfaches Klick-Spiel mit JavaScript! 🎮',
$$<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mein erstes Spiel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            color: white;
        }

        .spiel-studio {
            max-width: 1000px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 20px;
        }

        .spiel-bereich {
            background: rgba(0, 0, 0, 0.3);
            padding: 30px;
            border-radius: 15px;
            margin: 20px 0;
            min-height: 400px;
            position: relative;
        }

        #spielfeld {
            width: 100%;
            height: 400px;
            position: relative;
            border: 3px solid white;
            border-radius: 10px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.05);
        }

        #ziel {
            width: 50px;
            height: 50px;
            background: #ffeb3b;
            border-radius: 50%;
            position: absolute;
            cursor: pointer;
            display: none;
            /* Aufgabe: Zeige mich und mache mich klickbar! */
        }

        #punkte-anzeige {
            font-size: 30px;
            text-align: center;
            margin: 20px 0;
            /* Aufgabe: Zeige die Punkte an! */
        }

        #start-button {
            background: #4caf50;
            color: white;
            border: none;
            padding: 15px 40px;
            font-size: 20px;
            border-radius: 30px;
            cursor: pointer;
            display: block;
            margin: 20px auto;
            /* Aufgabe: Starte das Spiel wenn geklickt! */
        }

        .lern-panel {
            background: rgba(255, 255, 255, 0.2);
            padding: 25px;
            border-radius: 15px;
            margin: 20px 0;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .code-editor {
            background: #263238;
            color: #aed581;
            padding: 20px;
            border-radius: 10px;
            font-family: 'Courier New', monospace;
            margin: 15px 0;
        }

        .hilfe-bereich {
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            padding: 20px;
            border-radius: 10px;
            margin: 15px 0;
            display: none;
        }

        .variable-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
            margin: 10px 0;
            border: 2px dashed rgba(255, 255, 255, 0.5);
        }

        .erfolg {
            background: #4caf50;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            display: none;
            animation: erfolg-animation 0.5s ease;
        }

        @keyframes erfolg-animation {
            from { transform: scale(0.8); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .werkzeugkiste {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .werkzeug-karte {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .werkzeug-karte:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-5px);
        }

        .level-fortschritt {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 20px 0;
        }

        .level-punkt {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .level-punkt.aktiv {
            background: #4caf50;
        }

        #timer {
            font-size: 20px;
            text-align: center;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="spiel-studio">
        <h1>🎮 Mein erstes Spiel - Click & Catch!</h1>
        <p>Lerne JavaScript, während du dein eigenes Spiel baust!</p>

        <div class="level-fortschritt">
            <div class="level-punkt aktiv" id="level1">1</div>
            <div class="level-punkt" id="level2">2</div>
            <div class="level-punkt" id="level3">3</div>
            <div class="level-punkt" id="level4">4</div>
        </div>

        <!-- Level 1: Variablen verstehen -->
        <div class="lern-panel" id="lern1">
            <h2>📦 Level 1: Variablen - Die Spielzutaten</h2>
            <p>Ein Spiel braucht Variablen um Dinge zu speichern, wie Punkte!</p>

            <div class="variable-box">
                <strong>Was ist eine Variable?</strong><br>
                Eine Variable ist wie eine Box 📦, in der du Sachen speichern kannst!
            </div>

            <button onclick="zeigeHilfe('var-hilfe')" style="background: #ff9800; color: white; padding: 10px 20px; border: none; border-radius: 20px; cursor: pointer;">
                💡 Ich brauche Hilfe!
            </button>

            <div class="hilfe-bereich" id="var-hilfe">
                <p><strong>So erstellst du Variablen:</strong></p>
                <div class="code-editor">
let punkte = 0;  // Speichert die Punkte<br>
let spielLaeuft = false;  // Ist das Spiel aktiv?<br>
let zeit = 30;  // Spielzeit in Sekunden
                </div>
                <p>Frage die KI: "Wie erstelle ich eine Variable für Punkte in JavaScript?"</p>
            </div>
        </div>

        <!-- Das Spiel -->
        <div class="spiel-bereich">
            <div id="punkte-anzeige">Punkte: 0</div>
            <div id="timer">Zeit: 30</div>
            <div id="spielfeld">
                <div id="ziel">🎯</div>
            </div>
            <button id="start-button">Spiel starten!</button>
        </div>

        <div class="erfolg" id="erfolg1">
            ✅ Super! Du hast Variablen gemeistert! Weiter zu Level 2!
        </div>

        <!-- Level 2: Click Events -->
        <div class="lern-panel" id="lern2" style="display: none;">
            <h2>🖱️ Level 2: Click Events - Mach es klickbar!</h2>
            <p>Jetzt machen wir das Ziel klickbar und zählen Punkte!</p>

            <button onclick="zeigeHilfe('click-hilfe')" style="background: #ff9800; color: white; padding: 10px 20px; border: none; border-radius: 20px; cursor: pointer;">
                💡 Zeig mir wie!
            </button>

            <div class="hilfe-bereich" id="click-hilfe">
                <p><strong>Click Events in JavaScript:</strong></p>
                <div class="code-editor">
// Element finden<br>
const ziel = document.getElementById('ziel');<br><br>
// Click Event hinzufügen<br>
ziel.addEventListener('click', function() {<br>
&nbsp;&nbsp;punkte = punkte + 1;<br>
&nbsp;&nbsp;// Zeige neue Punkte an<br>
});
                </div>
                <p>Frage die KI: "Wie füge ich einen Click-Event zu #ziel hinzu?"</p>
            </div>
        </div>

        <!-- Level 3: Bewegung -->
        <div class="lern-panel" id="lern3" style="display: none;">
            <h2>🏃 Level 3: Bewegung - Lass das Ziel springen!</h2>
            <p>Das Ziel soll nach jedem Klick an eine neue Position springen!</p>

            <div class="code-editor">
function bewegeZiel() {<br>
&nbsp;&nbsp;// Zufällige Position<br>
&nbsp;&nbsp;let x = Math.random() * 350;<br>
&nbsp;&nbsp;let y = Math.random() * 350;<br>
&nbsp;&nbsp;<br>
&nbsp;&nbsp;ziel.style.left = x + 'px';<br>
&nbsp;&nbsp;ziel.style.top = y + 'px';<br>
}
            </div>
        </div>

        <!-- Level 4: Timer -->
        <div class="lern-panel" id="lern4" style="display: none;">
            <h2>⏱️ Level 4: Timer - Zeitdruck macht Spaß!</h2>
            <p>Füge einen Countdown hinzu! Das Spiel endet nach 30 Sekunden!</p>

            <div class="code-editor">
setInterval(function() {<br>
&nbsp;&nbsp;zeit = zeit - 1;<br>
&nbsp;&nbsp;// Zeige Zeit an<br>
&nbsp;&nbsp;if (zeit <= 0) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;// Spiel beenden<br>
&nbsp;&nbsp;}<br>
}, 1000); // Jede Sekunde
            </div>
        </div>

        <!-- Werkzeugkiste -->
        <div class="werkzeugkiste">
            <div class="werkzeug-karte" onclick="erklaereKonzept('variablen')">
                <h3>📦 Variablen</h3>
                <p>Speichere Werte</p>
            </div>
            <div class="werkzeug-karte" onclick="erklaereKonzept('funktionen')">
                <h3>⚙️ Funktionen</h3>
                <p>Wiederverwendbarer Code</p>
            </div>
            <div class="werkzeug-karte" onclick="erklaereKonzept('events')">
                <h3>🖱️ Events</h3>
                <p>Reagiere auf Aktionen</p>
            </div>
            <div class="werkzeug-karte" onclick="erklaereKonzept('bedingungen')">
                <h3>🔀 If/Else</h3>
                <p>Entscheidungen treffen</p>
            </div>
        </div>

        <!-- Bonus Bereich -->
        <div class="lern-panel" id="bonus" style="display: none; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <h2>🏆 Glückwunsch! Du hast dein erstes Spiel gebaut!</h2>
            <p><strong>Was du gelernt hast:</strong></p>
            <ul>
                <li>✅ Variablen erstellen und nutzen</li>
                <li>✅ Click-Events programmieren</li>
                <li>✅ Elemente bewegen</li>
                <li>✅ Timer und Spiellogik</li>
            </ul>
            <p><strong>Nächste Ideen:</strong></p>
            <ul>
                <li>🎨 Verschiedene Ziele mit unterschiedlichen Punkten</li>
                <li>🚀 Power-Ups die doppelte Punkte geben</li>
                <li>📈 Highscore speichern</li>
                <li>🎵 Sounds hinzufügen</li>
            </ul>
        </div>
    </div>

    <script>
        // Spiel-Variablen (werden vom Schüler erstellt)
        let punkte = 0;
        let zeit = 30;
        let spielLaeuft = false;
        let timerInterval;

        // Hilfsfunktionen
        function zeigeHilfe(id) {
            const hilfe = document.getElementById(id);
            hilfe.style.display = hilfe.style.display === 'none' ? 'block' : 'none';
        }

        function erklaereKonzept(konzept) {
            const erklaerungen = {
                'variablen': 'Variablen:\n\nSpeichere Daten!\n\nlet punkte = 0;\nlet name = "Max";\nlet spielAktiv = true;\n\nVariablen können Zahlen, Texte oder Wahrheitswerte speichern!',
                'funktionen': 'Funktionen:\n\nCode-Bausteine die du wiederverwenden kannst!\n\nfunction sagHallo() {\n  alert("Hallo!");\n}\n\nsagHallo(); // Rufe die Funktion auf',
                'events': 'Events:\n\nReagiere auf Benutzeraktionen!\n\nclick - Mausklick\nkeypress - Tastendruck\nmouseover - Maus drüber\n\nelement.addEventListener("click", machEtwas);',
                'bedingungen': 'If/Else:\n\nTreffe Entscheidungen!\n\nif (punkte > 10) {\n  alert("Super!");\n} else {\n  alert("Weiter so!");\n}\n\nPrüfe Bedingungen und führe verschiedenen Code aus!'
            };

            alert('📚 ' + konzept.toUpperCase() + '\n\n' + erklaerungen[konzept]);
        }

        // Level-System
        function aktiviereLevel(level) {
            document.getElementById('level' + level).classList.add('aktiv');

            // Zeige entsprechenden Lerninhalt
            for (let i = 1; i <= 4; i++) {
                document.getElementById('lern' + i).style.display = i === level ? 'block' : 'none';
            }

            if (level === 1) {
                pruefeVariablen();
            }
        }

        // Prüfe ob Variablen erstellt wurden
        function pruefeVariablen() {
            // Simuliere Erfolg nach einiger Zeit
            setTimeout(() => {
                if (typeof punkte !== 'undefined') {
                    document.getElementById('erfolg1').style.display = 'block';
                    setTimeout(() => aktiviereLevel(2), 2000);
                }
            }, 3000);
        }

        // Start-Button Funktionalität (wird vom Schüler programmiert)
        document.getElementById('start-button').addEventListener('click', function() {
            // Der Schüler soll hier Code hinzufügen
            console.log('Start-Button wurde geklickt!');

            // Beispiel-Implementation (normalerweise vom Schüler)
            spielLaeuft = true;
            punkte = 0;
            zeit = 30;
            document.getElementById('ziel').style.display = 'block';
            bewegeZiel();
            starteTimer();
        });

        // Ziel-Click (wird vom Schüler programmiert)
        document.getElementById('ziel').addEventListener('click', function() {
            if (spielLaeuft) {
                punkte++;
                document.getElementById('punkte-anzeige').textContent = 'Punkte: ' + punkte;
                bewegeZiel();

                // Aktiviere nächstes Level
                if (punkte === 1) aktiviereLevel(3);
                if (punkte === 5) aktiviereLevel(4);
                if (punkte === 10) {
                    document.getElementById('bonus').style.display = 'block';
                }
            }
        });

        // Hilfsfunktionen für das Spiel
        function bewegeZiel() {
            const spielfeld = document.getElementById('spielfeld');
            const maxX = spielfeld.offsetWidth - 50;
            const maxY = spielfeld.offsetHeight - 50;

            const x = Math.random() * maxX;
            const y = Math.random() * maxY;

            document.getElementById('ziel').style.left = x + 'px';
            document.getElementById('ziel').style.top = y + 'px';
        }

        function starteTimer() {
            timerInterval = setInterval(function() {
                zeit--;
                document.getElementById('timer').textContent = 'Zeit: ' + zeit;

                if (zeit <= 0) {
                    beendeSpiel();
                }
            }, 1000);
        }

        function beendeSpiel() {
            spielLaeuft = false;
            clearInterval(timerInterval);
            document.getElementById('ziel').style.display = 'none';
            alert('Spiel vorbei! Du hast ' + punkte + ' Punkte erreicht!');
        }

        // Starte mit Level 1
        aktiviereLevel(1);
    </script>
</body>
</html>$$, '', '', 'gamified', true, 5, '{"level": 2, "duration": "30-35 min", "skills": ["JavaScript Basics", "Variables", "Events", "Functions"], "age": "10-14"}'),

-- Template 6: Animations-Zauberei
('06 - Animations-Zauberei', 'Erwecke deine Website mit CSS-Animationen zum Leben! 🌈',
$$<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Animations-Zauberei</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #0f0f23;
            color: white;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .zauber-akademie {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px;
        }

        .titel {
            text-align: center;
            margin-bottom: 50px;
        }

        .titel h1 {
            font-size: 3em;
            background: linear-gradient(45deg, #ff00ff, #00ffff, #ffff00);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            /* Aufgabe: Animiere mich! */
        }

        .zauber-labor {
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 30px;
            margin: 30px 0;
            backdrop-filter: blur(10px);
        }

        /* Animations-Objekte */
        .ball {
            width: 60px;
            height: 60px;
            background: #ff4757;
            border-radius: 50%;
            margin: 20px;
            /* Aufgabe 1: Lass mich hüpfen! */
        }

        .stern {
            font-size: 50px;
            display: inline-block;
            margin: 20px;
            /* Aufgabe 2: Lass mich drehen! */
        }

        .box {
            width: 100px;
            height: 100px;
            background: linear-gradient(45deg, #3498db, #2ecc71);
            margin: 20px;
            /* Aufgabe 3: Morphe mich! */
        }

        .zauberstab {
            display: inline-block;
            font-size: 40px;
            cursor: pointer;
            /* Aufgabe 4: Schüttle mich bei Hover! */
        }

        .lern-karte {
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 25px;
            margin: 20px 0;
        }

        .code-zauber {
            background: #1a1a2e;
            border: 1px solid #16213e;
            border-radius: 10px;
            padding: 20px;
            margin: 15px 0;
            font-family: 'Courier New', monospace;
            color: #00ff88;
            position: relative;
            overflow: hidden;
        }

        .code-zauber::before {
            content: '✨';
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 20px;
        }

        .animations-galerie {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            margin: 40px 0;
        }

        .galerie-item {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .galerie-item:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(255, 255, 255, 0.2);
        }

        .hilfe-zauberbuch {
            background: rgba(138, 43, 226, 0.2);
            border: 2px solid rgba(138, 43, 226, 0.5);
            border-radius: 15px;
            padding: 20px;
            margin: 15px 0;
            display: none;
        }

        .fortschritts-sterne {
            position: fixed;
            top: 20px;
            right: 20px;
            background: rgba(0, 0, 0, 0.8);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.5);
        }

        .erfolgs-feuerwerk {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 100px;
            display: none;
            animation: feuerwerk 1s ease;
        }

        @keyframes feuerwerk {
            0% { transform: translate(-50%, -50%) scale(0) rotate(0deg); opacity: 0; }
            50% { transform: translate(-50%, -50%) scale(1.5) rotate(180deg); opacity: 1; }
            100% { transform: translate(-50%, -50%) scale(1) rotate(360deg); opacity: 0; }
        }

        /* Beispiel-Animationen */
        @keyframes regenbogen {
            0% { color: red; }
            16% { color: orange; }
            33% { color: yellow; }
            50% { color: green; }
            66% { color: blue; }
            83% { color: indigo; }
            100% { color: violet; }
        }

        .magie-button {
            background: linear-gradient(45deg, #ff006e, #8338ec, #3a86ff);
            background-size: 300% 300%;
            border: none;
            color: white;
            padding: 15px 30px;
            font-size: 18px;
            border-radius: 50px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .magie-button:hover {
            animation: farbwechsel 3s ease infinite;
        }

        @keyframes farbwechsel {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .zauber-partikel {
            position: absolute;
            width: 4px;
            height: 4px;
            background: white;
            border-radius: 50%;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="fortschritts-sterne">
        <div>🌟 Level: <span id="level">1</span>/5</div>
        <div>✨ Zauber: <span id="zauber-punkte">0</span></div>
    </div>

    <div class="zauber-akademie">
        <div class="titel">
            <h1 id="animierter-titel">🪄 Animations-Zauberei 🪄</h1>
            <p>Erwecke deine Website mit magischen CSS-Animationen zum Leben!</p>
        </div>

        <!-- Level 1: Transitions -->
        <div class="lern-karte">
            <h2>📚 Lektion 1: Transition-Zauber</h2>
            <p>Transitions machen Änderungen smooth und magisch!</p>

            <button onclick="zeigeZauberbuch('transition-hilfe')" class="magie-button">
                📖 Öffne Zauberbuch
            </button>

            <div class="hilfe-zauberbuch" id="transition-hilfe">
                <p><strong>Der Transition-Zauberspruch:</strong></p>
                <div class="code-zauber">
transition: all 0.3s ease;<br>
/* oder spezifisch: */<br>
transition: transform 0.5s ease-in-out;<br>
transition: background-color 1s linear;
                </div>
                <p>💡 Frage die KI: "Wie füge ich eine smooth transition zu hover-Effekten hinzu?"</p>
            </div>

            <div class="zauber-labor">
                <p>Aufgabe: Gib dem Zauberstab einen magischen Hover-Effekt!</p>
                <div class="zauberstab">🪄</div>
            </div>
        </div>

        <!-- Level 2: Keyframe Animations -->
        <div class="lern-karte" id="level2" style="display: none;">
            <h2>📚 Lektion 2: Keyframe-Magie</h2>
            <p>Mit @keyframes kannst du komplexe Animationen erstellen!</p>

            <div class="code-zauber">
@keyframes meine-animation {<br>
&nbsp;&nbsp;0% { /* Start */ }<br>
&nbsp;&nbsp;50% { /* Mitte */ }<br>
&nbsp;&nbsp;100% { /* Ende */ }<br>
}<br><br>
.element {<br>
&nbsp;&nbsp;animation: meine-animation 2s infinite;<br>
}
            </div>

            <div class="zauber-labor">
                <p>Aufgabe 1: Lass den Ball hüpfen!</p>
                <div class="ball"></div>

                <p>Aufgabe 2: Lass den Stern rotieren!</p>
                <div class="stern">⭐</div>
            </div>
        </div>

        <!-- Level 3: Transform -->
        <div class="lern-karte" id="level3" style="display: none;">
            <h2>📚 Lektion 3: Transform-Verwandlung</h2>
            <p>Verwandle Elemente mit transform!</p>

            <div class="code-zauber">
transform: rotate(45deg);<br>
transform: scale(1.5);<br>
transform: translateX(100px);<br>
transform: skew(10deg);<br>
/* Kombiniere mehrere: */<br>
transform: rotate(45deg) scale(1.2);
            </div>

            <div class="zauber-labor">
                <p>Aufgabe: Verwandle die Box in einen Kreis und lass sie wachsen!</p>
                <div class="box"></div>
            </div>
        </div>

        <!-- Level 4: Animation Properties -->
        <div class="lern-karte" id="level4" style="display: none;">
            <h2>📚 Lektion 4: Animations-Eigenschaften</h2>
            <p>Meistere die Feinheiten der Animation!</p>

            <div class="code-zauber">
animation-duration: 2s;        /* Dauer */<br>
animation-delay: 0.5s;         /* Verzögerung */<br>
animation-iteration-count: infinite; /* Wiederholungen */<br>
animation-direction: alternate; /* Richtung */<br>
animation-timing-function: ease-in-out; /* Timing */<br>
animation-fill-mode: forwards; /* Endposition */
            </div>
        </div>

        <!-- Animations-Galerie -->
        <div class="animations-galerie">
            <div class="galerie-item">
                <h3>🌊 Wellen</h3>
                <div style="animation: welle 2s ease-in-out infinite;">~~~~~</div>
            </div>

            <div class="galerie-item">
                <h3>💫 Pulsieren</h3>
                <div style="animation: puls 1s ease infinite;">●</div>
            </div>

            <div class="galerie-item">
                <h3>🌀 Wirbel</h3>
                <div style="animation: wirbel 3s linear infinite;">🌀</div>
            </div>

            <div class="galerie-item">
                <h3>✨ Funkeln</h3>
                <div style="animation: funkeln 0.5s ease infinite;">✨</div>
            </div>
        </div>

        <!-- Bonus: Eigene Animation -->
        <div class="lern-karte" id="bonus" style="display: none; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <h2>🏆 Meister-Aufgabe: Deine eigene Animation!</h2>
            <p>Erstelle eine eigene, einzigartige Animation!</p>

            <div class="zauber-labor" style="min-height: 200px;">
                <div id="mein-element" style="width: 100px; height: 100px; background: gold; margin: 50px auto;">
                    Animiere mich!
                </div>
            </div>

            <p>Ideen:</p>
            <ul>
                <li>🎭 Morphing zwischen Formen</li>
                <li>🌈 Regenbogen-Farbverlauf</li>
                <li>🎪 Zirkus-Animation</li>
                <li>🚀 Raketen-Start</li>
            </ul>
        </div>

        <div class="erfolgs-feuerwerk" id="feuerwerk">🎆</div>
    </div>

    <style>
        /* Zusätzliche Animationen für die Galerie */
        @keyframes welle {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes puls {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.3); opacity: 0.7; }
        }

        @keyframes wirbel {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        @keyframes funkeln {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.3; transform: scale(0.8); }
        }
    </style>

    <script>
        let aktuellesLevel = 1;
        let zauberPunkte = 0;

        function zeigeZauberbuch(id) {
            const buch = document.getElementById(id);
            buch.style.display = buch.style.display === 'none' ? 'block' : 'none';
        }

        function erhoeheZauberPunkte(punkte) {
            zauberPunkte += punkte;
            document.getElementById('zauber-punkte').textContent = zauberPunkte;

            // Zeige Feuerwerk
            const feuerwerk = document.getElementById('feuerwerk');
            feuerwerk.style.display = 'block';
            setTimeout(() => feuerwerk.style.display = 'none', 1000);
        }

        function naechstesLevel() {
            aktuellesLevel++;
            document.getElementById('level').textContent = aktuellesLevel;

            // Zeige nächstes Level
            if (aktuellesLevel <= 4) {
                document.getElementById('level' + aktuellesLevel).style.display = 'block';
            } else {
                document.getElementById('bonus').style.display = 'block';
            }
        }

        // Prüfe Animationen
        function pruefeAnimationen() {
            // Prüfe Zauberstab Hover
            const zauberstab = document.querySelector('.zauberstab');
            if (getComputedStyle(zauberstab).transition !== 'none') {
                erhoeheZauberPunkte(10);
                setTimeout(naechstesLevel, 1000);
            }

            // Weitere Prüfungen für andere Elemente...
        }

        // Erstelle magische Partikel bei Mausbewegung
        document.addEventListener('mousemove', (e) => {
            if (Math.random() > 0.95) {
                const partikel = document.createElement('div');
                partikel.className = 'zauber-partikel';
                partikel.style.left = e.pageX + 'px';
                partikel.style.top = e.pageY + 'px';
                document.body.appendChild(partikel);

                // Animiere Partikel
                partikel.animate([
                    { transform: 'translate(0, 0) scale(1)', opacity: 1 },
                    { transform: `translate(${Math.random() * 100 - 50}px, ${Math.random() * 100}px) scale(0)`, opacity: 0 }
                ], {
                    duration: 1000,
                    easing: 'ease-out'
                }).onfinish = () => partikel.remove();
            }
        });

        // Easter Egg: Geheime Animation
        let klickZaehler = 0;
        document.getElementById('animierter-titel').addEventListener('click', () => {
            klickZaehler++;
            if (klickZaehler === 5) {
                document.getElementById('animierter-titel').style.animation = 'regenbogen 2s linear infinite';
                alert('🌈 Geheime Regenbogen-Animation aktiviert!');
                erhoeheZauberPunkte(50);
            }
        });

        // Überwache Änderungen
        setInterval(pruefeAnimationen, 1000);
    </script>
</body>
</html>$$, '', '', 'gamified', true, 6, '{"level": 3, "duration": "30-35 min", "skills": ["CSS Animations", "Transitions", "Keyframes", "Transform"], "age": "10-14"}'),

-- Template 7: Mobile-First Design
('07 - Mobile-First Design', 'Gestalte Websites die auf jedem Gerät super aussehen! 📱',
$$<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mobile-First Design</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
            background: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }

        .device-simulator {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            padding: 40px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            margin-bottom: 40px;
        }

        .device-frame {
            background: #222;
            border-radius: 35px;
            padding: 15px;
            margin: 20px auto;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            position: relative;
            transition: all 0.3s ease;
        }

        .device-frame.phone {
            width: 375px;
            height: 667px;
        }

        .device-frame.tablet {
            width: 768px;
            height: 1024px;
        }

        .device-frame.desktop {
            width: 100%;
            max-width: 1200px;
            height: 700px;
        }

        .device-screen {
            background: white;
            height: 100%;
            border-radius: 20px;
            overflow-y: auto;
            overflow-x: hidden;
        }

        /* Die zu bearbeitende Website */
        .meine-website {
            padding: 20px;
        }

        .navigation {
            background: #333;
            color: white;
            padding: 15px;
            /* Aufgabe 1: Mache mich responsive! */
        }

        .nav-liste {
            list-style: none;
            /* Aufgabe: Bei Desktop nebeneinander, bei Mobile untereinander */
        }

        .hero-bereich {
            background: #e3f2fd;
            padding: 40px 20px;
            text-align: center;
            /* Aufgabe 2: Passe die Schriftgröße an! */
        }

        .hero-titel {
            font-size: 48px;
            /* Problem: Zu groß für Mobile! */
        }

        .produkt-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin: 40px 0;
            /* Aufgabe 3: Mache das Grid responsive! */
        }

        .produkt-karte {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        /* Steuerung */
        .geraete-auswahl {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 30px 0;
            flex-wrap: wrap;
        }

        .geraet-button {
            background: white;
            border: 2px solid #667eea;
            padding: 15px 30px;
            border-radius: 30px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
        }

        .geraet-button.aktiv {
            background: #667eea;
            color: white;
        }

        .lern-panel {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .code-beispiel {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin: 15px 0;
            font-family: 'Courier New', monospace;
        }

        .hilfe-box {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 20px;
            margin: 20px 0;
            border-radius: 5px;
            display: none;
        }

        .erfolg-nachricht {
            background: #4caf50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin: 20px 0;
            display: none;
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .viewport-info {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 15px 25px;
            border-radius: 30px;
            font-family: monospace;
        }

        .werkzeugkasten {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .werkzeug {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border: 2px solid #e9ecef;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .werkzeug:hover {
            border-color: #667eea;
            transform: translateY(-5px);
        }

        /* Beispiel Media Queries */
        @media (max-width: 768px) {
            /* Tablet und kleiner */
        }

        @media (max-width: 480px) {
            /* Smartphone */
        }
    </style>
</head>
<body>
    <div class="device-simulator">
        <div class="header">
            <h1>📱 Mobile-First Design Workshop</h1>
            <p>Lerne, wie man Websites für alle Bildschirmgrößen optimiert!</p>
        </div>

        <div class="geraete-auswahl">
            <button class="geraet-button aktiv" onclick="wechsleGeraet('phone')">
                📱 Smartphone
            </button>
            <button class="geraet-button" onclick="wechsleGeraet('tablet')">
                📱 Tablet
            </button>
            <button class="geraet-button" onclick="wechsleGeraet('desktop')">
                💻 Desktop
            </button>
        </div>

        <!-- Level 1: Viewport verstehen -->
        <div class="lern-panel">
            <h2>📏 Level 1: Der Viewport</h2>
            <p>Der Viewport ist der sichtbare Bereich einer Webseite. Jedes Gerät hat einen anderen!</p>

            <div class="code-beispiel">
&lt;meta name="viewport" content="width=device-width, initial-scale=1.0"&gt;
            </div>

            <button onclick="zeigeHilfe('viewport-hilfe')" style="background: #667eea; color: white; padding: 10px 20px; border: none; border-radius: 20px; cursor: pointer;">
                💡 Was bedeutet das?
            </button>

            <div class="hilfe-box" id="viewport-hilfe">
                <strong>Viewport Meta-Tag erklärt:</strong>
                <ul>
                    <li><code>width=device-width</code> - Breite = Gerätebreite</li>
                    <li><code>initial-scale=1.0</code> - Kein Zoom beim Laden</li>
                </ul>
                <p>Ohne dieses Tag sehen Mobile-Seiten winzig aus!</p>
            </div>
        </div>

        <!-- Device Frame -->
        <div class="device-frame phone" id="device">
            <div class="device-screen">
                <div class="meine-website">
                    <!-- Navigation -->
                    <nav class="navigation">
                        <ul class="nav-liste">
                            <li>Home</li>
                            <li>Produkte</li>
                            <li>Über uns</li>
                            <li>Kontakt</li>
                        </ul>
                    </nav>

                    <!-- Hero Bereich -->
                    <div class="hero-bereich">
                        <h1 class="hero-titel">Willkommen auf meiner Website!</h1>
                        <p>Diese Seite soll auf allen Geräten gut aussehen.</p>
                    </div>

                    <!-- Produkt Grid -->
                    <div class="produkt-grid">
                        <div class="produkt-karte">
                            <h3>Produkt 1</h3>
                            <p>Beschreibung</p>
                        </div>
                        <div class="produkt-karte">
                            <h3>Produkt 2</h3>
                            <p>Beschreibung</p>
                        </div>
                        <div class="produkt-karte">
                            <h3>Produkt 3</h3>
                            <p>Beschreibung</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Level 2: Media Queries -->
        <div class="lern-panel">
            <h2>🎯 Level 2: Media Queries - Die Responsive-Magie</h2>
            <p>Mit Media Queries kannst du CSS für verschiedene Bildschirmgrößen anpassen!</p>

            <div class="code-beispiel">
/* Mobile First Approach */<br>
.element {<br>
&nbsp;&nbsp;font-size: 16px; /* Mobile */<br>
}<br><br>
@media (min-width: 768px) {<br>
&nbsp;&nbsp;.element {<br>
&nbsp;&nbsp;&nbsp;&nbsp;font-size: 20px; /* Tablet+ */<br>
&nbsp;&nbsp;}<br>
}
            </div>

            <h3>🎯 Aufgabe:</h3>
            <p>1. Mache die Navigation responsive (horizontal auf Desktop, vertikal auf Mobile)</p>
            <p>2. Passe die Hero-Titel-Größe an (kleiner auf Mobile)</p>
            <p>3. Ändere das Grid (1 Spalte Mobile, 2 Tablet, 3 Desktop)</p>
        </div>

        <!-- Level 3: Flexible Units -->
        <div class="lern-panel">
            <h2>📐 Level 3: Flexible Einheiten</h2>
            <p>Verwende flexible Einheiten statt feste Pixel!</p>

            <div class="werkzeugkasten">
                <div class="werkzeug" onclick="erklaereEinheit('rem')">
                    <h3>rem</h3>
                    <p>Relativ zur Root-Schriftgröße</p>
                    <code>font-size: 1.5rem;</code>
                </div>
                <div class="werkzeug" onclick="erklaereEinheit('em')">
                    <h3>em</h3>
                    <p>Relativ zur Eltern-Schriftgröße</p>
                    <code>padding: 1em;</code>
                </div>
                <div class="werkzeug" onclick="erklaereEinheit('vw')">
                    <h3>vw / vh</h3>
                    <p>Viewport Width/Height</p>
                    <code>width: 80vw;</code>
                </div>
                <div class="werkzeug" onclick="erklaereEinheit('prozent')">
                    <h3>%</h3>
                    <p>Prozent vom Elternelement</p>
                    <code>width: 100%;</code>
                </div>
            </div>
        </div>

        <!-- Bonus: Touch-Optimierung -->
        <div class="lern-panel" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
            <h2>🎯 Bonus: Touch-Optimierung</h2>
            <p>Mobile Nutzer tippen mit Fingern - mache Buttons groß genug!</p>

            <div style="background: rgba(255,255,255,0.2); padding: 20px; border-radius: 10px;">
                <strong>Touch-Target Regeln:</strong>
                <ul>
                    <li>Mindestens 44x44px (iOS) oder 48x48px (Android)</li>
                    <li>Genug Abstand zwischen klickbaren Elementen</li>
                    <li>Hover-States für Desktop, Focus-States für alle</li>
                </ul>
            </div>
        </div>

        <div class="erfolg-nachricht" id="erfolg">
            🎉 Großartig! Deine Website ist jetzt responsive!
        </div>

        <div class="viewport-info">
            Viewport: <span id="viewport-breite">375</span>px
        </div>
    </div>

    <script>
        let aktuellesGeraet = 'phone';

        function wechsleGeraet(geraet) {
            // Update Buttons
            document.querySelectorAll('.geraet-button').forEach(btn => {
                btn.classList.remove('aktiv');
            });
            event.target.classList.add('aktiv');

            // Update Device Frame
            const frame = document.getElementById('device');
            frame.className = 'device-frame ' + geraet;

            // Update Viewport Info
            const breiten = {
                'phone': 375,
                'tablet': 768,
                'desktop': 1200
            };
            document.getElementById('viewport-breite').textContent = breiten[geraet];

            aktuellesGeraet = geraet;
        }

        function zeigeHilfe(id) {
            const hilfe = document.getElementById(id);
            hilfe.style.display = hilfe.style.display === 'none' ? 'block' : 'none';
        }

        function erklaereEinheit(einheit) {
            const erklaerungen = {
                'rem': 'REM (Root EM):\n\n1rem = Schriftgröße des HTML-Elements (meist 16px)\n\nVorteil: Konsistent über die ganze Seite\n\nBeispiel:\nhtml { font-size: 16px; }\nh1 { font-size: 2rem; } /* 32px */',
                'em': 'EM:\n\n1em = Schriftgröße des Elternelements\n\nVorsicht: Kann sich verschachteln!\n\nBeispiel:\n.parent { font-size: 20px; }\n.child { font-size: 1.5em; } /* 30px */',
                'vw': 'Viewport Units:\n\nvw = Viewport Width (Breite)\nvh = Viewport Height (Höhe)\n\n1vw = 1% der Viewport-Breite\n\nBeispiel:\n.hero { height: 100vh; } /* Volle Höhe */\n.container { width: 90vw; } /* 90% Breite */',
                'prozent': 'Prozent (%):\n\nRelativ zum Elternelement\n\nBeispiel:\n.container { width: 1200px; }\n.half { width: 50%; } /* 600px */'
            };

            alert('📏 ' + einheit.toUpperCase() + '\n\n' + erklaerungen[einheit]);
        }

        // Prüfe Responsive-Änderungen
        function pruefeResponsive() {
            // Hier würde die Prüfung der CSS-Änderungen stattfinden
            // Für Demo-Zwecke zeigen wir nach einiger Zeit Erfolg
            setTimeout(() => {
                document.getElementById('erfolg').style.display = 'block';
            }, 5000);
        }

        // Live Viewport-Breite anzeigen
        function aktualisiereViewport() {
            if (window.innerWidth) {
                document.getElementById('viewport-breite').textContent = window.innerWidth;
            }
        }

        window.addEventListener('resize', aktualisiereViewport);

        // Easter Egg: Schüttle das Gerät
        let shakeCount = 0;
        document.getElementById('device').addEventListener('click', () => {
            shakeCount++;
            if (shakeCount === 5) {
                document.getElementById('device').style.animation = 'shake 0.5s';
                setTimeout(() => {
                    document.getElementById('device').style.animation = '';
                    alert('🎉 Geheimes Schüttel-Feature entdeckt!');
                }, 500);
                shakeCount = 0;
            }
        });

        // CSS für Shake-Animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                25% { transform: translateX(-10px); }
                75% { transform: translateX(10px); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>$$, '', '', 'gamified', true, 7, '{"level": 3, "duration": "35-40 min", "skills": ["Responsive Design", "Media Queries", "Mobile First", "Flexible Units"], "age": "11-15"}')
