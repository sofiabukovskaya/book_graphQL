import 'package:book_app_graph_ql/book_model.dart';
import 'package:book_app_graph_ql/graphql_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BookModel>? _books;
  GraphQLService graphQLService = GraphQLService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _books = await graphQLService.getBooks(limit: 10);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: _books == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _books!.isEmpty
                ? const Center(
                    child: Text('No books'),
                  )
                : ListView.builder(
                    itemCount: _books!.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(
                          '${_books![index].title} by ${_books![index].author}'),
                      subtitle: Text('${_books![index].year}'),
                    ),
                  ),
      ),
    );
  }
}
