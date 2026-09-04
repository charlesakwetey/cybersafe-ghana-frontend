import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../services/article_service.dart';
import '../../utils/constants.dart';
import 'article_detail_screen.dart';
import 'bookmarks_screen.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  List<Article>? _articles;
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final articles = await ArticleService.getArticles();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load articles';
        _isLoading = false;
      });
    }
  }

  List<Article> get _filteredArticles {
    if (_articles == null) return [];
    if (_selectedCategory == 'all') return _articles!;
    return _articles!
        .where((article) => article.category == _selectedCategory)
        .toList();
  }

  IconData _iconFor(String category) {
    switch (category) {
      case 'mobile_money':
        return Icons.phone_android;
      case 'phishing':
        return Icons.mail_outline;
      case 'sim_swap':
        return Icons.sim_card_outlined;
      case 'romance_scam':
        return Icons.favorite_border;
      case 'job_scam':
        return Icons.work_outline;
      default:
        return Icons.article_outlined;
    }
  }

  Color _colorFor(String category) {
    switch (category) {
      case 'mobile_money':
        return AppColors.danger;
      case 'phishing':
        return AppColors.warning;
      case 'sim_swap':
        return AppColors.navy;
      case 'romance_scam':
        return AppColors.success;
      case 'job_scam':
        return AppColors.jobScamPurple;
      default:
        return AppColors.charcoal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awareness Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarksScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      {'value': 'all', 'label': 'All'},
      ...ScamTypes.all,
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['value'];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: ChoiceChip(
              label: Text(category['label']!),
              selected: isSelected,
              selectedColor: AppColors.navy,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : AppColors.charcoal),
                fontSize: 13,
              ),
              onSelected: (_) {
                setState(() {
                  _selectedCategory = category['value']!;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: TextStyle(color: AppColors.danger)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadArticles,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filtered = _filteredArticles;

    if (filtered.isEmpty) {
      return const Center(child: Text('No articles in this category.'));
    }

    return RefreshIndicator(
      onRefresh: _loadArticles,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final article = filtered[index];
          return _ArticleCard(
            article: article,
            icon: _iconFor(article.category),
            color: _colorFor(article.category),
          );
        },
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  final IconData icon;
  final Color color;

  const _ArticleCard({
    required this.article,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ScamTypes.labelFor(article.category),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
