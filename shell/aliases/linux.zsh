function open() {
	xdg-open "${@:-}" </dev/null >/dev/null 2>&1 \
		& disown
}