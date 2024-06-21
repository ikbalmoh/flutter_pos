import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final Icon icon;
  final Function()? onTap;

  const SummaryCard({
    super.key,
    required this.color,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: icon,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                    ),
                    Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black54),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class SummaryCardSkeleton extends StatelessWidget {
  const SummaryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 0,
      color: Colors.blueGrey.shade50.withOpacity(0.5),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25)),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 120,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
