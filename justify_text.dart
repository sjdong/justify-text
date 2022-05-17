import 'package:flutter/material.dart';

class JustifyText extends StatelessWidget {
  final String text;
  final double width;
  final TextStyle? style;
  const JustifyText(
      {Key? key, required this.text, required this.width, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getTextList(context));
  }

  List<Widget> getTextList(BuildContext ctx) {
    List<Widget> lines = [];

    TextPainter tp = TextPainter(
        locale: WidgetsBinding.instance!.window.locale,
        textScaleFactor: MediaQuery.of(ctx).textScaleFactor,
        textDirection: TextDirection.ltr,
        maxLines: 1);
    String _text = text;
    TextStyle _defaultStyle = DefaultTextStyle.of(ctx).style;

    late TextStyle _style;
    if (style != null) {
      _style = style!;
      if (style!.fontSize == null) {
        _style = _style.copyWith(fontSize: _defaultStyle.fontSize);
      }
      if (style!.fontWeight == null) {
        _style = _style.copyWith(fontWeight: _defaultStyle.fontWeight);
      }
    } else {
      _style = _defaultStyle;
    }

    double? spacing = _style.letterSpacing;
    Offset offset = Offset(width, 1);

    while (true) {
      tp.text = TextSpan(text: _text, style: _style);
      tp.layout(maxWidth: width);
      final textCount = tp.getPositionForOffset(offset).offset;
      final renderText = _text.substring(0, textCount);
      tp.text = TextSpan(text: renderText, style: _style);
      tp.layout();
      if (tp.width > width - _style.fontSize!) {
        //0.005，spacing微调比例，因按照除出来的spacing有可能会导致最后一个字是换行
        spacing = (width - tp.width) / textCount - 0.005;
      }
      lines.add(Text(renderText,
          style: _style.copyWith(letterSpacing: spacing),
          maxLines: 1,
          overflow: TextOverflow.visible));

      if (_text.length <= textCount) {
        break;
      } else {
        _text = _text.substring(textCount);
      }
    }
    return lines;
  }
}
