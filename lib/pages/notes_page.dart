import 'package:flutter/material.dart';
import '../data/api_client.dart';
import '../data/notes_repository.dart';
import '../models/note.dart';
import 'note_details_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final NotesRepository repo;
  final List<Note> _items = [];
  int _page = 1;
  bool _canLoadMore = true;
  bool _loading = false;
  bool _error = false;
  bool _usingMockData = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _loadInitialData();
  }

  void _initializeRepository() {
    try {
      final client = ApiClient(baseUrl: 'https://jsonplaceholder.typicode.com');
      repo = NotesRepository(client);
    } catch (e) {
      setState(() {
        _error = true;
        _errorMessage = 'Ошибка инициализации: $e';
      });
    }
  }

  Future<void> _loadInitialData() async {
    if (_loading) return;
    
    setState(() {
      _loading = true;
      _error = false;
      _errorMessage = '';
    });
    
    await _loadMore();
  }

  Future<void> _refresh() async {
    setState(() {
      _page = 1;
      _canLoadMore = true;
      _items.clear();
      _usingMockData = false;
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (!_canLoadMore || _loading) return;

    setState(() => _loading = true);

    try {
      final batch = await repo.list(page: _page, limit: 10);
      
      setState(() {
        _items.addAll(batch);
        _canLoadMore = batch.isNotEmpty;
        _page++;
        _error = false;
        _errorMessage = '';
        
        // Проверяем, используем ли мы мок-данные по содержимому
        if (batch.isNotEmpty && batch.first.title.contains('Мок-запись')) {
          _usingMockData = true;
        }
      });
    } catch (e) {
      setState(() {
        _error = true;
        _errorMessage = e.toString();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Повторить',
              onPressed: _loadInitialData,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateNoteDialog(
        repo: repo,
        onNoteCreated: (newNote) {
          setState(() {
            _items.insert(0, newNote);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_usingMockData 
                  ? 'Запись создана (локально)' 
                  : 'Запись создана (демо)'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _deleteNote(int index) {
    final deletedNote = _items[index];
    
    setState(() {
      _items.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_usingMockData 
            ? 'Запись удалена (локально)'
            : 'Запись удалена (демо)'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              _items.insert(index, deletedNote);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Notes Feed'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_usingMockData)
            const Tooltip(
              message: 'Используются локальные данные',
              child: Icon(Icons.wifi_off, color: Colors.orange),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading && _items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка данных...'),
          ],
        ),
      );
    }

    if (_error && _items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'Проблемы с подключением',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadInitialData,
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    _usingMockData = true;
                    _error = false;
                  });
                  _loadInitialData();
                },
                child: const Text('Использовать демо-данные'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (_usingMockData)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.orange[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                const Text('Используются демо-данные'),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: _refresh,
                  child: const Text('Обновить'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length + (_canLoadMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return _buildLoadMoreIndicator();
                }
                return _buildNoteItem(_items[index], index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _loadMore,
                child: const Text('Загрузить еще'),
              ),
    ));
  }

  Widget _buildNoteItem(Note note, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteDetailsPage(id: note.id, repo: repo),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _deleteNote(index),
        ),
      ),
    );
  }
}

class CreateNoteDialog extends StatefulWidget {
  final NotesRepository repo;
  final Function(Note)? onNoteCreated;

  const CreateNoteDialog({
    super.key,
    required this.repo,
    this.onNoteCreated,
  });

  @override
  State<CreateNoteDialog> createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateNoteDialog> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _saving = false;

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final newNote = await widget.repo.create(
        _titleController.text,
        _bodyController.text,
      );
      
      if (mounted) {
        widget.onNoteCreated?.call(newNote);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка создания: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать запись'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Заголовок',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(
              labelText: 'Текст',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _saveNote,
          child: _saving 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Создать'),
        ),
      ],
    );
  }
}