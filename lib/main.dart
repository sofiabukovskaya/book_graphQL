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
      debugShowCheckedModeBanner: false,
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
  BookModel? _selectedBook;

  final graphQLService = GraphQLService();

  final _titleEditingController = TextEditingController();
  final _authorEditingController = TextEditingController();
  final _yearEditingController = TextEditingController();

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _books = await graphQLService.getBooks(limit: 10);
    setState(() {});
  }

  void _clear() {
    _titleEditingController.clear();
    _authorEditingController.clear();
    _yearEditingController.clear();
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
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _books!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ListTile(
                            leading: const Icon(Icons.book),
                            onTap: () {
                              _selectedBook = _books![index];

                              _titleEditingController.text =
                                  _selectedBook!.title;
                              _authorEditingController.text =
                                  _selectedBook!.author;
                              _yearEditingController.text =
                                  _selectedBook!.year.toString();
                            },
                            title: Text(
                                '${_books![index].title} by ${_books![index].author}'),
                            subtitle: Text('${_books![index].year}'),
                            trailing: IconButton(
                              onPressed: () async {
                                await graphQLService.deleteBook(
                                    id: _books![index].id!);
                                _load();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              isEditMode = !isEditMode;
                              setState(() {});
                            },
                            icon: Icon(isEditMode ? Icons.create : Icons.add),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    controller: _titleEditingController,
                                    decoration: const InputDecoration(
                                      hintText: 'Title',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    controller: _authorEditingController,
                                    decoration: const InputDecoration(
                                      hintText: 'Author',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    controller: _yearEditingController,
                                    decoration: const InputDecoration(
                                      hintText: 'Year',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isEditMode) {
                                await graphQLService.updateBook(
                                  id: _selectedBook!.id!,
                                  title: _titleEditingController.text,
                                  author: _authorEditingController.text,
                                  year: int.tryParse(
                                      _yearEditingController.text)!,
                                );
                              }
                              await graphQLService.createBook(
                                title: _titleEditingController.text,
                                author: _authorEditingController.text,
                                year:
                                    int.tryParse(_yearEditingController.text)!,
                              );
                              _clear();
                              _load();
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      )
                    ],
                  ),
      ),
    );
  }
}
