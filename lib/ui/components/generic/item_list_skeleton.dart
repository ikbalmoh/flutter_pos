import 'package:flutter/material.dart';

class ItemListSkeleton extends StatelessWidget {
  const ItemListSkeleton({super.key, this.leading});

  final bool? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading == false
                  ? Container()
                  : Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25)),
                    ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 120,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 70,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ],
          )),
    );
  }
}
