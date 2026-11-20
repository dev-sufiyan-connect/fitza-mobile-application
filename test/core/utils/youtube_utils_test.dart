import 'package:flutter_test/flutter_test.dart';

import 'package:fitza_mobile_application/core/utils/youtube_utils.dart';

void main() {
  test('parses standard watch URLs', () {
    expect(
      parseYoutubeVideoId('https://www.youtube.com/watch?v=0nrW-q7-WRQ'),
      '0nrW-q7-WRQ',
    );
    expect(
      parseYoutubeVideoId('https://youtube.com/watch?v=Xu4DxwKWzl4&t=30s'),
      'Xu4DxwKWzl4',
    );
  });

  test('parses short, shorts, embed and live URLs', () {
    expect(
      parseYoutubeVideoId('https://youtu.be/nIalczfM8es?si=abc'),
      'nIalczfM8es',
    );
    expect(
      parseYoutubeVideoId('https://www.youtube.com/shorts/_ChZv2iluM8'),
      '_ChZv2iluM8',
    );
    expect(
      parseYoutubeVideoId('https://www.youtube.com/embed/LI3b05LUdpA'),
      'LI3b05LUdpA',
    );
    expect(
      parseYoutubeVideoId('https://www.youtube.com/live/aYy3alWRDmk'),
      'aYy3alWRDmk',
    );
  });

  test('clips stray trailing characters from malformed ids', () {
    expect(
      parseYoutubeVideoId('https://www.youtube.com/watch?v=aYy3alWRDmk-4'),
      'aYy3alWRDmk',
    );
  });

  test('returns null for empty, short or non-YouTube values', () {
    expect(parseYoutubeVideoId(''), isNull);
    expect(parseYoutubeVideoId('not a url'), isNull);
    expect(parseYoutubeVideoId('https://example.com/watch?v=abc'), isNull);
    expect(
      parseYoutubeVideoId('https://www.youtube.com/watch?v=tooShort'),
      isNull,
    );
  });
}
