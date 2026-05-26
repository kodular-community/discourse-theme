---
name: discourse-theme-authoring
description: Use when creating, developing, or modifying Discourse themes and theme components — covers scaffolding, SCSS architecture, BEM CSS, viewport design, localization, settings, icons, value transformers, theme modifiers, and CSS variables
---

# Discourse Theme Authoring

Themes and theme components are the primary way to customize Discourse's appearance and behavior without modifying core code. Themes can include SCSS stylesheets, JavaScript/Glimmer components, locale files, settings, and assets.

For detailed reference data, see the sibling files in this directory:
- `css-variables.md` — All ~400 CSS custom properties
- `icons.md` — Default icon list and icon system details
- `transformers.md` — All value and behavior transformers

## Scaffolding a New Theme

**Always use the `discourse_theme` CLI to scaffold a new theme or component. Never create theme files manually unless the user explicitly asks.**

First, confirm the details with the user:
1. **Theme name** (defaults to directory name)
2. **Is this a component?** (Y/n — default Y, answer `n` for a full theme)
3. **Author** (defaults to "Discourse")
4. **Description**
5. **Start watching?** (Y/n — usually `n` during development)

Then run with piped answers:

```bash
printf 'Theme Name\nn\nAuthor Name\nTheme description here\nn\n' | discourse_theme new /path/to/my-theme
```

It clones from the `discourse-theme-skeleton` repo, customizes files based on the answers, initializes git, and runs `pnpm install`.

### Generated Structure

```
my-theme/
├── about.json                  # Theme metadata (required)
├── settings.yml                # Theme settings schema
├── locales/
│   └── en.yml                  # i18n translations
├── javascripts/
│   └── discourse/
│       └── api-initializers/
│           └── my-theme.gjs    # Theme initializer
├── common/
│   └── common.scss             # Common styles entry point
├── stylesheets/                # Additional SCSS files (importable)
├── assets/                     # Static assets (images, fonts)
├── spec/                       # Ruby system tests
├── test/                       # JS acceptance tests
├── .discourse-compatibility    # Version mapping
├── eslint.config.mjs
├── stylelint.config.mjs
├── .prettierrc.cjs
├── .template-lintrc.cjs
└── package.json
```

### about.json

```json
{
  "name": "My Theme",
  "component": false,
  "authors": "Discourse",
  "about_url": null,
  "license_url": null,
  "theme_version": "0.0.1",
  "minimum_discourse_version": null,
  "maximum_discourse_version": null,
  "assets": {},
  "color_schemes": {},
  "modifiers": {},
  "screenshots": []
}
```

For theme components, set `"component": true` and remove `color_schemes`.

### Color Schemes

Full themes can define color schemes in `about.json`. These appear in the admin color scheme picker and set the core color variables:

```json
{
  "color_schemes": {
    "My Light Theme": {
      "primary": "333333",
      "secondary": "ffffff",
      "tertiary": "0088cc",
      "quaternary": "e45735",
      "header_background": "ffffff",
      "header_primary": "333333",
      "highlight": "ffff4d",
      "danger": "e45735",
      "success": "009900",
      "love": "fa6c8d"
    },
    "My Dark Theme": {
      "primary": "dddddd",
      "secondary": "222222",
      "tertiary": "0088cc",
      "quaternary": "e45735",
      "header_background": "111111",
      "header_primary": "dddddd",
      "highlight": "ffff4d",
      "danger": "e45735",
      "success": "009900",
      "love": "fa6c8d"
    }
  }
}
```

Color values are hex without the `#` prefix. These 10 base colors generate the full set of color scale variables (`--primary-low`, `--tertiary-hover`, etc.).

To restrict the color scheme picker to only this theme's schemes, use:

```json
{
  "modifiers": {
    "only_theme_color_schemes": true
  }
}
```

## SCSS Architecture

Follow this pattern for all themes. **No code in `common.scss` — only imports.** Every top-level folder in `stylesheets/` has an `_index.scss` file.

### Directory Structure

```
common/
└── common.scss          # Only imports, no rules
stylesheets/
├── brand/
│   ├── _index.scss      # @import "fonts"; @import "colors";
│   ├── fonts.scss
│   └── colors.scss
├── app/
│   ├── _index.scss      # @import "variables"; @import "header"; ...
│   ├── variables.scss
│   ├── header.scss
│   ├── sidebar.scss
│   ├── buttons.scss
│   └── topic-list.scss
├── blocks/
│   ├── _index.scss      # @import "block-hero"; @import "block-featured-list"; ...
│   ├── block-hero.scss
│   └── block-featured-list.scss
└── layouts/
    ├── _index.scss      # @import "homepage"; @import "sidebar-discovery";
    ├── homepage.scss
    └── sidebar-discovery.scss
```

### common.scss

```scss
@use "lib/viewport";
@import "brand";
@import "app";
@import "blocks";
@import "layouts";
```

Rules:
- `common.scss` imports top-level folders only, never individual files
- Each folder's `_index.scss` imports all files within that folder
- Adding a new file only requires updating that folder's `_index.scss`
- Only `_index.scss` files use the underscore prefix — regular SCSS files do not

## BEM CSS Conventions

Discourse uses a modified BEM variant for CSS. All theme styles must follow these conventions.

### Syntax

- **Block**: A standalone component. One BEM block per Ember component. Example: `.topic-card`
- **Element**: A part of a block, joined with `__`. Example: `.topic-card__title`
- **Modifier**: Changes appearance, written as a separate `--` prefixed class. Example: `--featured`

### Nesting in SCSS

Use `&` to visually nest elements under their block. This keeps related styles together and makes them easy to collapse:

```scss
.topic-card {
  display: flex;
  gap: var(--space-3);

  &__title {
    font-size: var(--font-up-1);
    font-weight: 700;
  }

  &__excerpt {
    color: var(--primary-medium);
    line-height: var(--line-height-large);
  }

  &__meta {
    display: flex;
    gap: var(--space-2);
  }

  // Modifier applied directly to element
  &__title.--highlighted {
    color: var(--tertiary);
  }

  // Modifier on the block affects children
  &.--compact {
    gap: var(--space-1);
  }

  // Indirect modifier: style children when block has modifier
  .--featured & {
    border-left: 3px solid var(--tertiary);
  }
}
```

### State Prefixes

For conditional states, use `is-` and `has-` prefixes:

```scss
.sidebar-panel {
  &.is-open { display: block; }
  &.is-collapsed { display: none; }
  &.has-errors { border-color: var(--danger); }
}
```

### HTML Usage

```html
<div class="topic-card --featured">
  <h3 class="topic-card__title --highlighted">Title</h3>
  <p class="topic-card__excerpt">...</p>
  <div class="topic-card__meta">...</div>
</div>
```

### Key Rules

- One BEM block per reusable component
- Blocks can contain other blocks
- Elements belong to their block only — never use `.block-a__element` inside `.block-b`
- Modifiers are standalone classes (`--modifier`), not chained to the element name
- Prefer indirect modifiers (on the parent block) over repeating modifiers on every child

## Viewport Library

**Never use raw CSS media queries.** Use the viewport library from Discourse core.

### SCSS Mixins

If `common.scss` already has `@use "lib/viewport"`, all `@import`ed files inherit the namespace — no per-file import needed. Otherwise, add `@use "lib/viewport"` at the top of the file that uses it.

```scss
@include viewport.from(lg) {
  // Applies at lg (1024px) and larger
}

@include viewport.until(sm) {
  // Applies below sm (640px)
}

@include viewport.between(sm, md) {
  // Applies between sm (640px) and md (768px)
}
```

### Breakpoints

| Breakpoint | Size   | Pixels (at 16px base) |
|------------|--------|-----------------------|
| sm         | 40rem  | 640px                 |
| md         | 48rem  | 768px                 |
| lg         | 64rem  | 1024px                |
| xl         | 80rem  | 1280px                |
| 2xl        | 96rem  | 1536px                |

### JavaScript (Advanced Cases)

For conditional rendering in components, use the capabilities service:

```gjs
import Component from "@glimmer/component";
import { service } from "@ember/service";

class MyComponent extends Component {
  @service capabilities;

  <template>
    {{#if this.capabilities.viewport.lg}}
      Only shown on lg and larger
    {{/if}}
  </template>
}
```

### Touch Detection

```scss
html.discourse-touch {
  // Touch devices (phones, tablets, touch laptops)
}

html.discourse-no-touch {
  // Non-touch devices
}
```

## Localized Strings

### Locale File Structure

`locales/en.yml`:

```yaml
en:
  theme_metadata:
    description: "My theme description"
    settings:
      my_setting: "Description of my_setting"
  homepage:
    welcome: "Welcome to our community"
    topic_count:
      one: "%{count} topic"
      other: "%{count} topics"
```

### Using Theme Strings in Templates

`themePrefix` is automatically injected in `.gjs` files — no import needed. It resolves the key under the theme's namespace (`theme_translations.{themeId}.{key}`).

```gjs
import { i18n } from "discourse-i18n";

<template>
  {{! Theme string via themePrefix }}
  {{i18n (themePrefix "homepage.welcome")}}

  {{! Pluralized theme string }}
  {{i18n (themePrefix "homepage.topic_count") count=@topicCount}}

  {{! Passing theme string key to a component }}
  <DButton @label={{theme-prefix "homepage.welcome"}} />
</template>
```

### Using Core Strings

Reference core i18n strings directly without `themePrefix`:

```gjs
import { i18n } from "discourse-i18n";

<template>
  {{! Core string — no themePrefix }}
  {{i18n "topic.create"}}
</template>
```

## Theme Settings

Settings are defined in `settings.yml` at the theme root. Type is auto-detected from the default value unless explicitly set.

### Setting Types

#### Integer

```yaml
max_items:
  type: integer
  default: 5
  min: 1
  max: 20
```

#### Float

```yaml
opacity:
  type: float
  default: 0.8
  min: 0.0
  max: 1.0
```

#### String

```yaml
heading_text:
  default: "Welcome"

custom_css_class:
  default: ""
  min: 0
  max: 50

bio_text:
  default: ""
  textarea: true
```

#### Bool

```yaml
show_banner: true

show_sidebar:
  default: false
```

#### Enum

```yaml
layout_style:
  type: enum
  default: grid
  choices:
    - grid
    - list
    - cards
```

#### List

Pipe-separated values. The `list_type` controls the admin UI widget.

| `list_type` | UI Widget | Description |
|-------------|-----------|-------------|
| (omitted) | Text field | Plain text input, pipe-separated |
| `compact` | Dropdown with choices | Select from predefined `choices` |
| `simple` | Tag-style input | Add/remove free-form text items |
| `category` | Category selector | Pick categories from the site |
| `tag` | Tag chooser | Pick tags from the site |
| `group` | Group selector | Pick groups from the site |
| `emoji` | Emoji picker | Pick emojis |

```yaml
# Plain list (default)
featured_tags:
  type: list
  default: "announcements|support|feedback"

# Compact list with predefined choices
layout_options:
  type: list
  list_type: compact
  default: "grid|list"

# Category picker
homepage_categories:
  type: list
  list_type: category
  default: ""

# Tag picker
featured_tags:
  type: list
  list_type: tag
  default: ""

# Simple (tag-style free-form input)
contact_fields:
  type: list
  list_type: simple
  default: "email|phone"
```

#### Upload

Stores a file upload. The value is a CDN URL in JavaScript.

```yaml
hero_image:
  type: upload
  default: ""
```

#### Objects

Structured data with schema validation. Stored as JSON. Max 0.5 MB.

```yaml
navigation_links:
  type: objects
  default:
    - label: "Home"
      url: "/"
      icon: "house"
    - label: "About"
      url: "/about"
      icon: "circle-info"
  schema:
    name: link
    properties:
      label:
        type: string
        required: true
        validations:
          min_length: 1
          max_length: 100
      url:
        type: string
        required: true
        validations:
          url: true
      icon:
        type: string
```

**Object property types:** `string`, `integer`, `float`, `boolean`, `datetime`, `upload`, `enum`, `categories`, `groups`, `tags`, `objects` (nested).

**Validations by type:**
- `string`: `min_length`, `max_length`, `url` (boolean)
- `integer`/`float`: `min`, `max`
- `categories`/`groups`/`tags`: `min`, `max` (item count)

### Accessing Settings in JavaScript

The `settings` object is automatically injected in theme `.gjs` files:

```javascript
// In an api-initializer:
const heroImage = settings.hero_image;
const links = settings.navigation_links;
```

### Setting Descriptions in Locales

```yaml
en:
  theme_metadata:
    settings:
      show_banner: "Toggle the hero banner on the homepage"
      navigation_links: "Configure the navigation links"
```

## Theme Modifiers

Modifiers are declared in the `modifiers` key of `about.json`. They affect server-side behavior.

### Boolean Modifiers

| Modifier | Default | Description |
|----------|---------|-------------|
| `serialize_topic_excerpts` | false | Include excerpts when serializing topic lists |
| `custom_homepage` | null | Enable custom homepage for this theme |
| `serialize_topic_op_likes_data` | null | Include OP likes data in topic serialization |
| `serialize_topic_is_hot` | null | Include "is hot" status in topic serialization |
| `only_theme_color_schemes` | null | Restrict color scheme picker to this theme's schemes |

### String Array Modifiers

| Modifier | Description |
|----------|-------------|
| `csp_extensions` | Additional Content Security Policy directives |
| `svg_icons` | Icon names to include in the icon subset |
| `serialize_post_user_badges` | Badge names to serialize alongside post data |

### Complex Modifiers

| Modifier | Description |
|----------|-------------|
| `topic_thumbnail_sizes` | Additional thumbnail resolutions (format: `["800x600"]`) |

### Example

```json
{
  "modifiers": {
    "serialize_topic_excerpts": true,
    "custom_homepage": true,
    "svg_icons": ["star", "rocket", "chart-line", "far-comments"],
    "topic_thumbnail_sizes": ["400x300"]
  }
}
```

### Setting-Dependent Modifiers

Pull modifier values from a theme setting:

```json
{
  "modifiers": {
    "serialize_topic_excerpts": {
      "type": "setting",
      "value": "enable_excerpts"
    }
  }
}
```

## Font Awesome Icons

Discourse uses Font Awesome 6 Free (solid, regular, brands) plus custom Discourse icons. See `icons.md` for the full default icon list.

### Icon Name Conventions

| Style | Prefix | Example |
|-------|--------|---------|
| Solid | (none) | `heart`, `star`, `house` |
| Regular | `far-` | `far-heart`, `far-star` |
| Brands | `fab-` | `fab-github`, `fab-discord` |
| Discourse custom | `discourse-` | `discourse-sparkles` |

### Adding Non-Default Icons

For any icon not in the default set, add it to `svg_icons` in `about.json`:

```json
{
  "modifiers": {
    "svg_icons": ["chart-line", "wand-magic-sparkles", "far-face-grin"]
  }
}
```

### Custom SVG Icons

Upload a custom SVG sprite file as a theme asset with variable name `icons-sprite`. Icons are registered using their `<symbol>` IDs.

### Icon Replacement

Replace icons globally via the plugin API:

```javascript
api.replaceIcon("heart", "thumbs-up");
```

## Value and Behavior Transformers

Transformers let themes modify values and behavior used by core components. See `transformers.md` for the full list.

### Value Transformers

Register in an api-initializer. The callback receives the current `value` and `context`:

```javascript
api.registerValueTransformer("transformer-name", ({ value, context }) => {
  return transformedValue;
});
```

Commonly used value transformers for theming:

| Transformer | Use Case |
|-------------|----------|
| `home-logo-href` | Change where the logo links |
| `home-logo-image-url` | Swap the logo image |
| `topic-list-columns` | Add/remove/reorder topic list columns |
| `topic-list-item-class` | Add CSS classes to topic list rows |
| `post-menu-buttons` | Customize post action buttons |
| `navigation-items` | Modify top navigation tabs |
| `create-topic-label` | Change the "New Topic" button text |
| `category-display-name` | Customize category name rendering |

### Behavior Transformers

Wrap core logic with chainable callbacks. Call `next()` to continue the chain; omit it to override:

```javascript
api.registerBehaviorTransformer("topic-list-item-click", ({ next, context }) => {
  if (context.topic.pinned) {
    // Custom handling for pinned topics
    return;
  }
  next();
});
```

## CSS Variables

Discourse defines ~400 CSS custom properties. Override them in your theme's SCSS. See `css-variables.md` for the full listing.

Key variable categories and examples:

```scss
// Core colors
--primary, --secondary, --tertiary, --quaternary, --danger, --success

// Spacing (base unit: 0.25rem)
--space-1 through --space-12

// Typography
--font-up-1 through --font-up-6, --font-down-1 through --font-down-6
--font-family, --heading-font-family

// Layout
--d-max-width, --d-sidebar-width, --d-border-radius

// Component-specific
--d-button-{variant}-bg-color, --d-input-border, --d-nav-color
--d-topic-list-title-font-size, --d-sidebar-link-color
```

## Testing

Themes include a system spec at `spec/system/core_features_spec.rb` that runs shared examples from Discourse core to verify basic functionality (login, topic creation, search, etc.) still works with the theme active.

### Core Features Spec

The generated spec looks like:

```ruby
RSpec.describe "Core features" do
  before { upload_theme_or_component }

  it_behaves_like "having working core features"
end
```

### Skipping Examples

If the theme intentionally changes behavior that causes a core features test to fail (e.g., a custom homepage without a Create Topic button), skip that example rather than removing the entire spec:

```ruby
RSpec.describe "Core features" do
  before { upload_theme_or_component }

  it_behaves_like "having working core features",
                  skip_examples: %i[topics:create]
end
```

Available skip keys: `login`, `likes`, `profile`, `topics`, `topics:read`, `topics:reply`, `topics:create`, `search`, `search:quick_search`, `search:full_page`.

To find the right key, look in core's `spec/support/shared_examples/core_features.rb` for the `skip_examples.exclude?` guard around the failing example.

Only skip examples when the failure is caused by intentional theme behavior, not actual bugs.

## Key Files Reference

| Area | Path |
|------|------|
| Theme modifier definitions | `app/models/theme_modifier_set.rb` |
| Theme settings model | `app/models/theme_setting.rb` |
| Settings type managers | `lib/theme_settings_manager/*.rb` |
| SVG sprite / icon system | `lib/svg_sprite.rb` |
| Icon library (frontend) | `frontend/discourse/app/lib/icon-library.js` |
| Viewport SCSS library | `app/assets/stylesheets/lib/viewport.scss` |
| Capabilities service (viewport JS) | `frontend/discourse/app/services/capabilities.js` |
| Color definitions | `app/assets/stylesheets/color_definitions.scss` |
| Plugin API (transformers) | `frontend/discourse/app/lib/plugin-api.gjs` |
| Transformer system | `frontend/discourse/app/lib/transformer.js` |
| BEM CSS guidelines | `docs/developer-guides/docs/03-code-internals/25-css-guidelines-bem.md` |
| Theme docs | `docs/developer-guides/docs/05-themes-components/` |
| themePrefix helper | `frontend/discourse/app/helpers/theme-prefix.js` |
| theme-i18n helper | `frontend/discourse/app/helpers/theme-i18n.js` |
