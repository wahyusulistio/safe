/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:safe/Models/HasilB5P.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class HasilB5PPeserta extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const HasilB5PPeserta({Key? key, required this.hb}) : super(key: key);

  final List<HasilB5P> hb;
  @override
  _HasilB5PPesertaState createState() => _HasilB5PPesertaState();
}

class _HasilB5PPesertaState extends State<HasilB5PPeserta> {
  // List<_SalesData> data = [
  //   _SalesData(35,1),
  //   _SalesData(28, 2),
  //   _SalesData(34, 3),
  //   _SalesData(32, 4),
  //   _SalesData(40, 5)
  // ];

  late List<HasilB5P> hb;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hb = widget.hb;
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
          title: const Text('Hasil Test B5P'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            //Initialize the chart widget
            SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
              ),
              annotations: [
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Flexible",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'C',
                    y: 40),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Balanced",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'C',
                    y: 50),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Focused",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'C',
                    y: 60),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Challenger",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'A',
                    y: 40),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Negosiator",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'A',
                    y: 50),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Adapter",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'A',
                    y: 60),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Preserver",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'O',
                    y: 40),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Moderator",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'O',
                    y: 50),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Explorer",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'O',
                    y: 60),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Introvert",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'E',
                    y: 40),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Ambivert",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'E',
                    y: 50),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Extrovert",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'E',
                    y: 60),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Resilient",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'N',
                    y: 40),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Responsive",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'N',
                    y: 50),
                CartesianChartAnnotation(
                    widget: Container(
                        child: Text(
                      "Reactive",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    )),
                    coordinateUnit: CoordinateUnit.point,
                    x: 'N',
                    y: 60),
              ],
              primaryYAxis: NumericAxis(
                plotBands: <PlotBand>[
                  PlotBand(
                    shouldRenderAboveSeries: true,
                    isVisible: true,
                    start: 35,
                    end: 35,
                    //Specify the width for the line
                    borderWidth: 2,
                    borderColor: Colors.black,
                  ),
                  PlotBand(
                    shouldRenderAboveSeries: true,
                    isVisible: true,
                    start: 45,
                    end: 45,
                    //Specify the width for the line
                    borderWidth: 2,
                    borderColor: Colors.black,
                  ),
                  PlotBand(
                    shouldRenderAboveSeries: true,
                    isVisible: true,
                    start: 55,
                    end: 55,
                    //Specify the width for the line
                    borderWidth: 2,
                    borderColor: Colors.black,
                  ),
                  PlotBand(
                    shouldRenderAboveSeries: true,
                    isVisible: true,
                    start: 65,
                    end: 65,
                    //Specify the width for the line
                    borderWidth: 2,
                    borderColor: Colors.black,
                  )
                  //Specify the dash array for the line
                  //dashArray: const <double>[4, 5])
                ],
                majorGridLines: const MajorGridLines(width: 0),
                numberFormat: NumberFormat.compact(),
                maximum: 80,
                minimum: 20,
              ),
              // Chart title
              title: ChartTitle(text: 'Big 5 Personality'),
              // Enable legend
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries>[
                BarSeries<HasilB5P, String>(
                    dataSource: hb,
                    // Renders the track
                    isTrackVisible: true,
                    xValueMapper: (HasilB5P _hb, _) => _hb.dimensi,
                    yValueMapper: (HasilB5P _hb, _) => int.parse(_hb.skor),
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.bottom))
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
            SizedBox(
              height: 1,
              child: Container(
                color: Colors.teal,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Keterangan :",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "N - NEUROTISM",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "E - EXTRAVERSION",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "O - OPENNESS",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "A - AGREEBLENESS",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "C - CONSCIENTIOUSNESS",
                    style: TextStyle(fontSize: 18),
                  ),
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
