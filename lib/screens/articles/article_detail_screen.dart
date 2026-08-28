import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/article_model.dart';
import '../../services/bookmark_service.dart';
import '../../utils/constants.dart';
import '../reports/report_form_screen.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _isBookmarked = false;
  int? _bookmarkId;
  bool _isCheckingBookmark = true;
  bool _isTogglingBookmark = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    try {
      final bookmarks = await BookmarkService.getBookmarks();
      final match = bookmarks.where((b) => b.article.id == widget.article.id);
      if (match.isNotEmpty) {
        setState(() {
          _isBookmarked = true;
          _bookmarkId = match.first.id;
        });
      }
    } catch (e) {
      // fail silently, bookmark button just won't show as active
    } finally {
      setState(() {
        _isCheckingBookmark = false;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    setState(() {
      _isTogglingBookmark = true;
    });

    if (_isBookmarked && _bookmarkId != null) {
      final success = await BookmarkService.removeBookmark(_bookmarkId!);
      if (success) {
        setState(() {
          _isBookmarked = false;
          _bookmarkId = null;
        });
      }
    } else {
      final newId = await BookmarkService.addBookmark(widget.article.id);
      if (newId != null) {
        setState(() {
          _isBookmarked = true;
          _bookmarkId = newId;
        });
      }
    }

    setState(() {
      _isTogglingBookmark = false;
    });
  }

  void _shareArticle() {
    Share.share(
      '${widget.article.title}\n\n${widget.article.body}\n\nShared from CyberSafe Ghana',
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final accentColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.ghanaGold
        : AppColors.navy;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Awareness Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: _shareArticle,
          ),
          IconButton(
            icon: _isCheckingBookmark || _isTogglingBookmark
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: (_isCheckingBookmark || _isTogglingBookmark)
                ? null
                : _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ScamTypes.labelFor(article.category),
                style: TextStyle(
                  color: accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              article.body,
              style: const TextStyle(fontSize: 15, height: 1.7),
            ),
            const SizedBox(height: 28),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportFormScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: accentColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: accentColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Seen this scam? Report it',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}