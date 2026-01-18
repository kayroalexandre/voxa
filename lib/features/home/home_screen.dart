
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
            _buildNotesList(context),
            _buildJournalsList(context),
            _buildMindMapsList(context),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (_tabController.index == 0) {
          _showCreateNoteDialog(context);
        } else if (_tabController.index == 1) {
          _showCreateJournalDialog(context);
        } else {
          _showCreateMindMapDialog(context);
        }
      },
      child: const Icon(Icons.add),
    );
  }

  void _showCreateNoteDialog(BuildContext context) {
    final noteService = context.read<NoteService>();
    final textController = TextEditingController();

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
                  hintText: 'Note text',
                  suffixIcon: IconButton(
                    icon: Icon(_speechService.isListening ? Icons.mic_off : Icons.mic),
                    onPressed: () {
                      if (_speechService.isListening) {
                        _speechService.stopListening();
                      } else {
                        _speechService.startListening((text) {
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  noteService.createNote(textController.text, 'text');
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateJournalDialog(BuildContext context) {
    final journalService = context.read<JournalService>();
    final textController = TextEditingController();

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
                  hintText: 'Journal text',
                  suffixIcon: IconButton(
                    icon: Icon(_speechService.isListening ? Icons.mic_off : Icons.mic),
                    onPressed: () {
                      if (_speechService.isListening) {
                        _speechService.stopListening();
                      } else {
                        _speechService.startListening((text) {
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  journalService.createJournal(textController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateMindMapDialog(BuildContext context) {
    final mindMapService = context.read<MindMapService>();
    final titleController = TextEditingController();

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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  mindMapService.createMindMap(titleController.text, []);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotesList(BuildContext context) {
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

  Widget _buildJournalsList(BuildContext context) {
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

  Widget _buildMindMapsList(BuildContext context) {
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
                    onPressed: () => _handleFileUpload(context, mindMap.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.summarize),
                    onPressed: () => _handleSummarize(context, mindMap),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleFileUpload(BuildContext context, String mindMapId) async {
    final mindMapService = context.read<MindMapService>();

    // Get the temporary directory
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/placeholder.txt';

    // Copy the asset file to the temporary directory
    final byteData = await rootBundle.load('assets/files/placeholder.txt');
    final buffer = byteData.buffer;
    await File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    // Upload the file
    await mindMapService.addFileToMindMap(mindMapId, filePath);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File uploaded!')),
      );
    }
  }

  void _handleSummarize(BuildContext context, MindMap mindMap) async {
    final aiService = context.read<AiService>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final summary = await aiService.summarizeMindMap(mindMap);
      if (!mounted) return;
      Navigator.pop(context); // Dismiss the loading indicator
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Summary'),
          content: Text(summary),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss the loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error summarizing: $e')),
      );
    }
  }
}
