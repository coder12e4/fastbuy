import 'package:flutter/material.dart';

class EmptyOrAlert extends StatelessWidget {
  final bool empty;
  const EmptyOrAlert({super.key, required this.empty});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: empty
          ? const Row(
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Empty")
              ],
            )
          : const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(
                  width: 10,
                ),
                Text("Empty")
              ],
            ),
    );
  }
}
