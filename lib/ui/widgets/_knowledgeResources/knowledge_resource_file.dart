import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../../constants/index.dart';
import './../../../util/helper.dart';

class KnowledgeResourceFile extends StatefulWidget {
  final String name;
  final String source;
  final String file;

  const KnowledgeResourceFile(this.name, this.source, this.file);

  @override
  _KnowledgeResourceFileState createState() => _KnowledgeResourceFileState();
}

class _KnowledgeResourceFileState extends State<KnowledgeResourceFile> {
  String _getFileIcon(String fileExtension) {
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
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
                      widget.source,
                      style: GoogleFonts.lato(
                          color: AppColors.greys60,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    Helper.getFileName(widget.name),
                    style: GoogleFonts.lato(
                        color: AppColors.greys87,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        _getFileIcon(Helper.getFileExtension(widget.file)),
                        width: 24.0,
                        height: 24.0,
                      )
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 10.0, right: 18),
                      //   child: Icon(Icons.download_outlined),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
