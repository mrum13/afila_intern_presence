import 'package:afila_intern_presence/cubit/navbar_cubit.dart';
import 'package:afila_intern_presence/intern/pages/account_page.dart';
import 'package:afila_intern_presence/intern/pages/home_page.dart';
import 'package:afila_intern_presence/intern/pages/list_presence_page.dart';
import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/intern/pages/live_preview_page.dart';
import 'package:afila_intern_presence/widgets/custom_button_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    Widget buildContent(int currentIndex) {
      switch (currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const ListPresencePage();
        case 2:
          return const AccountPage();
        default:
          return const Scaffold(
            body: Center(
              child: Text("Home Page"),
            ),
          );
      }
    }

    return BlocBuilder<NavbarCubit, int>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: whiteColor,
            body: Column(
              children: [Expanded(child: buildContent(state))],
            ),
            // ignore: prefer_const_constructors
            bottomNavigationBar: BottomAppBar(
              notchMargin: 6,
              padding: EdgeInsets.zero,
              height: 64,
              color: backgroundColor,
              // shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomBottomNavigationItem(
                      title: "Home", icon: Icons.home, index: 0),
                  CustomBottomNavigationItem(
                      title: "Riwayat", icon: Icons.list, index: 1),
                  CustomBottomNavigationItem(
                      title: "Akun", icon: Icons.person, index: 2),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              shape: OvalBorder(),
              heroTag: 'attendance_fab',
              backgroundColor: yellowColor,
              elevation: 0,
              // hoverColor: AppColors.primaryBackgroundColor,
              enableFeedback: true,
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: yellowColor),
                child: Icon(
                  Icons.add,
                  size: 34,
                  color: whiteColor,
                ),
              ),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LivePreviewPage(),));
              },
            ));
      },
    );
  }
}
