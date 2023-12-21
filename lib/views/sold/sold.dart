import 'package:estore/constants/constants.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/utils/screen_size.dart';
import 'package:estore/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class SoldScreen extends StatefulWidget {
  const SoldScreen({super.key});

  @override
  State<SoldScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends State<SoldScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _subTitle(),
        const Divider(),
        Expanded(
          child: FutureBuilder(
              future: hiveDb.getOverallHistory(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  Map snap = snapshot.data;

                  List keys = [];
                  snap.forEach((key, value) {
                    keys.add(key);
                  });

                  keys.sort((a, b) => a.compareTo(b));
                  keys = keys.reversed.toList();

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      List innerkeys = [];
                      String key = keys[index];
                      key =
                          '${key.substring(8, 10)}-${key.substring(5, 7)}-${key.substring(0, 4)}';

                      Map innerSnap = snap[keys[index]];
                      innerSnap.forEach((key, value) {
                        innerkeys.add(key);
                      });
                      innerkeys.sort((a, b) => a.compareTo(b));
                      innerkeys = innerkeys.reversed.toList();
                      return Column(
                        children: [
                          Stack(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 9),
                              child: Text(
                                key.toString(),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            Divider(
                              indent: screenSize(context,
                                  isHeight: false, percentage: 30),
                              color: miniTextColor,
                            ),
                          ]),
                          ListOfSold(
                            innerSnap: innerSnap,
                            innerkeys: innerkeys,
                          ),
                        ],
                      );
                    },
                    itemCount: snap.length,
                  );
                } else {
                  return const Center(
                    child: Text('Solded data listed here.'),
                  );
                }
              }),
        ),
      ],
    );
  }

  _subTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 9, top: 9, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Solded List ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class ListOfSold extends StatefulWidget {
  final Map innerSnap;
  final List innerkeys;
  const ListOfSold(
      {super.key, required this.innerSnap, required this.innerkeys});

  @override
  State<ListOfSold> createState() => _ListOfSoldState();
}

class _ListOfSoldState extends State<ListOfSold> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 9, right: 9),
      child: Column(
          children: List.generate(
        widget.innerkeys.length,
        (index) => customTile(context,
            date:
                widget.innerSnap[widget.innerkeys[index]]['product'].toString(),
            name: widget.innerSnap[widget.innerkeys[index]]['name'].toString(),
            price:
                widget.innerSnap[widget.innerkeys[index]]['price'].toString(),
            quantity: widget.innerSnap[widget.innerkeys[index]]['quantity']
                .toString()),
      )),
    );
  }
}
