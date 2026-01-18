
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:voxa/features/ai/ai_service.dart';
import 'package:voxa/features/auth/auth_service.dart';
import 'package:voxa/features/journals/journal_service.dart';
import 'package:voxa/features/mind_maps/mind_map_model.dart';
import 'package:voxa/features/mind_maps/mind_map_service.dart';
import 'package:voxa/features/notes/note_service.dart';
import 'package:voxa/features/speech/speech_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SpeechService _speechService = SpeechService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _speechService.initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => NoteService()),
        Provider(create: (_) => JournalService()),
        Provider(create: (_) => MindMapService()),
        Provider(create: (_) => AiService()),
        Provider.value(value: _speechService),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Voxa'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthService>().signOut();
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Notes'),
              Tab(text: 'Journals'),
              Tab(text: 'Mind Maps'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNotesList(),
            _buildJournalsList(),
            _buildMindMapsList(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        if (_tabController.index == 0) {
          _showCreateNoteDialog();
        } else if (_tabController.index == 1) {
          _showCreateJournalDialog();
        } else {
          _showCreateMindMapDialog();
        }
      },
      child: const Icon(Icons.add),
    );
  }

  void _showCreateNoteDialog() {
    final noteService = context.read<NoteService>();
    final aiService = context.read<AiService>();
    final speechService = context.read<SpeechService>();
    final textController = TextEditingController();
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Note'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Speak to transcribe...',
                  suffixIcon: IconButton(
                    icon: Icon(speechService.isListening ? Icons.mic_off : Icons.mic),
                    onPressed: () {
                      if (speechService.isListening) {
                        speechService.stopListening();
                      } else {
                        speechService.startListening((text) {
                          setState(() {
                            textController.text = text;
                          });
                        });
                      }
                      // We need to call setState to rebuild the icon
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => navigator.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final rawText = textController.text;
                if (rawText.isEmpty) return;

                final enhancedText = await aiService.enhanceText(rawText);
                noteService.createNote(enhancedText, 'audio');

                if (mounted) {
                  navigator.pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateJournalDialog() {
    final journalService = context.read<JournalService>();
    final aiService = context.read<AiService>();
    final speechService = context.read<SpeechService>();
    final textController = TextEditingController();
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Journal'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Speak to transcribe...',
                  suffixIcon: IconButton(
                    icon: Icon(speechService.isListening ? Icons.mic_off : Icons.mic),
                    onPressed: () {
                      if (speechService.isListening) {
                        speechService.stopListening();
                      } else {
                        speechService.startListening((text) {
                          setState(() {
                            textController.text = text;
                          });
                        });
                      }
                       setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => navigator.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final rawText = textController.text;
                if (rawText.isEmpty) return;

                final enhancedText = await aiService.enhanceText(rawText);
                journalService.createJournal(enhancedText);

                 if (mounted) {
                  navigator.pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateMindMapDialog() {
    final mindMapService = context.read<MindMapService>();
    final titleController = TextEditingController();
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Mind Map'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Mind Map title'),
          ),
          actions: [
            TextButton(
              onPressed: () => navigator.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                mindMapService.createMindMap(titleController.text, []);
                 if (mounted) {
                  navigator.pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotesList() {
    final noteService = context.watch<NoteService>();
    return StreamBuilder(
      stream: noteService.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final notes = snapshot.data!;
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note.text),
              subtitle: Text(note.createdAt.toDate().toString()),
            );
          },
        );
      },
    );
  }

  Widget _buildJournalsList() {
    final journalService = context.watch<JournalService>();
    return StreamBuilder(
      stream: journalService.getJournals(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final journals = snapshot.data!;
        return ListView.builder(
          itemCount: journals.length,
          itemBuilder: (context, index) {
            final journal = journals[index];
            return ListTile(
              title: Text(journal.text),
              subtitle: Text(journal.createdAt.toDate().toString()),
            );
          },
        );
      },
    );
  }

  Widget _buildMindMapsList() {
    final mindMapService = context.watch<MindMapService>();
    return StreamBuilder<List<MindMap>>(
      stream: mindMapService.getMindMaps(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final mindMaps = snapshot.data!;
        return ListView.builder(
          itemCount: mindMaps.length,
          itemBuilder: (context, index) {
            final mindMap = mindMaps[index];
            return ListTile(
              title: Text(mindMap.title),
              subtitle: Text(mindMap.createdAt.toDate().toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.upload_file),
                    onPressed: () => _handleFileUpload(mindMap.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.summarize),
                    onPressed: () => _handleSummarize(mindMap),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleFileUpload(String mindMapId) async {
    final mindMapService = context.read<MindMapService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/placeholder.txt';

      final byteData = await rootBundle.load('assets/files/placeholder.txt');
      final buffer = byteData.buffer;
      await File(filePath).writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      await mindMapService.addFileToMindMap(mindMapId, filePath);

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('File uploaded!')),
      );
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  void _handleSummarize(MindMap mindMap) async {
    final aiService = context.read<AiService>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final summary = await aiService.summarizeMindMap(mindMap.id);

      if (!mounted) return;

      navigator.pop(); // Dismiss the loading indicator
      
      _showSummaryDialog(summary);

    } catch (e) {
      if (!mounted) return;
      navigator.pop(); // Dismiss the loading indicator
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error summarizing: $e')),
      );
    }
  }

  void _showSummaryDialog(String summary) {
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Summary'),
        content: Text(summary),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
