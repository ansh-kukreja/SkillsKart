import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills_kart/main.dart';
import 'package:skills_kart/Models/user_role.dart';
import 'package:skills_kart/Services/user_session.dart';

void main() {
  setUp(() {
    UserSession.instance.logout();
  });

  testWidgets('SkillsKart login and role selection test', (WidgetTester tester) async {
    // Build app without initial login to view LoginScreen
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify brand header SkillsKart and choose user type
    expect(find.text('SkillsKart'), findsOneWidget);
    expect(find.text('CHOOSE USER TYPE'), findsOneWidget);
    expect(find.text('Normal User'), findsWidgets);
    expect(find.text('Enterprise'), findsWidgets);
    expect(find.text('SignIn'), findsOneWidget);

    // Tap SignIn button to enter app as default Normal User
    await tester.tap(find.text('SignIn'));
    await tester.pumpAndSettle();

    // Verify Services is displayed as default screen
    expect(find.text('Services'), findsWidgets);
    expect(find.text('Normal'), findsOneWidget);

    // Verify navigation tabs
    expect(find.text('Jobs'), findsOneWidget);
    expect(find.text('Craft Store'), findsOneWidget);
    expect(find.text('Community Services'), findsOneWidget);

    // In Normal user mode, Enterprise banner is absent
    expect(find.text('ENTERPRISE WORKFORCE DESK'), findsNothing);
  });

  testWidgets('SkillsKart enterprise bulk features test', (WidgetTester tester) async {
    // Launch app directly with Enterprise role
    await tester.pumpWidget(const MyApp(initialRole: UserRole.enterprise));
    await tester.pumpAndSettle();

    // Default screen is Services, verify Enterprise Workforce Desk banner is displayed
    expect(find.text('ENTERPRISE WORKFORCE DESK'), findsOneWidget);
    expect(find.text('Request Federation'), findsOneWidget);
    expect(find.textContaining('Bulk Contracts'), findsOneWidget);
  });

  testWidgets('SkillsKart initial smoke test with initial role', (WidgetTester tester) async {
    // Build our app with initial Normal role
    await tester.pumpWidget(const MyApp(initialRole: UserRole.normal));
    await tester.pumpAndSettle();

    // Verify brand header SkillsKart is displayed
    expect(find.text('SkillsKart'), findsWidgets);

    // Verify Services screen is displayed as default screen
    expect(find.text('Services'), findsWidgets);

    // Verify navigation tabs are present
    expect(find.text('Jobs'), findsOneWidget);
    expect(find.text('Craft Store'), findsOneWidget);
    expect(find.text('Community Services'), findsOneWidget);

    // Verify 'Post a Job' is not on the initial screen
    expect(find.text('Post a Job'), findsNothing);

    // Switch to Jobs tab
    await tester.tap(find.text('Jobs'));
    await tester.pumpAndSettle();

    // Verify Jobs screen is visible and 'Post a Job' is still absent
    expect(find.text('Available Openings'), findsOneWidget);
    expect(find.text('Post a Job'), findsNothing);
  });

  testWidgets('SkillsKart role switcher and bulk booking modal test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRole: UserRole.normal));
    await tester.pumpAndSettle();

    // Tap role indicator pill in AppBar
    await tester.tap(find.text('Normal'));
    await tester.pumpAndSettle();

    // Verify role options bottom sheet appears
    expect(find.text('Switch to Enterprise Client Mode'), findsOneWidget);

    // Tap switch to Enterprise
    await tester.tap(find.text('Switch to Enterprise Client Mode'));
    await tester.pumpAndSettle();

    // Now verified as Enterprise
    expect(find.text('Enterprise'), findsWidgets);

    // Services is already open (default tab)
    // Ensure Electricians is visible and tap it
    await tester.ensureVisible(find.text('Electricians'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Electricians'));
    await tester.pumpAndSettle();

    // Verify Enterprise Bulk Staffing options are visible on service detail
    expect(find.text('Bulk Staffing & Contracts'), findsOneWidget);
    expect(find.text('Configure Bulk Contract (5-100+ Workers)'), findsOneWidget);
    expect(find.text('Send Service Requisition to Federation'), findsOneWidget);

    // Ensure Configure Bulk Contract button is visible and tap it
    await tester.ensureVisible(find.text('Configure Bulk Contract (5-100+ Workers)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Configure Bulk Contract (5-100+ Workers)'));
    await tester.pumpAndSettle();

    // Verify Bulk Contract Booking Sheet elements
    expect(find.text('Book Bulk Gig Workers'), findsOneWidget);
    expect(find.text('Workers Required'), findsOneWidget);
    expect(find.text('Contract Duration'), findsOneWidget);
    expect(find.text('Confirm Bulk Contract Booking'), findsOneWidget);
  });

  testWidgets('SkillsKart simple logout dialog test', (WidgetTester tester) async {
    // Launch app in Enterprise mode
    await tester.pumpWidget(const MyApp(initialRole: UserRole.enterprise));
    await tester.pumpAndSettle();

    // Verify AppBar contains Enterprise indicator and direct logout button
    expect(find.text('ENTERPRISE'), findsOneWidget);
    final logoutButton = find.byTooltip('Logout');
    expect(logoutButton, findsOneWidget);

    // Tap direct logout button in AppBar
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Verify simple logout dialog appears
    expect(find.text('Do you want to logout?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    // Tap Logout button in dialog
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();

    // Verify user is logged out and back on LoginScreen
    expect(find.text('CHOOSE USER TYPE'), findsOneWidget);
    expect(find.text('SignIn'), findsOneWidget);
  });
}
