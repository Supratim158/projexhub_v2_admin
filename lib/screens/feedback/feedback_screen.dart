import 'package:admin/controllers/feedback_controller.dart';
import 'package:admin/models/feedback_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late final FeedbackController feedbackController;
  bool _sortNewestFirst = true;

  // ─── DESIGN TOKENS ──────────────────────────────────────────────────
  static const _bgColor = Color(0xFFF7F8FA);
  static const _cardBg = Colors.white;
  static const _textPrimary = Color(0xFF1A1D26);
  static const _textSecondary = Color(0xFF6B7280);
  static const _borderColor = Color(0xFFE5E7EB);
  static const _accentPurple = Color(0xFF7C5CFC);
  static const _accentPurpleLight = Color(0xFFF0ECFF);
  static const _starColor = Color(0xFF7C5CFC);
  static const _starEmpty = Color(0xFFD1D5DB);

  @override
  void initState() {
    super.initState();
    feedbackController = Get.find<FeedbackController>();
    // Auto-refresh feedbacks every time this screen is visited
    feedbackController.fetchFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: RefreshIndicator(
        color: _accentPurple,
        onRefresh: () => feedbackController.fetchFeedbacks(),
        child: Obx(() {
          if (feedbackController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _accentPurple),
            );
          }

          final rawFeedbacks = feedbackController.feedbackList.toList();
          // Sort by date
          rawFeedbacks.sort((a, b) => _sortNewestFirst
              ? b.createdAt.compareTo(a.createdAt)
              : a.createdAt.compareTo(b.createdAt));
          final feedbacks = rawFeedbacks;

          return CustomScrollView(
            slivers: [
              // ─── HEADER ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, top: 28, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Feedback & Testimonials',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Monitor and manage sentiment across your user base. '
                        'Analyze ratings and detailed comments to drive product improvements.',
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondary.withOpacity(0.85),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ─── STATS ROW + SORT TOGGLE ───────────────────
                      Row(
                        children: [
                          Expanded(child: _buildStatsRow(feedbacks)),
                          const SizedBox(width: 12),
                          _buildSortToggle(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ─── FEEDBACK CARDS ──────────────────────────────────
              if (feedbacks.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.feedback_outlined,
                            size: 64, color: _starEmpty),
                        SizedBox(height: 16),
                        Text(
                          'No feedbacks yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child:
                              _buildFeedbackCard(feedbacks[index], index),
                        );
                      },
                      childCount: feedbacks.length,
                    ),
                  ),
                ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        }),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── STATS ROW ─────────────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildStatsRow(List<Datum> feedbacks) {
    return Row(
      children: [
        _buildStatChip(
          icon: Icons.chat_bubble_outline_rounded,
          label: '${feedbacks.length}',
          subtitle: 'Total',
          color: _accentPurple,
        ),
        const SizedBox(width: 12),
        _buildStatChip(
          icon: Icons.today_rounded,
          label: _todayCount(feedbacks).toString(),
          subtitle: 'Today',
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }

  int _todayCount(List<Datum> feedbacks) {
    final now = DateTime.now();
    return feedbacks
        .where((f) =>
            f.createdAt.year == now.year &&
            f.createdAt.month == now.month &&
            f.createdAt.day == now.day)
        .length;
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: _textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── SORT TOGGLE ───────────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSortToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortNewestFirst = !_sortNewestFirst;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _sortNewestFirst
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: 16,
              color: _accentPurple,
            ),
            const SizedBox(width: 6),
            Text(
              _sortNewestFirst ? 'Latest First' : 'Oldest First',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _accentPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── FEEDBACK CARD ─────────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildFeedbackCard(Datum datum, int index) {
    final user = datum.user;
    final dateStr = DateFormat('MMM dd, yyyy').format(datum.createdAt);

    // Generate a pseudo-rating from title hash (1-5 stars), since API has no rating
    final stars = (datum.title.hashCode.abs() % 5) + 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── TOP ROW: Avatar + name + stars + date ───────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: _accentPurpleLight,
                backgroundImage: user.profile.isNotEmpty
                    ? NetworkImage(user.profile)
                    : null,
                child: user.profile.isEmpty
                    ? Text(
                        user.userName.isNotEmpty
                            ? user.userName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _accentPurple,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),

              // Name + email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Date
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                dateStr,
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondary.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ─── TITLE ────────────────────────────────────────────────
          if (datum.title.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _accentPurpleLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                datum.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _accentPurple,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ─── FEEDBACK TEXT ────────────────────────────────────────
          Text(
            datum.feedback,
            style: const TextStyle(
              fontSize: 14,
              color: _textPrimary,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 16),

        
          
        ],
      ),
    );
  }

}
