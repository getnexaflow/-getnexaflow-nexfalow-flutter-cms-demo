import 'package:flutter/material.dart' hide Page;
import 'package:flutter_html/flutter_html.dart';
import 'package:nexaflow_flutter_sdk/nexaflow_flutter_sdk.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NexaflowSdk sdk = NexaflowSdk(apiKey: 'API_KEY');
  late Future<Page> data;

  @override
  void initState() {
    data = sdk.getPageById(websiteId: 'WEBSITE_ID', pageId: 'PAGE_ID');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog Demo')),
      body: FutureBuilder<Page>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Page page = snapshot.data!;
            return ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: List.generate(
                  page.blocks.length,
                  (index) => Blog(block: page.blocks[index]),
                ),
              ).toList(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Some Error Occured'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Blog extends StatelessWidget {
  const Blog({super.key, required this.block});

  final Block block;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(block.blockName.characters.first),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            block.blockName.replaceAll(r'_', ' '),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            block.blockDescription!,
            textAlign: TextAlign.justify,
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Blog Demo')),
              body: SingleChildScrollView(child: Html(data: block.blockData)),
            ),
          ),
        ),
      ),
    );
  }
}
