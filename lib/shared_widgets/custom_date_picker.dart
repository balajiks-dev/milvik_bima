library datepicker_dropdown;

import 'package:flutter/material.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/constants.dart';
import 'package:milvik_bima/utils/text_styles.dart';

/// Defines widgets which are to used as DropDown Date Picker.
class DropdownDatePicker extends StatefulWidget {
  ///DropDown select text style
  final TextStyle? textStyle;

  final bool? isEditable;

  ///DropDown container box decoration
  final BoxDecoration? boxDecoration;

  ///DropDown expand icon
  final Icon? icon;

  ///Start year for date picker
  ///Default is 1900
  final int? startYear;

  ///End year for date picker
  ///Default is Current year
  final int? endYear;

  ///width between each drop down
  ///Default is 12.0
  final double width;

  ///Return selected date
  ValueChanged<String?>? onChangedDay;

  ///Return selected month
  ValueChanged<String?>? onChangedMonth;

  ///Return selected year
  ValueChanged<String?>? onChangedYear;

  ///Error message for Date
  String errorDay;

  ///Error message for Month
  String errorMonth;

  ///Error message for Year
  String errorYear;

  ///Is Form validator enabled
  ///Default is false
  final bool isFormValidator;

  ///Is Expanded for dropdown
  ///Default is true
  final bool isExpanded;

  ///Selected Day between 1 to 31
  final int? selectedDay;

  ///Selected Month between 1 to 12
  final int? selectedMonth;

  ///Selected Year between startYear and endYear
  final int? selectedYear;

  ///Default [isDropdownHideUnderline] = false. Wrap with DropdownHideUnderline for the dropdown to hide the underline.
  final bool isDropdownHideUnderline;
  DropdownDatePicker(
      {Key? key,
        this.textStyle,
        this.boxDecoration,
        this.icon,
        this.startYear,
        this.endYear,
        this.width = 12.0,
        this.onChangedDay,
        this.onChangedMonth,
        this.onChangedYear,
        this.isDropdownHideUnderline = false,
        this.errorDay = 'Please select day',
        this.errorMonth = 'Please select month',
        this.errorYear = 'Please select year',
        this.isFormValidator = false,
        this.isExpanded = true,
        this.selectedDay,
        this.selectedMonth,
        this.selectedYear,
        this.isEditable = false
      })
      : super(key: key);

  @override
  _DropdownDatePickerState createState() => _DropdownDatePickerState();
}

class _DropdownDatePickerState extends State<DropdownDatePicker> {
  var monthselVal = '';
  var dayselVal = '';
  var yearselVal = '';
  int daysIn = 32;
  late List listdates = [];
  late List listyears = [];

  @override
  void initState() {
    super.initState();
    dayselVal = widget.selectedDay != null ? widget.selectedDay.toString() : '';
    monthselVal =
    widget.selectedMonth != null ? widget.selectedMonth.toString() : '';
    yearselVal =
    widget.selectedYear != null ? widget.selectedYear.toString() : '';
    listdates = Iterable<int>.generate(daysIn).skip(1).toList();
    listyears =
        Iterable<int>.generate((widget.endYear ?? DateTime.now().year) + 1)
            .skip(widget.startYear ?? 1900)
            .toList()
            .reversed
            .toList();
  }

  ///Month selection dropdown function
  monthSelected(value) {
    widget.onChangedMonth!(value);
    monthselVal = value;
    int days = daysInMonth(
        yearselVal == '' ? DateTime.now().year : int.parse(yearselVal),
        int.parse(value));
    listdates = Iterable<int>.generate(days + 1).skip(1).toList();
    checkDates(days);
    update();
  }

  ///check dates for selected month and year
  void checkDates(days) {
    if (dayselVal != '') {
      if (int.parse(dayselVal) > days) {
        dayselVal = '1';
        widget.onChangedDay!('1');
        update();
      }
    }
  }

  ///find days in month and year
  int daysInMonth(year, month) => DateTimeRange(
      start: DateTime(year, month, 1), end: DateTime(year, month + 1))
      .duration
      .inDays;

  ///day selection dropdown function
  daysSelected(value) {
    widget.onChangedDay!(value);
    dayselVal = value;
    update();
  }

  ///year selection dropdown function
  yearsSelected(value) {
    widget.onChangedYear!(value);
    yearselVal = value;
    if (monthselVal != '') {
      int days = daysInMonth(
          yearselVal == '' ? DateTime.now().year : int.parse(yearselVal),
          int.parse(monthselVal));
      listdates = Iterable<int>.generate(days + 1).skip(1).toList();
      checkDates(days);
      update();
    }
    update();
  }

  ///list of months
  List<dynamic> listMonths = [
    {"id": 1, "value": "January"},
    {"id": 2, "value": "February"},
    {"id": 3, "value": "March"},
    {"id": 4, "value": "April"},
    {"id": 5, "value": "May"},
    {"id": 6, "value": "June"},
    {"id": 7, "value": "July"},
    {"id": 8, "value": "August"},
    {"id": 9, "value": "September"},
    {"id": 10, "value": "October"},
    {"id": 11, "value": "November"},
    {"id": 12, "value": "December"}
  ];

  ///update function
  update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: ColorData.kcWhite,
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                  child: Center(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.date_range, color: ColorData.kcGrayShade_1, size: 20,),
                        ),
                        Text(
                          AppStrings.day,
                          maxLines: 1,
                          style: ktsFontStyle12RegularGrawy,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                  child: Container(
                    decoration: widget.boxDecoration ?? const BoxDecoration(),
                    child: SizedBox(
                      // height: 49,
                        child: widget.isEditable! ? ButtonTheme(
                          alignedDropdown: true,
                          child: widget.isDropdownHideUnderline
                              ? DropdownButtonHideUnderline(
                            child: dayDropdown(),
                          )
                              : dayDropdown(),
                        ) : Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            widget.selectedDay.toString(),
                            maxLines: 1,
                            style: ktsFontStyle16Regular,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),),
                  ),
                ),
              ],
            ),
          ),
        ),
        w(widget.width),
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
                color: ColorData.kcWhite,
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                  child: Center(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.date_range, color: ColorData.kcGrayShade_1, size: 20,),
                        ),
                        Text(
                          AppStrings.month,
                          maxLines: 1,
                          style: ktsFontStyle12RegularGrawy,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                  child: Container(
                    decoration: widget.boxDecoration ?? const BoxDecoration(),
                    child: SizedBox(
                      // height: 49,
                      child: widget.isEditable! ? ButtonTheme(
                        alignedDropdown: true,
                        child: widget.isDropdownHideUnderline
                            ? DropdownButtonHideUnderline(
                          child: monthDropdown(),
                        )
                            : monthDropdown(),
                      ) : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          getMonthName(widget.selectedMonth!),
                          maxLines: 1,
                          style: ktsFontStyle16Regular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // w(widget.width),
        // Expanded(
        //   flex: 3,
        //   child: Container(
        //     decoration: widget.boxDecoration ?? const BoxDecoration(),
        //     child: SizedBox(
        //       // height: 49,
        //         child: ButtonTheme(
        //           alignedDropdown: true,
        //           child: widget.isDropdownHideUnderline
        //               ? DropdownButtonHideUnderline(
        //             child: dayDropdown(),
        //           )
        //               : dayDropdown(),
        //         )),
        //   ),
        // ),
        w(widget.width),
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
                color: ColorData.kcWhite,
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                  child: Center(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.date_range, color: ColorData.kcGrayShade_1, size: 20,),
                        ),
                        Text(
                          AppStrings.year,
                          maxLines: 1,
                          style: ktsFontStyle12RegularGrawy,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                  child: Container(
                    decoration: widget.boxDecoration ?? const BoxDecoration(),
                    child: SizedBox(
                      // height: 49,
                      child: widget.isEditable! ? ButtonTheme(
                        alignedDropdown: true,
                        child: widget.isDropdownHideUnderline
                            ? DropdownButtonHideUnderline(
                          child: yearDropdown(),
                        )
                            : yearDropdown(),
                      ) : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          widget.selectedYear.toString(),
                          maxLines: 1,
                          style: ktsFontStyle16Regular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getMonthName(int month){
    List<String> monthNames = ["","January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return monthNames[month];
  }

  ///month dropdown
  DropdownButtonFormField<String> monthDropdown() {
    return DropdownButtonFormField<String>(
        decoration: widget.isDropdownHideUnderline ? removeUnderline() : null,
        isExpanded: widget.isExpanded,
        hint: const Text('Month'),
        icon: Container(),
      //  icon: widget.icon ?? const Icon(Icons.expand_more, color: Colors.grey),
        value: monthselVal == '' ? null : monthselVal,
        onChanged: (value) {
          monthSelected(value);
        },
        validator: (value) {
          return widget.isFormValidator
              ? value == null
              ? widget.errorMonth
              : null
              : null;
        },
        items: listMonths.map((item) {
          return DropdownMenuItem<String>(
            value: item["id"].toString(),
            child: Text(
              item["value"].toString(),
              style: widget.textStyle ??
                  ktsFontStyle16Regular,
            ),
          );
        }).toList());
  }

  ///Remove underline from dropdown
  InputDecoration removeUnderline() {
    return const InputDecoration(
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
  }

  ///year dropdown
  DropdownButtonFormField<String> yearDropdown() {
    return DropdownButtonFormField<String>(
        decoration: widget.isDropdownHideUnderline ? removeUnderline() : null,
        hint: const Text('Year'),
        isExpanded: widget.isExpanded,
        icon: Container(),
       // icon: widget.icon ?? const Icon(Icons.expand_more, color: Colors.grey),
        value: yearselVal == '' ? null : yearselVal,
        onChanged: (value) {
          yearsSelected(value);
        },
        validator: (value) {
          return widget.isFormValidator
              ? value == null
              ? widget.errorYear
              : null
              : null;
        },
        items: listyears.map((item) {
          return DropdownMenuItem<String>(
            value: item.toString(),
            child: Text(
              item.toString(),
              style: widget.textStyle ??
                  const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
            ),
          );
        }).toList());
  }

  ///day dropdown
  DropdownButtonFormField<String> dayDropdown() {
    return DropdownButtonFormField<String>(
        decoration: widget.isDropdownHideUnderline ? removeUnderline() : null,
        hint: const Text('Days'),
        isExpanded: widget.isExpanded,
        icon: Container(),
       // icon: widget.icon ?? const Icon(Icons.expand_more, color: Colors.grey),
        value: dayselVal == '' ? null : dayselVal,
        onChanged: (value) {
          daysSelected(value);
        },
        validator: (value) {
          return widget.isFormValidator
              ? value == null
              ? widget.errorDay
              : null
              : null;
        },
        items: listdates.map((item) {
          return DropdownMenuItem<String>(
            value: item.toString(),
            child: Text(item.toString(),
                style: widget.textStyle ??
                    const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
          );
        }).toList());
  }

  ///sizedbox for width
  Widget w(double count) => SizedBox(
    width: count,
  );
}
