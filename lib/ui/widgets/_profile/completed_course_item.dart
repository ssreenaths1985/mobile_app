import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmayogi_mobile/ui/widgets/index.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constants/index.dart';
import '../../../localization/_langs/english_lang.dart';
import '../../../services/_services/learn_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img_lib;
import 'package:pdf_render/pdf_render.dart' as pdf_render;

class CompletedCourseItemCard extends StatefulWidget {
  final String name;
  final String description;
  final String image;
  final String issuedDate;
  final completionCertificate;

  CompletedCourseItemCard(
      {this.name,
      this.description,
      this.image = '',
      this.issuedDate,
      this.completionCertificate});

  @override
  State<CompletedCourseItemCard> createState() =>
      _CompletedCourseItemCardState();
}

class _CompletedCourseItemCardState extends State<CompletedCourseItemCard> {
  final LearnService learnService = LearnService();
  String _certificateUrl;
  bool _isProgressStop;

  Future<String> getDownloadPath() async {
    Directory directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory(APP_DOWNLOAD_FOLDER);
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      throw "Cannot get download folder path";
      // print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<void> _saveImageAsPdf(String courseName) async {
    String fileName =
        '$courseName-' + DateTime.now().millisecondsSinceEpoch.toString();
    final pdf = pw.Document();
    // final directoryName = "Karmayogi";
    // Directory directory = await getExternalStorageDirectory();
    // var dir = await DownloadsPathProvider.downloadsDirectory;
    // String path = dir.path;
    String path = await getDownloadPath();
    // String path = APP_DOWNLOAD_FOLDER;
    await Directory('$path').create(recursive: true);

    try {
      if (await Helper.requestPermission(Permission.storage)) {
        setState(() {
          _isProgressStop = false;
        });

        final image = pw.SvgImage(svg: Helper.svgDecoder(_certificateUrl));

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

  Future<void> _shareCertificate() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final pdf = pw.Document();
    final image = pw.SvgImage(svg: Helper.svgDecoder(_certificateUrl));

    //creating PDF for the image
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.undefined,
        build: (pw.Context context) {
          return image; // Center
        }));

    final document = await pdf_render.PdfDocument.openData(await pdf.save());

    final page = await document.getPage(1);
    final pdfImage = await page.render();
    var img = await pdfImage.createImageDetached();
    var imgBytes = await img.toByteData(format: ImageByteFormat.png);
    var libImage = img_lib.decodeImage(imgBytes.buffer
        .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));

    int totalHeight = libImage.height;
    int totalWidth = libImage.width;
    final mergedImage = img_lib.Image(totalWidth, totalHeight);

    img_lib.copyInto(mergedImage, libImage);

    final tempDir = await getTemporaryDirectory();

    final path = ("${tempDir.path}/$fileName.png");
    await File(path).writeAsBytes(img_lib.encodePng(mergedImage));

    await Share.shareFiles([path], text: "Certificate of completion");
  }

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
                                        ? EnglishLang.fileDownloadingCompleted
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
                                          EnglishLang.open,
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
                                  child: roundedButton(EnglishLang.close,
                                      Colors.white, AppColors.primaryThree),
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
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: ExpansionTile(
        // collapsedTextColor: AppColors.primaryThree,
        onExpansionChanged: (value) async {
          // print(widget.completionCertificate);
          if (value) {
            if (widget.completionCertificate.raw['issuedCertificates'].length >
                    0 &&
                ((widget.completionCertificate.raw['issuedCertificates']
                                .length >
                            1
                        ? widget.completionCertificate.raw['issuedCertificates']
                            [1]['identifier']
                        : widget.completionCertificate.raw['issuedCertificates']
                            [0]['identifier']) !=
                    null)) {
              String certificateId = widget.completionCertificate
                          .raw['issuedCertificates'].length >
                      1
                  ? widget.completionCertificate.raw['issuedCertificates'][1]
                      ['identifier']
                  : widget.completionCertificate.raw['issuedCertificates'][0]
                      ['identifier'];
              final certificate = await learnService
                  .getCourseCompletionCertificate(certificateId);
              setState(() {
                _certificateUrl = certificate;
              });
            }
          }
        },
        tilePadding: EdgeInsets.only(right: 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 5),
              child: Container(
                height: 48,
                width: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: (widget.image == '' || widget.image == null)
                      ? Image.asset(
                          'assets/img/image_placeholder.jpg',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.image,
                          // width: 48,
                          // height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/img/image_placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700),
                  ),
                  (widget.description != null && widget.description != '')
                      ? Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text(
                            widget.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                                color: AppColors.greys60,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      : Center(),
                ],
              ),
            ),
          ],
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.issuedDate,
                style: GoogleFonts.lato(
                    // color: AppColors.greys60,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400),
              ),
              widget.issuedDate == EnglishLang.certificateIsBeingGenerated
                  ? Tooltip(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.info_outline,
                          color: AppColors.greys60,
                          size: 20,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 100, right: 20),
                      padding: EdgeInsets.all(16),
                      message: EnglishLang.certificateIsBeingGeneratedMessage,
                      showDuration: Duration(seconds: 3),
                      triggerMode: TooltipTriggerMode.tap,
                      verticalOffset: 20,
                    )
                  : Center()
            ],
          ),
        ),
        children: [
          widget.issuedDate != EnglishLang.certificateIsBeingGenerated
              ? Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                  // height: 193,
                  // width: double.infinity,
                  child: _certificateUrl != null
                      ? Column(
                          children: [
                            Container(
                              height: 210,
                              width: double.infinity,
                              child: ClipRRect(
                                child: SvgPicture.string(
                                  Helper.svgDecoder(_certificateUrl),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        onPrimary: AppColors.primaryThree,
                                        primary: Colors.white,
                                        minimumSize:
                                            const Size.fromHeight(40), // NEW
                                        side: BorderSide(
                                            width: 1,
                                            color: AppColors.primaryThree),
                                      ),
                                      onPressed: () async {
                                        await _shareCertificate();
                                      },
                                      child: Text(
                                        EnglishLang.share,
                                        style: GoogleFonts.lato(
                                            height: 1.429,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                            color: AppColors.primaryThree,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.68,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors.primaryThree,
                                        minimumSize:
                                            const Size.fromHeight(40), // NEW
                                        side: BorderSide(
                                            width: 1,
                                            color: AppColors.primaryThree),
                                      ),
                                      onPressed: () =>
                                          _saveImageAsPdf(widget.name),
                                      child: Text(
                                        EnglishLang.downloadCertificate,
                                        style: GoogleFonts.lato(
                                            height: 1.429,
                                            letterSpacing: 0.5,
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(height: 200, child: PageLoader()))
              : Center()
        ],
      ),
    );
  }
}
