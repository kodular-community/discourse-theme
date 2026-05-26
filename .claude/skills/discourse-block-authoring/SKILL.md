---
name: discourse-block-authoring
description: Use when creating, registering, or rendering Discourse block components in themes — covers the @block decorator, plugin API registration, outlets, conditions, container blocks, async data, and testing
---

# Discourse Block Authoring

Blocks are the modular UI composition system in Discourse. They allow themes to define self-contained Glimmer components that can be registered, conditionally shown, and rendered into named outlets throughout the app.

## Conventions

### File Structure

```
javascripts/discourse/
├── api-initializers/
│   ├── homepage-blocks.gjs       # one file per outlet
│   ├── hero-blocks.gjs
│   ├── sidebar-discovery-blocks.gjs
│   └── main-outlet-blocks.gjs
└── blocks/
    ├── block-hero.gjs             # always prefixed block-
    ├── block-featured-list.gjs
    └── block-leaderboard.gjs
```

- Block files are always named `block-*.gjs` inside `blocks/`
- Initializer files are named after the outlet they configure (e.g., `homepage-blocks.gjs`)
- **Exactly one initializer file per outlet, and exactly one outlet per initializer file.** Never call `api.renderBlocks()` for two different outlets in the same file. If you need to render into `main-outlet-blocks` and `homepage-blocks`, create two separate initializer files.

### Block Names

Block names follow a strict namespacing pattern:

| Context | Pattern                       | Example               |
| ------- | ----------------------------- | --------------------- |
| Core    | `block-name`                  | `group`, `head`       |
| Plugin  | `plugin-name:block-name`      | `chat:message-widget` |
| Theme   | `theme:theme-name:block-name` | `theme:tactile:hero`  |

Append `?` to mark a reference as optional (no error if not registered):

```javascript
{
  block: "chat:sidebar-widget?";
}
```

## Defining a Block

Use the `@block` decorator on a Glimmer component:

```javascript
import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import DButton from "discourse/components/d-button";

@block("theme:my-theme:hero", {
  description: "A hero banner with title, subtitle, and button",
  args: {
    title:       { type: "string" },
    subtitle:    { type: "string" },
    buttonLabel: { type: "string" },
    buttonLink:  { type: "string" },
    buttonIcon:  { type: "string" },
    image:       { type: "string" },
  },
})
export default class BlockHero extends Component {
  <template>
    <div class="block-hero__layout">
      {{#if @title}}<h1 class="block-hero__title">{{@title}}</h1>{{/if}}
      {{#if @buttonLink}}
        <DButton
          class="btn-primary"
          @icon={{@buttonIcon}}
          @href={{@buttonLink}}
          @translatedLabel={{@buttonLabel}}
        />
      {{/if}}
    </div>
  </template>
}
```

### Decorator Options

| Option                | Type                     | Description                                      |
| --------------------- | ------------------------ | ------------------------------------------------ |
| `description`         | string                   | Human-readable label                             |
| `args`                | object                   | Schema for block arguments                       |
| `childArgs`           | object                   | Schema for children args (container blocks only) |
| `container`           | boolean                  | Whether this block renders children              |
| `allowedOutlets`      | string[]                 | Restrict to specific outlets                     |
| `deniedOutlets`       | string[]                 | Exclude from specific outlets                    |
| `decoratorClassNames` | string \| string[] \| fn | Extra CSS classes on the wrapper                 |
| `constraints`         | object                   | Cross-arg validation rules                       |

### Args Schema

```javascript
args: {
  title:   { type: "string",  required: true },
  count:   { type: "number",  default: 5 },
  visible: { type: "boolean", default: true },
  variant: { type: "string",  oneOf: ["small", "large"] },
}
```

### Dynamic CSS Classes

`decoratorClassNames` can be a function that receives the block's args:

```javascript
@block("theme:my-theme:card", {
  args: {
    variant: { type: "string", oneOf: ["compact", "full"] },
  },
  decoratorClassNames: (args) => `--${args.variant}`,
})
```

### Constraints

Constraints validate relationships between args at registration time:

```javascript
@block("theme:my-theme:media", {
  args: {
    imageUrl: { type: "string" },
    videoUrl: { type: "string" },
    altText:  { type: "string" },
  },
  constraints: {
    atLeastOne: ["imageUrl", "videoUrl"],  // at least one must be provided
    atMostOne: ["imageUrl", "videoUrl"],   // no more than one
    requires: { altText: "imageUrl" },     // altText requires imageUrl
  },
})
```

Available constraint types: `atLeastOne`, `exactlyOne`, `allOrNone`, `atMostOne`, `requires`.

### Async Data

Use `AsyncContent` with a `@bind` fetch method for blocks that load data:

```javascript
import Component from "@glimmer/component";
import { service } from "@ember/service";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";

@block("theme:my-theme:leaderboard", {
  args: {
    count: { type: "number", default: 10 },
  },
})
export default class BlockLeaderboard extends Component {
  @service currentUser;

  @bind
  async fetchData() {
    const data = await ajax("/leaderboard", { data: { user_limit: this.args.count } });
    return data.users;
  }

  <template>
    <AsyncContent @asyncData={{this.fetchData}}>
      <:loading><div class="spinner" /></:loading>
      <:empty><p>No data</p></:empty>
      <:content as |users|>
        {{! render users }}
      </:content>
    </AsyncContent>
  </template>
}
```

## Rendering Blocks

Import block classes and pass them to `api.renderBlocks()` in an `apiInitializer`. Always use `apiInitializer` (not `apiPreInitializer`) for `renderBlocks` calls.

```javascript
import BlockGroup from "discourse/blocks/builtin/block-group";
import { apiInitializer } from "discourse/lib/api";
import BlockFeaturedList from "../blocks/block-featured-list";
import BlockLeaderboard from "../blocks/block-leaderboard";
import BlockPromo from "../blocks/block-promo";

export default apiInitializer((api) => {
  api.renderBlocks("homepage-blocks", [
    {
      block: BlockFeaturedList,
      id: "featured-list",
      args: {
        title: "Latest topics",
        count: 14,
        buttonLabel: "See all topics",
        buttonLink: "/latest",
      },
    },
    {
      block: BlockGroup,
      id: "main-right",
      children: [
        { block: BlockPromo, args: { title: "Ideas" } },
        {
          block: BlockLeaderboard,
          id: "homepage-leaderboard",
          args: { count: 10 },
        },
      ],
    },
  ]);
});
```

### Layout Entry Fields

| Field           | Description                                                                                                          |
| --------------- | -------------------------------------------------------------------------------------------------------------------- |
| `block`         | The block class (required)                                                                                           |
| `id`            | Stable identifier — use when there are multiple entries of the same block type, or when you need stable DOM identity |
| `args`          | Arguments passed to the block component                                                                              |
| `conditions`    | Single condition object OR array of conditions                                                                       |
| `children`      | Child entries for container blocks                                                                                   |
| `containerArgs` | Args passed by a parent container to a child                                                                         |

### Available Outlets

These core outlets are always available:

- `hero-blocks`
- `homepage-blocks`
- `main-outlet-blocks`
- `sidebar-blocks`
- `sidebar-discovery`

Plugins can register additional outlets via `api.registerBlockOutlet()`. Themes cannot register new outlets — they can only render into existing ones.

## Translations & Theme Settings

### Translations

Theme locale files (`locales/en.yml`) register keys under the theme's i18n namespace. In block templates, wrap the arg with `themePrefix` so the key resolves correctly:

```yaml
# locales/en.yml
en:
  homepage:
    banner:
      title: "Welcome"
      link_text: "Learn more"
```

```javascript
// In template:
{{i18n (themePrefix @sectionTitle)}}
{{i18n (themePrefix @linkText)}}
```

```javascript
// In the initializer — hardcode the i18n key as the arg value:
{
  block: BlockBanner,
  args: {
    sectionTitle: "homepage.banner.title",
    linkText: "homepage.banner.link_text",
    linkUrl: settings.banner[0]?.link_url,  // functional config from settings
  },
}
```

**Key rule:** Display strings (titles, labels) are hardcoded i18n keys in the initializer and resolved via `themePrefix` in the template. Functional values (URLs, counts, tags, filters) come from object settings. Do NOT put display strings in the settings schema.

Strings hardcoded directly in the template (not passed as args) also use `themePrefix`:

```javascript
{{i18n (themePrefix "homepage.featured_categories.topic_count") count=category.topic_count}}
```

### Theme Settings

Theme settings are available via the global `settings` object:

```javascript
args: {
  image: settings.hero_image;
}
```

## Conditions

`conditions` can be a **single object** or an **array** (AND logic):

```javascript
// Single condition (shorthand)
conditions: { type: "route", pages: ["HOMEPAGE"] }

// Multiple conditions (AND — all must pass)
conditions: [
  { type: "route", pages: ["CATEGORY_PAGES"] },
  { not: { type: "route", pages: ["HOMEPAGE"] } },
]
```

### Boolean Logic

```javascript
// OR — use { any: [...] }
{ any: [
  { type: "user", admin: true },
  { type: "user", moderator: true },
]}

// NOT — use { not: {...} }
{ not: { type: "route", pages: ["CATEGORY_PAGES"] } }

// Combined (AND + NOT)
conditions: [
  { type: "route", pages: ["TAG_PAGES"] },
  { not: { type: "route", pages: ["CATEGORY_PAGES"] } },
]
```

### Route Condition

Match by semantic page type, URL pattern, route params, or query params.

**Page types** match semantic contexts without requiring knowledge of URL structure:

| Page Type         | Description                                                 | Available Params                                          |
| ----------------- | ----------------------------------------------------------- | --------------------------------------------------------- |
| `HOMEPAGE`        | Custom homepage only                                        | (none)                                                    |
| `CATEGORY_PAGES`  | Category listing pages                                      | `categoryId`, `categorySlug`, `parentCategoryId`          |
| `TAG_PAGES`       | Tag listing pages                                           | `tagId`, `categoryId`, `categorySlug`, `parentCategoryId` |
| `DISCOVERY_PAGES` | Discovery routes (latest, top, etc.) excluding homepage     | `filter`                                                  |
| `TOP_MENU`        | Top nav discovery routes (excludes category, tag, homepage) | `filter`                                                  |
| `TOPIC_PAGES`     | Individual topic pages                                      | `id`, `slug`                                              |
| `USER_PAGES`      | User profile pages                                          | `username`                                                |
| `ADMIN_PAGES`     | Admin section pages                                         | (none)                                                    |
| `GROUP_PAGES`     | Group pages                                                 | `name`                                                    |

```javascript
// Match homepage
{ type: "route", pages: ["HOMEPAGE"] }

// Match multiple page types (OR logic)
{ type: "route", pages: ["CATEGORY_PAGES", "TAG_PAGES"] }

// Match specific category by ID
{ type: "route", pages: ["CATEGORY_PAGES"], params: { categoryId: 5 } }

// Match specific category by slug
{ type: "route", pages: ["CATEGORY_PAGES"], params: { categorySlug: "support" } }

// URL glob patterns (picomatch syntax: *, **, ?, [abc], {a,b})
{ type: "route", urls: ["/c/general/**", "/c/ideas/**"] }

// Combined pages + urls (either must match)
{ type: "route", pages: ["TOP_MENU"], urls: ["/tags"] }

// With query params (route AND query must both match)
{ type: "route", urls: ["/latest"], queryParams: { filter: "solved" } }

// Params support any/not operators
{ type: "route", pages: ["CATEGORY_PAGES"], params: {
  any: [{ categorySlug: "support" }, { categorySlug: "help" }]
}}
```

URL matching automatically handles Discourse subfolder installations — patterns like `/c/**` work regardless of whether Discourse runs on `/forum` or root.

### User Condition

Match by user state. All specified conditions use AND logic. When `source` is provided, checks a user object from outlet args instead of the current user.

```javascript
// Logged-in users only
{ type: "user", loggedIn: true }

// Anonymous users only
{ type: "user", loggedIn: false }

// Admin users
{ type: "user", admin: true }

// Moderators (includes admins)
{ type: "user", moderator: true }

// Staff (admin or moderator)
{ type: "user", staff: true }

// Trust level range
{ type: "user", minTrustLevel: 2 }
{ type: "user", minTrustLevel: 1, maxTrustLevel: 3 }

// Group membership (OR logic — user must be in at least one)
{ type: "user", groups: ["beta-testers", "power-users"] }

// Combined (AND): trust level 2+ AND in group
{ type: "user", minTrustLevel: 2, groups: ["beta-testers"] }

// Check a user from outlet args
{ type: "user", source: "@outletArgs.topicAuthor", admin: true }

// Check if source user IS the current user
{ type: "user", source: "@outletArgs.post.user", loggedIn: true }
```

### Setting Condition

Match by site setting or theme setting values. Supports multiple check types:

| Check         | Setting Type          | Question                                   |
| ------------- | --------------------- | ------------------------------------------ |
| `enabled`     | Boolean               | Is the setting truthy/falsy?               |
| `equals`      | Any                   | Does the setting exactly equal this value? |
| `includes`    | Single value (enum)   | Is the setting value IN my list?           |
| `contains`    | List (pipe-separated) | Does the setting list CONTAIN my value?    |
| `containsAny` | List (pipe-separated) | Does the list contain ANY of my values?    |

```javascript
// Boolean setting
{ type: "setting", name: "enable_badges", enabled: true }

// Exact match
{ type: "setting", name: "desktop_category_page_style", equals: "categories_and_latest_topics" }

// Setting is one of several values
{ type: "setting", name: "desktop_category_page_style",
  includes: ["categories_and_latest_topics", "categories_and_top_topics"] }

// List setting contains value
{ type: "setting", name: "top_menu", contains: "hot" }

// List setting contains any of values
{ type: "setting", name: "share_links", containsAny: ["twitter", "facebook"] }

// Theme setting (pass settings object as source)
{ type: "setting", source: settings, name: "show_sidebar", enabled: true }
```

### Viewport Condition

Match by screen size using breakpoints (`sm`, `md`, `lg`, `xl`, `2xl`) and touch capability. For simple show/hide, prefer CSS media queries via the viewport SCSS library — use this condition when you need to remove components from the DOM entirely.

```javascript
// Large screens only (lg and up)
{ type: "viewport", min: "lg" }

// Small screens only (below sm)
{ type: "viewport", max: "sm" }

// Medium to large screens
{ type: "viewport", min: "md", max: "xl" }

// Touch devices only
{ type: "viewport", touch: true }

// Non-touch large screens
{ type: "viewport", min: "lg", touch: false }
```

At least one of `min`, `max`, or `touch` must be specified.

### Outlet Arg Condition

Match on args passed via `@outletArgs` using dot-notation paths:

```javascript
{ type: "outlet-arg", name: "post.staff", value: true }
```

## Container Blocks

Container blocks render children. Two built-in containers are available:

### BlockGroup — Render All Children

Use `BlockGroup` for simple grouping. It renders all children whose conditions pass:

```javascript
import BlockGroup from "discourse/blocks/builtin/block-group";

{
  block: BlockGroup,
  id: "main-right",
  children: [
    { block: BlockPromo, args: { title: "Promo" } },
    { block: BlockLeaderboard, args: { count: 5 } },
  ],
}
```

Groups can be nested — `BlockGroup` inside `BlockGroup` is a common layout pattern.

### BlockHead — Render First Matching Child

Use `BlockHead` for if/else fallback logic. It renders only the first child whose conditions pass:

```javascript
import BlockHead from "discourse/blocks/builtin/block-head";

{
  block: BlockHead,
  children: [
    // Show support panel for support category
    {
      block: InfoPanel,
      args: { variant: "support" },
      conditions: { type: "route", pages: ["CATEGORY_PAGES"], params: { categorySlug: "support" } },
    },
    // Show dev panel for dev category
    {
      block: InfoPanel,
      args: { variant: "dev" },
      conditions: { type: "route", pages: ["CATEGORY_PAGES"], params: { categorySlug: "dev" } },
    },
    // Default fallback (no conditions = always matches)
    { block: InfoPanel, args: { variant: "default" } },
  ],
}
```

### Custom Containers

For custom containers, use `container: true` and render `@children`:

```javascript
@block("theme:my-theme:card-grid", {
  container: true,
  childArgs: {
    featured: { type: "boolean", default: false },
  },
})
export default class CardGrid extends Component {
  <template>
    <div class="card-grid">
      {{#each @children key="key" as |child|}}
        <div class="card-grid__item {{if child.containerArgs.featured "--featured"}}">
          <child.Component />
        </div>
      {{/each}}
    </div>
  </template>
}
```

## Testing

Use the test helpers from `discourse/tests/helpers/block-testing`:

```javascript
import {
  registerBlock,
  resetBlockRegistryForTesting,
} from "discourse/tests/helpers/block-testing";

module("My block tests", function (hooks) {
  hooks.beforeEach(() => registerBlock(MyBlock));
  hooks.afterEach(() => resetBlockRegistryForTesting());
});
```

## Common Mistakes

| Mistake                                            | Fix                                                                                                                                                    |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Calling `renderBlocks` in a pre-initializer        | Move to a plain `apiInitializer`                                                                                                                       |
| Using `<MyBlock />` directly in a template         | Only `<BlockOutlet>` can render blocks                                                                                                                 |
| Forgetting namespace in block name                 | Theme blocks must be `theme:theme-name:block-name`                                                                                                     |
| Trying to register a custom outlet from a theme    | Themes cannot register outlets — only plugins can (requires pre-initializer phase)                                                                     |
| Conditions array with OR logic using a plain array | Use `{ any: [...] }` for OR; plain array is always AND                                                                                                 |
| Multiple blocks of same type without `id`          | Add `id` to each entry for stable DOM identity                                                                                                         |
| Using `sizes` in viewport condition                | Use `min`/`max` breakpoints: `{ type: "viewport", min: "lg" }`                                                                                         |
| Using `trust_level` in user condition              | Use `minTrustLevel`/`maxTrustLevel` (camelCase, separate min/max)                                                                                      |
| Using `enabled` alone in setting condition         | Always include `name`: `{ type: "setting", name: "...", enabled: true }`                                                                               |
| Multiple outlets in one initializer file           | Never call `renderBlocks()` for different outlets in the same file. One file = one outlet. Create separate initializer files named after their outlet. |
