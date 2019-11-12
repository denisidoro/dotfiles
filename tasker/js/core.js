function randomLine(text) {
    const lines = text.split('\n');
    return lines[Math.floor(Math.random() * lines.length)];
}