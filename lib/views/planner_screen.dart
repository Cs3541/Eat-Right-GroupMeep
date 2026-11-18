import 'package:flutter/material.dart';
import '../models/nutrition_data.dart';

void main() => runApp(const CalendarApp());

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekly Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const WeeklyCalendarScreen(),
    );
  }
}

/// Simple event model. Fields are mutable so events can be edited in place.
class CalendarEvent {
  String title;
  TimeOfDay? time;
  bool completed;

  CalendarEvent(this.title, {this.time, this.completed = false});
}

class WeeklyCalendarScreen extends StatefulWidget {
  const WeeklyCalendarScreen({super.key, this.nutritionData});

  /// Optional pre-loaded data. If null, the screen loads it from the asset
  /// the first time the add/edit dialog is opened.
  final NutritionData? nutritionData;

  @override
  State<WeeklyCalendarScreen> createState() => _WeeklyCalendarScreenState();
}

class _WeeklyCalendarScreenState extends State<WeeklyCalendarScreen> {
  int _navIndex = 0;

  late DateTime _weekStart; // Always a Sunday, time stripped.
  late DateTime _selectedDay;

  /// Events keyed by date-only DateTime.
  final Map<DateTime, List<CalendarEvent>> _events = {};

  static const _dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _nutritionAsset = 'assets/files/nutrition.csv';

  /// Max rows shown in the selector; typing narrows the list further.
  static const _maxResults = 50;

  /// Loaded once and shared by every instance of this screen.
  static Future<NutritionData>? _nutritionFuture;

  Future<NutritionData> _loadNutrition() {
    final provided = widget.nutritionData;
    if (provided != null) return Future.value(provided);
    return _nutritionFuture ??= NutritionData.fromAsset(_nutritionAsset);
  }

  @override
  void initState() {
    super.initState();
    final today = _dateOnly(DateTime.now());
    _selectedDay = today;
    _weekStart = _startOfWeek(today);
  }

  // ---------- Date helpers ----------

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// DateTime.weekday: Mon = 1 ... Sun = 7, so `% 7` makes Sunday = 0.
  DateTime _startOfWeek(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday % 7));

  /// Built with the calendar constructor (not Duration) so DST shifts
  /// never push a date off by one.
  List<DateTime> get _weekDays => List.generate(
    7,
    (i) => DateTime(_weekStart.year, _weekStart.month, _weekStart.day + i),
  );

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekRangeLabel() {
    final start = _weekDays.first;
    final end = _weekDays.last;
    final startMonth = _monthNames[start.month - 1].substring(0, 3);
    final endMonth = _monthNames[end.month - 1].substring(0, 3);
    if (start.year != end.year) {
      return '$startMonth ${start.day}, ${start.year} – $endMonth ${end.day}, ${end.year}';
    }
    if (start.month != end.month) {
      return '$startMonth ${start.day} – $endMonth ${end.day}, ${end.year}';
    }
    return '${_monthNames[start.month - 1]} ${start.day} – ${end.day}, ${end.year}';
  }

  // ---------- Actions ----------

  void _changeWeek(int offset) {
    setState(() {
      _weekStart = DateTime(
        _weekStart.year,
        _weekStart.month,
        _weekStart.day + 7 * offset,
      );
      // Keep the same weekday selected in the new week.
      _selectedDay = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day + 7 * offset,
      );
    });
  }

  void _goToToday() {
    final today = _dateOnly(DateTime.now());
    setState(() {
      _selectedDay = today;
      _weekStart = _startOfWeek(today);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDay = _dateOnly(picked);
        _weekStart = _startOfWeek(picked);
      });
    }
  }

  /// Incomplete events first, then by time (all-day events lead each group).
  List<CalendarEvent> _eventsFor(DateTime day) {
    final list = List<CalendarEvent>.from(_events[_dateOnly(day)] ?? []);
    list.sort((a, b) {
      if (a.completed != b.completed) return a.completed ? 1 : -1;
      if (a.time == null && b.time == null) return 0;
      if (a.time == null) return -1;
      if (b.time == null) return 1;
      return (a.time!.hour * 60 + a.time!.minute).compareTo(
        b.time!.hour * 60 + b.time!.minute,
      );
    });
    return list;
  }

  /// Shared add/edit dialog. Returns the chosen title and time, or null
  /// if cancelled. The title is picked from a list filtered by
  /// [NutritionData.searchNames] as the user types.
  Future<({String title, TimeOfDay? time})?> _showEventDialog({
    CalendarEvent? existing,
  }) async {
    final NutritionData data;
    try {
      data = await _loadNutrition();
    } catch (e) {
      _nutritionFuture = null; // allow a retry next time
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load foods: $e')),
        );
      }
      return null;
    }
    if (!mounted) return null;

    String? selected = existing?.title;
    TimeOfDay? time = existing?.time;
    final isEditing = existing != null;

    // Start the search with the current title so it's visible when editing.
    var query = existing?.title ?? '';

    // If the event's title is no longer in the data, still offer it.
    final missingTitle =
        (selected != null && !data.getNames().contains(selected))
            ? selected
            : null;

    return showDialog<({String title, TimeOfDay? time})>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final theme = Theme.of(ctx);
          final matches = data.searchNames(query);
          final shown = <String>[
            if (missingTitle != null) missingTitle,
            ...matches.take(_maxResults),
          ];

          return AlertDialog(
            title: Text(
              '${isEditing ? 'Edit' : 'New'} event · '
              '${_dayLabels[_selectedDay.weekday % 7]} '
              '${_selectedDay.month}/${_selectedDay.day}',
            ),
            content: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: query,
                    autofocus: !isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Search foods',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) =>
                        setDialogState(() => query = value),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 240,
                    child: shown.isEmpty
                        ? Center(
                            child: Text(
                              'No matches for "$query".',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: shown.length,
                            itemBuilder: (_, i) {
                              final name = shown[i];
                              final isSelected = name == selected;
                              return ListTile(
                                dense: true,
                                title: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                selected: isSelected,
                                selectedTileColor:
                                    theme.colorScheme.primaryContainer,
                                trailing: isSelected
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () =>
                                    setDialogState(() => selected = name),
                              );
                            },
                          ),
                  ),
                  if (matches.length > _maxResults)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Showing $_maxResults of ${matches.length}. '
                        'Keep typing to narrow it down.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
                  if (selected != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Selected: $selected',
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(
                          time == null ? 'Add time (optional)' : time!.format(ctx),
                        ),
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: ctx,
                            initialTime: time ?? TimeOfDay.now(),
                          );
                          if (t != null) setDialogState(() => time = t);
                        },
                      ),
                      if (time != null)
                        IconButton(
                          tooltip: 'Clear time',
                          icon: const Icon(Icons.close),
                          onPressed: () => setDialogState(() => time = null),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: selected == null
                    ? null
                    : () => Navigator.pop(ctx, (title: selected!, time: time)),
                child: Text(isEditing ? 'Save' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addEvent() async {
    final result = await _showEventDialog();
    if (result == null) return;
    setState(() {
      _events
          .putIfAbsent(_dateOnly(_selectedDay), () => [])
          .add(CalendarEvent(result.title, time: result.time));
    });
  }

  Future<void> _editEvent(CalendarEvent event) async {
    final result = await _showEventDialog(existing: event);
    if (result == null) return;
    setState(() {
      event.title = result.title;
      event.time = result.time;
    });
  }

  void _toggleComplete(CalendarEvent event) {
    setState(() => event.completed = !event.completed);
  }

  void _deleteEvent(CalendarEvent event) {
    final day = _dateOnly(_selectedDay);
    final list = _events[day];
    if (list == null) return;
    final index = list.indexOf(event);
    if (index == -1) return;

    setState(() => list.removeAt(index));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Deleted "${event.title}"'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => setState(() {
              final l = _events.putIfAbsent(day, () => []);
              l.insert(index.clamp(0, l.length), event);
            }),
          ),
        ),
      );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildCalendarPage(context),
      _buildPlaceholderPage(Icons.check_circle_outline, 'Tasks'),
      _buildPlaceholderPage(Icons.settings_outlined, 'Settings'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(['Calendar', 'Home', 'Settings'][_navIndex]),
        actions: _navIndex == 0
            ? [
                IconButton(
                  tooltip: 'Pick a date',
                  icon: const Icon(Icons.calendar_month),
                  onPressed: _pickDate,
                ),
                TextButton(onPressed: _goToToday, child: const Text('Today')),
              ]
            : null,
      ),
      body: IndexedStack(index: _navIndex, children: pages),
      floatingActionButton: _navIndex == 0
          ? FloatingActionButton(
              tooltip: 'Add event',
              onPressed: _addEvent,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildCalendarPage(BuildContext context) {
    final theme = Theme.of(context);
    final events = _eventsFor(_selectedDay);

    return GestureDetector(
      // Swipe left/right to change week.
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v < -200) _changeWeek(1);
        if (v > 200) _changeWeek(-1);
      },
      child: Column(
        children: [
          // Week navigation header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Previous week',
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeWeek(-1),
                ),
                Expanded(
                  child: Text(
                    _weekRangeLabel(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Next week',
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeWeek(1),
                ),
              ],
            ),
          ),

          // 7-column week grid, Sunday through Saturday
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: _weekDays
                  .map((day) => Expanded(child: _buildDayCell(day)))
                  .toList(),
            ),
          ),

          const Divider(height: 24),

          // Selected day's events
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][_selectedDay.weekday % 7]}, '
                '${_monthNames[_selectedDay.month - 1]} ${_selectedDay.day}',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'No events. Tap + to add one.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: events.length,
                    itemBuilder: (context, i) =>
                        _buildEventTile(theme, events[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(ThemeData theme, CalendarEvent e) {
    final muted = theme.colorScheme.outline;

    return Dismissible(
      key: ObjectKey(e),
      direction: DismissDirection.endToStart,
      background: Container(
        color: theme.colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete),
      ),
      onDismissed: (_) => _deleteEvent(e),
      child: ListTile(
        onTap: () => _editEvent(e),
        leading: Checkbox(
          value: e.completed,
          onChanged: (_) => _toggleComplete(e),
        ),
        title: Text(
          e.title,
          style: e.completed
              ? TextStyle(decoration: TextDecoration.lineThrough, color: muted)
              : null,
        ),
        subtitle: Text(
          e.time?.format(context) ?? 'All day',
          style: e.completed ? TextStyle(color: muted) : null,
        ),
        trailing: PopupMenuButton<String>(
          tooltip: 'Event options',
          onSelected: (action) {
            switch (action) {
              case 'edit':
                _editEvent(e);
              case 'complete':
                _toggleComplete(e);
              case 'delete':
                _deleteEvent(e);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Edit'),
              ),
            ),
            PopupMenuItem(
              value: 'complete',
              child: ListTile(
                leading: Icon(
                  e.completed ? Icons.undo : Icons.check_circle_outline,
                ),
                title: Text(e.completed ? 'Mark incomplete' : 'Mark complete'),
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isSelected = _isSameDay(day, _selectedDay);
    final isToday = _isSameDay(day, DateTime.now());
    final dayEvents = _events[_dateOnly(day)] ?? const <CalendarEvent>[];
    final hasEvents = dayEvents.isNotEmpty;
    final allDone = hasEvents && dayEvents.every((e) => e.completed);

    final bg = isSelected ? scheme.primary : Colors.transparent;
    final fg = isSelected
        ? scheme.onPrimary
        : (isToday ? scheme.primary : scheme.onSurface);
    final dotColor = isSelected ? scheme.onPrimary : scheme.primary;

    return GestureDetector(
      onTap: () => setState(() => _selectedDay = day),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: isToday && !isSelected
              ? Border.all(color: scheme.primary, width: 1.5)
              : null,
        ),
        child: Column(
          children: [
            Text(
              _dayLabels[day.weekday % 7],
              style: theme.textTheme.labelSmall?.copyWith(color: fg),
            ),
            const SizedBox(height: 6),
            Text(
              '${day.day}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            // Event indicator: filled dot = pending events, ring = all done.
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasEvents && !allDone ? dotColor : Colors.transparent,
                border: allDone ? Border.all(color: dotColor) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderPage(IconData icon, String label) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text('$label screen', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
