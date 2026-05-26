# Icons Reference

Discourse uses Font Awesome 6 Free (solid, regular, brands) plus custom Discourse icons by default. Sites can optionally use Lucide icons via the `discourse-lucide-icons` theme component.

Icons not in the default set must be added via `svg_icons` in `about.json`:

```json
{
  "modifiers": {
    "svg_icons": ["chart-line", "wand-magic-sparkles", "far-face-grin"]
  }
}
```

## Default Font Awesome Icons

### Solid (no prefix)

a, address-book, address-card, align-left, anchor, angle-down, angle-left, angle-right, angle-up, angles-down, angles-left, angles-right, arrow-down, arrow-left, arrow-right, arrow-rotate-left, arrow-rotate-right, arrow-up, arrows-rotate, asterisk, at, backward, backward-fast, backward-step, ban, bars, bars-staggered, bed, bell, bell-slash, bold, book, book-open-reader, bookmark, bookmark-delete, box-archive, briefcase, bullseye, calendar-days, caret-down, caret-left, caret-right, caret-up, certificate, chart-bar, chart-pie, check, chevron-down, chevron-left, chevron-right, chevron-up, circle, circle-check, circle-chevron-down, circle-exclamation, circle-half-stroke, circle-info, circle-minus, circle-plus, circle-question, circle-user, circle-xmark, clock, clock-rotate-left, cloud-arrow-down, cloud-arrow-up, code, code-branch, comment, compress, copy, crosshairs, cube, cubes, desktop, diagram-project, download, earth-americas, ellipsis, ellipsis-vertical, envelope, eye, eye-dropper, eye-slash, file, file-lines, filter, flag, flask, folder, folder-open, font, forward, forward-fast, forward-step, gavel, gear, gift, globe, grip-lines, hand-point-right, handshake-angle, hashtag, heart, hourglass-start, house, id-card, image, images, inbox, italic, key, keyboard, language, layer-group, left-right, link, link-slash, list, list-check, list-ol, list-ul, location-dot, lock, magnifying-glass, magnifying-glass-minus, magnifying-glass-plus, microphone-slash, minus, mobile-screen-button, moon, paintbrush, palette, paper-plane, pause, pen, pencil, play, plug, plus, power-off, puzzle-piece, question, quote-left, quote-right, reply, right-from-bracket, right-left, right-to-bracket, robot, rocket, rotate, screwdriver-wrench, scroll, share, shield-halved, shuffle, signal, sign-hanging, sliders, spinner, square-check, square-envelope, square-full, square-plus, star, sun, table, table-cells, table-cells-minus, table-cells-plus, table-columns, tag, tags, temperature-three-quarters, thumbs-down, thumbs-up, thumbtack, toggle-off, toggle-on, trash-can, triangle-exclamation, truck-medical, unlock, unlock-keyhole, up-down, up-right-from-square, upload, user, user-check, user-gear, user-group, user-pen, user-plus, user-secret, user-shield, user-xmark, users, wand-magic, wrench, xmark

### Regular (far- prefix)

far-bell, far-bell-slash, far-bookmark, far-calendar-plus, far-chart-bar, far-circle, far-circle-dot, far-clipboard, far-clock, far-comment, far-comments, far-copyright, far-envelope, far-eye, far-eye-slash, far-face-frown, far-face-meh, far-face-smile, far-file-lines, far-heart, far-image, far-moon, far-pen-to-square, far-rectangle-list, far-square, far-square-check, far-star, far-sun, far-thumbs-down, far-thumbs-up, far-trash-can

### Brands (fab- prefix)

fab-android, fab-apple, fab-chrome, fab-discord, fab-discourse, fab-facebook, fab-facebook-square, fab-github, fab-google, fab-instagram, fab-linkedin-in, fab-linux, fab-markdown, fab-microsoft, fab-threads, fab-threads-square, fab-twitter, fab-twitter-square, fab-x-twitter, fab-wikipedia-w, fab-windows

### Discourse Custom (discourse- prefix)

discourse-amazon, discourse-bell-exclamation, discourse-bell-one, discourse-bell-slash, discourse-bookmark-clock, discourse-chevron-collapse, discourse-chevron-expand, discourse-compress, discourse-dnd, discourse-emojis, discourse-expand, discourse-flask-check, discourse-other-tab, discourse-sidebar, discourse-sparkles, discourse-table, discourse-text, discourse-threads, discourse-chat-search, discourse-add-translation, discourse-h1, discourse-h2, discourse-h3, discourse-h4, discourse-h5

## Lucide Icons

The [discourse-lucide-icons](https://github.com/discourse/discourse-lucide-icons) theme component replaces Font Awesome icons with the stroke-based [Lucide](https://lucide.dev/) icon set. It ships an SVG sprite sheet and uses `api.replaceIcon()` to map ~250 standard Font Awesome names to their Lucide equivalents automatically.

**Theme authors don't need to do anything special.** Just use the standard Font Awesome icon names (e.g., `heart`, `gear`, `magnifying-glass`) — the component handles the replacement transparently at runtime.

### Settings

| Setting         | Type | Default                        | Description                                                                                    |
| --------------- | ---- | ------------------------------ | ---------------------------------------------------------------------------------------------- |
| `stroke_width`  | enum | `medium`                       | Line thickness: `extra-thin` (1), `thin` (1.5), `medium` (2), `thick` (2.5), `extra-thick` (3) |
| `ignored_icons` | list | `d-liked\|square-full\|circle` | FA icon names to skip (keep the original FA icon instead)                                      |
