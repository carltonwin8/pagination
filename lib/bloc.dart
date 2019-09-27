import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'model.dart';
import 'network.dart';

class PhotoBloc {
  final API api = API();
  int pageNumber = 1;
  double pixels = 0.0;

  ReplaySubject<List<Photo>> _subject = ReplaySubject();
  final ReplaySubject<ScrollNotification> _controller = ReplaySubject();

  void dispose() {
    _controller.close();
    _subject.close();
  }

  PhotoBloc() {
    _subject.addStream(Observable.fromFuture(api.getPhotos(pageNumber)));
    _controller.listen((notification) => loadPhotos(notification));
  }

  Future<void> loadPhotos([
    ScrollNotification notification,
  ]) async {
    if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
        pixels != notification.metrics.pixels) {
      pageNumber++;
      List<Photo> list = await api.getPhotos(pageNumber);
      _subject.sink.add(list);
    }
  }

  Observable<List<Photo>> get stream => _subject.stream;
  Sink<ScrollNotification> get sink => _controller.sink;
}
