# CSS Variables Reference

Discourse defines ~400 CSS custom properties. Override them in your theme's SCSS to customize appearance. These are applied at the `:root` level and cascade throughout the application.

```scss
// In your theme SCSS:
:root {
  --d-sidebar-width: 300px;
  --d-border-radius: 6px;
}
```

## Core Colors

```
--primary, --secondary, --tertiary, --quaternary
--header_background, --header_primary
--highlight, --danger, --success, --love
--d-selected, --d-selected-hover, --d-hover
```

## Color Scales

```
--primary-very-low, --primary-low, --primary-low-mid, --primary-medium,
--primary-high, --primary-very-high
--primary-50 through --primary-900

--secondary-low, --secondary-medium, --secondary-high, --secondary-very-high

--tertiary-very-low, --tertiary-low, --tertiary-medium, --tertiary-high, --tertiary-hover
--tertiary-50 through --tertiary-900

--highlight-bg, --highlight-low, --highlight-medium, --highlight-high
--danger-low, --danger-low-mid, --danger-medium, --danger-hover
--success-low, --success-medium, --success-hover
--love-low
```

## Typography

```
--base-font-size, --base-font-size-smallest, --base-font-size-smaller,
--base-font-size-larger, --base-font-size-largest

--font-up-1 through --font-up-6
--font-0
--font-down-1 through --font-down-6

--line-height-small, --line-height-medium, --line-height-large
--font-family, --heading-font-family, --d-font-family--monospace
```

## Spacing

```
--space (base unit: 0.25rem / 4px)
--space-half (2px)
--space-1 through --space-12
```

## Buttons

```
--d-button-border, --d-button-border-radius, --d-button-transition

Each variant (default, primary, danger, success, flat, transparent):
--d-button-{variant}-text-color, --d-button-{variant}-text-color--hover
--d-button-{variant}-bg-color, --d-button-{variant}-bg-color--hover
--d-button-{variant}-icon-color, --d-button-{variant}-icon-color--hover
--d-button-{variant}-border, --d-button-{variant}-border--hover
```

## Inputs

```
--d-input-bg-color, --d-input-text-color, --d-input-border, --d-input-border-radius
--d-input-bg-color--disabled, --d-input-text-color--disabled, --d-input-border--disabled
--d-input-focused-color
```

## Navigation

```
--d-nav-color, --d-nav-color--hover, --d-nav-color--active
--d-nav-bg-color, --d-nav-bg-color--hover, --d-nav-bg-color--active
--d-nav-border-color--active, --d-nav-underline-height, --d-nav-font-size
```

## Header

```
--d-header-icon-color, --d-header-icon-color--hover, --d-header-icon-color--active
--d-header-icon-background--hover, --d-header-icon-background--active
--d-header-padding-x, --d-logo-height
```

## Sidebar

```
--d-sidebar-width, --d-sidebar-background, --d-sidebar-border-color
--d-sidebar-link-color, --d-sidebar-link-icon-color
--d-sidebar-highlight-background, --d-sidebar-highlight-color
--d-sidebar-active-background, --d-sidebar-active-color
--d-sidebar-active-icon-color, --d-sidebar-active-font-weight
--d-sidebar-row-height, --d-sidebar-row-horizontal-padding
```

## Layout & Content

```
--d-content-background, --d-max-width, --d-wrap-padding-x, --d-main-content-gap
--d-link-color, --d-link-text-decoration
--d-border-radius, --d-border-radius-large
```

## Topic List

```
--d-topic-list-avatar-size, --d-topic-list-title-font-size
--d-topic-list-data-padding-y, --d-topic-list-data-padding-x
--d-topic-list-header-background-color, --d-topic-list-header-text-color
--d-topic-list-margin-y, --d-topic-list-margin-x
```

## Post Controls

```
--d-post-aside-background, --d-post-aside-border-left
--d-post-control-background--hover, --d-post-control-border-radius
--d-post-control-icon-color, --d-post-control-icon-color--hover
```

## Tags

```
--d-tag-background-color, --d-tag-border-radius, --d-tag-font-size,
--d-tag-font-weight, --d-tag-horizontal-padding
```

## Shadows

```
--shadow-modal, --shadow-composer, --shadow-card, --shadow-dropdown
--shadow-menu-panel, --shadow-header, --shadow-footer-nav
```

## Code Highlighting

```
--hljs-attr, --hljs-attribute, --hljs-addition, --hljs-bg, --inline-code-bg
--hljs-comment, --hljs-deletion, --hljs-keyword, --hljs-title, --hljs-name
--hljs-string, --hljs-symbol, --hljs-variable, --hljs-punctuation
```
