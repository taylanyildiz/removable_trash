import 'package:flutter/material.dart';
import 'package:removable_trash_package/config/images_movie.dart';
import 'package:removable_trash_package/widgets/removable_trash.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    void _showSnackBar(int index) {
      final snackbar = SnackBar(
        content: Text('remove ${moviesList[index].imgUrl}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Removable Trash',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Removable(
              width: 400.0,
              height: 400.0,
              actionAlignment: Alignment.center,
              dismissed: (index) => _showSnackBar(index),
              actionDelegate: RemovableActionBuilderDelegate(
                actionCount: 5,
                builder: (context, index) {
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        moviesList[index].imgUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
