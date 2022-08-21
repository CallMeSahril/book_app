import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/screen/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookScreen extends StatefulWidget {
  const DetailBookScreen({
    Key? key,
    required this.isbn,
  }) : super(key: key);
  final String isbn;

  @override
  State<DetailBookScreen> createState() => _DetailBookScreenState();
}

class _DetailBookScreenState extends State<DetailBookScreen> {
  BookController? bookProvider;
  String? love;

  @override
  void initState() {
    super.initState();
    bookProvider = Provider.of<BookController>(context, listen: false);
    bookProvider!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Book App"),
          centerTitle: true,
        ),
        body: Consumer<BookController>(builder: (context, value, child) {
          return bookProvider!.detailBook == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageViewScreen(
                                            imageUrl:
                                                value.detailBook!.image!)));
                              },
                              child: Image.network(
                                value.detailBook!.image!,
                                height: 150,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.detailBook!.title!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      bookProvider!.detailBook!.authors!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: List.generate(
                                          5,
                                          (index) => Icon(
                                                Icons.star,
                                                color: index <
                                                        int.parse(bookProvider!
                                                            .detailBook!
                                                            .rating!)
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                              )),
                                    ),
                                    Text(
                                      bookProvider!.detailBook!.subtitle!,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      bookProvider!.detailBook!.price!,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final Uri uri = Uri.parse(value.detailBook!.url!);

                              try {
                                (await canLaunchUrl(uri))
                                    ? launchUrl(uri)
                                    : print("tidak berhasil navigasi");
                              } catch (e) {
                                print("Error");

                                print(e);
                              }
                            },
                            child: const Text("BUY"),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(bookProvider!.detailBook!.desc!),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Year: ${bookProvider!.detailBook!.year!}"),
                            Text("ISBN${bookProvider!.detailBook!.isbn13!}"),
                            Text("${bookProvider!.detailBook!.pages!} Page"),
                            Text(
                                "Publisher: ${bookProvider!.detailBook!.publisher!}"),
                            Text(
                                "Langueage: ${bookProvider!.detailBook!.language!}"),
                          ],
                        ),
                        const Divider(),
                        bookProvider!.similiarBooks == null
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: bookProvider!
                                      .similiarBooks!.books!.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final current = bookProvider!
                                        .similiarBooks!.books![index];
                                    return SizedBox(
                                      width: 200,
                                      child: Column(
                                        children: [
                                          Image.network(
                                            current.image!,
                                            height: 100,
                                          ),
                                          Expanded(
                                            child: Text(
                                              current.title!,
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                );
        }));
  }
}
