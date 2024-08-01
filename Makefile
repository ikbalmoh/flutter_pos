.PHONY: all runner shorebird distribute release patch

# Default target
all: prompt

include .env

BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')
FVM_VER := $(shell grep '"flutter":' .fvmrc | awk '{print $$2}')
FLUTTER_VERSION := $(shell echo $(FVM_VER) | cut -d',' -f1)

test-cmd:
	@echo "platform : $(PLATFORM)" 
	@echo "flavor : $(FLAVOR)"
	@echo "add arg : $(ADD_ARG)"
	@echo "path : $(BUILD_PATH)"
	@echo "app id : $(APP_ID)"
	@echo "release notes : $(RELEASE_NOTES)"
	@echo "flutter version : $(FLUTTER_VERSION)"

prompt:
	@if [ -z "$(op)" ]; then \
		echo "Choose an operation patch(p) or release(r): "; \
		read op; \
	fi; \
	if [ "$$op" = "p" ] || [ "$$op" = "patch" ]; then \
		if [ -z "$(flavor)" ]; then \
			echo "Choose a flavor dev(d) or stage(s) or prod(p): "; \
			read flavor; \
		fi; \
		\
			case $$flavor in \
				d | dev) \
					flavor=dev \
					;; \
				s | stage) \
					flavor=staging \
					;; \
				p | prod) \
					flavor=production \
					;; \
				*) \
					echo -n "Invalid flavor. Please choose dev(d) or stage(s) or prod(p)" \
					exit 1 \
					;; \
			esac; \
		\
		make patch FLAVOR=$$flavor; \
	elif [ "$$op" = "r" ] || [ "$$op" = "release" ]; then \
		if [ -z "$(platform)" ]; then \
			echo "Choose a platform android(a) or ios(i): "; \
			read platform; \
		fi; \
		if [ "$$platform" = "i" ] || [ "$$platform" = "ios" ]; then \
			target_platform="ios"; \
			add_arg="--export-method ad-hoc"; \
			build_path=$(build_path_ios); \
		elif [ "$$platform" = "a" ] || [ "$$platform" = "android" ]; then \
			target_platform="android"; \
			add_arg="--artifact apk"; \
			build_path=$(build_path_android); \
		else \
			echo "Invalid platform. Please choose 'android' or 'ios'."; \
			exit 1; \
		fi; \
		\
		if [ -z "$(flavor)" ]; then \
			echo "Choose a flavor dev(d) or stage(s) or prod(p): "; \
			read flavor; \
		fi; \
		\
			case $$flavor in \
				d | dev) \
					flavor=dev \
					;; \
				s | stage) \
					flavor=staging \
					;; \
				p | prod) \
					flavor=production \
					;; \
				*) \
					echo -n "Invalid flavor. Please choose dev(d) or stage(s) or prod(p)" \
					exit 1 \
					;; \
			esac; \
		\
		if [ -z "$(release_notes)" ]; then \
			echo "Type release notes: "; \
			read release_notes; \
		fi; \
		\
		if [ $$target_platform = ios ]; then \
			build_path=$(BUILD_PATH_IOS); \
			case $$flavor in \
				dev) \
					app_id=$(APP_ID_IOS_DEV) \
					;; \
				staging) \
					app_id=$(APP_ID_IOS_STAGE) \
					;; \
				production) \
					app_id=$(APP_ID_IOS_PROD) \
					;; \
			esac; \
		else \
			build_path="$(BUILD_PATH_ANDROID)app-$$flavor-release.apk"; \
			case $$flavor in \
				dev) \
					app_id=$(APP_ID_ANDROID_DEV) \
					;; \
				staging) \
					app_id=$(APP_ID_ANDROID_STAGE) \
					;; \
				production) \
					app_id=$(APP_ID_ANDROID_PROD) \
					;; \
			esac; \
		fi; \
		\
		make release PLATFORM=$$target_platform FLAVOR=$$flavor ADD_ARG="$$add_arg" BUILD_PATH=$$build_path APP_ID=$$app_id RELEASE_NOTES="$$release_notes"; \
	else \
		echo "Invalid operation. Please choose 'patch' or 'release'."; \
		exit 1; \
	fi; \

runner:
	dart run build_runner build -d

shorebird:
	yes | shorebird release $(PLATFORM) --flavor $(FLAVOR) --flutter-version=$(FLUTTER_VERSION) $(ADD_ARG)

distribute:
	firebase appdistribution:distribute "$(BUILD_PATH)" --app $(APP_ID) --release-notes '$(RELEASE_NOTES)' --groups $(GROUP_TESTER)

release:
	@make runner
	@make shorebird
	@make distribute

patch: 
	yes | shorebird patch --platforms=android,ios  --flavor $(FLAVOR) --release-version $(BUILD_VERSION)"
