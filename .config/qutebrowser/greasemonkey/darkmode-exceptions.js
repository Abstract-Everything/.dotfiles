// ==UserScript==
// @match https://dev.epicgames.com/community/*
// @match https://forums.unrealengine.com/*
// ==/UserScript==

const meta = document.createElement('meta');
meta.name = "color-scheme";
meta.content = "dark light";
document.head.appendChild(meta);
