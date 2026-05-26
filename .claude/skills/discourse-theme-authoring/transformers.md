# Transformers Reference

Transformers let themes modify values and behavior used by core components without patching core code.

## Value Transformers

Register in an api-initializer. The callback receives the current `value` and a `context` object, and must return the (possibly modified) value:

```javascript
api.registerValueTransformer("transformer-name", ({ value, context }) => {
  return transformedValue;
});
```

### All Value Transformers (84)

| Transformer | Description |
|-------------|-------------|
| `admin-onboarding-start-posting-options` | Admin onboarding posting options |
| `admin-plugin-icon` | Plugin icon in admin |
| `admin-reports-show-query-params` | Report query parameters |
| `bulk-select-in-nav-controls` | Bulk select in navigation |
| `category-available-views` | Available category views |
| `category-default-colors` | Default category colors |
| `category-description-text` | Category description text |
| `category-display-name` | Category display name |
| `category-sort-orders` | Category sort orders |
| `category-text-color` | Category text color |
| `composer-editor-quoted-post-avatar-template` | Quoted post avatar in composer |
| `composer-editor-reply-placeholder` | Composer reply placeholder text |
| `composer-force-editor-mode` | Force composer editor mode |
| `composer-message-components` | Composer message components |
| `composer-reply-options-user-avatar-template` | Reply options avatar |
| `composer-reply-options-user-link-name` | Reply options user link name |
| `composer-save-button-label` | Composer save button label |
| `composer-service-cannot-submit-post` | Composer submit validation |
| `composer-toggles-class` | Composer toggles CSS class |
| `create-topic-button-class` | Create topic button CSS class |
| `create-topic-label` | Create topic button label |
| `flag-button-disabled-state` | Flag button disabled state |
| `flag-button-dynamic-class` | Flag button CSS class |
| `flag-button-render-decision` | Flag button render decision |
| `flag-custom-placeholder` | Custom flag placeholder |
| `flag-description` | Flag description text |
| `flag-formatted-name` | Flag formatted name |
| `hamburger-dropdown-click-outside-exceptions` | Hamburger click-outside exceptions |
| `header-notifications-avatar-size` | Header notification avatar size |
| `home-logo-href` | Home logo link URL |
| `home-logo-image-url` | Home logo image URL |
| `home-logo-minimized` | Home logo minimized state |
| `invite-simple-mode-topic` | Invite simple mode topic |
| `latest-topic-list-item-class` | Latest topic list item CSS class |
| `like-button-render-decision` | Like button render decision |
| `mentions-class` | Mentions CSS class |
| `more-topics-tabs` | More topics tabs |
| `move-to-topic-merge-options` | Move-to-topic merge options |
| `move-to-topic-move-options` | Move-to-topic move options |
| `navigation-bar-dropdown-icon` | Navigation bar dropdown icon |
| `navigation-bar-dropdown-mode` | Navigation bar dropdown mode |
| `navigation-items` | Navigation items |
| `notifications-tracking-description` | Notification tracking description |
| `parent-category-row-class` | Parent category row CSS class |
| `parent-category-row-class-mobile` | Parent category row mobile CSS class |
| `post-article-class` | Post article CSS class |
| `post-avatar-class` | Post avatar CSS class |
| `post-avatar-size` | Post avatar size |
| `post-avatar-template` | Post avatar template |
| `post-class` | Post CSS class |
| `post-event-listener` | Post event listener |
| `post-flag-available-flags` | Available post flags |
| `post-flag-title` | Post flag title |
| `post-menu-buttons` | Post menu buttons |
| `post-menu-collapsed` | Post menu collapsed state |
| `post-menu-like-button-icon` | Post menu like button icon |
| `post-meta-data-edits-indicator-label` | Post edits indicator label |
| `post-meta-data-infos` | Post metadata infos |
| `post-meta-data-poster-name-suppress-similar-name` | Suppress similar poster name |
| `post-notice-component` | Post notice component |
| `post-share-url` | Post share URL |
| `post-show-topic-map` | Show topic map |
| `post-small-action-class` | Small action CSS class |
| `post-small-action-custom-component` | Small action custom component |
| `post-small-action-icon` | Small action icon |
| `poster-name-class` | Poster name CSS class |
| `poster-name-icons` | Poster name icons |
| `poster-name-user-title` | Poster name user title |
| `preferences-save-attributes` | Preferences save attributes |
| `quote-params` | Quote parameters |
| `route-to-url` | Route-to URL |
| `small-user-attrs` | Small user attributes |
| `tag-separator` | Tag separator |
| `topic-list-class` | Topic list CSS class |
| `topic-list-columns` | Topic list columns |
| `topic-list-header-sortable-column` | Topic list sortable column header |
| `topic-list-item-class` | Topic list item CSS class |
| `topic-list-item-expand-pinned` | Topic list expand pinned |
| `topic-list-item-mobile-layout` | Topic list item mobile layout |
| `topic-list-item-style` | Topic list item style |
| `topic-url-for-post-number` | Topic URL for post number |
| `user-field-components` | User field components |
| `user-menu-notification-item-acting-user-avatar` | User menu notification avatar |
| `user-notes-modal-subtitle` | User notes modal subtitle |
| `welcome-banner-display-for-route` | Welcome banner route display |

## Behavior Transformers

Behavior transformers wrap core logic with chainable callbacks. Call `next()` to continue the chain; omitting `next()` completely overrides the default behavior:

```javascript
api.registerBehaviorTransformer("transformer-name", ({ next, context }) => {
  // Optionally do something before
  const result = next();
  // Optionally do something after
  return result;
});
```

### All Behavior Transformers (9)

| Transformer |
|-------------|
| `composer-position:correct-scroll-position` |
| `composer-position:editor-touch-move` |
| `discovery-topic-list-load-more` |
| `full-page-search-load-more` |
| `post-menu-toggle-like-action` |
| `post-stream-error-loading` |
| `post-stream-update-from-json` |
| `topic-controller:finished-editing` |
| `topic-list-item-click` |
