/* Run with make test (uses an isolated X server via xvfb-run). */
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xft/Xft.h>

#include "../st.h"
#include "../hb.h"

static int selection = -1;

int
selected(int x, int y)
{
	(void)y;
	return x == selection;
}

void
die(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);
	exit(1);
}

void *
xrealloc(void *ptr, size_t size)
{
	void *result = realloc(ptr, size);
	if (!result)
		die("allocation failed\n");
	return result;
}

static void
check(Display *dpy, XftFont *font, Glyph *glyphs, int len)
{
	XftGlyphFontSpec specs[32], original[32];
	Glyph saved[32];
	int n = 0;

	assert(len <= 32);
	memcpy(saved, glyphs, len * sizeof(*glyphs));
	for (int i = 0; i < len; i++) {
		if (glyphs[i].mode & ATTR_WDUMMY)
			continue;
		specs[n] = (XftGlyphFontSpec){font,
		    glyphs[i].mode & ATTR_BOXDRAW ? 1234 :
		    XftCharIndex(dpy, font, glyphs[i].u), i * 10, 20};
		n++;
	}
	memcpy(original, specs, n * sizeof(*specs));
	hbtransform(specs, glyphs, len, 0, 0);
	for (int i = 0; i < n; i++) {
		if (specs[i].glyph != original[i].glyph)
			die("cell %d: expected glyph %u, got %u\n", i,
			    original[i].glyph, specs[i].glyph);
		assert(specs[i].font == original[i].font);
		assert(specs[i].x == original[i].x);
		assert(specs[i].y == original[i].y);
	}
	assert(!memcmp(saved, glyphs, len * sizeof(*glyphs)));
}

static void
checkfont(Display *dpy, const char *name)
{
	XftFont *font = XftFontOpenName(dpy, DefaultScreen(dpy), name);
	assert(font);

	/* Composition shrinks HarfBuzz's output. Trailing text must not shift. */
	Glyph composed[] = {{.u = 'a'}, {.u = 0x0301}, {.u = 'Z'}};
	check(dpy, font, composed, LEN(composed));
	/* Redraws must produce identical results and leave terminal cells intact. */
	check(dpy, font, composed, LEN(composed));

	Glyph plain[] = {{.u = 'A'}, {.u = 'B'}, {.u = 'Z'}};
	check(dpy, font, plain, LEN(plain));
	selection = 1;
	check(dpy, font, plain, LEN(plain));
	selection = -1;
	Glyph symbols[] = {{.u = 0xf15b}, {.u = 0xe0b0}, {.u = 'Z'}};
	check(dpy, font, symbols, LEN(symbols));
	check(dpy, font, symbols, LEN(symbols));

	Glyph wide[] = {{.u = 0x4e00, .mode = ATTR_WIDE},
	    {.mode = ATTR_WDUMMY}, {.u = 'Z'}};
	check(dpy, font, wide, LEN(wide));
	/* Partial draws can start with a wide-character dummy cell. */
	check(dpy, font, wide + 1, LEN(wide) - 1);
	check(dpy, font, wide + 1, 1);
	wide[1].mode |= ATTR_BOLD;
	check(dpy, font, wide, LEN(wide));

	Glyph boxes[] = {{.u = 0x2500, .mode = ATTR_BOXDRAW}, {.u = 'Z'}};
	check(dpy, font, boxes, LEN(boxes));
	hbtransform(NULL, NULL, 0, 0, 0);

	hbunloadfonts();
	check(dpy, font, plain, LEN(plain));
	hbunloadfonts();
	XftFontClose(dpy, font);
}

int
main(void)
{
	Display *dpy = XOpenDisplay(NULL);
	if (!dpy)
		die("cannot open test display\n");
	checkfont(dpy, "monospace:pixelsize=20");
	checkfont(dpy, "IosvMata-Regular:pixelsize=20");
	checkfont(dpy, "IosvMata-Regular:pixelsize=20:weight=bold");
	checkfont(dpy, "Iosevka Nerd Font:pixelsize=20");
	XCloseDisplay(dpy);
	FcFini();
	puts("HarfBuzz rendering regressions passed");
	return 0;
}
