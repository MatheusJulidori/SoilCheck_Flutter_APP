import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton(
      {Key? key, required this.buttonName, required this.onExecute})
      : super(key: key);

  final String buttonName;
  final Future<void> Function() onExecute;

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              setState(() => _isLoading = true);
              widget
                  .onExecute()
                  .then((value) => setState(() => _isLoading = false));
            },
      child: _isLoading
          ? Row(
              children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ))),
                Text(widget.buttonName)
              ],
            )
          : Text(widget.buttonName),
    );
  }
}
