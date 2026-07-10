import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      title: 'Counter con estado restaurable',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A1B4D)),
        scaffoldBackgroundColor: const Color(0xFFF8EEF4),
        useMaterial3: true,
      ),
      home: const CounterPage(title: 'Persistencia en Flutter'),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.title});

  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
    with RestorationMixin, WidgetsBindingObserver {
  final RestorableInt _counter = RestorableInt(0);
  bool _didEmitStart = false;
  bool _shouldLogRestart = false;

  @override
  String? get restorationId => 'counter_page';

  void _log(String event) {
    debugPrint('[Lifecycle] $event');
  }

  @override
  void initState() {
    super.initState();
    _log('onCreate');
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_didEmitStart) {
        _didEmitStart = true;
        _log('onStart');
      }
    });
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_counter, 'counter');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_shouldLogRestart) {
          _log('onRestart');
          _shouldLogRestart = false;
        }
        _log('onResume');
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _shouldLogRestart = true;
        _log('onPause');
        break;
      case AppLifecycleState.hidden:
        _shouldLogRestart = true;
        _log('onStop');
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter.value++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter.value = 0;
    });
  }

  @override
  void dispose() {
    _log('onDestroy');
    WidgetsBinding.instance.removeObserver(this);
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Contador',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '${_counter.value}',
                key: const Key('counter-value'),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'El estado se restaura con RestorationMixin para sobrevivir recreaciones de la Activity en Android.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _incrementCounter,
                icon: const Icon(Icons.add),
                label: const Text('Sumar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _resetCounter,
                icon: const Icon(Icons.refresh),
                label: const Text('Reiniciar contador'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
