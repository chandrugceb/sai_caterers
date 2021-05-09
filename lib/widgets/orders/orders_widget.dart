import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sai_caterers/models/event_model.dart';
import 'package:sai_caterers/providers/event_provider.dart';
import 'package:sai_caterers/widgets/plates/events_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

class OrdersWidget extends StatefulWidget {
  final spinkit = SpinKitRipple(
    color: Colors.deepOrange,
    size: 200.0,
  );

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget>
    with TickerProviderStateMixin {
  //Almost all the events on the calendar
  Map<DateTime, List<OrderEvent>> _events = new Map();

  //Only the Events of selected date
  List<OrderEvent> _selectedEvents;

  OrderEventsProvider _orderEventProvider;

  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _events = {};
    _selectedEvents = [];

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected => ' + day.day.toString());
    setState(() {
      if (events.isNotEmpty) {
        _selectedEvents = events;
      } else {
        _selectedEvents = [];
      }
    });
    _selectedDay = new DateTime(day.year, day.month, day.day, 0, 0, 0);
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    print('Build: _OrdersWidgetState');
    _selectedEvents = [];
    _orderEventProvider =
        Provider.of<OrderEventsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("ORDERS")),
      ),
      body: Column(children: [
        _buildTableCalendarWithBuilders(),
        StreamBuilder(
          stream: _orderEventProvider.events,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                refreshEvents(snapshot);
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _buildEventList(),
                    const SizedBox(height: 8.0),
                  ],
                );
              } else {
                return widget.spinkit;
              }
            } else {
              return widget.spinkit;
            }
          },
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Uuid _uuid = new Uuid();
          OrderEvent _orderEvent = new OrderEvent(
              eventId: _uuid.v1().toString(),
              eventName: "New Event on " + _selectedDay.toString(),
              startDateTime: _selectedDay,
              endDateTime: null,
              orderDeliveryDateTime: null,
              orderReadyDateTime: null,
              customerName: null,
              customerPhone: null,
              cookingVenue: null,
              eventNotes: null,
              persons: 1);
          _orderEventProvider.addEvent(_orderEvent);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(providers: [
                  ListenableProvider<OrderEventsProvider>(
                      create: (context) => _orderEventProvider),
                  ListenableProvider<OrderEvent>(
                      create: (context) => _orderEvent),
                ], child: EventsWidget()),
              ));
        },
        child: Icon(Icons.add_sharp, color: Colors.white),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    print("_buildTableCalendarWithBuilders");
    return TableCalendar(
      locale: 'en_EN',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle:
            TextStyle().copyWith(fontSize: 20.0, color: Colors.blueGrey[500]),
        weekdayStyle:
            TextStyle().copyWith(fontSize: 20.0, color: Colors.grey[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle:
              TextStyle().copyWith(fontSize: 20.0, color: Colors.blueGrey[500]),
          weekdayStyle:
              TextStyle().copyWith(fontSize: 20.0, color: Colors.grey[500])),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: true,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          print("selectedDayBuilder " + date.toString());
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(4.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style:
                      TextStyle().copyWith(fontSize: 26.0, color: Colors.white),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            color: Colors.blue[600],
            child: Center(
              child: Text(
                '${date.day}',
                style:
                    TextStyle().copyWith(fontSize: 20.0, color: Colors.white),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List<OrderEvent> events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.5,
          color: _calendarController.isToday(date)
              ? Colors.deepOrange
              : date.difference(DateTime.now()) < Duration(seconds: 0)
                  ? Colors.grey
                  : Colors.lightGreen,
        ),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      width: 26.0,
      height: 26.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: _calendarController.isToday(date)
                ? Colors.deepOrange
                : date.difference(DateTime.now()) < Duration(seconds: 0)
                    ? Colors.grey
                    : Colors.lightGreen,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    print("====================================>_buildEventList " +
        DateTime.now().toString());
    return ListView(
      shrinkWrap: true,
      children: _selectedEvents
          .map((_event) => Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: _eventItemWidget(_event),
                  onTap: () {
                    print(_event.eventName + 'tapped!');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(providers: [
                            ListenableProvider<OrderEventsProvider>(
                                create: (context) => _orderEventProvider),
                            ListenableProvider<OrderEvent>(
                                create: (context) => _event),
                          ], child: EventsWidget()),
                        ));
                  },
                ),
              ))
          .toList(),
    );
  }

  void refreshEvents(AsyncSnapshot snapshot) {
    _events.clear();
    snapshot.data.forEach((_orderEvent) {
      insertEvents(_orderEvent);
    });
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  void insertEvents(OrderEvent _orderEvent) {
    DateTime orderEventStartDateTime;
    orderEventStartDateTime = new DateTime(
        _orderEvent.startDateTime.year,
        _orderEvent.startDateTime.month,
        _orderEvent.startDateTime.day,
        0,
        0,
        0);

    _events.update(orderEventStartDateTime, (value) {
      value.add(_orderEvent);
      return value;
    }, ifAbsent: () => [_orderEvent]);
  }

  Widget _eventItemWidget(OrderEvent _orderEvent) {
    return Card(
      elevation: 10,
      child: ListTile(
        leading: Icon(Icons.timelapse_outlined, color: Colors.deepOrange),
        title: Text(_orderEvent.eventName),
        subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
          Text(DateFormat('dd MMMM, yyyy – kk:mm')
              .format(_orderEvent.startDateTime)),
          Text(_orderEvent.persons.toString() + " persons"),
        ]),
      ),
    );
    Text(_orderEvent.eventName);
  }
}
