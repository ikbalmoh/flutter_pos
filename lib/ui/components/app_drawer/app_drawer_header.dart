import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

class AppDrawerHeader extends ConsumerWidget {
  const AppDrawerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthState? authState = ref.watch(authProvider).value;
    return ref.watch(outletProvider).when(
        data: (data) {
          return DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: Divider.createBorderSide(context,
                    color: Colors.white, width: 0.0),
              ),
            ),
            child: data is OutletSelected
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          child: data.config.attributeReceipts?.imagePath !=
                                  null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      data.config.attributeReceipts!.imagePath!,
                                  height: 60,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/icon.png',
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/icon.png',
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        authState is Authenticated
                            ? authState.user.user.company.companyName
                            : '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        data.outlet.outletName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Container(),
          );
        },
        error: (error, _) => Container(),
        loading: () => Container());
  }
}
