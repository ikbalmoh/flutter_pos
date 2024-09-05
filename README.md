# Selleri POS

## Requirement

- Flutter 3.22.2
- Shorebird
- Makefile
- Firebase Tools

### Generate Provider or Model

- run `dart run build_runner build -d` or `dart run build_runner watch -d` once provider or model are changed

### Build APK Stage

add and fill following properties on android/key.properties

```
storePasswordStage=
keyPasswordStage=
keyAliasStage=
storeFileStage=
```

run following commain

```
make op=release platform=ios flavor=stage release_notes="describe about new feature or fixing issue in which part feature"
```

### Release Patch

add and fill following properties on android/key.properties

```
storePassword=
keyPassword=
keyAlias=
storeFile=
```

run following commain

```
make op=patch flavor=prod
```

## Available Flavor

- dev
- stage
- release

### Note for prod release

#### Android

Place .keystore file to android/app directory

Create android/key.properties file with following config
```
storePassword=
keyPassword=
keyAlias=
storeFile=
```
