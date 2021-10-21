part of '../staggered_animations.dart';

class _Row3 extends StatelessWidget {
  const _Row3({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = [
      Flexible(
        child: SmartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Parking',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Gap(16),
              _Indicator(),
              const Gap(16),
              const Center(
                child: Icon(
                  LineIcons.car,
                  size: 48,
                ),
              )
            ],
          ),
        ),
      ),
      Flexible(
        child: SmartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kitchen',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Gap(16),
              _Indicator(),
              const Gap(16),
              const Center(
                child: Icon(
                  LineIcons.cookie,
                  size: 48,
                ),
              )
            ],
          ),
        ),
      ),
    ];

    return LayoutBuilder(
      builder: (context, size) {
        if (size.maxWidth > 600) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
        }
      },
    );
  }
}

class _Row2 extends StatelessWidget {
  const _Row2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = [
      Flexible(
        // constraints: BoxConstraints(maxWidth: 500),
        child: SmartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Living Room',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Gap(16),
              _Indicator(),
              const Gap(16),
              SizedBox(
                height: 64,
                child: LineChart(
                  sampleData(),
                ),
              ),
            ],
          ),
        ),
      ),
      Flexible(
        // constraints: BoxConstraints(maxWidth: 500),
        child: SmartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bedroom',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Gap(16),
              _Indicator(),
              const Gap(16),
              SizedBox(
                height: 64,
                child: LineChart(
                  sampleData(),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    return LayoutBuilder(
      builder: (context, size) {
        if (size.maxWidth > 600) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
        }
      },
    );
  }
}

class _Row1 extends StatelessWidget {
  const _Row1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SmartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Family Room',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Gap(16),
                OverflowBar(
                  spacing: 16,
                  children: [
                    _Indicator(),
                    Gap(16),
                    _Indicator(),
                  ],
                ),
                Gap(16),
                OverflowBar(
                  spacing: 16,
                  children: [
                    _Indicator(),
                    Gap(16),
                    _Indicator(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0),
      child: Row(
        children: [
          const CircleAvatar(
            child: Text('JS'),
          ),
          Gap(16),
          Text(
            'John Smith',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(LineIcons.batteryAlt2Full),
        const Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('42%'),
            Text(
              'John\'s battery',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}

class SmartCard extends StatelessWidget {
  const SmartCard({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 32,
              offset: Offset(6, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: child,
        ),
      ),
    );
  }
}

LineChartData sampleData() {
  return LineChartData(
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 6,
        getTextStyles: (context, value) => const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        interval: 1,
        // margin: 10,
        getTitles: (value) {
          switch (value.toInt() % 7) {
            case 1:
              return 'MON';
            // case 2:
            //   return 'TUE';
            case 3:
              return 'WED';
            // case 4:
            //   return 'THU';
            case 5:
              return 'FRI';
            case 7:
              return 'SUN';
          }
          return '';
        },
      ),
      rightTitles: SideTitles(showTitles: false),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),

        interval: 50,
        // getTitles: (value) {
        //   switch (value.toInt()) {
        //     case 1:
        //       return '';
        //     case 2:
        //       return '20';
        //     case 3:
        //       return '';
        //     case 4:
        //       return '22';
        //   }
        //   return '';
        // },
        margin: 4,
        reservedSize: 30,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(
          color: Color(0xff4e4965),
          width: 1,
        ),
        left: BorderSide(
          color: Colors.transparent,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    minX: 0,
    maxX: 14,
    maxY: 100,
    minY: 0,
    lineBarsData: linesBarData1(),
  );
}

List<LineChartBarData> linesBarData1() {
  final LineChartBarData lineChartBarData1 = LineChartBarData(
    spots: [
      FlSpot(1, 80),
      FlSpot(2, 40),
      FlSpot(3, 30),
      FlSpot(4, 60),
      FlSpot(5, 80),
      FlSpot(6, 70),
      FlSpot(8, 30),
      FlSpot(9, 100),
      FlSpot(10, 85),
      FlSpot(11, 64),
      FlSpot(12, 62),
      FlSpot(13, 49),
    ],
    isCurved: true,
    colors: [
      Colors.black54,
    ],
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );

  return [
    lineChartBarData1,
  ];
}
