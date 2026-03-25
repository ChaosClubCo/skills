---
name: algorithmic-art
description: >
  Create original generative and algorithmic art using p5.js with seeded randomness and interactive parameter controls. Use this skill when the user asks to create generative art, procedural art, creative code, or any interactive p5.js visualization. Also triggers on: make me some art with code, generative art, creative coding, parametric art, particle system art, noise-based art, computational aesthetics, procedural visuals, make a living algorithm, emergent patterns, mathematical art, seeded random art, interactive art generator, algorithmic aesthetic, p5.js sketch, fractal visualization, organic noise patterns, generative piece, code-driven art, algorithmic composition.
---

# Algorithmic Art Creation Skill

This skill enables creation of original generative art using p5.js with seeded randomness. The process follows a two-phase approach: first developing an algorithmic philosophy (computational aesthetic movement), then expressing it through interactive code.

## Core Process

**Phase 1: Algorithmic Philosophy**
- Create a named generative aesthetic movement (1-2 words)
- Write 4-6 paragraphs articulating the computational vision
- Emphasize how the philosophy manifests through noise functions, particle behavior, mathematical relationships, and emergent complexity
- Stress craftsmanship repeatedly—the final algorithm should appear meticulously refined by a master

**Phase 2: p5.js Implementation**
- Build a self-contained HTML artifact using `templates/viewer.html` as the foundation
- Embed the complete algorithm inline (no external files except p5.js CDN)
- Include seeded randomness for reproducibility
- Design parameters that emerge naturally from the philosophy

## Critical Requirements

**Philosophy Development**
- Avoid redundancy—mention each algorithmic aspect once
- Emphasize expert craftsmanship and painstaking optimization repeatedly
- Leave creative space for interpretive implementation
- Focus on process over final frame

**HTML Implementation**
- Start from `templates/viewer.html`—this is mandatory, not optional
- Keep ALL fixed sections unchanged: header, sidebar structure, Anthropic colors/fonts, seed controls, action buttons
- Replace ONLY variable sections: algorithm code, parameters, UI controls
- Maintain complete self-containment—everything runs in one HTML file

## Parameter Structure

Parameters should control core system properties:
- Quantities (particle counts, iterations)
- Scales (sizes, speeds, distances)
- Probabilities (occurrence likelihood)
- Ratios (proportions, relationships)
- Angles (directions, rotations)
- Thresholds (behavioral triggers)

## Sidebar Organization (Fixed)

1. **Seed section**: Display, Previous/Next, Random, Jump-to-seed
2. **Parameters section**: Custom sliders/inputs for the specific algorithm
3. **Colors section** (optional): Include only if art needs adjustable palettes
4. **Actions section**: Regenerate, Reset, Download buttons

## Implementation Philosophy

The algorithm flows from the philosophy—not from pattern menus. If the philosophy emphasizes organic emergence, build accumulating elements with constrained randomness. If it emphasizes mathematical beauty, use geometric relationships and trigonometric functions.

Quality markers:
- Balance complexity without visual noise
- Thoughtful color harmony
- Visual hierarchy even in randomness
- Smooth performance
- Reproducible results from seeds

## Output Deliverables

1. **Algorithmic Philosophy** (.md format): 4-6 substantial paragraphs describing the computational worldview
2. **Interactive HTML Artifact**: Self-contained, works immediately in any browser, includes all p5.js code, controls, and UI

## Key Principles

- **Process over product**: Beauty emerges from algorithm execution; each run is unique
- **Parametric expression**: Ideas communicate through mathematical relationships and behaviors, not static composition
- **Artistic freedom**: Philosophy provides direction; implementation allows creative interpretation
- **Pure generative art**: Create living algorithms, not randomized static images
- **Expert craftsmanship**: Every parameter carefully tuned, every pattern purposeful

The final work should feel like the product of countless iterations by someone at the absolute top of computational aesthetics.
