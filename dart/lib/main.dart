import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'common/injection.dart';
import 'ui/cubits/activities_cubit.dart';
import 'ui/cubits/bookmark_cubit.dart';
import 'ui/details_page/activity_details_page.dart';
import 'ui/home_page/home_page.dart';
import 'ui/person_page/person_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  runApp(const ChuvaDart());
}

class ChuvaDart extends StatelessWidget {
  const ChuvaDart({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ActivitiesCubit(getIt())..fetchActivitiesFromPage()),
        BlocProvider(create: (_) => BookmarkCubit(getIt())..loadInitialData()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        locale: const Locale("pt"),
        supportedLocales: const [
          Locale("pt"),
          Locale("en"),
        ],
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(centerTitle: true),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(centerTitle: true),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
      routes: [
        GoRoute(
            path: 'activity/:id',
            name: "activity-details",
            builder: (context, state) {
              final id = state.pathParameters["id"];
              final intId = int.tryParse(id ?? "0") ?? 0;

              return ActivityDetailsPage.activityPageBuilder(context, intId);
            },
            redirect: invalidIdRedirect,
            routes: [
              GoRoute(
                path: 'person/:personId',
                name: "person-details",
                builder: (context, state) {
                  final id = state.pathParameters["personId"];
                  final intId = int.tryParse(id ?? "0") ?? 0;

                  return PersonPage.personPageBuilder(context, intId);
                },
              ),
            ]),
      ],
    ),
    GoRoute(
      name: "not-found",
      path: "/404",
      builder: (context, __) => Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.go("/")),
        ),
        body: const Text("Página não encontrada"),
      ),
    )
  ],
);

FutureOr<String?> invalidIdRedirect(BuildContext context, GoRouterState state) {
  if ((int.tryParse(state.pathParameters["id"] ?? "0") ?? 0) == 0) {
    return "/404";
  } else {
    return null;
  }
}

//

//

//

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime(2023, 11, 26);
  bool _clicked = false;

  void _changeDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chuva ❤️ Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Programação'),
            const Text('Nov'),
            const Text('2023'),
            OutlinedButton(
              onPressed: () {
                _changeDate(DateTime(2023, 11, 26));
              },
              child: Text('26', style: Theme.of(context).textTheme.headlineMedium),
            ),
            OutlinedButton(
              onPressed: () => _changeDate(DateTime(2023, 11, 28)),
              child: Text(
                '28',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (_currentDate.day == 26)
              OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _clicked = true;
                    });
                  },
                  child: const Text('Mesa redonda de 07:00 até 08:00')),
            if (_currentDate.day == 28)
              OutlinedButton(
                  onPressed: () => setState(() => _clicked = true),
                  child: const Text('Palestra de 09:30 até 10:00')),
            if (_currentDate.day == 26 && _clicked) const Activity(),
          ],
        ),
      ),
    );
  }
}

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(children: [
        Text(
          'Activity title',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Text('A Física dos Buracos Negros Supermassivos'),
        const Text('Mesa redonda'),
        const Text('Domingo 07:00h - 08:00h'),
        const Text('Sthepen William Hawking'),
        const Text('Maputo'),
        const Text('Astrofísica e Cosmologia'),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _favorited = !_favorited;
            });
          },
          icon: _favorited ? const Icon(Icons.star) : const Icon(Icons.star_outline),
          label: Text(_favorited ? 'Remover da sua agenda' : 'Adicionar à sua agenda'),
        )
      ]),
    );
  }
}
