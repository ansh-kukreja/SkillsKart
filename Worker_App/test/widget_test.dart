import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skills_kart_worker/main.dart';

void main() {
  testWidgets('SkillsKart Worker clean login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillsKartWorkerApp());
    await tester.pumpAndSettle();

    // Verify clean login screen elements
    expect(find.text('SkillsKart'), findsOneWidget);
    expect(find.text('PARTNER PORTAL'), findsOneWidget);
    expect(find.text('Select your role'), findsOneWidget);

    // Exactly 4 clean cards
    expect(find.text('Gig Worker'), findsOneWidget);
    expect(find.text('Product Seller'), findsOneWidget);
    expect(find.text('Business Owner'), findsOneWidget);
    expect(find.text('Community Org'), findsOneWidget);
  });

  testWidgets('Login as Gig Worker and test Logout flow', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillsKartWorkerApp());
    await tester.pumpAndSettle();

    // Login as Gig Worker
    await tester.tap(find.text('Gig Worker'));
    await tester.pumpAndSettle();

    // Verify logged in
    expect(find.text('YOU ARE ONLINE'), findsOneWidget);
    expect(find.text('Incoming Leads Nearby'), findsOneWidget);

    // Tap Logout button in app bar
    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pumpAndSettle();

    // Confirm dialog appears
    expect(find.text('Log out of Gig Worker?'), findsOneWidget);
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    // Returned to clean login screen
    expect(find.text('Select your role'), findsOneWidget);
    expect(find.text('Gig Worker'), findsOneWidget);
  });

  testWidgets('Login as Product Seller and verify dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillsKartWorkerApp());
    await tester.pumpAndSettle();

    // Login as Product Seller
    await tester.tap(find.text('Product Seller'));
    await tester.pumpAndSettle();

    // Verify logged in
    expect(find.text('ODOP Certified Artisan Store'), findsOneWidget);
    expect(find.text('List Product'), findsOneWidget);

    // Logout
    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();
    expect(find.text('Select your role'), findsOneWidget);
  });

  testWidgets('Login as Business Owner and verify dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillsKartWorkerApp());
    await tester.pumpAndSettle();

    // Login as Business Owner
    await tester.tap(find.text('Business Owner'));
    await tester.pumpAndSettle();

    // Verify logged in
    expect(find.text('Verified Local Employer'), findsOneWidget);
    expect(find.text('Post a Job'), findsOneWidget);

    // Logout
    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();
    expect(find.text('Select your role'), findsOneWidget);
  });

  testWidgets('Login as Community Org and verify dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillsKartWorkerApp());
    await tester.pumpAndSettle();

    // Login as Community Org
    await tester.tap(find.text('Community Org'));
    await tester.pumpAndSettle();

    // Verify logged in
    expect(find.text('Verified Social Impact Organizer'), findsOneWidget);
    expect(find.text('Post Event'), findsOneWidget);

    // Logout
    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();
    expect(find.text('Select your role'), findsOneWidget);
  });

  testWidgets('Verify dummy images are rendered on RoleSelection and dashboard cards', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillsKartWorkerApp());
    await tester.pumpAndSettle();

    // Verify role selection cards have 4 preview image widgets using offline AssetImage
    expect(find.byType(Image), findsNWidgets(4));
    final firstImageWidget = tester.firstWidget<Image>(find.byType(Image));
    expect(firstImageWidget.image, isA<AssetImage>());

    // Tap Gig Worker and verify lead cards have images
    await tester.tap(find.text('Gig Worker'));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsWidgets);

    // Logout
    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    // Tap Business Owner and verify job cards have images
    await tester.tap(find.text('Business Owner'));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsWidgets);

    // Logout
    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    // Tap Product Seller and verify product cards have images
    await tester.tap(find.text('Product Seller'));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsWidgets);

    // Logout
    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    // Tap Community Org and verify event cards have images
    await tester.tap(find.text('Community Org'));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsWidgets);
  });
}

