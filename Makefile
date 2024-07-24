.PHONY: all

all: prompt

app_id_android_dev="1:957311922583:android:3cf6cde1763ae2a62794d2"
app_id_android_stage="1:957311922583:android:beaea6232a392c9c2794d2"
app_id_ios_dev="1:957311922583:ios:41c668332f306ec92794d2"
app_id_ios_stage="1:957311922583:ios:0ee684f7ac559e142794d2"
group_tester="dgti"
build_path_android="build/app/outputs/flutter-apk"
build_path_ios="build/ios/ipa"

prompt:
	@echo "Choose an operation patch(p) or release(r): "; \
	read op; \
	if [ "$$op" = "p" ] || [ "$$op" = "patch" ]; then \
		operation="patch"; \
	elif [ "$$op" = "r" ] || [ "$$op" = "release" ]; then \
		operation="release"; \
	else \
		echo "Invalid operation. Please choose 'patch' or 'release'."; \
		exit 1; \
	fi; \
	\
	echo "Choose a platform android(a) or ios(i): "; \
	read platform; \
	if [ "$$platform" = "a" ] || [ "$$platform" = "android" ]; then \
		target_platform="android"; \
		artifact="--artifact apk"; \
		build_path=$(build_path_android); \
	elif [ "$$platform" = "i" ] || [ "$$platform" = "ios" ]; then \
		target_platform="ios"; \
		artifact="--export-method ad-hoc"; \
		build_path=$(build_path_ios); \
	else \
		echo "Invalid platform. Please choose 'android' or 'ios'."; \
		exit 1; \
	fi; \
	\
	echo "Choose a flavor dev(d) or stage(s) or prod(p): "; \
	read flavor; \
	if [ "$$flavor" = "d" ] || [ "$$flavor" = "dev" ]; then \
		target_flavor="dev"; \
		if [ "$$target_platform" = "ios" ]; then \
			build_path="$$build_path/selleri.ipa" ; \
			app_id="$(app_id_ios_dev)"; \
		else \
			build_path="$$build_path/app-dev-release.apk" ; \
			app_id="$(app_id_android_dev)"; \
		fi; \
	elif [ "$$flavor" = "s" ] || [ "$$flavor" = "stage" ]; then \
		target_flavor="staging"; \
		if [ "$$target_platform" = "ios" ]; then \
			build_path="$$build_path/selleri.ipa" ;\
			app_id="$(app_id_ios_stage)"; \
		else \
			build_path="$$build_path/app-staging-release.apk" ;\
			app_id="$(app_id_android_stage)"; \
		fi; \
	elif [ "$$flavor" = "p" ] || [ "$$flavor" = "prod" ]; then \
		target_flavor="production"; \
	else \
		echo "Invalid flavor. Please choose 'dev', 'stage', or 'prod'."; \
		exit 1; \
	fi; \
	\
	if [ "$$operation" = "release" ] && [ "$$target_flavor" != "production" ] ; then \
		echo "Distribute app (yes/no): "; \
		read distribute; \
		if [ "$$distribute" = "y" ] || [ "$$distribute" = "yes" ]; then \
			distribute="true"; \
		elif [ "$$distribute" = "n" ] || [ "$$distribute" = "no" ]; then \
			distribute="false"; \
		else \
			echo "Invalid command. Please choose 'yes(y)' or 'no(n)'."; \
			exit 1; \
		fi; \
		\
		if [ "$$distribute" = "true" ]; then \
			echo "Type release notes: "; \
			read release_note; \
			release_notes=$$release_note; \
		fi; \
	fi; \
	\
	echo "Run dart build (yes/no): "; \
	read build; \
	if [ "$$build" = "y" ] || [ "$$build" = "yes" ]; then \
		dart_build="true"; \
	elif [ "$$build" = "n" ] || [ "$$build" = "no" ]; then \
		dart_build="false"; \
	else \
		echo "Invalid command. Please choose 'yes(y)' or 'no(n)'."; \
		exit 1; \
	fi; \
	\
	if [ "$$dart_build" = "true" ]; then \
		dart run build_runner build -d && yes | shorebird $$operation $$target_platform --flavor $$target_flavor --flutter-version=3.22.2 $$artifact; \
	else \
		yes | shorebird $$operation $$target_platform --flavor $$target_flavor --flutter-version=3.22.2 $$artifact; \
	fi; \
	\
	if [ "$$distribute" = "true" ]; then \
		make distribute APP_PATH=$$build_path APP_ID=$$app_id RELEASE_NOTES="$$release_notes" GROUP_TESTER="$(group_tester)"; \
	fi; \
	\

distribute:
	firebase appdistribution:distribute $(APP_PATH) --app $(APP_ID) --release-notes '$(RELEASE_NOTES)' --groups $(GROUP_TESTER)
