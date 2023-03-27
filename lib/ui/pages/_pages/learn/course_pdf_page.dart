import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../../constants/index.dart';
import './../../../widgets/index.dart';

class CoursePDF extends StatefulWidget {
  final String identifier;
  final String fileUrl;
  CoursePDF(this.identifier, this.fileUrl);
  @override
  _CoursePDFState createState() => _CoursePDFState();
}

class _CoursePDFState extends State<CoursePDF> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
      widget.fileUrl,
    );
    setState(() => _isLoading = false);
    // changePDF(2);
  }

  // changePDF(value) async {
  //   setState(() => _isLoading = true);
  //   if (value == 1) {
  //     document = await PDFDocument.fromAsset('assets/pdf/sample.pdf');
  //   } else if (value == 2) {
  //     document = await PDFDocument.fromURL(
  //         // widget.fileUrl,
  //         'http://www.africau.edu/images/default/sample.pdf'
  //         /* cacheManager: CacheManager(
  //         Config(
  //           "customCacheKey",
  //           stalePeriod: const Duration(days: 2),
  //           maxNrOfCacheObjects: 10,
  //         ),
  //       ), */
  //         );
  //   } else {
  //     document = await PDFDocument.fromAsset('assets/pdf/sample2.pdf');
  //   }
  //   setState(() => _isLoading = false);
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.clear, color: AppColors.greys60),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'PDF Viewer',
            style: GoogleFonts.montserrat(
              color: AppColors.greys87,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          // centerTitle: true,
        ),
        body: Center(
          child: _isLoading
              ? PageLoader()
              : PDFViewer(
                  document: document,
                  zoomSteps: 1,
                  //uncomment below line to preload all pages
                  // lazyLoad: false,
                  // uncomment below line to scroll vertically
                  // scrollDirection: Axis.vertical,

                  //uncomment below code to replace bottom navigation with your own
                  navigationBuilder:
                      (context, page, totalPages, jumpToPage, animateToPage) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.first_page),
                          onPressed: () {
                            jumpToPage(page: totalPages - totalPages);
                            // print('Page: ' +
                            //     (totalPages - totalPages + 1).toString());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            animateToPage(page: page - 2);
                            // print('Page: ' + (page - 1).toString());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            animateToPage(page: page);
                            // print('Page: ' + (page + 1).toString());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.last_page),
                          onPressed: () {
                            jumpToPage(page: totalPages - 1);
                            // print('Page: ' + (totalPages).toString());
                          },
                        ),
                      ],
                    );
                  },
                ),
        ));
  }
}
