# Template quality checklist

Use this checklist before adding or releasing a template.

## Build and behavior

- [ ] Opens in the documented Xcode version.
- [ ] Builds without source changes.
- [ ] Runs without a backend, account, or secret.
- [ ] Includes deterministic mock data.
- [ ] Has no compiler warnings introduced by the template.
- [ ] Loading, empty, and error states exist when the feature needs them.

## Design

- [ ] Glass is limited to navigation, controls, menus, or overlays.
- [ ] Content remains readable over bright and dark backgrounds.
- [ ] System controls are used when they already solve the interaction.
- [ ] Light and dark appearance are reviewed when supported.
- [ ] Motion communicates state without delaying the user.

## Accessibility

- [ ] VoiceOver labels describe interactive controls.
- [ ] Selection is not communicated by color alone.
- [ ] Hit targets are at least 44 points.
- [ ] Dynamic Type does not clip essential labels.
- [ ] Reduce Motion and Reduce Transparency are usable.

## Documentation

- [ ] README explains requirements and opening steps.
- [ ] Public API has a copy-paste example.
- [ ] Customization points are documented.
- [ ] Screenshots or GIFs match the current code.
- [ ] The template has no private branding, credentials, or data.
