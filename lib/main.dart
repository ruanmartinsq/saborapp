import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'data/receita_repository.dart';
import 'providers/favoritos_provider.dart';
import 'providers/receitas_providers.dart';
import 'screens/home_screen.dart';

const usarApi = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SaborApp());
}

class SaborApp extends StatelessWidget {
  const SaborApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ReceitasProvider(
            usarApi
                ? ReceitaRepositoryHttp(http.Client())
                : ReceitaRepositoryMock(),
          )..buscar(''),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritosProvider()..carregar(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SaborApp',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
