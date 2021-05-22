# removable_trash_package

Just move the items which you want to delete onto the trash can, now they've been deleted.

|              App Display             | 
| :----------------------------------: | 
| <a  target="_blank"><img src="https://user-images.githubusercontent.com/37551474/119237676-b85adf00-bb46-11eb-90af-8d18d5d225da.gif" width="200"></a> | 
## Example Usage
 -[home screen](https://github.com/taylanyildiz/removable_trash/blob/master/lib/screens/home_screen.dart) 
```dart
 Removable(
    width: 400.0,
    height: 400.0,
    actionAlignment: Alignment.center,
    dismissed: (index) => _showSnackBar(index),
    actionDelegate: RemovableActionBuilderDelegate(
    actionCount: moviesList.length,
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
```

### lib src file

- [Lib - draggable trash](https://github.com/taylanyildiz/removable_trash/blob/master/lib/widgets/src/removable.dart) 

### yaml 
 - [pubspec.yaml](https://github.com/taylanyildiz/removable_trash/blob/master/pubspec.yaml)
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
