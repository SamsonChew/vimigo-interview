import 'package:flutter/material.dart';
import '../models/attendance_record.dart';

class AddAttendanceScreen extends StatefulWidget {
  final Function(AttendanceRecord) onAdd;

  const AddAttendanceScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddAttendanceScreenState createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _contactInfo;
  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _selectedTime = TimeOfDay.now();
  late int _selectedSecond = 0; // Added field for second

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attendance Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  //phone number must be digits only
                  if (value == null || value.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter the phone number in digits only, no spaces or hypher';
                  }
                  return null;
                },
                onSaved: (value) => _contactInfo = value!,
              ),
              ListTile(
                title: Text('Date'),
                //show only the date not time
                subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text('Time'),
                subtitle: Text(_selectedTime.format(context)),
                onTap: () => _selectTime(context),
              ),
              TextFormField( // Added TextFormField for second
                decoration: InputDecoration(labelText: 'Second'),
                keyboardType: TextInputType.number,
                // default value is 0
                initialValue: '0',
                validator: (value) {
                  //second is between 0 and 59
                  if (value == null || value.isEmpty || int.parse(value) < 0 || int.parse(value) > 59){
                    return 'Please enter a second (between 0 and 59)';
                  }
                  return null;
                },
                onSaved: (value) => _selectedSecond = int.parse(value!),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newRecord = AttendanceRecord(
                      
                        name: _name,
                        contactInfo: _contactInfo,
                        time: DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          _selectedTime.hour,
                          _selectedTime.minute,
                          _selectedSecond, // Added second to the DateTime
                        ),
                      );
                      //print the new record time and second
                      print(newRecord.time);
                      widget.onAdd(newRecord);
                      //show indicator that the record has been added
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Record added'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Text('Add Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}