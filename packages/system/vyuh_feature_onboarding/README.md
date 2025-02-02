<p align="center">
  <a href="https://vyuh.tech">
    <img src="https://github.com/vyuh-tech.png" alt="Vyuh Logo" height="128" />
  </a>
  <h1 align="center">Vyuh Framework</h1>
  <p align="center">Build Modular, Scalable, CMS-driven Flutter Apps</p>
  <p align="center">
    <a href="https://docs.vyuh.tech">Docs</a> |
    <a href="https://vyuh.tech">Website</a>
  </p>
</p>

# Vyuh Feature Onboarding 🎯

[![vyuh_feature_onboarding](https://img.shields.io/pub/v/vyuh_feature_onboarding.svg?label=vyuh_feature_onboarding&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_feature_onboarding)

Onboarding feature for Vyuh applications, providing a flexible and customizable
onboarding experience. This package includes content-driven onboarding screens
with step-by-step guidance, rich text descriptions, and image support.

## Features ✨

- **Content-driven Onboarding** 📝: Customizable onboarding content using
  Sanity.io CMS
- **Step-by-step Flow** 🔄: Support for multiple onboarding steps with
  navigation
- **Rich Text Support** 📖: Markdown-style rich text for step descriptions
- **Image Integration** 🖼️: Support for images in onboarding steps
- **Action Integration** 🔗: Built-in actions for navigation and completion

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_feature_onboarding: any
```

## Usage 💡

### Feature Registration

Register the onboarding feature in your Vyuh application setup:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:vyuh_feature_onboarding/vyuh_feature_onboarding.dart' as onboarding;

void main() {
  vyuh.runApp(
    initialLocation: '/',
    plugins: _getPlugins(),
    features: () => [
      onboarding.feature,
      // ... other features
    ],
  );
}
```

### Content Examples 🎯

#### Basic Onboarding

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:vyuh_feature_onboarding/vyuh_feature_onboarding.dart' as onboarding;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

// Create and render an onboarding flow
final content = onboarding.OnboardingContent(
  steps: [
    onboarding.OnboardingStep(
      title: 'Welcome to Vyuh',
      description: PortableTextContent([
        PortableTextBlock(
          children: [
            PortableTextSpan(
              text: 'Build beautiful Flutter apps with content-driven UI',
            ),
          ],
        ),
      ]),
      image: ImageReference(
        ref: 'welcome-image.jpg',
        dimensions: ImageDimensions(width: 300, height: 200),
      ),
    ),
    onboarding.OnboardingStep(
      title: 'Content Management',
      description: PortableTextContent([
        PortableTextBlock(
          children: [
            PortableTextSpan(
              text: 'Manage your content with Sanity.io CMS',
            ),
          ],
        ),
      ]),
      image: ImageReference(
        ref: 'cms-image.jpg',
        dimensions: ImageDimensions(width: 300, height: 200),
      ),
    ),
  ],
  doneAction: Action(
    title: 'Get Started',
    configurations: [
      system.NavigationAction(
        navigationType: system.NavigationType.replace,
        linkType: system.LinkType.url,
        url: '/dashboard',
      ),
    ],
  ),
);

// Render in a widget
class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vyuh.content.buildContent(context, content),
    );
  }
}
```

#### Custom Layout

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:vyuh_feature_onboarding/vyuh_feature_onboarding.dart' as onboarding;

// Create onboarding with custom layout
final content = onboarding.OnboardingContent(
  steps: [
    onboarding.OnboardingStep(
      title: 'Custom Layout Example',
      description: PortableTextContent([
        PortableTextBlock(
          children: [
            PortableTextSpan(
              text: 'This step uses a custom layout',
            ),
          ],
        ),
      ]),
    ),
  ],
  layout: YourCustomOnboardingLayout(),
);

// Render in a widget
vyuh.content.buildContent(context, content);
```

## Content Types 📝

The onboarding feature provides the following content types:

- `vyuh.content.onboarding` 🎯: Main onboarding content type with steps and
  navigation

Each content type comes with its own layout configuration and can be customized
through Sanity.io CMS.

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for
  source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
