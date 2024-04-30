import 'package:flutter/material.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'outlet_item.dart';

class SelectOutletScreen extends StatefulWidget {
  const SelectOutletScreen({super.key});

  @override
  State<SelectOutletScreen> createState() => _SelectOutletScreenState();
}

class _SelectOutletScreenState extends State<SelectOutletScreen> {
  bool loading = false;
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  ListView buildOutletLists(BuildContext context, List<Outlet> outlets) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: outlets.length,
      itemBuilder: (context, index) {
        Outlet outlet = outlets[index];
        return OutletItem(
          outlet: outlet,
          onSelect: (outlet) => {
            // Select outlet
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return const Scaffold(
      body: Text('Select Outlet'),
    );
    return Scaffold(
      backgroundColor: Colors.teal.shade400,
      body: loading
          ? Center(
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
                    '${"preparing_outlet"} ...',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    'Company Name',
                    style:
                        textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
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
                          child: Text("select_outlet",
                              style: textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                        ),
                        loading
                            ? const LoadingWidget()
                            : buildOutletLists(context, [])
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
