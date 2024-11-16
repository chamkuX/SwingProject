import 'package:flutter/material.dart';

class SwingOptionPage extends StatefulWidget {
  const SwingOptionPage({super.key});

  @override
  _SwingOptionPageState createState() => _SwingOptionPageState();
}

class _SwingOptionPageState extends State<SwingOptionPage> {
  int selectedStrikePrice = 1000; // Initial strike price
  bool isPanelVisible = false;

  // Generate random premiums for demonstration
  double getRandomPremium() {
    return (50 + (100 * (DateTime.now().millisecondsSinceEpoch % 5)))
        .toDouble();
  }

  void showStrikeDetails(int strikePrice) {
    setState(() {
      selectedStrikePrice = strikePrice;
      isPanelVisible = true;
    });
  }

  void hideStrikeDetails() {
    setState(() {
      isPanelVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swing Options'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Top section: Match details and live score
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'IND',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '141-1 (17.5)',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                'India vs Australia',
                                style: TextStyle(
                                    color: Colors.orangeAccent, fontSize: 16),
                              ),
                              Text(
                                'Wed, 12 Jun \'24',
                                style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontSize: 14),
                              ),
                              Text(
                                'Melbourne Cricket Ground, Aus',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(6, (index) {
                        return CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue[700],
                          child: const Text(
                            '6',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Rohit Sharma 45(30)',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            Text('Virat Kohli 45(30)',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        const Text('Micheal Stark 4-1-30, Eco 6.46',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              // Option Chain with strike prices and premiums
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text('IN - BAT',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                          Text('Swing',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text('OUT - BOWL',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          int strikePrice = 500 + (index * 100);
                          return OptionRow(
                            strikePrice: strikePrice,
                            inPremium: getRandomPremium(),
                            outPremium: getRandomPremium(),
                            isCurrent: strikePrice == selectedStrikePrice,
                            onStrikeSelected: () =>
                                showStrikeDetails(strikePrice),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bottom pane showing strike details
          if (isPanelVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: hideStrikeDetails,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Strike Price: $selectedStrikePrice',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Premium: ₹${getRandomPremium().toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Add buy action
                              },
                              child: const Text('Buy',
                                  style: TextStyle(fontSize: 18)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent[700],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: hideStrikeDetails,
                              child: const Text('Close',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white70),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Option Row widget for each strike price
class OptionRow extends StatelessWidget {
  final int strikePrice;
  final double inPremium;
  final double outPremium;
  final bool isCurrent;
  final VoidCallback onStrikeSelected;

  const OptionRow({
    super.key,
    required this.strikePrice,
    required this.inPremium,
    required this.outPremium,
    required this.isCurrent,
    required this.onStrikeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStrikeSelected,
      child: Container(
        color: isCurrent ? Colors.blue[700] : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '+₹${inPremium.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$strikePrice',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '+₹${outPremium.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
