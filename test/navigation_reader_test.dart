import 'dart:io';

import 'package:epubx/epubx.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;

int countChapterRefs(List<EpubChapterRef> chapters) {
  var count = chapters.length;
  for (final chapter in chapters) {
    count += countChapterRefs(chapter.SubChapters ?? []);
  }
  return count;
}

void main() {
  test('xml 6.x label text uses innerText', () {
    final navLabel = xml.XmlDocument.parse(
      '<navLabel xmlns="http://www.daisy.org/z3986/2005/ncx/">'
      '<text>Cover</text>'
      '</navLabel>',
    ).rootElement;
    final textEl = navLabel
        .findElements('text', namespace: navLabel.name.namespaceUri)
        .first;

    expect(textEl.value, isNull);
    expect(textEl.innerText, 'Cover');
  });

  group('childrens-literature.epub', () {
    late List<int> bytes;

    setUpAll(() async {
      bytes = await File('test/res/std/childrens-literature.epub').readAsBytes();
    });

    test('parses navigation labels and chapter refs', () async {
      final bookRef = await EpubReader.openBook(bytes);
      final chapters = await bookRef.getChapters();

      expect(
        bookRef.Schema!.Navigation!.NavMap!.Points!.first
            .NavigationLabels!.first.Text,
        isNotEmpty,
      );
      expect(countChapterRefs(chapters), greaterThanOrEqualTo(22));
      expect(chapters.first.Title, contains('SECTION IV'));
    });
  });
}
