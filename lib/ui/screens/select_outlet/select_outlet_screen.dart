import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_list_state.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'outlet_item.dart';
import 'package:selleri/providers/outlet/outlet_list_provider.dart';

class SelectOutletScreen extends ConsumerStatefulWidget {
  const SelectOutletScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectOutletScreenState();
}

class _SelectOutletScreenState extends ConsumerState<SelectOutletScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    ref.read(outletListNotifierProvider.notifier).fetchOutletList();
    super.initState();
  }

  void onSelectOutlet(Outlet outlet) {
    ref.read(outletNotifierProvider.notifier).selectOutlet(outlet,
        onSelected: (config) => context.setLocale(config.locale == 'en'
            ? const Locale('en', 'US')
            : const Locale('id', 'ID')));
  }

  ListView buildOutletLists(BuildContext context, List<Outlet> outlets) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: outlets.length,
      itemBuilder: (context, index) {
        Outlet outlet = outlets[index];
        return OutletItem(outlet: outlet, onSelect: onSelectOutlet);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final outletState = ref.watch(outletNotifierProvider);
    final state = ref.watch(outletListNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.teal.shade400,
      body: outletState.value is OutletLoading
          ? const PreparingOutlet()
          : state is OutletListFailure
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      state.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CompanyIcon(),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.5),
                          color: Colors.white,
                          border: Border.all(width: 0.5, color: Colors.black12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.shade600,
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 17.5, vertical: 15),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Text("select_outlet".tr(),
                                  style: textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w500)),
                            ),
                            state is OutletListLoaded
                                ? buildOutletLists(context, state.outlets)
                                : const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 50),
                                    child: LoadingIndicator(
                                      color: Colors.teal,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class CompanyIcon extends ConsumerWidget {
  const CompanyIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
        error: (e, stack) => Container(),
        data: (s) {
          if (s is Authenticated) {
            return Column(
              children: [
                const Icon(
                  Icons.store,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  s.user.user.company.companyName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
              ],
            );
          }
          return Container();
        },
        loading: () => Container(),
        skipError: true);
  }
}

class PreparingOutlet extends StatelessWidget {
  const PreparingOutlet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Preparing Outlet ...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          )
        ],
      ),
    );
  }
}
