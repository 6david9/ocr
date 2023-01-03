# Description

Extract text from image using MacOS system framework.

# Build

```
swift package update

swift build -c release

swift run --skip-build ocr <path-to-image>
```

# Usage

```
ocr <path-to-image>
```

```
ocr --show-supported-languages
```

```
ocr --lang "zh-Hans" <path-to-image>
```
