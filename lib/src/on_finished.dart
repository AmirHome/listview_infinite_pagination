import 'package:flutter/material.dart';

class OnFinished extends StatelessWidget {
  const OnFinished({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (loading)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child: Container(
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            (icon != null)
                ? Icon(icon,
                color:
                textColor ?? FlutterFlowTheme.of(context).primaryBtnText)
                : Container(),
            const SizedBox(width: 5),
            Text(message,
                style: TextStyle(
                    color: textColor ??
                        FlutterFlowTheme.of(context).primaryBtnText)),
          ],
        ),
        duration: Duration(seconds: duration),
        backgroundColor: backgroundColor,
      ),
    );
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      // color: Colors.amber,
      child: const Center(
        child: Text('Fetched all of the content'),
      ),
    );
  }
}
