# Contributing to tailwind_flutter

Thanks for your interest in contributing! This guide will help you get started.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/<your-username>/tailwind_flutter.git`
3. Create a feature branch: `git checkout -b feat/your-feature`
4. Install dependencies: `flutter pub get`

## Development Workflow

### Code Style

This project uses [very_good_analysis](https://pub.dev/packages/very_good_analysis) for linting. Before submitting:

```bash
dart format .
flutter analyze
```

### Running Tests

```bash
flutter test
```

To update golden files after intentional visual changes:

```bash
flutter test --update-goldens
```

### Project Structure

```
lib/
  src/
    tokens/       # Design token definitions (colors, spacing, etc.)
    extensions/   # Widget and Text extension methods
    styles/       # TwStyle and TwVariant composable styles
    theme/        # Theme integration (TwTheme, TwThemeData)
```

## Pull Requests

1. Keep PRs focused — one feature or fix per PR
2. Update `CHANGELOG.md` under an `## Unreleased` section
3. Add tests for new functionality
4. Ensure all CI checks pass (analyze, test, publish-check)
5. Write a clear PR description explaining *what* and *why*

### Commit Messages

Use conventional commits:

- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation only
- `refactor:` code change that neither fixes a bug nor adds a feature
- `test:` adding or updating tests
- `chore:` maintenance tasks

### Adding New Tokens

When adding new Tailwind design tokens:

1. Create or update the token file in `lib/src/tokens/`
2. Export it from `lib/tailwind_flutter.dart`
3. Add corresponding tests
4. Update the example app to demonstrate usage

## Reporting Issues

- Use the **Bug Report** template for bugs
- Use the **Feature Request** template for new ideas
- Search existing issues before creating a new one

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
