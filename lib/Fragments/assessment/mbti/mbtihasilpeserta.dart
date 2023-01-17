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
  const HasilMBTIPeserta({Key? key, required this.hb}) : super(key: key);

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

  late List<HasilMBTI> listhasil1 = <HasilMBTI>[];
  late List<HasilMBTI> listhasil2 = <HasilMBTI>[];
  //final List<List<HasilMBTI>> chartData = <List<HasilMBTI>>[];
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
    listhasil1.clear();
    listhasil2.clear();
    for (int i = 0; i < hb.length; i++) {
      print("dimensi "+hb[i].dimensi);
      if (hb[i].dimensi == "I" ||
          hb[i].dimensi == "S" ||
          hb[i].dimensi == "T" ||
          hb[i].dimensi == "J") {
        listhasil1.add(hb[i]);
      } else {
        listhasil2.add(hb[i]);
      }
    }
    // chartData.add(listhasil1);
    // chartData.add(listhasil2);
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
              onTooltipRender: (TooltipArgs args) {
                print("pointindex "+args.pointIndex.toString());
                print("seriesindex "+args.seriesIndex.toString());
                //print("datapoins "+args..toString());
                args.text = args.seriesIndex.toString()=="0" ?
                listhasil1[int.parse(args.pointIndex.toString())].dimensi +
                    ":" +listhasil1[int.parse(args.pointIndex.toString())].skor :
                listhasil2[int.parse(args.pointIndex.toString())].dimensi +
                    ":" +listhasil2[int.parse(args.pointIndex.toString())].skor;
              },
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                plotBands: <PlotBand>[
                  // PlotBand(
                  //   shouldRenderAboveSeries: true,
                  //   isVisible: true,
                  //     start: 33.33,
                  //     end: 33.33,
                  //     //Specify the width for the line
                  //     borderWidth: 2,
                  //     borderColor: Colors.black,),
                  // PlotBand(
                  //   shouldRenderAboveSeries: true,
                  //   isVisible: true,
                  //   start: 66.67,
                  //   end: 66.67,
                  //   //Specify the width for the line
                  //   borderWidth: 2,
                  //   borderColor: Colors.black,)
                  //Specify the dash array for the line
                  //dashArray: const <double>[4, 5])
                ],
                majorGridLines: const MajorGridLines(width: 0),
                numberFormat: NumberFormat.compact(),
                maximum: 100,
              ),
              // Chart title
              title: ChartTitle(text: 'Dimensi MBTI'),
              // Enable legend
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(
                  enable: true,
                  //format: formatTooltip('series.name', 'point.x', 'point.y')
                ),
              series: <ChartSeries>[
                ColumnSeries<HasilMBTI, String>(
                    dataSource: listhasil1,
                    // Renders the track
                    //isTrackVisible: true,
                    xValueMapper: (HasilMBTI _hb, _) => _hb.dimensi == "I"
                        ? "I-E"
                        : _hb.dimensi == "S"
                            ? "S-N"
                            : _hb.dimensi == "T"
                                ? "T-F"
                                : "J-P",
                    yValueMapper: (HasilMBTI _hb, _) => double.parse(_hb.skor),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      //labelAlignment: ChartDataLabelAlignment.bottom,
                      //labelIntersectAction: LabelIntersectAction.shift,
                      //labelPosition: ChartDataLabelPosition.inside,
                      labelAlignment: ChartDataLabelAlignment.outer,
                      margin: EdgeInsets.only(left: 50),
                      //offset: Offset(-130, -60),
                      // builder: (dynamic data, dynamic point, dynamic series,
                      //     int pointIndex, int seriesIndex) {
                      //   return Text(listhasil1[pointIndex].dimensi +
                      //       ":" +
                      //       listhasil1[pointIndex].skor);
                      // }
                    )),
                ColumnSeries<HasilMBTI, String>(
                    dataSource: listhasil2,
                    // Renders the track
                    //isTrackVisible: true,
                    xValueMapper: (HasilMBTI _hb, _) => _hb.dimensi == "E"
                        ? "I-E"
                        : _hb.dimensi == "N"
                            ? "S-N"
                            : _hb.dimensi == "F"
                                ? "T-F"
                                : "J-P",
                    yValueMapper: (HasilMBTI _hb, _) => double.parse(_hb.skor),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      //labelAlignment: ChartDataLabelAlignment.,
                      //labelIntersectAction: LabelIntersectAction.shift,
                      //labelPosition: ChartDataLabelPosition.inside,
                      labelAlignment: ChartDataLabelAlignment.outer,
                      //offset: Offset(30, 0),
                      // builder: (dynamic data, dynamic point, dynamic series,
                      //     int pointIndex, int seriesIndex) {
                      //   return Text(listhasil2[pointIndex].dimensi +
                      //       ":" +
                      //       listhasil2[pointIndex].skor);
                      // }
                    ))
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
                    "I - Introvert",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "E - Ekstrovert",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "S - Sensing",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "N - Intuition",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "T - Thinking",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "F - Feeling",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "J - Judging",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "P - Perceiving",
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
