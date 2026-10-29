import 'package:flutter/material.dart';

void main() => runApp(const TaskFlowApp());

const purple = Color(0xFF7663E9);
const ink = Color(0xFF28243D);
const pageBg = Color(0xFFF8F7FC);

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageBg,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        fontFamily: 'Arial',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFBFAFE),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFFE9E6F2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFFE9E6F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: purple, width: 1.5),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class AppTask {
  AppTask({
    required this.title,
    this.description = '',
    this.category = 'Personal',
    this.priority = 'Medium',
    this.dueDate,
    this.done = false,
  });

  String title;
  String description;
  String category;
  String priority;
  DateTime? dueDate;
  bool done;
}

class AppNote {
  AppNote(this.title, this.body, this.createdAt);
  String title;
  String body;
  DateTime createdAt;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _signup = true;
  bool _hidePassword = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TaskFlowHome(
          name: _signup && _name.text.trim().isNotEmpty
              ? _name.text.trim()
              : _email.text.trim().split('@').first,
          email: _email.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0ECFF), Color(0xFFFCF9FF), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(color: Color(0xFFEDEAF7)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              height: 62,
                              width: 62,
                              decoration: BoxDecoration(
                                color: purple,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/taskflow_logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text('taskflow',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w900,
                                color: ink,
                                letterSpacing: -1,
                              )),
                          const SizedBox(height: 8),
                          Text(
                            _signup
                                ? 'A fresh start looks good on you.'
                                : 'Welcome back. Let’s make today count.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 28),
                          if (_signup) ...[
                            const Text('Your name',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Alex Morgan',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (v) => _signup &&
                                      (v == null || v.trim().isEmpty)
                                  ? 'Please enter your name'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                          ],
                          const Text('Email address',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'you@example.com',
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                            validator: (v) {
                              if (v == null ||
                                  !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                      .hasMatch(v.trim())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Password',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _password,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              hintText: 'At least 6 characters',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                    () => _hidePassword = !_hidePassword),
                                icon: Icon(_hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),
                            ),
                            validator: (v) => v == null || v.length < 6
                                ? 'Use at least 6 characters'
                                : null,
                          ),
                          const SizedBox(height: 22),
                          FilledButton(
                            onPressed: _continue,
                            style: FilledButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: Text(_signup ? 'Create account  ↗' : 'Sign in  ↗',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => setState(() => _signup = !_signup),
                            child: Text(_signup
                                ? 'Already have an account? Sign in'
                                : 'New to TaskFlow? Create an account'),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'UI demo only · Connect secure authentication for real accounts.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskFlowHome extends StatefulWidget {
  const TaskFlowHome({super.key, required this.name, required this.email});
  final String name;
  final String email;

  @override
  State<TaskFlowHome> createState() => _TaskFlowHomeState();
}

class _TaskFlowHomeState extends State<TaskFlowHome> {
  int _tab = 0;
  late String _name;
  late String _email;
  String _role = 'Student';
  String _bio = '';
  final List<AppTask> _tasks = [];
  final List<AppNote> _notes = [];

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
  }

  int get _completed => _tasks.where((t) => t.done).length;
  int get _active => _tasks.length - _completed;

  String get _greeting {
    final hour = DateTime.now().hour;
    final hello = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    return '$hello, ${_name.split(' ').first} ✨';
  }

  void _showTaskDialog({int? index}) {
    final existing = index == null ? null : _tasks[index];
    final title = TextEditingController(text: existing?.title ?? '');
    final description =
        TextEditingController(text: existing?.description ?? '');
    String category = existing?.category ?? 'Personal';
    String priority = existing?.priority ?? 'Medium';
    DateTime? dueDate = existing?.dueDate;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Text(existing == null ? 'Create a task' : 'Edit task',
              style: const TextStyle(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: 'Task title *',
                        hintText: 'What would you like to get done?'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: description,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Add a little detail...'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: ['Personal', 'Study', 'Work', 'Health', 'Other']
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) =>
                        setDialogState(() => category = v ?? 'Personal'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: ['Low', 'Medium', 'High']
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) =>
                        setDialogState(() => priority = v ?? 'Medium'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dueDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => dueDate = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(dueDate == null
                        ? 'Choose due date'
                        : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (title.text.trim().isEmpty) return;
                setState(() {
                  final task = AppTask(
                    title: title.text.trim(),
                    description: description.text.trim(),
                    category: category,
                    priority: priority,
                    dueDate: dueDate,
                    done: existing?.done ?? false,
                  );
                  if (index == null) {
                    _tasks.insert(0, task);
                  } else {
                    _tasks[index] = task;
                  }
                });
                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(backgroundColor: purple),
              child: Text(existing == null ? 'Add task' : 'Save changes'),
            ),
          ],
        ),
      ),
    ).then((_) {
      title.dispose();
      description.dispose();
    });
  }

  void _showNoteDialog() {
    final title = TextEditingController();
    final body = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Add a quick note',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: title,
                  decoration: const InputDecoration(
                      labelText: 'Title', hintText: 'A thought worth keeping')),
              const SizedBox(height: 12),
              TextField(
                controller: body,
                maxLines: 5,
                decoration: const InputDecoration(
                    labelText: 'Your text', hintText: 'Write your idea here...'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (body.text.trim().isEmpty) return;
              setState(() => _notes.insert(
                  0,
                  AppNote(title.text.trim().isEmpty ? 'Quick note' : title.text.trim(),
                      body.text.trim(), DateTime.now())));
              Navigator.pop(dialogContext);
              title.dispose();
              body.dispose();
            },
            style: FilledButton.styleFrom(backgroundColor: purple),
            child: const Text('Save note'),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog() {
    final name = TextEditingController(text: _name);
    final email = TextEditingController(text: _email);
    final bio = TextEditingController(text: _bio);
    String role = _role;
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('Your profile',
              style: TextStyle(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: const Color(0xFFE8E3FF),
                    child: Text(_initials(name.text),
                        style: const TextStyle(
                            color: purple,
                            fontWeight: FontWeight.w800,
                            fontSize: 23)),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                      controller: name,
                      decoration: const InputDecoration(labelText: 'Full name')),
                  const SizedBox(height: 12),
                  TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'Email address')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: const InputDecoration(labelText: 'Your role'),
                    items: ['Student', 'Professional', 'Creator', 'Entrepreneur', 'Other']
                        .map((s) =>
                            DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) =>
                        setDialogState(() => role = v ?? 'Student'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                      controller: bio,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          labelText: 'About you',
                          hintText: 'Your goals and interests...')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (name.text.trim().isEmpty || email.text.trim().isEmpty) {
                  return;
                }
                setState(() {
                  _name = name.text.trim();
                  _email = email.text.trim();
                  _role = role;
                  _bio = bio.text.trim();
                });
                Navigator.pop(dialogContext);
                name.dispose();
                email.dispose();
                bio.dispose();
              },
              style: FilledButton.styleFrom(backgroundColor: purple),
              child: const Text('Save profile'),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'T';
    return parts.length == 1
        ? parts.first[0].toUpperCase()
        : '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;
    return Scaffold(
      body: Row(
        children: [
          if (wide) _sideBar(),
          Expanded(
            child: Column(
              children: [
                _topBar(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _tab == 0
                        ? _dashboard(key: const ValueKey('dashboard'))
                        : _tab == 1
                            ? _tasksPage(key: const ValueKey('tasks'))
                            : _notesPage(key: const ValueKey('notes')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (v) => setState(() => _tab = v),
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.grid_view_rounded), label: 'Overview'),
                NavigationDestination(
                    icon: Icon(Icons.checklist_rounded), label: 'Tasks'),
                NavigationDestination(
                    icon: Icon(Icons.sticky_note_2_outlined), label: 'Notes'),
              ],
            ),
    );
  }

  Widget _sideBar() => Container(
        width: 235,
        padding: const EdgeInsets.fromLTRB(18, 28, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: Color(0xFFEEECF5))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/taskflow_logo.png',
                    width: 42, height: 42, fit: BoxFit.cover),
              ),
              const SizedBox(width: 9),
              const Text('taskflow',
                  style: TextStyle(
                      fontSize: 23, fontWeight: FontWeight.w900, color: ink))
            ]),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 12),
              child: Text('WORKSPACE',
                  style: TextStyle(
                      color: Color(0xFFA7A2B8),
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold)),
            ),
            _navButton(0, Icons.grid_view_rounded, 'Overview'),
            _navButton(1, Icons.checklist_rounded, 'My tasks'),
            _navButton(2, Icons.sticky_note_2_outlined, 'Quick notes'),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F2FF),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome, color: purple),
                    SizedBox(height: 9),
                    Text('A little progress adds up.',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: ink)),
                    SizedBox(height: 5),
                    Text('One task at a time. You’ve got this.',
                        style: TextStyle(
                            color: Color(0xFF858198), fontSize: 11, height: 1.5))
                  ]),
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: _showProfileDialog,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  _avatar(_initials(_name)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(_email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey))
                        ]),
                  ),
                  const Icon(Icons.more_horiz, color: Colors.grey)
                ]),
              ),
            ),
          ],
        ),
      );

  Widget _brandIcon() => Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
            color: purple, borderRadius: BorderRadius.circular(11)),
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
      );

  Widget _avatar(String text) => CircleAvatar(
        radius: 19,
        backgroundColor: const Color(0xFFE8E3FF),
        child: Text(text,
            style: const TextStyle(
                color: purple, fontWeight: FontWeight.w800, fontSize: 12)),
      );

  Widget _navButton(int index, IconData icon, String label) {
    final selected = _tab == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: InkWell(
        onTap: () => setState(() => _tab = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF0EDFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Icon(icon, size: 19, color: selected ? purple : Colors.grey),
            const SizedBox(width: 13),
            Text(label,
                style: TextStyle(
                    color: selected ? purple : const Color(0xFF858198),
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
            if (index == 1) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)),
                child: Text('$_active',
                    style: const TextStyle(fontSize: 10, color: purple)),
              )
            ]
          ]),
        ),
      ),
    );
  }

  Widget _topBar() => Container(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
        color: pageBg,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateTime.now()
                        .toLocal()
                        .toString()
                        .split(' ')
                        .first,
                    style: const TextStyle(
                        color: Color(0xFF9995AD),
                        fontSize: 10,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(_greeting,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: ink,
                          letterSpacing: -.5)),
                ],
              ),
            ),
            IconButton(
              onPressed: _showProfileDialog,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFEEECF5)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.person_outline, color: purple),
            ),
            const SizedBox(width: 8),
            _avatar(_initials(_name)),
          ],
        ),
      );

  Widget _dashboard({Key? key}) {
    final openTasks = _tasks.where((t) => !t.done).take(4).toList();
    final percent = _tasks.isEmpty ? 0 : (_completed / _tasks.length * 100).round();
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEAE5FF), Color(0xFFF8EEFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(23),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('YOUR DAILY RESET',
                          style: TextStyle(
                              color: purple,
                              fontSize: 10,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 13),
                      const Text('Make room for\nwhat matters.',
                          style: TextStyle(
                              color: ink,
                              fontSize: 28,
                              height: 1.18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.7)),
                      const SizedBox(height: 9),
                      const Text('Small steps make wonderful things happen.',
                          style: TextStyle(
                              color: Color(0xFF817B9D), fontSize: 11)),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: () => _showTaskDialog(),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add a task'),
                        style: FilledButton.styleFrom(
                          backgroundColor: purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11)),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.wb_sunny_rounded,
                    color: Color(0xFFB3A4FF), size: 90),
              ],
            ),
          ),
          const SizedBox(height: 27),
          const Text('Your overview',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: ink)),
          const SizedBox(height: 5),
          const Text('A little clarity goes a long way.',
              style: TextStyle(color: Color(0xFF858198), fontSize: 11)),
          const SizedBox(height: 15),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth < 520 ? 1 : 3;
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: columns == 1 ? 3.4 : 1.45,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _statCard('ALL TASKS', '${_tasks.length}',
                    Icons.checklist_rounded, const Color(0xFFF0EDFF), purple,
                    'Everything on your list'),
                _statCard('COMPLETED', '$_completed',
                    Icons.check_circle_outline, const Color(0xFFE5F8EF),
                    const Color(0xFF2FA875), '$percent% of tasks finished'),
                _statCard('IN PROGRESS', '$_active', Icons.schedule_rounded,
                    const Color(0xFFFFF0E5), const Color(0xFFD58C4E),
                    'Keep your momentum'),
              ],
            );
          }),
          const SizedBox(height: 27),
          LayoutBuilder(builder: (context, constraints) {
            final stacked = constraints.maxWidth < 720;
            final tasksPanel = _panel(
              title: 'Today’s focus',
              subtitle: 'Your next best steps.',
              trailing: IconButton(
                onPressed: () => _showTaskDialog(),
                icon: const Icon(Icons.add_circle, color: purple),
              ),
              child: openTasks.isEmpty
                  ? _emptyState(Icons.auto_awesome, 'A fresh start!',
                      'Add your first task and make today count.')
                  : Column(
                      children: openTasks
                          .map((t) => _taskTile(t, _tasks.indexOf(t)))
                          .toList(),
                    ),
            );
            final notesPanel = _panel(
              title: 'Thought corner',
              subtitle: 'Catch ideas before they fly away.',
              trailing: const Icon(Icons.edit_note,
                  color: Color(0xFFD58C4E), size: 27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_notes.isEmpty)
                    const Text('Your saved notes will appear here.',
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF858198))),
                  ..._notes.take(2).map((n) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFFAF2),
                            borderRadius: BorderRadius.circular(11)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              const SizedBox(height: 5),
                              Text(n.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF858198))),
                            ]),
                      )),
                  OutlinedButton.icon(
                    onPressed: _showNoteDialog,
                    icon: const Icon(Icons.add, size: 17),
                    label: const Text('Add a note'),
                  )
                ],
              ),
            );
            return stacked
                ? Column(children: [
                    tasksPanel,
                    const SizedBox(height: 14),
                    notesPanel
                  ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: tasksPanel),
                      const SizedBox(width: 15),
                      Expanded(child: notesPanel),
                    ],
                  );
          }),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color bg,
      Color iconColor, String foot) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFEEECF5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration:
                BoxDecoration(color: bg, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: iconColor, size: 19),
          ),
          const Spacer(),
          Flexible(
            child: Text(label,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 9,
                    letterSpacing: .8,
                    color: Color(0xFFA5A1B4),
                    fontWeight: FontWeight.bold)),
          ),
        ]),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontSize: 27, fontWeight: FontWeight.w900, color: ink)),
        Text(foot,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 10, color: Color(0xFF858198))),
      ]),
    );
  }

  Widget _panel(
      {required String title,
      required String subtitle,
      required Widget child,
      Widget? trailing}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEEECF5))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w900, color: ink)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      color: Color(0xFF858198), fontSize: 10)),
            ]),
          ),
          if (trailing != null) trailing,
        ]),
        const SizedBox(height: 15),
        child,
      ]),
    );
  }

  Widget _emptyState(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(children: [
        Icon(icon, size: 29, color: const Color(0xFFB7ABFF)),
        const SizedBox(height: 9),
        Text(title,
            style: const TextStyle(
                color: ink, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 5),
        Text(description,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xFF858198), fontSize: 11, height: 1.5)),
      ]),
    );
  }

  Widget _taskTile(AppTask task, int index) {
    final color = task.priority == 'High'
        ? const Color(0xFFD45B6A)
        : task.priority == 'Low'
            ? const Color(0xFF2FA875)
            : const Color(0xFFC28A35);
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFDFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EEF6)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Checkbox(
          value: task.done,
          activeColor: purple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onChanged: (v) => setState(() => task.done = v ?? false),
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(task.title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration:
                          task.done ? TextDecoration.lineThrough : null,
                      color: task.done ? Colors.grey : ink)),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFF858198), fontSize: 10)),
              ],
              const SizedBox(height: 7),
              Wrap(spacing: 6, runSpacing: 5, children: [
                _chip(task.priority, color),
                _chip(task.category, purple),
                if (task.dueDate != null)
                  _chip(
                      '${task.dueDate!.day}/${task.dueDate!.month}',
                      const Color(0xFF858198)),
              ]),
            ]),
          ),
        ),
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
          onSelected: (value) {
            if (value == 'edit') _showTaskDialog(index: index);
            if (value == 'delete') setState(() => _tasks.removeAt(index));
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ]),
    );
  }

  Widget _chip(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 9, color: color, fontWeight: FontWeight.w600)),
      );

  Widget _tasksPage({Key? key}) {
    final completed = _tasks.where((t) => t.done).length;
    return ListView(
      key: key,
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 30),
      children: [
        Row(children: [
          const Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My tasks',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: ink)),
                  SizedBox(height: 5),
                  Text('Make a plan, then make it happen.',
                      style: TextStyle(
                          color: Color(0xFF858198), fontSize: 11))
                ]),
          ),
          FilledButton.icon(
            onPressed: () => _showTaskDialog(),
            icon: const Icon(Icons.add),
            label: const Text('New task'),
            style: FilledButton.styleFrom(backgroundColor: purple),
          )
        ]),
        const SizedBox(height: 20),
        _panel(
          title: 'Your list',
          subtitle: '$completed completed · ${_active} still to do',
          child: _tasks.isEmpty
              ? _emptyState(Icons.checklist, 'Nothing on your list yet',
                  'Create a task to get started.')
              : Column(
                  children: List.generate(
                      _tasks.length, (index) => _taskTile(_tasks[index], index)),
                ),
        )
      ],
    );
  }

  Widget _notesPage({Key? key}) {
    return ListView(
      key: key,
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 30),
      children: [
        Row(children: [
          const Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick notes',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: ink)),
                  SizedBox(height: 5),
                  Text('Your ideas deserve a place to land.',
                      style: TextStyle(
                          color: Color(0xFF858198), fontSize: 11))
                ]),
          ),
          FilledButton.icon(
            onPressed: _showNoteDialog,
            icon: const Icon(Icons.add),
            label: const Text('New note'),
            style: FilledButton.styleFrom(backgroundColor: purple),
          )
        ]),
        const SizedBox(height: 20),
        if (_notes.isEmpty)
          _panel(
              title: 'Thought corner',
              subtitle: 'Save reminders, ideas, and text.',
              child: _emptyState(Icons.sticky_note_2_outlined,
                  'No notes yet', 'Tap “New note” to save your first thought.'))
        else
          LayoutBuilder(builder: (context, constraints) {
            final count = constraints.maxWidth < 550 ? 1 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _notes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 180,
              ),
              itemBuilder: (context, index) {
                final note = _notes[index];
                final colors = [
                  const Color(0xFFFFFAF2),
                  const Color(0xFFF5F2FF),
                  const Color(0xFFEFFAF5)
                ];
                return Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEEECF5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.sticky_note_2_outlined,
                            color: purple, size: 19),
                        const Spacer(),
                        IconButton(
                          onPressed: () =>
                              setState(() => _notes.removeAt(index)),
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.grey, size: 19),
                          tooltip: 'Delete note',
                        )
                      ]),
                      Text(note.title,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: ink)),
                      const SizedBox(height: 7),
                      Expanded(
                        child: Text(note.body,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: const TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: Color(0xFF77738A))),
                      ),
                      Text(
                          '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                          style: const TextStyle(
                              color: Color(0xFFA09BAD), fontSize: 9)),
                    ],
                  ),
                );
              },
            );
          }),
      ],
    );
  }
}
