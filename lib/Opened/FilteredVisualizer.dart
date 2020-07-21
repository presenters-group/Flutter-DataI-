import 'package:eyedatai/Classes/SeriesData.dart';
import 'package:eyedatai/Classes/VisualizerModel.dart';
import 'package:eyedatai/Opened/Charts/BarChart.dart';
import 'package:eyedatai/Opened/FilteredDataSource.dart';
import 'package:flutter/material.dart';

import '../ColorClass.dart';
import '../FontClass.dart';

// ignore: must_be_immutable
class FilteredVisualizer extends StatefulWidget {
  List<List<dynamic>> data = new List();
  VisualizerModel visualizerModel;

  FilteredVisualizer(this.data, this.visualizerModel);

  @override
  _FilteredVisualizerState createState() =>
      _FilteredVisualizerState(data, visualizerModel);
}

class _FilteredVisualizerState extends State<FilteredVisualizer>
    with SingleTickerProviderStateMixin {
  List<List<dynamic>> data = new List();
  VisualizerModel visualizerModel;

  _FilteredVisualizerState(this.data, this.visualizerModel);

  TabController tabController;
  int width;
  List<List<SeriesData>> dataBarChart = new List();
  List<SeriesData> dataBarChartSingle = new List();
  List<SeriesData> dataPieChart = new List();
  List<List<SeriesData>> dataLineChart = new List();
  List<SeriesData> dataLineChartSingle = new List();
  List<dynamic> titlesBarChart = new List();
  List<dynamic> colorsBarChart = new List();

  int getWidth(data) {
    int width = 0;
    List<dynamic> listOfWidths = new List();
    for (List<dynamic> list in data) {
      listOfWidths.add(list.length);
    }
    width = listOfWidths.reduce((curr, next) => curr > next ? curr : next);
    return width;
  }

  void getDataBarChart() {
    dataBarChart = [];
    dataBarChartSingle = [];
    dataPieChart = [];
    dataLineChart = [];
    dataLineChartSingle = [];
    titlesBarChart = [];
    colorsBarChart = [];

    List<dynamic> tempDataCol = new List();
    List<dynamic> allTempDataCol = new List();

    for (int i = 0; i < data[0].length; i++) {
      for (int j = 0; j < data.length; j++) {
        tempDataCol.add(data[j][i]);
      }
      allTempDataCol.add(tempDataCol);
      tempDataCol = [];
    }
    print("Filtered Data");
    print(allTempDataCol);
    List<dynamic> tempColumn = new List();

    for (int i = 0; i < allTempDataCol.length; i++) {
      if (i == visualizerModel.xColumn) {
        tempColumn = allTempDataCol[i];
        allTempDataCol.remove(allTempDataCol[i]);
      }
    }
    allTempDataCol.insert(0, tempColumn);

    print("After editing");
    print(allTempDataCol);
    width = getWidth(allTempDataCol);
    for (int j = 1; j <= allTempDataCol.length - 1; j++) {
      titlesBarChart.add(allTempDataCol[j][0]);
    }

    print(titlesBarChart);
    List<dynamic> tempData = new List();
    List<List<dynamic>> allData = new List();
    for (int i = 0; i < allTempDataCol[0].length; i++) {
      for (int j = 0; j < allTempDataCol.length; j++) {
        tempData.add(allTempDataCol[j][i]);
      }
      allData.add(tempData);
      tempData = [];
    }
    print(allData);
    print("width : $width");
    for (int j = 1; j <= allTempDataCol.length - 1; j++) {
      for (int i = 1; i < allData.length; i++) {
        if (width == 2) {
          dataBarChartSingle.add(
            new SeriesData(
                task: allData[i][0],
                taskValue: int.parse(allData[i][j].trim()),
                taskColor: visualizerModel.dataSource.columnsColors[i]),
          );
        } else {
          dataBarChartSingle.add(
            new SeriesData(
                task: allData[i][0],
                taskValue: int.parse(allData[i][j].toString().trim()),
                taskColor: visualizerModel.dataSource.columnsColors[j]),
          );
        }
      }
      colorsBarChart.add(visualizerModel.dataSource.columnsColors[j]);
      dataBarChart.add(dataBarChartSingle);
      dataBarChartSingle = [];
    }
  }

  void getDataPieChart() {}

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    getDataBarChart();
    getDataPieChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Text(
              "Filterd Visualizer",
              style: TextStyle(
                  color: ColorClass.fontColor,
                  fontFamily: FontClass.appFont,
                  fontSize: 15),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 25),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: ColorClass.fontColor,
                size: 17,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 25),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new FilteredDataSource(data)));
                },
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('Images/table.png'))),
                ),
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: ColorClass.scaffoldBackgroundColor,
          elevation: 0.0,
        ),
      ),
      backgroundColor: ColorClass.scaffoldBackgroundColor,
      bottomNavigationBar: Material(
        child: Container(
          color: ColorClass.scaffoldBackgroundColor,
          child: TabBar(
              unselectedLabelColor: Colors.black,
              controller: tabController,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              indicatorWeight: 4,
              tabs: [
                Icon(
                  Icons.insert_chart,
                  size: 27,
                ),
                Icon(
                  Icons.pie_chart,
                  size: 27,
                ),
                Icon(
                  Icons.show_chart,
                  size: 27,
                ),
              ]),
        ),
      ),
      body: TabBarView(controller: tabController, children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(titlesBarChart.length, (index) {
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: 20,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: colorsBarChart[index]),

                          //columnsModel[index]
                          //                                    .columnStyleMode.color
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          titlesBarChart[index].toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorClass.fontColor,
                              fontFamily: FontClass.appFont),
                        ),
                      )
                    ],
                  );
                }))),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(dataBarChart),
            )),
          ],
        ),
        Container(),
        Container()
      ]),
    );
  }
}
