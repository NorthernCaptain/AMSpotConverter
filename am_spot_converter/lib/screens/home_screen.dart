import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/conversion_provider.dart';
import '../widgets/song_card.dart';

class HomeScreen extends StatefulWidget {
  final String? initialUrl;

  const HomeScreen({super.key, this.initialUrl});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _urlController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl ?? '');

    if (widget.initialUrl != null && widget.initialUrl!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ConversionProvider>().convertUrl(widget.initialUrl!);
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'SpAM Links',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paste a music link to convert:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Paste Spotify or Apple Music link here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: _urlController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _urlController.clear();
                                      context.read<ConversionProvider>().clearResults();
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {});
                            if (value.trim().isEmpty) {
                              context.read<ConversionProvider>().clearResults();
                            }
                          },
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              context.read<ConversionProvider>().convertUrl(value.trim());
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () async {
                          final provider = context.read<ConversionProvider>();
                          final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                          if (clipboardData?.text != null && mounted) {
                            _urlController.text = clipboardData!.text!;
                            setState(() {});
                            provider.convertUrl(clipboardData.text!.trim());
                          }
                        },
                        icon: const Icon(Icons.content_paste),
                        tooltip: 'Paste from clipboard',
                      ),
                      IconButton(
                        onPressed: _urlController.text.trim().isNotEmpty
                            ? () {
                                context.read<ConversionProvider>().convertUrl(_urlController.text.trim());
                              }
                            : null,
                        icon: const Icon(Icons.search),
                        tooltip: 'Convert',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
            child: Consumer<ConversionProvider>(
              builder: (context, provider, child) {
                final result = provider.result;

                if (result.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Converting your link...'),
                      ],
                    ),
                  );
                }

                if (result.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            result.error!,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (result.originalSong == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.music_note,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome to SpAM Links!\nApple Music ↔ Spotify Links',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Paste a Spotify or Apple Music link above to find it on the other platform.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.only(top: 8),
                  children: [
                    if (result.originalSong != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Original Song',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SongCard(
                        song: result.originalSong!,
                        isOriginal: true,
                      ),
                    ],
                    if (result.searchResults.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'Found on ${_getTargetPlatform(result.originalSong!.platform)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...result.searchResults.map(
                        (song) => SongCard(song: song),
                      ),
                    ] else if (result.originalSong != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No matches found on ${_getTargetPlatform(result.originalSong!.platform)}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }

  String _getTargetPlatform(String originalPlatform) {
    return originalPlatform == 'spotify' ? 'Apple Music' : 'Spotify';
  }
}