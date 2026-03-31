import 'package:epubx/src/schema/opf/epub_manifest.dart';
import 'package:xml/src/xml/builder.dart' show XmlBuilder;

class EpubManifestWriter {
  static void writeManifest(XmlBuilder builder, EpubManifest? manifest) {
    builder.element(
      'manifest',
      nest: () {
        manifest!.Items!.forEach((item) {
          builder.element(
            'item',
            nest: () {
              if (item.Id != null) {
                builder.attribute('id', item.Id!);
              }
              if (item.Href != null) {
                builder.attribute('href', item.Href!);
              }
              if (item.MediaType != null) {
                builder.attribute('media-type', item.MediaType!);
              }
              if (item.Properties != null) {
                builder.attribute('properties', item.Properties);
              }
            },
          );
        });
      },
    );
  }
}
