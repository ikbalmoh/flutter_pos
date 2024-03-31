import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/utils/formater.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  String selected = '';

  void onChangeMethod(String method) {
    setState(() {
      selected = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('payments'.tr, style: textTheme.bodyLarge),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.blueGrey.shade100),
              ),
            ),
            child: Column(
              children: [
                PaymentItem(
                  title: 'cash'.tr.capitalize!,
                  icon: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.green.shade600,
                  ),
                  onPress: onChangeMethod,
                  active: selected == 'cash',
                ),
                PaymentItem(
                  title: 'debit'.tr.capitalize!,
                  icon: Icon(
                    CupertinoIcons.creditcard,
                    color: Colors.amber.shade600,
                  ),
                  onPress: onChangeMethod,
                  active: selected == 'debit',
                ),
                PaymentItem(
                  title: 'credit'.tr.capitalize!,
                  icon: Icon(
                    CupertinoIcons.creditcard_fill,
                    color: Colors.blue.shade600,
                  ),
                  onPress: onChangeMethod,
                  active: selected == 'credit',
                ),
                PaymentItem(
                  title: 'e-wallet'.tr,
                  icon: const Icon(
                    Icons.qr_code,
                    color: Colors.black,
                  ),
                  onPress: onChangeMethod,
                  active: selected == 'e-wallet',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PaymentItem extends StatelessWidget {
  const PaymentItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      required this.active});

  final String title;
  final Icon icon;
  final Function(String) onPress;
  final bool active;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      child: InkWell(
        splashColor: Colors.blueGrey.shade50,
        highlightColor: Colors.blueGrey.shade100,
        onTap: () => onPress(title.toLowerCase()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: active ? Text(
                  CurrencyFormat.currency(125000),
                  textAlign: TextAlign.right,
                  style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700, fontWeight: FontWeight.w700),
                ) : Container(),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                active
                    ? CupertinoIcons.largecircle_fill_circle
                    : Icons.circle_outlined,
                size: 18,
                color: active ? Colors.teal : Colors.blueGrey.shade200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
