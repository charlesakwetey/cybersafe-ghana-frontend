import 'package:flutter/material.dart';
import '../../models/bookmark_model.dart';
import '../../services/bookmark_service.dart';
import '../../utils/constants.dart';
import 'article_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<ArticleBookmark>? _bookmarks;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookmarks = await BookmarkService.getBookmarks();
      setState(() {
        _bookmarks = bookmarks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load bookmarks';
        _isLoading = false;
      });
    }
  }

  Future<void> _removeBookmark(ArticleBookmark bookmark) async {
    final success = await BookmarkService.removeBookmark(bookmark.id);
    if (success) {
      setState(() {
        _bookmarks!.removeWhere((b) => b.id == bookmark.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Articles')),
      body: RefreshIndicator(
        onRefresh: _loadBookmarks,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage!, style: TextStyle(color: AppColors.danger)),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _loadBookmarks, child: const Text('Retry')),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    if (_bookmarks == null || _bookmarks!.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "No saved articles yet.\nTap the bookmark icon on any article to save it here.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _bookmarks!.length,
      itemBuilder: (context, index) {
        final bookmark = _bookmarks![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(bookmark.article.title),
            subtitle: Text(ScamTypes.labelFor(bookmark.article.category)),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark_remove_outlined),
              onPressed: () => _removeBookmark(bookmark),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(article: bookmark.article),
                ),
              );
              _loadBookmarks(); // refresh in case they un-bookmarked from the detail screen
            },
          ),
        );
      },
    );
  }
}