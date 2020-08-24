import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer(
      {Key key,
      @required this.isLoading,
      this.cover = false,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !cover
        ? !isLoading ? child : _loadView()
        : Stack(
            children: <Widget>[child, isLoading ? _loadView() : null],
          );
  }

  Widget _loadView() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
