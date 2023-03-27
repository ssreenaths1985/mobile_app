import 'dart:convert';
import 'dart:io';
import 'dart:ui';
// import 'package:karmayogi_mobile/base64_rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:karmayogi_mobile/localization/index.dart';
// import 'package:karmayogi_mobile/ui/widgets/_competency/competency_tagged_card.dart';s
import 'package:karmayogi_mobile/ui/widgets/_competency/other_competencies_tagged_card.dart';
import 'package:karmayogi_mobile/util/helper.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
// import 'dart:developer' as developer;
import '../../../../services/_services/learn_service.dart';
import './../../../../constants/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../util/faderoute.dart';
import './../../../pages/index.dart';
import './../../../../models/index.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img_lib;
import 'package:pdf_render/pdf_render.dart' as pdf_render;
import 'package:path_provider/path_provider.dart';

class CourseOverviewPage extends StatefulWidget {
  final course,
      courseAuthors,
      courseCurators,
      taggedCompetency,
      certificate,
      progress;
  final parentAction;
  final bool isStarted;
  final bool isFeatured;

  CourseOverviewPage(
      {this.course,
      this.courseAuthors,
      this.courseCurators,
      this.taggedCompetency,
      this.certificate,
      this.progress,
      this.parentAction,
      this.isStarted,
      this.isFeatured = false});

  @override
  _CourseOverviewPageState createState() => _CourseOverviewPageState();
}

class _CourseOverviewPageState extends State<CourseOverviewPage> {
  final LearnService learnService = LearnService();
  bool descriptionTrimText = false;
  bool summaryTrimText = false;
  int _maxLength = 100;
  var formattedDate;
  Map structure = {
    'video': 0,
    'pdf': 0,
    'assessment': 0,
    'module': 0,
    'other': 0,
    'html': 0,
    'course': 0,
    'practiceTest': 0,
    'finalTest': 0,
  };
  List<BrowseCompetencyCardModel> _courseCompetencies;
  // List<dynamic> _yourTaggedCompetencies = [];
  // List<dynamic> _otherTaggedCompetencies = [];
  String _dropdownValue = EnglishLang.topReviews;
  List<String> dropdownItems = [
    EnglishLang.topReviews,
    EnglishLang.latestReviews
  ];
  var _reviewSummery;
  var _yourReviews;
  List<dynamic> _courseReviews;
  List<dynamic> _filteredReviews;
  bool _pageInitilized = false;
  bool _isProgressStop;

  @override
  void initState() {
    super.initState();
    // _competenciesTaggedToList();
    if (!widget.isFeatured) {
      _getYourRatingAndReview();
    }
    if (widget.course['description'] != null) {
      if (widget.course['description'].length > _maxLength) {
        summaryTrimText = true;
      }
    }

    if (widget.course['instructions'] != null) {
      if (widget.course['instructions'].length > _maxLength) {
        descriptionTrimText = true;
      }
    }

    DateTime parseDt = DateTime.parse(widget.course['lastUpdatedOn']);
    formattedDate = DateFormat.yMMMd().format(parseDt);

    if (widget.course['children'] != null) {
      for (int i = 0; i < widget.course['children'].length; i++) {
        if (widget.course['children'][i]['contentType'] == 'Course') {
          structure['course'] += 1;
          // structure['module'] += 1;
          countArtifacts(widget.course['children'][i]);
        } else if (widget.course['children'][i]['contentType'] ==
                'Collection' ||
            widget.course['children'][i]['contentType'] == 'CourseUnit') {
          // structure['learningModule '] += 1;
          structure['module'] += 1;
          countArtifacts(widget.course['children'][i]);
        } else {
          if (widget.course['children'][i]['mimeType'] != null) {
            switch (widget.course['children'][i]['mimeType'].trim()) {
              case EMimeTypes.mp4:
                structure['video'] += 1;
                break;
              case EMimeTypes.pdf:
                structure['pdf'] += 1;
                break;
              case EMimeTypes.assessment:
                structure['assessment'] += 1;
                break;
              case EMimeTypes.collection:
                structure['module'] += 1;
                break;
              case EMimeTypes.html:
                structure['html'] += 1;
                break;
              case EMimeTypes.newAssessment:
                widget.course['children'][i]['primaryCategory'] ==
                        PrimaryCategory.practiceAssessment
                    ? structure['practiceTest'] += 1
                    : structure['finalTest'] += 1;
                break;
              default:
                structure['other'] += 1;
                break;
            }
          }
        }
      }
    }
    // developer.log('keywords: ' + widget.course['additionalFields'].toString());
  }

  _getYourRatingAndReview() async {
    final response = await learnService.getYourReview(
        widget.course['identifier'], widget.course['primaryCategory']);
    if (mounted) {
      setState(() {
        _yourReviews = response;
      });
    }
  }

  Future<List<dynamic>> _getReviews() async {
    if (!_pageInitilized) {
      if (_dropdownValue == EnglishLang.latestReviews) {
        _courseReviews = await learnService.getCourseReview(
            widget.course['identifier'], widget.course['primaryCategory']);
      } else if (_dropdownValue == EnglishLang.topReviews) {
        final response = await learnService.getCourseReviewSummery(
            widget.course['identifier'], widget.course['primaryCategory']);
        // developer.log(jsonDecode(response['latest50Reviews']).toString());
        if (response != null) {
          _reviewSummery = response;
          _courseReviews = response['latest50Reviews'] != null
              ? jsonDecode(response['latest50Reviews'])
              : [];
        }
      }

      setState(() {
        _filteredReviews = _courseReviews;
        _pageInitilized = true;
      });
      // print(_reviewSummery.toString());
    }
    return _courseReviews;
  }

  void _filterReviews(value) {
    if (_courseReviews != null && _courseReviews.length > 0) {
      setState(() {
        _filteredReviews = _courseReviews
            .where((review) =>
                review['review'].toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  _updateReview(value) {
    if (value == true) {
      setState(() {
        _pageInitilized = false;
      });
      _getReviews();
      _getYourRatingAndReview();
    }
  }

  void countArtifacts(children) {
    if (children['children'] != null) {
      for (int i = 0; i < children['children'].length; i++) {
        switch (children['children'][i]['mimeType']) {
          case EMimeTypes.mp4:
            structure['video'] += 1;
            break;
          case EMimeTypes.pdf:
            structure['pdf'] += 1;
            break;
          case EMimeTypes.assessment:
            structure['assessment'] += 1;
            break;
          case EMimeTypes.collection:
            structure['module'] += 1;
            countArtifacts(children['children'][i]);
            break;
          case EMimeTypes.html:
            structure['html'] += 1;
            break;
          case EMimeTypes.newAssessment:
            children['children'][i]['primaryCategory'] ==
                    PrimaryCategory.practiceAssessment
                ? structure['practiceTest'] += 1
                : structure['finalTest'] += 1;
            break;
          default:
            structure['other'] += 1;
            break;
        }
      }
    }
  }

  _competenciesTaggedToList() {
    if (widget.course['competencies_v3'] != null) {
      List<dynamic> courseCompetency =
          widget.course['competencies_v3'].runtimeType == String
              ? jsonDecode(widget.course['competencies_v3'])
              : widget.course['competencies_v3'];
      _courseCompetencies = courseCompetency
          .map(
            (dynamic item) => BrowseCompetencyCardModel.fromJson(item),
          )
          .toList();
      // List<dynamic> profileCompetency = widget.taggedCompetency;
      // List<BrowseCompetencyCardModel> _profileCompetencies = profileCompetency
      //     .map(
      //       (dynamic item) => BrowseCompetencyCardModel.fromJson(item),
      //     )
      //     .toList();
      // for (var i = 0; i < _courseCompetencies.length; i++) {
      //   Iterable<BrowseCompetencyCardModel> userTagged =
      //       _profileCompetencies.where((competency) =>
      //           competency.id.contains(_courseCompetencies[i].id));
      //   userTagged.forEach((competency) {
      //     _yourTaggedCompetencies.add(competency);
      //     for (var i = 0; i < _courseCompetencies.length; i++) {
      //       if (_courseCompetencies[i].id == competency.id) {
      //         setState(() {
      //           competency.courseCompetencyLevel =
      //               _courseCompetencies[i].courseCompetencyLevel;
      //         });
      //       }
      //     }
      //   });
      // }
      // if (_yourTaggedCompetencies.length > 0) {
      //   for (var i = 0; i < _yourTaggedCompetencies.length; i++) {
      //     Iterable<BrowseCompetencyCardModel> otherTagged =
      //         _courseCompetencies.where((competency) =>
      //             !competency.id.contains(_yourTaggedCompetencies[i].id));
      //     otherTagged.forEach((competency) {
      //       _otherTaggedCompetencies.add(competency);
      //     });
      //   }
      // } else {
      //   _courseCompetencies.forEach((competency) {
      //     _otherTaggedCompetencies.add(competency);
      //   });
      // }
    }
    // print('tagged: ' + _yourTaggedCompetencies.toString());
    // print('Other tagged: ' + _otherTaggedCompetencies[0].id.toString());
  }

  void _toogleReadMore({bool isSummary = false}) {
    setState(() {
      if (isSummary) {
        summaryTrimText = !summaryTrimText;
      } else {
        descriptionTrimText = !descriptionTrimText;
      }
    });
  }

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
    await Directory('$path').create(recursive: true);

    try {
      if (await Helper.requestPermission(Permission.storage)) {
        setState(() {
          _isProgressStop = false;
        });

        final image = pw.SvgImage(svg: Helper.svgDecoder(widget.certificate));

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
    final image = pw.SvgImage(svg: Helper.svgDecoder(widget.certificate));

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

    await Share.shareFiles([path], text: "Certificate share");
    // await Share.shareXFiles([XFile(path)], text: 'Certificate share');
    // await Share.shareWithResult(path, subject: "Certificate share");
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  widget.certificate != null
                      ? Container(
                          margin: EdgeInsets.only(top: 8, bottom: 8),
                          // height: 193,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 210,
                                child: ClipRRect(
                                  child: SvgPicture.string(
                                    Helper.svgDecoder(widget.certificate),
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
                                          0.70,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: AppColors.primaryThree,
                                          minimumSize:
                                              const Size.fromHeight(40), // NEW
                                          side: BorderSide(
                                              width: 1,
                                              color: AppColors.primaryThree),
                                        ),
                                        onPressed: () => _saveImageAsPdf(
                                            widget.course['name']),
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
                          ),
                        )
                      : (widget.progress == 100)
                          ? Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.white,
                              child: Text(
                                  'The certificate is not issued by the trusted certificate authority. Once issued you will be able to download it',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.12,
                                      height: 1.5,
                                      color: AppColors.greys87)),
                            )
                          : Center(),
                  // ActionLabel(icon: Icons.ac_unit, text: 'Add to a goal'),
                  // ActionLabel(
                  //     icon: 'assets/img/icons-social-share.svg', text: 'Share'),
                ],
              )),
          (!widget.isFeatured)
              ? (_yourReviews == null
                  ? (widget.isStarted
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              FadeRoute(
                                  page: CourseRating(
                                widget.course['name'],
                                widget.course['identifier'],
                                widget.course['primaryCategory'],
                                _yourReviews,
                                parentAction: _updateReview,
                              )),
                            ),
                            child: ActionLabel(
                                icon: Icons.star,
                                text:
                                    "Rate this ${widget.course['primaryCategory'].toLowerCase()}"),
                          ),
                        )
                      : Center())
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                EnglishLang.myRating,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.12,
                                    height: 1.5,
                                    color: AppColors.greys87),
                              ),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  FadeRoute(
                                      page: CourseRating(
                                    widget.course['name'],
                                    widget.course['identifier'],
                                    widget.course['primaryCategory'],
                                    _yourReviews,
                                    parentAction: _updateReview,
                                  )),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.greys60,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                            ),
                            child: Row(
                              children: <Widget>[
                                RatingBar.builder(
                                  initialRating: _yourReviews['rating'],
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  ignoreGestures: true,
                                  itemCount: 5,
                                  itemSize: 30,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.primaryOne,
                                  ),
                                  onRatingUpdate: (rating) => null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    // '4.5 out of 5',
                                    _yourReviews['rating'].toString() +
                                        " out of 5",
                                    style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )))
              : Center(),
          ((widget.isStarted && widget.progress != null) &&
                  widget.progress != 100)
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(EnglishLang.yourProgress,
                                style: GoogleFonts.lato(
                                    decoration: TextDecoration.none,
                                    color: AppColors.greys87,
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500)),
                            Text(widget.progress.toString() + ' %',
                                style: GoogleFonts.lato(
                                    decoration: TextDecoration.none,
                                    color: AppColors.greys87,
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                      ),
                      LinearProgressIndicator(
                        backgroundColor: AppColors.grey16,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryThree,
                        ),
                        value: widget.progress / 100,
                      ),
                    ],
                  ),
                )
              : Center(),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
            child: Text(
              EnglishLang.atAGlance,
              style: GoogleFonts.montserrat(
                  decoration: TextDecoration.none,
                  color: AppColors.greys87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.course['duration'] != null
                      ? GlanceItem1(
                          icon: 'assets/img/icons-action-timer.svg',
                          text: Helper.getTimeFormat(widget.course['duration']))
                      : Center(),
                  structure['course'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/course_icon.svg',
                          text: structure['course'].toString() +
                              (structure['course'] == 1
                                  ? ' Course'
                                  : ' Courses'))
                      : Center(),
                  structure['module'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/icons-file-types-module.svg',
                          text: structure['module'].toString() +
                              (structure['module'] == 1
                                  ? ' Module'
                                  : ' Modules'))
                      : Center(),
                  structure['video'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/icons-av-play.svg',
                          text: structure['video'].toString() +
                              (structure['video'] == 1 ? ' Video' : ' Videos'))
                      : Center(),
                  structure['pdf'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/icons-file-types-pdf-alternate.svg',
                          text: structure['pdf'].toString() +
                              (structure['pdf'] == 1 ? ' PDF' : ' PDFs'))
                      : Center(),
                  structure['assessment'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/assessment_icon.svg',
                          text: structure['assessment'].toString() +
                              (structure['assessment'] == 1
                                  ? ' Assessment'
                                  : ' Assessments'))
                      : Center(),
                  structure['html'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/link.svg',
                          text: structure['html'].toString() +
                              (structure['assessment'] == 1
                                  ? ' Interactive Content'
                                  : ' Interactive Contents'))
                      : Center(),
                  structure['other'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/icons-content-goal.svg',
                          text: structure['other'].toString() +
                              (structure['other'] == 1
                                  ? ' Other item'
                                  : ' Other items'))
                      : Center(),
                  structure['practiceTest'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/assessment_icon.svg',
                          text: structure['practiceTest'].toString() +
                              (structure['practiceTest'] == 1
                                  ? ' Practice test'
                                  : ' Practice tests'))
                      : Center(),
                  structure['finalTest'] > 0
                      ? GlanceItem1(
                          icon: 'assets/img/assessment_icon.svg',
                          text: structure['finalTest'].toString() +
                              (structure['finalTest'] == 1
                                  ? ' Final test'
                                  : ' Final tests'))
                      : Center(),
                  // GlanceItem2(
                  //     text1: 'Content type',
                  //     text2: widget.course['contentType']),
                  GlanceItem2(
                      text1: 'Source name',
                      text2: widget.course['source'] != null
                          ? widget.course['source']
                          : ''),
                  widget.course['license'] != null
                      ? GlanceItem2(
                          text1: 'License', text2: widget.course['license'])
                      : Center(),
                  widget.course['learningMode'] != null
                      ? GlanceItem2(
                          text1: 'Learning mode',
                          text2: widget.course['learningMode'])
                      : Center(),
                  GlanceItem2(text1: 'Cost', text2: 'Free'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: Text(
                      'Last updated on $formattedDate',
                      style: GoogleFonts.montserrat(
                          decoration: TextDecoration.none,
                          color: AppColors.greys60,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )),
          (widget.course['description'] != null &&
                  widget.course['description'] != '')
              ? Container(
                  margin: const EdgeInsets.only(bottom: 4, top: 4),
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            EnglishLang.summary,
                            style: GoogleFonts.montserrat(
                                decoration: TextDecoration.none,
                                color: AppColors.greys87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        widget.course['description'] != null
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  (summaryTrimText &&
                                          widget.course['description'].length >
                                              _maxLength)
                                      ? widget.course['description']
                                              .substring(0, _maxLength - 1) +
                                          '...'
                                      : widget.course['description'],
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: AppColors.greys87,
                                      fontSize: 16,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            : Center(),
                        widget.course['description'] != null
                            ? (widget.course['description'].length > _maxLength)
                                ? Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: InkWell(
                                          onTap: () =>
                                              _toogleReadMore(isSummary: true),
                                          child: Text(
                                            summaryTrimText
                                                ? EnglishLang.readMore
                                                : EnglishLang.showLess,
                                            style: GoogleFonts.montserrat(
                                                decoration: TextDecoration.none,
                                                color: AppColors.primaryThree,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ))
                                : Center()
                            : Center()
                      ]))
              : Center(),
          (widget.course['instructions'] != null &&
                  widget.course['instructions'] != '')
              ? Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 4),
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            EnglishLang.description,
                            style: GoogleFonts.montserrat(
                                decoration: TextDecoration.none,
                                color: AppColors.greys87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        widget.course['instructions'] != null
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: HtmlWidget(
                                  (descriptionTrimText &&
                                          widget.course['instructions'].length >
                                              _maxLength)
                                      ? widget.course['instructions']
                                              .substring(0, _maxLength - 1) +
                                          '...'
                                      : widget.course['instructions'],
                                  textStyle: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: AppColors.greys87,
                                      fontSize: 16,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            : Center(),
                        widget.course['instructions'] != null
                            ? (widget.course['instructions'].length >
                                    _maxLength)
                                ? Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: InkWell(
                                          onTap: () => _toogleReadMore(),
                                          child: Text(
                                            descriptionTrimText
                                                ? EnglishLang.readMore
                                                : EnglishLang.showLess,
                                            style: GoogleFonts.montserrat(
                                                decoration: TextDecoration.none,
                                                color: AppColors.primaryThree,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ))
                                : Center()
                            : Center()
                      ]))
              : Center(),
          (widget.courseAuthors.length > 0 || widget.courseCurators.length > 0)
              ? (Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                          child: Text(
                            EnglishLang.authorsAndCurators,
                            style: GoogleFonts.montserrat(
                                decoration: TextDecoration.none,
                                color: AppColors.greys87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        // for (int j = 0; j < 1; j++)
                        //   Author(
                        //       name: widget.course['creatorContacts'][j]['name'],
                        //       designation: 'Author'),
                        // Author(
                        //     name: 'Jayasree Talpade',
                        //
                        //  designation: 'Joint Secretary at Tourism'),
                        widget.courseAuthors.length > 0
                            ? Container(
                                padding: EdgeInsets.only(bottom: 5),
                                height: widget.courseAuthors.length * 80.0,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: widget.courseAuthors.length,
                                  itemBuilder: (context, index) {
                                    // return Author(
                                    //     name: widget.courseAuthors[index].firstName +
                                    //         " " +
                                    //         widget.courseAuthors[index].lastName,
                                    //     designation:
                                    //         widget.courseAuthors[index].department);
                                    return Author(
                                        name: widget.courseAuthors[index]
                                            ['name'],
                                        designation: 'Author');
                                  },
                                ),
                              )
                            : Center(),
                        widget.courseCurators.length > 0
                            ? Container(
                                height: widget.courseCurators.length * 80.0,
                                padding: EdgeInsets.only(bottom: 5),
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: widget.courseCurators.length,
                                  itemBuilder: (context, index) {
                                    // return Author(
                                    //     name: widget.courseAuthors[index].firstName +
                                    //         " " +
                                    //         widget.courseAuthors[index].lastName,
                                    //     designation:
                                    //         widget.courseAuthors[index].department);
                                    return Author(
                                        name: widget.courseCurators[index]
                                            ['name'],
                                        designation: 'Curator');
                                  },
                                ),
                              )
                            : Center(),
                      ])))
              : (Center()),
          // widget.course['competencies_v3'] != null &&
          //         _yourTaggedCompetencies.length > 0
          //     ? Container(
          //         padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
          //         child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          //                 child: Text(
          //                   EnglishLang.yourCompetenciesTagged,
          //                   style: GoogleFonts.montserrat(
          //                       decoration: TextDecoration.none,
          //                       color: AppColors.greys87,
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.w500),
          //                 ),
          //               ),
          //               Container(
          //                 // height: _yourTaggedCompetencies.length * 170.0,
          //                 child: ListView.builder(
          //                   scrollDirection: Axis.vertical,
          //                   shrinkWrap: true,
          //                   physics: const NeverScrollableScrollPhysics(),
          //                   itemCount: _yourTaggedCompetencies.length,
          //                   itemBuilder: (context, index) {
          //                     return TaggedCompetency(
          //                         yourTaggedCompetency:
          //                             _yourTaggedCompetencies[index],
          //                         courseCompetencies: _courseCompetencies);
          //                   },
          //                 ),
          //               )
          //             ]))
          //     : Center(),
          FutureBuilder(
              future: _competenciesTaggedToList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return _courseCompetencies != null &&
                        _courseCompetencies.length > 0
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                child: Text(
                                  EnglishLang.competencies,
                                  style: GoogleFonts.montserrat(
                                      decoration: TextDecoration.none,
                                      color: AppColors.greys87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                // height: _otherTaggedCompetencies.length * 135.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _courseCompetencies.length,
                                  itemBuilder: (context, index) {
                                    return OtherTaggedCompetency(
                                        _courseCompetencies[index]);
                                  },
                                ),
                              )
                            ]))
                    : Center();
              }),
          // widget.course['competencies_v3'] != null &&
          //         _otherTaggedCompetencies.length > 0
          //     ? Container(
          //         padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
          //         child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          //                 child: Text(
          //                   !widget.isFeatured
          //                       ? EnglishLang.otherCompetenciesTagged
          //                       : EnglishLang.competenciesTagged,
          //                   style: GoogleFonts.montserrat(
          //                       decoration: TextDecoration.none,
          //                       color: AppColors.greys87,
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.w500),
          //                 ),
          //               ),
          //               Container(
          //                 // height: _otherTaggedCompetencies.length * 135.0,
          //                 child: ListView.builder(
          //                   shrinkWrap: true,
          //                   scrollDirection: Axis.vertical,
          //                   physics: const NeverScrollableScrollPhysics(),
          //                   itemCount: _otherTaggedCompetencies.length,
          //                   itemBuilder: (context, index) {
          //                     return OtherTaggedCompetency(
          //                         _otherTaggedCompetencies[index]);
          //                   },
          //                 ),
          //               )
          //             ]))
          //     : Center(),
          !widget.isFeatured
              ? Container(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: _getReviews(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              var data = _reviewSummery;
                              // developer.log(jsonDecode(data['latest50Reviews'])
                              //     .runtimeType
                              //     .toString());
                              // setState(() {
                              //   _courseReviews = jsonDecode(data['latest50Reviews']);
                              // });

                              // if (data != null) {
                              double totalRating = (data != null &&
                                      (data['sum_of_total_ratings'] != null &&
                                          data['total_number_of_ratings'] !=
                                              null))
                                  ? (data['sum_of_total_ratings'] /
                                      data['total_number_of_ratings'])
                                  : 0;
                              widget.parentAction(totalRating);
                              int totalNoOfRating = ((data != null &&
                                      data['total_number_of_ratings'] != null)
                                  ? data['total_number_of_ratings'].toInt()
                                  : 0);
                              // _setReviews(data);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 20),
                                    child: Text(
                                      EnglishLang.ratingAndReviews,
                                      style: GoogleFonts.montserrat(
                                          decoration: TextDecoration.none,
                                          color: AppColors.greys87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            RatingBarIndicator(
                                              rating: totalRating,
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                Icons.star,
                                                color: AppColors.primaryOne,
                                              ),
                                              itemCount: 5,
                                              itemSize: 30.0,
                                              direction: Axis.horizontal,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                // '4.5 out of 5',
                                                double.parse((totalRating)
                                                            .toStringAsFixed(1))
                                                        .toString() +
                                                    " out of 5",
                                                style: GoogleFonts.lato(
                                                  color: AppColors.greys87,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Text(
                                            // '1 rating',
                                            totalNoOfRating.toString() +
                                                " ratings",
                                            style: GoogleFonts.lato(
                                              color: AppColors.greys60,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        StarProgressBar(
                                          text: '5 star',
                                          progress: (data != null &&
                                                  (data['totalcount5stars'] !=
                                                          null &&
                                                      data['totalcount5stars'] >
                                                          0))
                                              ? (data['totalcount5stars'] /
                                                  totalNoOfRating)
                                              : 0,
                                        ),
                                        StarProgressBar(
                                          text: '4 star',
                                          progress: (data != null &&
                                                  (data['totalcount4stars'] !=
                                                          null &&
                                                      data['totalcount4stars'] >
                                                          0))
                                              ? (data['totalcount4stars'] /
                                                  totalNoOfRating)
                                              : 0,
                                        ),
                                        StarProgressBar(
                                          text: '3 star',
                                          progress: ((data != null) &&
                                                  (data['totalcount3stars'] !=
                                                          null &&
                                                      data['totalcount3stars'] >
                                                          0))
                                              ? (data['totalcount3stars'] /
                                                  totalNoOfRating)
                                              : 0,
                                        ),
                                        StarProgressBar(
                                          text: '2 star',
                                          progress: (data != null &&
                                                  (data['totalcount2stars'] !=
                                                          null &&
                                                      data['totalcount2stars'] >
                                                          0))
                                              ? (data['totalcount2stars'] /
                                                  totalNoOfRating)
                                              : 0,
                                        ),
                                        StarProgressBar(
                                          text: '1 star',
                                          progress: (data != null &&
                                                  (data['totalcount1stars'] !=
                                                          null &&
                                                      data['totalcount1stars'] >
                                                          0))
                                              ? (data['totalcount1stars'] /
                                                  totalNoOfRating)
                                              : 0,
                                        )
                                      ],
                                    ),
                                  ),

                                  // (_reviewSummery != null)
                                  // ?
                                  Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 8),
                                        child: TextField(
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            prefixIcon: Icon(Icons.search),
                                            hintText:
                                                EnglishLang.searchInReviews,
                                            border: OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(width: 1)),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: AppColors.grey16),
                                            ),
                                          ),
                                          // onTap: () {
                                          //   // print('Hello');
                                          // },
                                          onChanged: (value) {
                                            _filterReviews(value);
                                          },
                                        ),
                                      ),
                                      // Container(
                                      //   height: 3 * 80.0,
                                      //   child: ListView.builder(
                                      //     scrollDirection: Axis.vertical,
                                      //     physics: const NeverScrollableScrollPhysics(),
                                      //     itemCount: 3,
                                      //     itemBuilder: (context, index) {
                                      //       return CompetencyLevelDetailItem();
                                      //     },
                                      //   ),
                                      // ),
                                      Container(
                                        alignment: Alignment.topRight,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(right: 16),
                                        child: DropdownButton<String>(
                                          value: _dropdownValue != null
                                              ? _dropdownValue
                                              : null,
                                          icon: Icon(
                                              Icons.arrow_drop_down_outlined),
                                          iconSize: 26,
                                          elevation: 16,
                                          style: TextStyle(
                                              color: AppColors.greys87),
                                          underline: Container(
                                            // height: 2,
                                            color: AppColors.lightGrey,
                                          ),
                                          selectedItemBuilder:
                                              (BuildContext context) {
                                            return dropdownItems
                                                .map<Widget>((String item) {
                                              return Row(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15.0,
                                                              15.0,
                                                              0,
                                                              15.0),
                                                      child: Text(
                                                        item,
                                                        style: GoogleFonts.lato(
                                                          color:
                                                              AppColors.greys87,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ))
                                                ],
                                              );
                                            }).toList();
                                          },
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _pageInitilized = false;
                                              _dropdownValue = newValue;
                                            });
                                          },
                                          items: dropdownItems
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      _filteredReviews != null &&
                                              _filteredReviews.length > 0
                                          ? Container(
                                              // height:
                                              //     (_filteredReviews.length <
                                              //                 3
                                              //             ? _filteredReviews
                                              //                 .length
                                              //             : 3) *
                                              //         130.0,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    _filteredReviews.length,
                                                itemBuilder: (context, index) {
                                                  return Review(
                                                    name: (_filteredReviews[index]['firstName'] !=
                                                                null &&
                                                            _filteredReviews[index]['lastName'] !=
                                                                null)
                                                        ? (_filteredReviews[index]
                                                                ['firstName'] +
                                                            ' ' +
                                                            _filteredReviews[index]
                                                                ['lastName'])
                                                        : ((_filteredReviews[index]['firstName'] !=
                                                                    null &&
                                                                _filteredReviews[index]['lastName'] ==
                                                                    null)
                                                            ? _filteredReviews[index]
                                                                ['firstName']
                                                            : ((_filteredReviews[index]['firstName'] ==
                                                                        null &&
                                                                    _filteredReviews[index]['lastName'] !=
                                                                        null)
                                                                ? _filteredReviews[index]
                                                                    ['lastName']
                                                                : 'Unknown user')),
                                                    rating: _filteredReviews[
                                                                    index]
                                                                ['rating'] !=
                                                            null
                                                        ? double.parse(
                                                            _filteredReviews[
                                                                        index]
                                                                    ['rating']
                                                                .toString())
                                                        : 0,
                                                    description:
                                                        _filteredReviews[index][
                                                                    'review'] !=
                                                                null
                                                            ? _filteredReviews[
                                                                index]['review']
                                                            : '',
                                                    updatedOn: _filteredReviews[
                                                                    index]
                                                                ['updatedon'] !=
                                                            null
                                                        ? _filteredReviews[
                                                            index]['updatedon']
                                                        : _filteredReviews[
                                                            index]['date'],
                                                    courseId: widget
                                                        .course['identifier'],
                                                    primaryCategory:
                                                        widget.course[
                                                            'primaryCategory'],
                                                    userId: _filteredReviews[
                                                                    index]
                                                                ['userId'] !=
                                                            null
                                                        ? _filteredReviews[
                                                            index]['userId']
                                                        : _filteredReviews[
                                                            index]['user_id'],
                                                  );
                                                },
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                EnglishLang.noReviewsFound,
                                                style: GoogleFonts.lato(
                                                  color: AppColors.greys87,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                    ],
                                  )
                                  // : Center(),
                                  // Review(
                                  //   name: 'Nachikeda Tiwari',
                                  //   rating: 3.0,
                                  //   description:
                                  //       'Curabitur lobortis id lorem id bibendum. Ut id consectetur magna. Quisque volutpat augue enim, pulvinar lobortis nibh lacinia at. Vestibulum nec erat ut mi sollicitudin porttitor id sit amet risus. Nam tempus vel odio vitae aliquam. ',
                                  // ),
                                  // Review(
                                  //   name: 'Syamala Gopalan',
                                  //   rating: 4.0,
                                  //   description:
                                  //       'Curabitur lobortis id lorem id bibendum. Ut id consectetur magna. Quisque volutpat augue enim, pulvinar lobortis nibh lacinia at. Vestibulum nec erat ut mi sollicitudin porttitor id sit amet risus. Nam tempus vel odio vitae aliquam. ',
                                  // ),
                                  // Container(
                                  //   height: 48,
                                  //   width: double.infinity,
                                  //   margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  //   child: TextButton(
                                  //     onPressed: () {
                                  //       // print('Received click');
                                  //     },
                                  //     style: TextButton.styleFrom(
                                  //       // primary: Colors.white,
                                  //       backgroundColor: AppColors.lightBackground,
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(4),
                                  //           side: BorderSide(color: AppColors.grey16)),
                                  //       // onSurface: Colors.grey,
                                  //     ),
                                  //     // color: AppColors.customBlue,

                                  //     child: Text(
                                  //       'SEE ALL 163 REVIEWS',
                                  //       style: GoogleFonts.lato(
                                  //         color: AppColors.primaryThree,
                                  //         fontWeight: FontWeight.w700,
                                  //         fontSize: 14,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              );
                              // } else {
                              //   return Center();
                              // }
                            }),
                        SizedBox(
                          height: 100,
                        )
                        // !widget.isFeatured
                        //     ? Container(
                        //         padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                        //         child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               Padding(
                        //                 padding: const EdgeInsets.fromLTRB(
                        //                     10, 10, 10, 10),
                        //                 child: Text(
                        //                   EnglishLang.similarCBPs,
                        //                   style: GoogleFonts.montserrat(
                        //                       decoration: TextDecoration.none,
                        //                       color: AppColors.greys87,
                        //                       fontSize: 16,
                        //                       fontWeight: FontWeight.w500),
                        //                 ),
                        //               ),
                        //               Container(
                        //                 height: 348,
                        //                 width: double.infinity,
                        //                 padding: const EdgeInsets.only(
                        //                     top: 5, bottom: 15),
                        //                 child: FutureBuilder(
                        //                   future: Provider.of<LearnRepository>(
                        //                           context,
                        //                           listen: false)
                        //                       .getCourses(
                        //                           1, '', ['course'], [], []),
                        //                   builder: (BuildContext context,
                        //                       AsyncSnapshot<List<Course>>
                        //                           snapshot) {
                        //                     if (snapshot.hasData) {
                        //                       List<Course> courses = snapshot.data;
                        //                       return ListView.builder(
                        //                         scrollDirection: Axis.horizontal,
                        //                         itemCount: 10,
                        //                         itemBuilder: (context, index) {
                        //                           return InkWell(
                        //                               onTap: () => Navigator.push(
                        //                                     context,
                        //                                     FadeRoute(
                        //                                       page:
                        //                                           CourseDetailsPage(
                        //                                         id: courses[index]
                        //                                             .id,
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                               child: CourseItem(
                        //                                   course: courses[index]));
                        //                         },
                        //                       );
                        //                     } else {
                        //                       // return Center(child: CircularProgressIndicator());
                        //                       return PageLoader();
                        //                     }
                        //                   },
                        //                 ),
                        //               ),
                        //             ]))
                        //     : SizedBox(
                        //         height: 50,
                        //       ),
                      ]))
              : SizedBox(height: 100,),
        ],
      )),
    );
  }
}
