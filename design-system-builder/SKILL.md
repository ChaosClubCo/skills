---
name: design-system-builder
description: >
  Build, audit, document, and extend cohesive design systems with design tokens, component libraries, Storybook integration, and governance workflows. This skill should be used when creating a company-wide design system from scratch, when components are visually inconsistent, when hardcoded hex values or px sizes are scattered across a codebase, when writing documentation for component variants and states, when adding a new pattern that must fit an existing system, or when preparing a component library for multi-brand or dark mode support. Also triggers on: design tokens, Style Dictionary, CVA, class variance authority, shadcn/ui customization, Tailwind token config, atomic design, dark mode token system, multi-brand theming, component API design, Storybook setup, Storybook stories, contribution workflow, component library governance, token drift audit, spacing scale, typography scale, color system, semantic tokens, primitive tokens, Figma tokens, accessible components, component documentation, "our components are inconsistent", token naming convention, CSS custom properties, theme switching, design system audit, "we need a component library".
license: MIT
---

# Design System Builder

Build a coherent, scalable design system. Three modes: **Build** (from scratch), **Audit** (existing system), **Extend** (add patterns).

## Token Architecture

Design tokens are the foundation. Use a 3-tier hierarchy:

```
Primitive tokens     →  Semantic tokens      →  Component tokens
------------------      ----------------         ----------------
--color-blue-500        --color-brand-primary    --button-bg
--space-4               --space-component-gap    --button-padding
--font-size-base        --text-body              --button-font-size
```

**Primitive tokens**: Raw values. Never used directly in components.
**Semantic tokens**: Purpose-mapped. Used in components.
**Component tokens**: Component-scoped overrides. Optional.

### Style Dictionary Config

```json
{
  "color": {
    "brand": {
      "primary": { "value": "{color.blue.500}" }
    }
  }
}
```

### Dark Mode Pattern

```css
:root { --color-surface: #ffffff; }
[data-theme="dark"] { --color-surface: #0f0f0f; }
```

## Component API Design

Every component needs a typed contract:

```ts
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'ghost' | 'destructive';
  size: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  children: React.ReactNode;
}
```

Use **CVA (class-variance-authority)** for variant-based styling:

```ts
const button = cva('base-classes', {
  variants: {
    variant: { primary: '...', secondary: '...' },
    size: { sm: '...', md: '...', lg: '...' }
  },
  defaultVariants: { variant: 'primary', size: 'md' }
});
```

## Storybook Documentation

Each component needs stories covering:
- Default state
- All variants and sizes
- Loading / disabled states
- Error states
- Edge cases (empty, overflow, truncation)

## Governance Checklist

**Before adding a new component:**
- [ ] Does a similar component already exist?
- [ ] Does it use only semantic tokens (no hardcoded hex/px)?
- [ ] Is it accessible (WCAG AA minimum)?
- [ ] Does it have Storybook stories for all states?
- [ ] Does it have TypeScript prop types?
- [ ] Does it work in dark mode?
- [ ] Does it work for all configured brands/themes?

## Audit Output Format

```
## Design System Health
Consistency Score: X/10
Token Coverage: X% components use tokens (vs hardcoded)

## Critical Gaps
- [Issue] in [Component] — [Impact]

## Token Drift
- [Component] uses hardcoded [value] → should use [token]
```
