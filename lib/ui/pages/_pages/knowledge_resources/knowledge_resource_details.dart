import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import './../../../../respositories/_respositories/knowledge_resource_repository.dart';
import './../../../../util/helper.dart';
import './../../../../constants/index.dart';
import './../../../../ui/widgets/index.dart';
import './../../../../models/index.dart';

class KnowledgeResourceDetails extends StatefulWidget {
  final KnowledgeResource knowledgeResource;
  final parentAction;
  final parentActionForSaved;
  KnowledgeResourceDetails(this.knowledgeResource,
      {this.parentAction, this.parentActionForSaved});

  @override
  _KnowledgeResourceDetailsState createState() {
    return _KnowledgeResourceDetailsState();
  }
}

class _KnowledgeResourceDetailsState extends State<KnowledgeResourceDetails>
    with TickerProviderStateMixin {
  bool selectionStatus = false;
  // String _downloadMessage = '';
  // GestureDetector button;
  Map<int, double> _progress = {};
  Map<int, double> _fileSize = {};
  bool bookmark;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    bookmark = widget.knowledgeResource.bookmark;
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    // openFile();
    // for (int i = 0; i < 3; i++) {
    //   _progress.addAll({i: 0.0});
    //   _fileSize.addAll({i: 0.0});
    // }
  }

  Future<void> _bookmarkKnowledgeResource(context, id, status) async {
    try {
      _iconAnimationController
          .forward()
          .then((value) => _iconAnimationController.reverse());
      // print(id.toString() + ', ' + status.toString());
      var response = await Provider.of<KnowledgeResourceRespository>(context,
              listen: false)
          .bookmarkKnowledgeResource(id, status);
      // print(response);
      if (response == 200) {
        if (status) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Bookmark added successfully!',
            ),
            duration: Duration(seconds: 3),
            backgroundColor: AppColors.positiveLight,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Bookmark removed successfully!',
            ),
            duration: Duration(seconds: 3),
            backgroundColor: AppColors.positiveLight,
          ));

          widget.parentActionForSaved(id);
        }
        setState(() {
          bookmark = !bookmark;
        });
        widget.parentAction();
      }
    } catch (err) {
      return err;
    }
  }

  Widget _link(urlLength) {
    return Row(children: [
      Icon(
        Icons.link,
        color: AppColors.primaryThree,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          widget.knowledgeResource.urls != null
              ? widget.knowledgeResource.urls.length.toString() + ' URL'
              : '',
          style: GoogleFonts.lato(
              color: AppColors.greys87,
              fontSize: 14.0,
              fontWeight: FontWeight.w400),
        ),
      )
    ]);
  }

  Future<dynamic> _openFile(filePath) async {
    await OpenFile.open(filePath);
  }

  Future<dynamic> downloadFile(String fileType, String url, index) async {
    // url =
    //     'https://images.unsplash.com/photo-1550330562-b055aa030d73?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format';
    // File filePath = new File(url);
    if (url == '') {
      _displayDialog(false, '');
      return;
    }
    String filename = Helper.getFileName(url);
    if (fileType.contains('/')) {
      fileType = fileType.split('/').last;
    }
    var httpClient = http.Client();
    var request = new http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);
    // String dir = (await getApplicationDocumentsDirectory()).path;
    String dir = APP_DOWNLOAD_FOLDER;

    List<List<int>> chunks = [];
    int downloaded = 0;
    _progress[index] = 0;
    // _displayDialog(_progress);
    response.asStream().listen((http.StreamedResponse r) {
      // print('r.contentLength: ' + r.contentLength.toString());
      if (r.contentLength == null) {
        _displayDialog(false, '');
        return;
      }
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        // debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');
        setState(() {
          _fileSize[index] = r.contentLength / (1000);
          _progress[index] = (downloaded / r.contentLength);
        });
        // debugPrint('downloadPercentage: ${_progress.toString()}');
        chunks.add(chunk);
        downloaded += chunk.length;
        // print(downloaded.toString());
      }, onDone: () async {
        // Display percentage of completion
        // debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');
        setState(() {
          _progress[index] = (downloaded / r.contentLength);
        });
        // debugPrint('downloadPercentage: ${_progress.toString()}');
        // Save the file
        String filePath = '$dir/$filename.$fileType';
        File file = new File(filePath);
        final Uint8List bytes = Uint8List(r.contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        // setState(() {
        //   _progress[index] = 1;
        // });
        _displayDialog(true, filePath);
        return;
      });
    });
  }

  String _getFileIcon(String fileExtension) {
    if (fileExtension.contains('/')) {
      fileExtension = fileExtension.split('/').last;
    }
    switch (fileExtension) {
      case 'jpg':
        return 'assets/img/jpg.svg';
        break;
      case 'jpeg':
        return 'assets/img/jpg.svg';
        break;
      case 'png':
        return 'assets/img/png.svg';
        break;
      case 'pdf':
        return 'assets/img/pdf.svg';
        break;
      case 'mp4':
        return 'assets/img/video.svg';
        break;
      case 'ppt':
        return 'assets/img/ppt.svg';
        break;
      case 'xlsx':
        return 'assets/img/excel.svg';
        break;
      case 'doc':
        return 'assets/img/doc.svg';
        break;
      default:
        return 'assets/img/default.svg';
    }
  }

  Future<bool> _displayDialog(bool isSuccess, String filePath) async {
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
                                        : 'Error while downloading the file.',
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
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Container(
              child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: AppColors.greys87,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
        // Tab controller
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 1000)),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // print(_searchKeyword);
                  return Column(children: [
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 5.0),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.0, 10.0, 20.0, 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.knowledgeResource.source != null
                                      ? widget.knowledgeResource.source
                                      : '',
                                  style: GoogleFonts.lato(
                                      color: AppColors.greys60,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                                (bookmark)
                                    ? ScaleTransition(
                                        scale: _iconAnimationController,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.bookmark,
                                            color: AppColors.primaryThree,
                                          ),
                                          onPressed: () {
                                            _bookmarkKnowledgeResource(
                                                context,
                                                widget.knowledgeResource.id,
                                                false);
                                          },
                                        ),
                                      )
                                    : ScaleTransition(
                                        scale: _iconAnimationController,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.bookmark,
                                            color: AppColors.grey16,
                                          ),
                                          onPressed: () {
                                            _bookmarkKnowledgeResource(
                                                context,
                                                widget.knowledgeResource.id,
                                                true);
                                          },
                                        ),
                                      )
                              ],
                            ),
                            Container(
                              child: Text(
                                widget.knowledgeResource.name,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                widget.knowledgeResource.description,
                                style: GoogleFonts.lato(
                                    color: AppColors.greys87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Icon(
                                  //   widget.icon,
                                  //   color: AppColors.greys60,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text(
                                      widget.knowledgeResource.id,
                                      style: GoogleFonts.lato(
                                          color: AppColors.greys60,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.knowledgeResource
                                        .raw['additionalProperties'] !=
                                    null
                                ? Container(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      children: [
                                        widget.knowledgeResource.files != null
                                            //                                         widget.knowledgeResources[14].krFiles
                                            // .where((item) => item['fileType'] == 'jpg')
                                            // .toList()
                                            ? Row(
                                                children: [
                                                  widget.knowledgeResource
                                                              .krFiles
                                                              .where((item) =>
                                                                  item[
                                                                      'fileType'] ==
                                                                  'jpg')
                                                              .toList()
                                                              .length !=
                                                          0
                                                      ? Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/img/jpg.svg',
                                                              width: 24.0,
                                                              height: 24.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          18),
                                                              child: Text(
                                                                widget
                                                                    .knowledgeResource
                                                                    .krFiles
                                                                    .where((item) =>
                                                                        item[
                                                                            'fileType'] ==
                                                                        'jpg')
                                                                    .toList()
                                                                    .length
                                                                    .toString(),
                                                                style: GoogleFonts.lato(
                                                                    color: AppColors
                                                                        .greys87,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Center(),
                                                  widget.knowledgeResource
                                                              .krFiles
                                                              .where((item) =>
                                                                  item[
                                                                      'fileType'] ==
                                                                  'png')
                                                              .toList()
                                                              .length !=
                                                          0
                                                      ? Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/img/png.svg',
                                                              width: 24.0,
                                                              height: 24.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          18),
                                                              child: Text(
                                                                widget
                                                                    .knowledgeResource
                                                                    .krFiles
                                                                    .where((item) =>
                                                                        item[
                                                                            'fileType'] ==
                                                                        'png')
                                                                    .toList()
                                                                    .length
                                                                    .toString(),
                                                                style: GoogleFonts.lato(
                                                                    color: AppColors
                                                                        .greys87,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Center(),
                                                  widget.knowledgeResource
                                                              .krFiles
                                                              .where((item) =>
                                                                  item[
                                                                      'fileType'] ==
                                                                  'pdf')
                                                              .toList()
                                                              .length !=
                                                          0
                                                      ? Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/img/pdf.svg',
                                                              width: 24.0,
                                                              height: 24.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          18),
                                                              child: Text(
                                                                widget
                                                                    .knowledgeResource
                                                                    .krFiles
                                                                    .where((item) =>
                                                                        item[
                                                                            'fileType'] ==
                                                                        'pdf')
                                                                    .toList()
                                                                    .length
                                                                    .toString(),
                                                                style: GoogleFonts.lato(
                                                                    color: AppColors
                                                                        .greys87,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Center(),
                                                ],
                                              )
                                            : Center(),
                                        widget.knowledgeResource.urls != null
                                            ? _link(widget
                                                .knowledgeResource.urls.length)
                                            : Center()
                                      ],
                                    ),
                                  )
                                : Center()
                          ],
                        ),
                      ),
                    ),
                    (widget.knowledgeResource.raw['additionalProperties'] !=
                                null &&
                            widget.knowledgeResource.raw['additionalProperties']
                                .isNotEmpty)
                        ? (Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 14, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Recent',
                                  style: GoogleFonts.lato(
                                      color: AppColors.greys87,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ))
                        : Center(),
                    Container(
                      // height: ,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.knowledgeResource.files != null
                            ? widget.knowledgeResource.files.length
                            : 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () => downloadFile(
                                  widget.knowledgeResource.krFiles[index]
                                      ['fileType'],
                                  widget.knowledgeResource.krFiles[index]
                                      ['url'],
                                  index),
                              child: Container(
                                width: double.infinity,
                                color: Colors.white,
                                margin: EdgeInsets.only(top: 5.0),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.0, 10.0, 20.0, 18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            widget.knowledgeResource.source,
                                            style: GoogleFonts.lato(
                                                color: AppColors.greys60,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: widget.knowledgeResource.files !=
                                                null
                                            ? (Text(
                                                Helper.getFileName(widget
                                                    .knowledgeResource
                                                    .files[index]),
                                                style: GoogleFonts.lato(
                                                    color: AppColors.greys87,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ))
                                            : Center(),
                                      ),
                                      widget.knowledgeResource.files != null
                                          ? (Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    _getFileIcon(widget
                                                            .knowledgeResource
                                                            .krFiles[index]
                                                        ['fileType']),
                                                    width: 24.0,
                                                    height: 24.0,
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    _fileSize[index] != null
                                                        ? _fileSize[index]
                                                                .toStringAsFixed(
                                                                    2) +
                                                            'Kb'
                                                        : '',
                                                    style: GoogleFonts.lato(
                                                        color:
                                                            AppColors.greys87,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),

                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(left: 10.0, right: 18),
                                                  //   child: Icon(Icons.download_outlined),
                                                  // ),
                                                ],
                                              ),
                                            ))
                                          : Center(),
                                      _progress[index] != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: LinearProgressIndicator(
                                                backgroundColor:
                                                    AppColors.lightGrey,
                                                value: _progress[index],
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        AppColors.primaryThree),
                                              ),
                                            )
                                          : Center(),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                    widget.knowledgeResource.urls != null
                        ? (Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.knowledgeResource.urls.length,
                              itemBuilder: (context, index) {
                                return KnowledgeResourceLink(
                                  widget.knowledgeResource.name,
                                  widget.knowledgeResource.source,
                                  widget.knowledgeResource.urls[index],
                                );
                              },
                            ),
                          ))
                        : Center(),
                  ]);
                })));
  }
}
