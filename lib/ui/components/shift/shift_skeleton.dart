import 'package:flutter/material.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/shift/summary_card.dart';

class ActiveShiftInfoSkeleton extends StatelessWidget {
  const ActiveShiftInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen.shade100,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 140,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShiftSummaryCardSkeleton extends StatelessWidget {
  const ShiftSummaryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SummaryCardSkeleton(),
              SizedBox(width: 10),
              SummaryCardSkeleton(),
            ],
          ),
        ),
      ],
    );
  }
}

class ShiftCashflowsSkeleton extends StatelessWidget {
  const ShiftCashflowsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) => const ItemListSkeleton(),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

class ShiftSkeleon extends StatelessWidget {
  const ShiftSkeleon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          ActiveShiftInfoSkeleton(),
          SizedBox(height: 20),
          ShiftSummaryCardSkeleton(),
          SizedBox(height: 20),
          ShiftCashflowsSkeleton()
        ],
      ),
    );
  }
}
