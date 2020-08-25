import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _textEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.defaultText != null) {
      setState(() {
        _textEditingController.text = widget.defaultText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _getNormalSearch()
        : _getHomeSearch();
  }

  _getHomeSearch() {}

  _getNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                child: widget?.hideLeft ?? false
                    ? null
                    : Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 26,
                      ),
              ),
              widget?.leftButtonClick),
          Expanded(flex: 1, child: _inputBox()),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  "搜索",
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              widget?.rightButtonClick)
        ],
      ),
    );
  }

  _wrapTap(Widget widget, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: widget,
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse("0xffEDEDED"));
    }
    return Row(children: <Widget>[
      Icon(
        Icons.search,
        size: 20,
        color: widget.searchBarType == SearchBarType.normal
            ? Color(0xffA9A9A9)
            : Colors.blue,
      ),
      Expanded(
          flex: 1,
          child: widget.searchBarType == SearchBarType.normal
              ? TextField(
                  controller: _textEditingController,
                  onChanged: _onChange,
                  autofocus: true,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      border: InputBorder.none,
                      hintText: widget?.hint ?? '',
                      hintStyle: TextStyle(fontSize: 15)),
                )
              : _wrapTap(
                  Container(
                    child: Text(
                      widget.defaultText,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  widget.inputBoxClick))
    ]);
  }

  _onChange(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged == null) {
      widget.onChanged(text);
    }
  }
}
