/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:safe/Models/HasilMBTI.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class HasilMBTIPeserta extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const HasilMBTIPeserta({Key? key, required this.hb})
      : super(key: key);

  final List<HasilMBTI> hb;
  @override
  _HasilMBTIPesertaState createState() => _HasilMBTIPesertaState();
}

class _HasilMBTIPesertaState extends State<HasilMBTIPeserta> {
  // List<_SalesData> data = [
  //   _SalesData(35,1),
  //   _SalesData(28, 2),
  //   _SalesData(34, 3),
  //   _SalesData(32, 4),
  //   _SalesData(40, 5)
  // ];

  late List<HasilMBTI> hb;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hb=widget.hb;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Hasil Test MBTI'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            //Initialize the chart widget
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                  plotBands: <PlotBand>[
                    PlotBand(
                      shouldRenderAboveSeries: true,
                      isVisible: true,
                        start: 33.33,
                        end: 33.33,
                        //Specify the width for the line
                        borderWidth: 2,
                        borderColor: Colors.black,),
                    PlotBand(
                      shouldRenderAboveSeries: true,
                      isVisible: true,
                      start: 66.67,
                      end: 66.67,
                      //Specify the width for the line
                      borderWidth: 2,
                      borderColor: Colors.black,)
                        //Specify the dash array for the line
                        //dashArray: const <double>[4, 5])
                  ],
                  majorGridLines: const MajorGridLines(width: 0),
                  numberFormat: NumberFormat.compact(),
                maximum: 100,
              ),
              // Chart title
              title: ChartTitle(text: 'Self Perception Team Role Profile'),
              // Enable legend
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries>[
                BarSeries<HasilMBTI, String>(
                    dataSource: hb,
                    // Renders the track
                    isTrackVisible: true,
                    xValueMapper: (HasilMBTI _hb, _) => _hb.dimensi,
                    yValueMapper: (HasilMBTI _hb, _) => _hb.dimensi=='E' ? int.parse(_hb.skor.replaceAll(".00", "")) : -1*int.parse(_hb.skor.replaceAll(".00", "")),
              dataLabelSettings: DataLabelSettings(isVisible: true)
                )
              ],
              // <ChartSeries<_SalesData, String>>[
              //   LineSeries<_SalesData, String>(
              //       dataSource: data,
              //       xValueMapper: (_SalesData sales, _) => sales.year,
              //       yValueMapper: (_SalesData sales, _) => sales.sales,
              //       name: 'Sales',
              //       // Enable data label
              //       dataLabelSettings: DataLabelSettings(isVisible: true))
              // ]
            ),
            SizedBox( height: 1, child: Container(color: Colors.teal,),),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Keterangan :", style: TextStyle(fontSize: 20),),
                  Text("I - Introvert", style: TextStyle(fontSize: 18),),
                  Text("E - Ekstrovert", style: TextStyle(fontSize: 18),),
                  Text("S - Sensing", style: TextStyle(fontSize: 18),),
                  Text("N - Intuition", style: TextStyle(fontSize: 18),),
                  Text("T - Thinking", style: TextStyle(fontSize: 18),),
                  Text("F - Feeling", style: TextStyle(fontSize: 18),),
                  Text("J - Judging", style: TextStyle(fontSize: 18),),
                  Text("P - Perceiving", style: TextStyle(fontSize: 18),),
                ],
              ),
            )
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     //Initialize the spark charts widget
            //     child: SfSparkLineChart.custom(
            //       //Enable the trackball
            //       trackball: SparkChartTrackball(
            //           activationMode: SparkChartActivationMode.tap),
            //       //Enable marker
            //       marker: SparkChartMarker(
            //           displayMode: SparkChartMarkerDisplayMode.all),
            //       //Enable data label
            //       labelDisplayMode: SparkChartLabelDisplayMode.all,
            //       xValueMapper: (int index) => data[index].year,
            //       yValueMapper: (int index) => data[index].sales,
            //       dataCount: 5,
            //     ),
            //   ),
            // )
          ]),
        ));
  }

  // BarSeries<_SalesData, String> _getDefaultBarSeries() {
  //   return //<BarSeries<ChartSampleData, String>>[
  //       BarSeries<_SalesData, String>(
  //           dataSource: data,
  //           xValueMapper: (_SalesData sales, _) => sales.year as String,
  //           yValueMapper: (_SalesData sales, _) => sales.sales,
  //           name: '2015');
  //   //];
  // }
}


