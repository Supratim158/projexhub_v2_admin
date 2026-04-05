import 'package:admin/core/constats/colors.dart';
import 'package:admin/screens/projects/details/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailedCard extends StatefulWidget {
  final String title;
  final List<String> usernames;
  final List<String>? memberIds;
  final List<String> imageUrls;
  final String tagline;
  final String description;
  final String totalMembers;
  final String duration;
  final String link;
  final String demoLink;
  final String video;
  final String pdf;
  final String ppt;
  final List<String> techStack;
  final List<String> tags;
  final List<String> categories;
  final String status;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ProjectDetailedCard({
    super.key,
    required this.title,
    required this.usernames,
    this.memberIds,
    required this.imageUrls,
    required this.tagline,
    required this.description,
    required this.totalMembers,
    required this.duration,
    required this.link,
    required this.demoLink,
    required this.video,
    required this.pdf,
    required this.ppt,
    required this.techStack,
    required this.categories,
    required this.status,
    this.tags = const [],
    this.onApprove,
    this.onReject,
  });

  @override
  State<ProjectDetailedCard> createState() => _ProjectDetailedCardState();
}

class _ProjectDetailedCardState extends State<ProjectDetailedCard> {
  // ─── ACCENT COLORS ────────────────────────────────────────────────────────
  static const _accentPurple = Color(0xFF7C5CFC);
  static const _accentPurpleLight = Color(0xFFF0ECFF);
  static const _bgColor = Color(0xFFF7F8FA);
  static const _cardShadow = Color(0x0D000000);
  static const _textPrimary = Color(0xFF1A1D26);
  static const _textSecondary = Color(0xFF6B7280);
  static const _borderColor = Color(0xFFE5E7EB);

  // ─── CATEGORY COLORS (cycle through for badges) ──────────────────────────
  static const _badgeColors = [
    Color(0xFF6366F1),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
  ];

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open: $url')),
        );
      }
    }
  }

  void _openImageViewer(int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return ImageViewerScreen(
            imageUrls: widget.imageUrls,
            initialIndex: initialIndex,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── HERO SECTION (full width) ────────────────────
            _buildHeroSection(context),

            // ─── CONTENT BODY ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildLeftColumn()),
                        const SizedBox(width: 24),
                        SizedBox(width: 280, child: _buildRightColumn()),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLeftColumn(),
                      const SizedBox(height: 24),
                      _buildRightColumn(),
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

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── HERO SECTION ──────────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: GestureDetector(
        onTap: widget.imageUrls.isNotEmpty ? () => _openImageViewer(0) : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 380,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                if (widget.imageUrls.isNotEmpty)
                  Image.network(
                    widget.imageUrls[0],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF1C2B3A),
                      child: const Center(
                        child:
                            Icon(Icons.image, size: 64, color: Colors.white30),
                      ),
                    ),
                  )
                else
                  Container(
                    color: const Color(0xFF1C2B3A),
                    child: const Center(
                      child: Icon(Icons.image, size: 64, color: Colors.white30),
                    ),
                  ),

                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.35, 0.7, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.92),
                      ],
                    ),
                  ),
                ),

                // Category badges at the top
                Positioned(
                  top: 20,
                  left: 24,
                  right: 24,
                  child: Row(
                    children: [
                      ...widget.categories.asMap().entries.map((entry) {
                        final color =
                            _badgeColors[entry.key % _badgeColors.length];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              entry.value.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        );
                      }),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusColor(widget.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Title + tagline at the bottom
                Positioned(
                  bottom: 28,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (widget.tagline.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          widget.tagline,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.78),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Tap-to-view indicator
                if (widget.imageUrls.isNotEmpty)
                  Positioned(
                    top: 20,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fullscreen,
                              color: Colors.white70, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'View',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF10B981);
      case 'rejected':
        return const Color(0xFFEF4444);
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── LEFT COLUMN ───────────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── VISION & STRATEGY ────────────────────────────────────
        _buildSectionCard(
          title: 'Vision & Strategy',
          child: Text(
            widget.description,
            style: const TextStyle(
              fontSize: 15,
              color: _textSecondary,
              height: 1.7,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ─── TECH STACK ───────────────────────────────────────────
        if (widget.techStack.isNotEmpty)
          _buildSectionCard(
            title: 'Tech Stack',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.techStack.map((tech) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _accentPurpleLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _accentPurple.withOpacity(0.2)),
                  ),
                  child: Text(
                    tech,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _accentPurple,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        if (widget.techStack.isNotEmpty) const SizedBox(height: 20),

        // ─── TEAM INFO ────────────────────────────────────────────
        _buildSectionCard(
          title: 'Team',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.group_outlined, 'Members',
                  '${widget.totalMembers} members'),
              const SizedBox(height: 10),
              _buildInfoRow(
                  Icons.schedule_outlined, 'Duration', widget.duration),
              if (widget.usernames.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: widget.usernames.asMap().entries.map((entry) {
                    final index = entry.key;
                    final name = entry.value;
                    final id = (widget.memberIds != null && index < widget.memberIds!.length) 
                        ? widget.memberIds![index] 
                        : null;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: _accentPurple.withOpacity(0.12),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _accentPurple),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _textPrimary),
                              ),
                              if (id != null && id.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  id,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: _textSecondary),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ─── PROCESS & PROTOTYPES (IMAGE GALLERY) ─────────────────
        if (widget.imageUrls.isNotEmpty)
          _buildSectionCard(
            title: 'Process & Prototypes',
            child: _buildImageGrid(),
          ),

        if (widget.imageUrls.isNotEmpty) const SizedBox(height: 20),

        // ─── DEMO VIDEO ───────────────────────────────────────────
        if (widget.video.isNotEmpty) _buildVideoCard(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── RIGHT COLUMN ──────────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─── EXECUTION & ASSETS CARD ──────────────────────────────
        _buildWhiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EXECUTION & ASSETS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: _textSecondary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),

              // GitHub button
              _buildLinkButton(
                icon: Ionicons.logo_github,
                label: 'View on GitHub',
                onTap: () => _launchUrl(widget.link),
                isPrimary: false,
              ),
              const SizedBox(height: 10),

              // Live Demo button
              _buildLinkButton(
                icon: Icons.open_in_new_rounded,
                label: 'Live Demo',
                onTap: () => _launchUrl(widget.demoLink),
                isPrimary: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ─── DOCUMENTATION CARD ───────────────────────────────────
        _buildWhiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DOCUMENTATION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: _textSecondary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 14),
              if (widget.pdf.isNotEmpty)
                _buildDocumentRow(
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: const Color(0xFFEF4444),
                  label: 'Technical Specs',
                  subtitle: 'PDF Document',
                  onTap: () => _launchUrl(widget.pdf),
                ),
              if (widget.pdf.isNotEmpty && widget.ppt.isNotEmpty)
                const SizedBox(height: 12),
              if (widget.ppt.isNotEmpty)
                _buildDocumentRow(
                  icon: Icons.slideshow_rounded,
                  iconColor: _accentPurple,
                  label: 'Pitch Deck',
                  subtitle: 'PPT Presentation',
                  onTap: () => _launchUrl(widget.ppt),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ─── REVIEW CARD ──────────────────────────────────────────
        _buildWhiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REVIEW',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: _textSecondary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 14),

              // Approve button
              GestureDetector(
                onTap: widget.onApprove,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Approve',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Reject button
              GestureDetector(
                onTap: widget.onReject,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEF4444)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined,
                          color: Color(0xFFEF4444), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Reject',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 14,
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
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ─── REUSABLE WIDGETS ──────────────────────────────────────────────────────
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: const [
          BoxShadow(color: _cardShadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: const [
          BoxShadow(color: _cardShadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _accentPurple),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        decoration: BoxDecoration(
          color: isPrimary ? _accentPurple : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isPrimary ? null : Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18, color: isPrimary ? Colors.white : _textPrimary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : _textPrimary,
                ),
              ),
            ),
            Icon(
              isPrimary ? Icons.open_in_new_rounded : Icons.arrow_forward,
              size: 16,
              color: isPrimary ? Colors.white70 : _textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, size: 16, color: _textSecondary),
          ],
        ),
      ),
    );
  }

  // ─── IMAGE GRID ────────────────────────────────────────────────────────────
  Widget _buildImageGrid() {
    final images = widget.imageUrls;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: images.length == 1 ? 1 : (images.length == 2 ? 2 : 3),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openImageViewer(index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(Icons.broken_image,
                        color: Colors.grey, size: 32),
                  ),
                ),
                // Hover overlay hint
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 8,
                  right: 8,
                  child: Icon(Icons.zoom_in, color: Colors.white70, size: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── VIDEO CARD ────────────────────────────────────────────────────────────
  Widget _buildVideoCard() {
    return _buildSectionCard(
      title: 'Demonstration Video',
      child: GestureDetector(
        onTap: () => _launchUrl(widget.video),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _accentPurple.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _accentPurple.withOpacity(0.5), width: 2),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Watch Demo Video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Opens in browser',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
