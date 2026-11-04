// import 'package:flutter/material.dart';

// import 'main_navigation.dart';
// import 'home_screen.dart';

// //void main() => runApp(const CalendarApp());

// class CalendarApp extends StatelessWidget {
//   const CalendarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weekly Calendar',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
//       home: const WeeklyCalendarScreen(),
//     );
//   }
// }

// /// Simple event model.
// class CalendarEvent {
//   final String title;
//   final TimeOfDay? time;

//   CalendarEvent(this.title, {this.time});
// }

// class WeeklyCalendarScreen extends StatefulWidget {
//   const WeeklyCalendarScreen({super.key});

//   @override
//   State<WeeklyCalendarScreen> createState() => _WeeklyCalendarScreenState();
// }

// class _WeeklyCalendarScreenState extends State<WeeklyCalendarScreen> {
//   int _navIndex = 0;

//   late DateTime _weekStart; // Always a Sunday, time stripped.
//   late DateTime _selectedDay;

//   /// Events keyed by date-only DateTime.
//   final Map<DateTime, List<CalendarEvent>> _events = {};

//   static const _dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//   static const _monthNames = [
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     final today = _dateOnly(DateTime.now());
//     _selectedDay = today;
//     _weekStart = _startOfWeek(today);
//   }

//   // ---------- Date helpers ----------

//   DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

//   /// DateTime.weekday: Mon = 1 ... Sun = 7, so `% 7` makes Sunday = 0.
//   DateTime _startOfWeek(DateTime d) =>
//       DateTime(d.year, d.month, d.day - (d.weekday % 7));

//   /// Built with the calendar constructor (not Duration) so DST shifts
//   /// never push a date off by one.
//   List<DateTime> get _weekDays => List.generate(
//     7,
//     (i) => DateTime(_weekStart.year, _weekStart.month, _weekStart.day + i),
//   );

//   bool _isSameDay(DateTime a, DateTime b) =>
//       a.year == b.year && a.month == b.month && a.day == b.day;

//   String _weekRangeLabel() {
//     final start = _weekDays.first;
//     final end = _weekDays.last;
//     final startMonth = _monthNames[start.month - 1].substring(0, 3);
//     final endMonth = _monthNames[end.month - 1].substring(0, 3);
//     if (start.year != end.year) {
//       return '$startMonth ${start.day}, ${start.year} – $endMonth ${end.day}, ${end.year}';
//     }
//     if (start.month != end.month) {
//       return '$startMonth ${start.day} – $endMonth ${end.day}, ${end.year}';
//     }
//     return '${_monthNames[start.month - 1]} ${start.day} – ${end.day}, ${end.year}';
//   }

//   // ---------- Actions ----------

//   void _changeWeek(int offset) {
//     setState(() {
//       _weekStart = DateTime(
//         _weekStart.year,
//         _weekStart.month,
//         _weekStart.day + 7 * offset,
//       );
//       // Keep the same weekday selected in the new week.
//       _selectedDay = DateTime(
//         _selectedDay.year,
//         _selectedDay.month,
//         _selectedDay.day + 7 * offset,
//       );
//     });
//   }

//   void _goToToday() {
//     final today = _dateOnly(DateTime.now());
//     setState(() {
//       _selectedDay = today;
//       _weekStart = _startOfWeek(today);
//     });
//   }

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDay,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDay = _dateOnly(picked);
//         _weekStart = _startOfWeek(picked);
//       });
//     }
//   }

//   List<CalendarEvent> _eventsFor(DateTime day) {
//     final list = List<CalendarEvent>.from(_events[_dateOnly(day)] ?? []);
//     list.sort((a, b) {
//       if (a.time == null && b.time == null) return 0;
//       if (a.time == null) return -1;
//       if (b.time == null) return 1;
//       return (a.time!.hour * 60 + a.time!.minute).compareTo(
//         b.time!.hour * 60 + b.time!.minute,
//       );
//     });
//     return list;
//   }

//   Future<void> _addEvent() async {
//     final controller = TextEditingController();
//     TimeOfDay? time;

//     final result = await showDialog<CalendarEvent>(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (ctx, setDialogState) => AlertDialog(
//           title: Text(
//             'New event · ${_dayLabels[_selectedDay.weekday % 7]} '
//             '${_selectedDay.month}/${_selectedDay.day}',
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: controller,
//                 autofocus: true,
//                 decoration: const InputDecoration(labelText: 'Title'),
//               ),
//               const SizedBox(height: 12),
//               OutlinedButton.icon(
//                 icon: const Icon(Icons.access_time),
//                 label: Text(
//                   time == null ? 'Add time (optional)' : time!.format(ctx),
//                 ),
//                 onPressed: () async {
//                   final t = await showTimePicker(
//                     context: ctx,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (t != null) setDialogState(() => time = t);
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Cancel'),
//             ),
//             FilledButton(
//               onPressed: () {
//                 final title = controller.text.trim();
//                 if (title.isEmpty) return;
//                 Navigator.pop(ctx, CalendarEvent(title, time: time));
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         ),
//       ),
//     );
//     controller.dispose();

//     if (result != null) {
//       setState(() {
//         _events.putIfAbsent(_dateOnly(_selectedDay), () => []).add(result);
//       });
//     }
//   }

//   void _deleteEvent(CalendarEvent event) {
//     setState(() {
//       _events[_dateOnly(_selectedDay)]?.remove(event);
//     });
//   }

//   // ---------- UI ----------

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       _buildCalendarPage(context),
//       _buildPlaceholderPage(Icons.check_circle_outline, 'Tasks'),
//       _buildPlaceholderPage(Icons.settings_outlined, 'Settings'),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(['Calendar', 'Home', 'Settings'][_navIndex]),
//         actions: _navIndex == 0
//             ? [
//                 IconButton(
//                   tooltip: 'Pick a date',
//                   icon: const Icon(Icons.calendar_month),
//                   onPressed: _pickDate,
//                 ),
//                 TextButton(onPressed: _goToToday, child: const Text('Today')),
//               ]
//             : null,
//       ),
//       body: IndexedStack(index: _navIndex, children: pages),
//       floatingActionButton: _navIndex == 0
//           ? FloatingActionButton(
//               tooltip: 'Add event',
//               onPressed: _addEvent,
//               child: const Icon(Icons.add),
//             )
//           : null,
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _navIndex,
//         onDestinationSelected: (i) => setState(() => _navIndex = i),
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.calendar_today_outlined),
//             selectedIcon: Icon(Icons.calendar_today),
//             label: 'Calendar',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.check_circle_outline),
//             selectedIcon: Icon(Icons.check_circle),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.settings_outlined),
//             selectedIcon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCalendarPage(BuildContext context) {
//     final theme = Theme.of(context);
//     final events = _eventsFor(_selectedDay);

//     return GestureDetector(
//       // Swipe left/right to change week.
//       onHorizontalDragEnd: (details) {
//         final v = details.primaryVelocity ?? 0;
//         if (v < -200) _changeWeek(1);
//         if (v > 200) _changeWeek(-1);
//       },
//       child: Column(
//         children: [
//           // Week navigation header
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child: Row(
//               children: [
//                 IconButton(
//                   tooltip: 'Previous week',
//                   icon: const Icon(Icons.chevron_left),
//                   onPressed: () => _changeWeek(-1),
//                 ),
//                 Expanded(
//                   child: Text(
//                     _weekRangeLabel(),
//                     textAlign: TextAlign.center,
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   tooltip: 'Next week',
//                   icon: const Icon(Icons.chevron_right),
//                   onPressed: () => _changeWeek(1),
//                 ),
//               ],
//             ),
//           ),

//           // 7-column week grid, Sunday through Saturday
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               children: _weekDays
//                   .map((day) => Expanded(child: _buildDayCell(day)))
//                   .toList(),
//             ),
//           ),

//           const Divider(height: 24),

//           // Selected day's events
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 '${['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][_selectedDay.weekday % 7]}, '
//                 '${_monthNames[_selectedDay.month - 1]} ${_selectedDay.day}',
//                 style: theme.textTheme.titleSmall,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: events.isEmpty
//                 ? Center(
//                     child: Text(
//                       'No events. Tap + to add one.',
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: theme.colorScheme.outline,
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.only(bottom: 88),
//                     itemCount: events.length,
//                     itemBuilder: (context, i) {
//                       final e = events[i];
//                       return Dismissible(
//                         key: ObjectKey(e),
//                         direction: DismissDirection.endToStart,
//                         background: Container(
//                           color: theme.colorScheme.errorContainer,
//                           alignment: Alignment.centerRight,
//                           padding: const EdgeInsets.only(right: 20),
//                           child: const Icon(Icons.delete),
//                         ),
//                         onDismissed: (_) => _deleteEvent(e),
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: theme.colorScheme.primaryContainer,
//                             child: const Icon(Icons.event, size: 20),
//                           ),
//                           title: Text(e.title),
//                           subtitle: Text(e.time?.format(context) ?? 'All day'),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDayCell(DateTime day) {
//     final theme = Theme.of(context);
//     final scheme = theme.colorScheme;
//     final isSelected = _isSameDay(day, _selectedDay);
//     final isToday = _isSameDay(day, DateTime.now());
//     final hasEvents = (_events[_dateOnly(day)]?.isNotEmpty ?? false);

//     final bg = isSelected ? scheme.primary : Colors.transparent;
//     final fg = isSelected
//         ? scheme.onPrimary
//         : (isToday ? scheme.primary : scheme.onSurface);

//     return GestureDetector(
//       onTap: () => setState(() => _selectedDay = day),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.symmetric(horizontal: 2),
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(12),
//           border: isToday && !isSelected
//               ? Border.all(color: scheme.primary, width: 1.5)
//               : null,
//         ),
//         child: Column(
//           children: [
//             Text(
//               _dayLabels[day.weekday % 7],
//               style: theme.textTheme.labelSmall?.copyWith(color: fg),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               '${day.day}',
//               style: theme.textTheme.titleMedium?.copyWith(
//                 color: fg,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 6),
//             // Event indicator dot
//             Container(
//               width: 6,
//               height: 6,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: hasEvents
//                     ? (isSelected ? scheme.onPrimary : scheme.primary)
//                     : Colors.transparent,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlaceholderPage(IconData icon, String label) {
//     final theme = Theme.of(context);
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 64, color: theme.colorScheme.outline),
//           const SizedBox(height: 12),
//           Text('$label screen', style: theme.textTheme.titleMedium),
//         ],
//       ),
//     );
//   }
// }
