import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

class _InputDropdown extends StatelessWidget{
	const _InputDropdown({
		Key key,
		this.child,
		this.labelText,
		this.valueText,
		this.valueStyle,
		this.onPressed}) : super(key: key);

	final String labelText;
	final String valueText;
	final TextStyle valueStyle;
	final VoidCallback onPressed;
	final Widget child;

	@override
	Widget build(BuildContext context) {
    // TODO: implement build
    return new InkWell(
	    onTap: onPressed,
	    child: new InputDecorator(
		    decoration: new InputDecoration(
			    labelText: labelText,
		    ),
		    baseStyle: valueStyle,
		    child: new Row(
			    mainAxisAlignment: MainAxisAlignment.spaceBetween,
			    mainAxisSize: MainAxisSize.min,
			    children: <Widget>[
			    	new Text(valueText, style: valueStyle,),
				    new Icon(
					    Icons.arrow_drop_down,
					    color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70,
				    ),
			    ],
		    ),
	    ),
    );
  }
}

class DateTimePicker extends StatelessWidget{
	const DateTimePicker({
		Key key,
		this.labelText,
		this.selectedDate,
		this.selectedTime,
		this.selectDate,
		this.selectTime}) : super(key: key);

	final String labelText;
	final DateTime selectedDate;
	final TimeOfDay selectedTime;
	final ValueChanged<DateTime> selectDate;
	final ValueChanged<TimeOfDay> selectTime;

	Future<Null> _selectDate(BuildContext context) async {
		final DateTime picked = await showDatePicker(
			context: context,
			initialDate: selectedDate,
			firstDate: new DateTime(2001,1),
			lastDate: new DateTime(2100),
			initialDatePickerMode: DatePickerMode.day,
		);
		if(picked != null && picked != selectedDate)
			selectDate(picked);
	}

	Future<Null> _selectTime(BuildContext context) async {
		final TimeOfDay picked = await showTimePicker(
			context: context,
			initialTime: selectedTime,
		);
		if(picked != null && picked != selectedTime)
			selectTime(picked);
	}

	@override
	Widget build(BuildContext context) {

		final TextStyle valueStyle = Theme.of(context).textTheme.title;

		return new Row(
			crossAxisAlignment: CrossAxisAlignment.end,
			children: <Widget>[
				new Expanded(
					flex: 4,
					child: new _InputDropdown(
						labelText: "Date",
						valueText: _Date2String(selectedDate),//new DateFormat.yMMMd().format(selectedDate),
						valueStyle: valueStyle,
						onPressed: () {_selectDate(context);},
					),
				),
				const SizedBox(width: 12.0,),
				new Expanded(
					flex: 3,
					child: new _InputDropdown(
						labelText: "Time",
						valueText: _Time2String(selectedTime),
						valueStyle: valueStyle,
						onPressed: (){_selectTime(context);},
					)
				)
			],
		);
  }
}

String _Date2String(DateTime d){
	return d.year.toString() + "-" + d.month.toString() + "-" + d.day.toString();
}

String _Time2String(TimeOfDay t){
	return t.hour.toString() + ":" + t.minute.toString();
}