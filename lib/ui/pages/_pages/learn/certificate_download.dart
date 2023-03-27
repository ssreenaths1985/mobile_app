import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../constants/_constants/app_constants.dart';
import '../../../../constants/_constants/color_constants.dart';
import '../../../../util/helper.dart';

class CertificateDownload extends StatefulWidget {
  final certificateData;
  final courseName;
  const CertificateDownload({Key key, this.certificateData, this.courseName})
      : super(key: key);

  @override
  State<CertificateDownload> createState() => _CertificateDownloadState();
}

class _CertificateDownloadState extends State<CertificateDownload> {
  bool _isProgressStop;
  List<int> bytes;
  @override
  void initState() {
    super.initState();
    // saveImage(widget.courseName);
  }

  Future<void> _saveImageAsPdf(String fileName) async {
    final pdf = pw.Document();
    // final directoryName = "Karmayogi";
    // Directory directory = await getExternalStorageDirectory();
    // var dir = await DownloadsPathProvider.downloadsDirectory;
    // String path = dir.path;
    String path = APP_DOWNLOAD_FOLDER;
    await Directory('$path').create(recursive: true);

    try {
      if (await Helper.requestPermission(Permission.storage)) {
        setState(() {
          _isProgressStop = false;
        });

        final image =
            pw.SvgImage(svg: Helper.svgDecoder(widget.certificateData));

        //creating PDF for the image
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.undefined,
            build: (pw.Context context) {
              return image; // Center
            }));

        //saving the PDF in external storage
        await File('$path/$fileName.pdf').writeAsBytes(await pdf.save());
        setState(() {
          _isProgressStop = true;
        });
        _displayDialog(true, '$path/$fileName.pdf', 'Success');
      } else {
        return false;
      }
    } catch (e) {
      setState(() {
        _isProgressStop = true;
      });
      _displayDialog(false, '', e.toString().split(':').last);
    }
  }

  // _requestPermission(Permission permission) async {
  //   if (await permission.isGranted) {
  //     return true;
  //   } else {
  //     var result = await permission.request();
  //     if (result == PermissionStatus.granted) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  // }

  Future<dynamic> _openFile(filePath) async {
    await OpenFile.open(filePath);
  }

  Future<bool> _displayDialog(
      bool isSuccess, String filePath, String message) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Stack(
              children: [
                Positioned(
                    child: Align(
                        // alignment: FractionalOffset.center,
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          // margin: EdgeInsets.only(left: 20, right: 20),
                          width: double.infinity,
                          height: filePath != '' ? 190.0 : 140,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 15),
                                  child: Text(
                                    isSuccess
                                        ? 'File downloading completed.'
                                        : message,
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.none,
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  )),
                              filePath != ''
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 10),
                                      child: GestureDetector(
                                        onTap: () => _openFile(filePath),
                                        child: roundedButton(
                                          'Open',
                                          AppColors.primaryThree,
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Center(),
                              // Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 15),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(false),
                                  child: roundedButton('Close', Colors.white,
                                      AppColors.primaryThree),
                                ),
                              ),
                            ],
                          ),
                        )))
              ],
            ));
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      width: MediaQuery.of(context).size.width - 50,
      padding: EdgeInsets.all(10),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
        border: bgColor == Colors.white
            ? Border.all(color: AppColors.grey40)
            : Border.all(color: bgColor),
      ),
      child: Text(
        buttonLabel,
        style: GoogleFonts.montserrat(
            decoration: TextDecoration.none,
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
    return loginBtn;
  }

  @override
  Widget build(BuildContext context) {
    // print(_isDownloadCompleted);
    // print(Helper.svgDecoder(widget.certificateData));
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text('Back'),
          backgroundColor: Colors.white),
      body: Stack(
        children: [
          Container(
            child: SvgPicture.string(
              Helper.svgDecoder(widget.certificateData),
              fit: BoxFit.fitWidth,
            ),
          ),
          (_isProgressStop != null && !_isProgressStop) ? PageLoader() : Stack()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        // heroTag: 'download',
        onPressed: () => _saveImageAsPdf(widget.courseName),
        child: Icon(Icons.download),
        backgroundColor: AppColors.primaryThree,
      ),
    );
  }
}
