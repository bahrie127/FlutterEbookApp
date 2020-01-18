import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/util/consts.dart';
import 'package:flutter_ebook_app/widgets/custom_alert.dart';

class DownloadAlert extends StatefulWidget {
  final String url;
  final String path;


  DownloadAlert({
    Key key,
    @required this.url,
    @required this.path
  }):super(key: key);

  @override
  _DownloadAlertState createState() => _DownloadAlertState();
}

class _DownloadAlertState extends State<DownloadAlert> {

  Dio dio = new Dio();
  int received = 0;
  String progress = "0";
  int total = 0;

  download() async{
    await dio.download(widget.url,widget.path,
      // Listen the download progress.
      onReceiveProgress: (receivedBytes, totalBytes) {
        print((received / total * 100).toStringAsFixed(0));
        print(progress);
        setState(() {
          received = receivedBytes;
          total = totalBytes;
          progress = (received / total * 100).toStringAsFixed(0);
        });
        print((received / total * 100).toStringAsFixed(0));
        if(receivedBytes == totalBytes){
          Navigator.pop(context, "${Constants.formatBytes(total, 1)}");
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    download();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlert(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Downloading...",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: LinearProgressIndicator(
                value: double.parse(progress)/100,
                valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.3),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "$progress %",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  "${Constants.formatBytes(received, 1)} "
                      "of ${Constants.formatBytes(total, 1)}",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}