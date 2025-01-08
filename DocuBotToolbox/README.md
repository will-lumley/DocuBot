# DocuBotToolbox

## What does DocuBotToolbox do?
 
DocuBotToolbox is a foundational module for the DocuBot macOS application, providing essential utilities, extensions, and abstractions to support the core functionality of the app. It includes reusable components such as progress tracking, string manipulation, feature flagging, and more.

## Features

🛠️ Core Utilities
- Date Extensions: Easily manipulate and format Date objects.
- String Utilities: Checksum generation, prefix/suffix trimming, and regex-based operations.
- Progress Tracking: Track progress with a lightweight Progress struct.

🚩 Feature Flag Support
- Integration with Vexil for managing feature flags in a structured and flexible way.

🧪 Testing Support
- Includes mock data and utilities to simplify unit testing across the app.

📦 Type-Safe Resources
- Utilises SwiftGen for type-safe access to assets like strings, images, and colors.

## Dependencies

This module relies on the following libraries:
- SwiftGen: Type-safe access to assets.
- Vexil: Feature flag management.
