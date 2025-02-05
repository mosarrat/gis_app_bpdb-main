import 'package:flutter/material.dart';

class ShowConsumerDetail extends StatelessWidget {
  const ShowConsumerDetail({
    Key? key,
    required this.consumerNo,
    required this.consumerName,
    required this.meterNo,
    // required this.zoneId,
    // required this.circleId,
    // required this.sndId,
  }) : super(key: key);

  final String consumerNo;
  final String consumerName;
  final String meterNo;
  // final String zoneId;
  // final String circleId;
  // final String sndId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: const Color.fromARGB(255, 3, 89, 100),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            Text(
              "Consumer Information",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Consumer No.', value: consumerNo, isAlternate: true),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Consumer Name', value: consumerName, isAlternate: false),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Meter No.',
                        value: meterNo,
                        isAlternate: true),
                    const Divider(height: 0),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text(
                          'Close',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 3, 89, 100),
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailContainer({
    required String label,
    required String value,
    bool isAlternate = false,
  }) {
    return Container(
      width: double.infinity,
      height: 40,
      color: isAlternate
          ? const Color.fromARGB(255, 223, 240, 243)
          : const Color.fromARGB(255, 241, 245, 245),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                ': $value',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
