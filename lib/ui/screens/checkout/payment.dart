import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/utils/formater.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key, required this.grandTotal});

  final double grandTotal;

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
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('Payments', style: textTheme.bodyLarge),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.blueGrey.shade100),
              ),
            ),
            child: Column(
              children: [
                PaymentItem(
                  title: 'Cash',
                  icon: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.green.shade600,
                  ),
                  onPress: onChangeMethod,
                  active: selected == 'cash',
                  grandTotal: widget.grandTotal,
                ),
                PaymentItem(
                  title: 'Debit',
                  icon: Icon(
                    CupertinoIcons.creditcard,
                    color: Colors.amber.shade600,
                  ),
                  onPress: onChangeMethod,
                  active: selected == 'debit',
                  grandTotal: widget.grandTotal,
                ),
                PaymentItem(
                  title: 'Credit',
                  icon: Icon(
                    CupertinoIcons.creditcard_fill,
                    color: Colors.blue.shade600,
                  ),
                  onPress: onChangeMethod,
                  active: selected == 'credit',
                  grandTotal: widget.grandTotal,
                ),
                PaymentItem(
                  title: 'e-wallet',
                  icon: const Icon(
                    Icons.qr_code,
                    color: Colors.black,
                  ),
                  onPress: onChangeMethod,
                  active: selected == 'e-wallet',
                  grandTotal: widget.grandTotal,
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
  const PaymentItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    required this.active,
    required this.grandTotal,
  });

  final String title;
  final Icon icon;
  final Function(String) onPress;
  final bool active;
  final double grandTotal;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
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
                child: active
                    ? Text(
                        CurrencyFormat.currency(grandTotal),
                        textAlign: TextAlign.right,
                        style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w700),
                      )
                    : Container(),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                active
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.circle,
                size: 20,
                color: active ? Colors.teal : Colors.blueGrey.shade200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
