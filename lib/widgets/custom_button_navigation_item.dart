import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:afila_intern_presence/cubit/navbar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;

  const CustomBottomNavigationItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.index});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<NavbarCubit, int>(
      builder: (context, state) {
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            context.read<NavbarCubit>().setIndexPage(index: index);
          },
          child: Container(
            height: 64,
            width: 70,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: state==index?blueColor:tertiaryTextColor,),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  title,
                  style: state == index
                      ? TextStyle(
                        color: blueColor,
                        fontSize: 12
                      ) : TextStyle(
                        color: tertiaryTextColor,
                        fontSize: 12
                      ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
