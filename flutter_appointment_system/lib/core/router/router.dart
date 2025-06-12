import 'package:flutter_appointment_system/features/appointments/models/appointment_model.dart';
import 'package:flutter_appointment_system/features/appointments/presentation/appointment_detail_screen.dart';
import 'package:flutter_appointment_system/features/appointments/presentation/appointment_form_screen.dart';
import 'package:flutter_appointment_system/features/appointments/presentation/appointment_list_screen.dart';
import 'package:flutter_appointment_system/features/auth/presentation/login_screen.dart';
import 'package:flutter_appointment_system/features/auth/presentation/register_screen.dart';
import 'package:flutter_appointment_system/features/dashboard/presentation/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
    GoRoute(
      path: '/detail/:docId',
      builder: (context, state) {
        final docId = state.pathParameters['docId']!;
        return AppointmentDetailScreen(documentId: docId);
      },
    ),

    GoRoute(
      path: '/appointments',
      builder: (context, state) {
        return AppointmentListScreen();
      },
    ),
    GoRoute(
      path: '/appointments/new',
      builder: (context, state) {
        return AppointmentFormScreen();
      },
    ),
    GoRoute(
      path: '/appointments/edit',
      builder: (context, state) {
        final appointment = state.extra as Appointment;
        return AppointmentFormScreen(existingAppointment: appointment);
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  ],
);
