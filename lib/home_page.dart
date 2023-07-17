import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DateTime> _blackoutDateCollection = <DateTime>[];
  late List<DateTime> _activeDates;
  final DateRangePickerController _controller = DateRangePickerController();
  late List<PickerDateRange> _selectedRanges;
  @override
  void initState() {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    _activeDates = [
      today,
      today.add(Duration(days: 1)),
      today.add(Duration(days: 2)),
      today.add(Duration(days: 3)),
      today.add(Duration(days: 4)),
      today.add(Duration(days: 5)),
    ];
    _selectedRanges = <PickerDateRange>[
      PickerDateRange(today, today.add(Duration(days: 1))),
      PickerDateRange(
          today.add(Duration(days: 2)), today.add(Duration(days: 3))),
      PickerDateRange(
          today.add(Duration(days: 4)), today.add(Duration(days: 5))),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: SfDateRangePicker(
              controller: _controller,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.multiRange,
              initialSelectedRanges: _selectedRanges,
              startRangeSelectionColor: Colors.purple,
              endRangeSelectionColor: Colors.purple,
              rangeSelectionColor: Colors.purpleAccent,
              onSelectionChanged: selectionChanged,
              monthViewSettings: DateRangePickerMonthViewSettings(
                blackoutDates: _blackoutDateCollection,
              ),
              /* monthCellStyle: DateRangePickerMonthCellStyle(
                  blackoutDateTextStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontFamily: 'Roboto'),
              ),*/
              onViewChanged: viewChanged,
            ),
          )
        ],
      ),
    );
  }

  void viewChanged(DateRangePickerViewChangedArgs args) {
    DateTime date;
    DateTime startDate = args.visibleDateRange.startDate!;
    DateTime endDate = args.visibleDateRange.endDate!;
    List<DateTime> _blackDates = <DateTime>[];
    for (date = startDate;
        date.isBefore(endDate) || date == endDate;
        date = date.add(const Duration(days: 1))) {
      if (_activeDates.contains(date)) {
        continue;
      }
      _blackDates.add(date);
    }
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        _blackoutDateCollection = _blackDates;
      });
    });
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    _controller.selectedRanges = _selectedRanges;
  }
}
