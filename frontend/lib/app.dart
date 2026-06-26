import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class JongSartApp extends StatelessWidget {
  const JongSartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JongSart Skincare',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
