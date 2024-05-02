import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/screens/select_outlet/select_outlet_prompt.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    ref.read(outletListNotifierProvider.notifier).fetchOutletList();
    super.initState();
  }

  void onSelectOutlet(Outlet outlet) {
    showDialog(
        context: context,
        barrierDismissible: false,
        // backgroundColor: Colors.white,
        // enableDrag: false,
        // isDismissible: false,
        // isScrollControlled: true,
        builder: (context) {
          return SelectOutletPrompt(outlet: outlet);
        });
  }

  Widget buildOutletLists(BuildContext context, List<Outlet> outlets) {
    final height = MediaQuery.sizeOf(context).height * 0.38;
    return SizedBox(
      height:  height,
      child: CupertinoScrollbar(
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white
              ],
              stops: [
                0.9,
                1.0
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: outlets.length,
            itemBuilder: (context, index) {
              Outlet outlet = outlets[index];
              return OutletItem(outlet: outlet, onSelect: onSelectOutlet);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final height = MediaQuery.of(context).size.height * 0.48;
    return Scaffold(
      backgroundColor: Colors.teal.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CompanyIcon(),
            Container(
              margin: const EdgeInsets.only(top: 50),
              width: 300,
              height: _isLoading ? null : height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5),
                color: Colors.white,
                // border: Border.all(width: 0.5, color: Colors.black12),
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
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17.5, vertical: 15),
                    // decoration: BoxDecoration(
                    //   border: Border(
                    //     bottom: BorderSide(
                    //       color: Colors.grey.shade300,
                    //       width: 0.5,
                    //     ),
                    //   ),
                    // ),
                    child: Text("select_outlet".tr(),
                        style: textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  ref.watch(outletListProvider).when(
                        data: (data) {
                          setState(() => _isLoading = false);
                          return buildOutletLists(context, data);
                        },
                        error: (error, stack) => ErrorHandler(
                          error: error.toString(),
                          stackTrace: stack.toString(),
                          onRetry: () => ref
                              .read(outletListProvider.notifier)
                              .fetchOutletList(),
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: LoadingIndicator(
                            color: Colors.teal,
                          ),
                        ),
                      ),
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
