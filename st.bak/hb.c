#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <X11/Xft/Xft.h>
#include <hb.h>
#include <hb-ft.h>

#include "st.h"

static void hbtransformsegment(XftGlyphFontSpec *, const Glyph *, int);
hb_font_t *hbfindfont(XftFont *match);

typedef struct {
	XftFont *match;
	hb_font_t *font;
} HbFontMatch;

static int hbfontslen = 0;
static HbFontMatch *hbfontcache = NULL;

void
hbunloadfonts()
{
	for (int i = 0; i < hbfontslen; i++) {
		hb_font_destroy(hbfontcache[i].font);
		XftUnlockFace(hbfontcache[i].match);
	}

	if (hbfontcache != NULL) {
		free(hbfontcache);
		hbfontcache = NULL;
	}
	hbfontslen = 0;
}

hb_font_t *
hbfindfont(XftFont *match)
{
	for (int i = 0; i < hbfontslen; i++) {
		if (hbfontcache[i].match == match)
			return hbfontcache[i].font;
	}

	/* Font not found in cache, caching it now. */
	hbfontcache = xrealloc(hbfontcache, sizeof(HbFontMatch) * (hbfontslen + 1));
	FT_Face face = XftLockFace(match);
	hb_font_t *font = hb_ft_font_create(face, NULL);
	if (font == NULL)
		die("Failed to load Harfbuzz font.");

	hbfontcache[hbfontslen].match = match;
	hbfontcache[hbfontslen].font = font;
	hbfontslen += 1;

	return font;
}

void
hbtransform(XftGlyphFontSpec *specs, const Glyph *glyphs, size_t len, int x, int y)
{
	size_t start, end, specidx = 0, specstart;

	for (start = 0; start < len; start = end) {
		end = start + 1;
		if (glyphs[start].mode & ATTR_WDUMMY)
			continue;
		if (glyphs[start].mode & ATTR_BOXDRAW) {
			specidx++;
			continue;
		}

		specstart = specidx++;
		for (; end < len; end++) {
			if (glyphs[end].mode & ATTR_WDUMMY)
				continue;
			if ((glyphs[end].mode & ATTR_BOXDRAW) ||
			    specs[specidx].font != specs[specstart].font ||
			    ATTRCMP(glyphs[start], glyphs[end]) ||
			    selected(x + end, y) != selected(x + start, y))
				break;
			specidx++;
		}
		hbtransformsegment(specs + specstart, glyphs + start, end - start);
	}
}

static void
hbtransformsegment(XftGlyphFontSpec *specs, const Glyph *glyphs, int length)
{
	hb_font_t *font = hbfindfont(specs[0].font);
	if (font == NULL)
		return;

	Rune rune;
	unsigned int count;
	hb_buffer_t *buffer = hb_buffer_create();
	hb_buffer_set_direction(buffer, HB_DIRECTION_LTR);
	hb_buffer_set_content_type(buffer, HB_BUFFER_CONTENT_TYPE_UNICODE);
	hb_buffer_set_cluster_level(buffer, HB_BUFFER_CLUSTER_LEVEL_MONOTONE_CHARACTERS);

	/* Fill buffer with codepoints. */
	for (int i = 0; i < length; i++) {
		rune = glyphs[i].u;
		if (glyphs[i].mode & ATTR_WDUMMY)
			rune = 0x0020;
		hb_buffer_add(buffer, rune, i);
	}

	/* Shape the segment. */
	hb_shape(font, buffer, NULL, 0);

	/* This renderer has one spec per terminal character. Keep the original
	 * Xft glyphs if shaping merges, expands, or reorders cells. Never index
	 * shaped output using the input length without checking its size. */
	hb_glyph_info_t *info = hb_buffer_get_glyph_infos(buffer, &count);
	if (count != (unsigned int)length)
		goto cleanup;
	for (int i = 0; i < length; i++) {
		if (info[i].cluster != (unsigned int)i)
			goto cleanup;
	}

	for (int i = 0, specidx = 0; i < length; i++) {
		if (!(glyphs[i].mode & ATTR_WDUMMY))
			specs[specidx++].glyph = info[i].codepoint;
	}

cleanup:
	hb_buffer_destroy(buffer);
}
