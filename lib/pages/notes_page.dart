import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final DBHelper _dbHelper = DBHelper.instance;
  late Future<List<Note>> _future;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      if (_isSearching && _searchController.text.isNotEmpty) {
        _future = _dbHelper.searchNotes(_searchController.text);
      } else {
        _future = _dbHelper.fetchNotes();
      }
    });
  }

  void _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _isSearching = true;
        _future = _dbHelper.searchNotes(value);
      });
    } else {
      setState(() {
        _isSearching = false;
        _future = _dbHelper.fetchNotes();
      });
    }
  }

  Future<void> _createDialog() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _NoteEditDialog(
        titleController: titleController,
        bodyController: bodyController,
        title: 'Новая заметка',
      ),
    );

    if (result == true && mounted) {
      final now = DateTime.now();
      await _dbHelper.insertNote(
        Note(
          title: titleController.text.trim(),
          body: bodyController.text.trim(),
          createdAt: now,
          updatedAt: now,
        ),
      );
      _reload();
    }
  }

  Future<void> _editDialog(Note note) async {
    final titleController = TextEditingController(text: note.title);
    final bodyController = TextEditingController(text: note.body);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _NoteEditDialog(
        titleController: titleController,
        bodyController: bodyController,
        title: 'Редактировать',
      ),
    );

    if (result == true && mounted) {
      final updatedNote = note.copyWith(
        title: titleController.text.trim(),
        body: bodyController.text.trim(),
        updatedAt: DateTime.now(),
      );
      await _dbHelper.updateNote(updatedNote);
      _reload();
    }
  }

  Future<void> _deleteNote(Note note) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заметку?'),
        content: Text('Вы уверены, что хотите удалить "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      await _dbHelper.deleteNote(note.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заметка удалена')),
      );
      _reload();
    }
  }

  Future<void> _toggleFavorite(Note note) async {
    final newFavoriteValue = note.isFavorite == 1 ? 0 : 1;
    await _dbHelper.toggleFavorite(note.id!, newFavoriteValue);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Поиск...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : const Text('Notes SQLite'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _reload();
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Note>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _reload,
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isSearching ? Icons.search_off : Icons.note_add,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isSearching ? 'Ничего не найдено' : 'Пока нет заметок',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSearching
                        ? 'Попробуйте изменить запрос'
                        : 'Нажмите + чтобы создать первую заметку',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final note = notes[index];
              return _NoteCard(
                note: note,
                onTap: () => _editDialog(note),
                onDelete: () => _deleteNote(note),
                onToggleFavorite: () => _toggleFavorite(note),
              );
            },
          );
        },
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            note.isFavorite == 1 ? Icons.favorite : Icons.favorite_border,
            color: note.isFavorite == 1 ? Colors.red : null,
          ),
          onPressed: onToggleFavorite,
        ),
        title: Text(
          note.title.isEmpty ? '(без названия)' : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(note.updatedAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня в ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Вчера в ${_formatTime(date)}';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _NoteEditDialog extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final String title;

  const _NoteEditDialog({
    required this.titleController,
    required this.bodyController,
    required this.title,
  });

  @override
  State<_NoteEditDialog> createState() => _NoteEditDialogState();
}

class _NoteEditDialogState extends State<_NoteEditDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                labelText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.bodyController,
              decoration: const InputDecoration(
                labelText: 'Текст заметки',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textInputAction: TextInputAction.newline,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            if (widget.titleController.text.trim().isNotEmpty ||
                widget.bodyController.text.trim().isNotEmpty) {
              Navigator.pop(context, true);
            }
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}