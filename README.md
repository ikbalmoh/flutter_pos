# Selleri POS

## Requirement

- Flutter 3.22.2
- Shorebird

### Generate Provider or Model

- run `dart run build_runner build -d` or `dart run build_runner watch -d` once provider or model are changed

### Build APK Staging

```
shorebird release android --flavor staging  --flutter-version=3.22.2 --artifact apk
```

### Release Patch

```
shorebird patch android --flavor [flavorName]
```


## Available Flavor

- dev
- staging
- release
