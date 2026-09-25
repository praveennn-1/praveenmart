/**
 * PraveenMart AI Chatbot Widget (Week 9)
 * Communicates with backend proxy servlet at /api/v1/chat.
 */
(function () {
    'use strict';

    const STORAGE_KEY = 'pm_chat_history_v1';
    const MAX_LEN = 500;

    // Detect context path if not set globally
    function getContextPath() {
        if (typeof window.contextPath === 'string') {
            return window.contextPath;
        }
        const pathname = window.location.pathname;
        const secondSlash = pathname.indexOf('/', 1);
        if (secondSlash !== -1) {
            const firstSegment = pathname.substring(0, secondSlash);
            // If running on Tomcat under /PraveenMart
            if (firstSegment.toLowerCase() === '/praveenmart') {
                return firstSegment;
            }
        }
        return '';
    }

    const contextPath = getContextPath();
    const chatApiUrl = contextPath + '/api/v1/chat';

    // Initial greeting and quick suggestions
    const DEFAULT_GREETING = {
        role: 'bot',
        text: 'Hello! 👋 I am your **PraveenMart AI Assistant**. How can I help you today? You can ask about our catalog, orders, shipping, returns, or selling on PraveenMart.',
        time: formatTime(new Date()),
        showChips: true
    };

    const QUICK_CHIPS = [
        'Popular Electronics',
        'Fashion Collection',
        'How to track order?',
        'Payment methods',
        'Return & Refund policy',
        'How to sell on PraveenMart?'
    ];

    let messages = [];
    let isWaiting = false;

    function formatTime(date) {
        return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    }

    function init() {
        const launcher = document.getElementById('pmChatLauncher');
        const panel = document.getElementById('pmChatPanel');
        const closeBtn = document.getElementById('pmChatCloseBtn');
        const clearBtn = document.getElementById('pmChatClearBtn');
        const form = document.getElementById('pmChatForm');
        const input = document.getElementById('pmChatInput');
        const charCount = document.getElementById('pmChatCharCount');
        const messagesContainer = document.getElementById('pmChatBody');

        if (!launcher || !panel || !form || !input || !messagesContainer) {
            return;
        }

        // Load saved session history or init with default greeting
        loadHistory();

        // Toggle open/close
        launcher.addEventListener('click', function () {
            const isOpen = panel.classList.toggle('active');
            if (isOpen) {
                input.focus();
                scrollToBottom();
            }
        });

        if (closeBtn) {
            closeBtn.addEventListener('click', function () {
                panel.classList.remove('active');
            });
        }

        // Escape key closes panel
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && panel.classList.contains('active')) {
                panel.classList.remove('active');
            }
        });

        // Reset conversation
        if (clearBtn) {
            clearBtn.addEventListener('click', function () {
                if (confirm('Start a fresh conversation?')) {
                    messages = [DEFAULT_GREETING];
                    saveHistory();
                    renderMessages();
                }
            });
        }

        // Live character counter
        input.addEventListener('input', function () {
            const len = input.value.length;
            if (charCount) {
                charCount.textContent = len + '/' + MAX_LEN;
                charCount.style.color = len >= MAX_LEN ? '#EF4444' : '#64748B';
            }
        });

        // Form submission
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            const text = input.value.trim();
            if (!text || isWaiting) return;

            if (text.length > MAX_LEN) {
                alert('Message exceeds maximum limit of ' + MAX_LEN + ' characters.');
                return;
            }

            input.value = '';
            if (charCount) charCount.textContent = '0/' + MAX_LEN;
            sendMessage(text);
        });

        // Initial render
        renderMessages();
    }

    function loadHistory() {
        try {
            const saved = sessionStorage.getItem(STORAGE_KEY);
            if (saved) {
                messages = JSON.parse(saved);
                if (!Array.isArray(messages) || messages.length === 0) {
                    messages = [DEFAULT_GREETING];
                }
            } else {
                messages = [DEFAULT_GREETING];
            }
        } catch (e) {
            messages = [DEFAULT_GREETING];
        }
    }

    function saveHistory() {
        try {
            sessionStorage.setItem(STORAGE_KEY, JSON.stringify(messages));
        } catch (e) {}
    }

    function scrollToBottom() {
        const body = document.getElementById('pmChatBody');
        if (body) {
            body.scrollTop = body.scrollHeight;
        }
    }

    function formatText(text) {
        if (!text) return '';
        // Escape HTML
        let escaped = text
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');

        // Markdown bold **text**
        escaped = escaped.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');

        // Markdown code `code`
        escaped = escaped.replace(/`([^`]+)`/g, '<code style="background:rgba(255,255,255,0.1);padding:1px 5px;border-radius:4px;color:#C8B196;">$1</code>');

        // Bullet point lines starting with • or - or *
        const lines = escaped.split('\n');
        let formatted = '';
        let inList = false;

        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim();
            if (line.startsWith('• ') || line.startsWith('- ') || line.startsWith('* ')) {
                if (!inList) {
                    formatted += '<ul style="margin:6px 0 6px 18px;padding:0;">';
                    inList = true;
                }
                formatted += '<li style="margin-bottom:3px;">' + line.substring(2) + '</li>';
            } else if (line.match(/^\d+\.\s/)) {
                if (inList) {
                    formatted += '</ul>';
                    inList = false;
                }
                formatted += '<p style="margin-bottom:6px;">' + line + '</p>';
            } else {
                if (inList) {
                    formatted += '</ul>';
                    inList = false;
                }
                if (line.length > 0) {
                    formatted += '<p style="margin-bottom:6px;">' + line + '</p>';
                }
            }
        }
        if (inList) {
            formatted += '</ul>';
        }

        return formatted;
    }

    function renderMessages() {
        const container = document.getElementById('pmChatBody');
        if (!container) return;

        container.innerHTML = '';

        messages.forEach(function (msg, idx) {
            const row = document.createElement('div');
            row.className = 'pm-message-row ' + (msg.role === 'user' ? 'user' : 'bot');

            const bubble = document.createElement('div');
            bubble.className = 'pm-message-bubble';
            bubble.innerHTML = formatText(msg.text);

            row.appendChild(bubble);

            // Optional suggestion chips for greeting
            if (msg.showChips && idx === 0) {
                const chipsBox = document.createElement('div');
                chipsBox.className = 'pm-suggestions-container';
                QUICK_CHIPS.forEach(function (chipText) {
                    const chip = document.createElement('button');
                    chip.type = 'button';
                    chip.className = 'pm-chip';
                    chip.textContent = chipText;
                    chip.addEventListener('click', function () {
                        // Strip leading emoji
                        const cleanQuery = chipText.replace(/^[^\w\s]+\s*/, '');
                        sendMessage(cleanQuery);
                    });
                    chipsBox.appendChild(chip);
                });
                row.appendChild(chipsBox);
            }

            const timeSpan = document.createElement('div');
            timeSpan.className = 'pm-message-time';
            timeSpan.textContent = msg.time || '';
            row.appendChild(timeSpan);

            container.appendChild(row);
        });

        if (isWaiting) {
            const typingRow = document.createElement('div');
            typingRow.className = 'pm-message-row bot';
            typingRow.id = 'pmTypingIndicator';
            typingRow.innerHTML = '<div class="pm-typing-indicator"><div class="pm-dot"></div><div class="pm-dot"></div><div class="pm-dot"></div></div>';
            container.appendChild(typingRow);
        }

        scrollToBottom();
    }

    function sendMessage(userText) {
        if (!userText || isWaiting) return;

        // Add user message
        messages.push({
            role: 'user',
            text: userText,
            time: formatTime(new Date())
        });
        saveHistory();

        isWaiting = true;
        renderMessages();

        const sendBtn = document.getElementById('pmChatSendBtn');
        const input = document.getElementById('pmChatInput');
        if (sendBtn) sendBtn.disabled = true;
        if (input) input.disabled = true;

        fetch(chatApiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ message: userText })
        })
            .then(function (res) {
                if (res.status === 429) {
                    return res.json().then(function (data) {
                        const errMsg = (data && data.error && data.error.message)
                            ? data.error.message
                            : 'Rate limit exceeded (10 messages/min). Please wait a moment before sending another message.';
                        throw new Error(errMsg);
                    });
                }
                if (!res.ok) {
                    return res.json().then(function (data) {
                        const errMsg = (data && data.error && data.error.message) ? data.error.message : 'Server error occurred.';
                        throw new Error(errMsg);
                    }).catch(function () {
                        throw new Error('HTTP error ' + res.status);
                    });
                }
                return res.json();
            })
            .then(function (json) {
                let replyText = 'I received your request.';
                if (json && json.data && json.data.reply) {
                    replyText = json.data.reply;
                } else if (json && json.reply) {
                    replyText = json.reply;
                }

                messages.push({
                    role: 'bot',
                    text: replyText,
                    time: formatTime(new Date())
                });
                saveHistory();
            })
            .catch(function (err) {
                messages.push({
                    role: 'bot',
                    text: '⚠️ ' + err.message,
                    time: formatTime(new Date())
                });
                saveHistory();
            })
            .finally(function () {
                isWaiting = false;
                if (sendBtn) sendBtn.disabled = false;
                if (input) {
                    input.disabled = false;
                    input.focus();
                }
                renderMessages();
            });
    }

    // Auto-init on DOMContentLoaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
