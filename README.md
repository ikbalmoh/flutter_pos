# Selleri POS

## Requirement

- Flutter 3.22.2
- Shorebird

## Flavor
- dev
- staging
- production

## Build APK Staging

```
shorebird release android --flavor staging  --flutter-version=3.22.2 --artifact apk
```

## Release Patch

```
shorebird patch android --flavor staging
```