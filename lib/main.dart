import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<PhotoBloc>(
      builder: (context) => PhotoBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'Pagination Picture Viewer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Pagination Picture Viewer'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Photo> photos;
  List<int> maxPhotos;

  @override
  void initState() {
    super.initState();
    photos = [];
    maxPhotos = List.generate(5000, (x) => x);
  }

  bool _onNotification(ScrollNotification scrollInfo, PhotoBloc bloc) {
    if (scrollInfo is ScrollEndNotification) {
      bloc.sink.add(scrollInfo);
    }
    return false;
  }

  _buildListView(context, snapshot) {
    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
    photos.addAll(snapshot.data);
    return ListView.builder(
      itemCount: (maxPhotos.length > photos.length)
          ? photos.length + 1
          : photos.length,
      itemBuilder: (context, index) => (index == photos.length)
          ? Container(
              margin: EdgeInsets.all(8),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListTile(
              leading: CircleAvatar(
                child: Image.network(photos[index].thumbnailUrl),
              ),
              title: Text(photos[index].id.toString()),
              subtitle: Text(photos[index].title),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PhotoBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<List<Photo>>(
            builder: (context, snapshot) => _buildListView(context, snapshot),
            stream: bloc.stream),
        onNotification: (scrollInfo) => _onNotification(scrollInfo, bloc),
      ),
    );
  }
}
