import 'dart:math';

import 'package:attendee_app/main.dart';
import 'package:attendee_app/network_request.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DigitalBadgeScreen extends StatelessWidget {
  const DigitalBadgeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Digital Badge'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Show this pass at venue checkpoints for quick verification.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.navyMid,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.navySurface),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.goldDim,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.badge_outlined,
                            color: AppColors.gold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "${Hive.box('LoginDetails').get("Profile_details")["name"] ?? ""}",
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const DigitalPassApiWidget(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalPassApiWidget extends StatefulWidget {
  const DigitalPassApiWidget({
    super.key,
  });

  @override
  State<DigitalPassApiWidget> createState() => _DigitalPassApiWidgetState();
}

class _DigitalPassApiWidgetState extends State<DigitalPassApiWidget> {
  bool _isLoading = true;
  String? _error;
  String? _qrPayload;

  @override
  void initState() {
    super.initState();
    _fetchPassFromApi();
  }

  Future<void> _fetchPassFromApi() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dynamic response = await Network_request().get_user_qr();
      final String payload = (response ?? '').toString().trim();
      if (payload.isEmpty) {
        throw Exception('Empty QR response');
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _qrPayload = payload;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Failed to fetch pass. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: _buildQrContent(),
        ),
        const SizedBox(height: 12),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _error!,
              style: const TextStyle(color: AppColors.red, fontSize: 12),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _isLoading ? null : _fetchPassFromApi,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Refresh QR'),
          ),
        ),
      ],
    );
  }

  Widget _buildQrContent() {
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.navyMid,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
        ),
      );
    }

    if (_qrPayload == null) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.navyMid,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          'QR unavailable',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    final String payload = _qrPayload!;
    if (payload.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          payload,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _QrPlaceholder(data: payload),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.navyMid,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Invalid QR URL',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    const int size = 29;
    final Random random = Random(data.hashCode);
    final List<bool> cells =
        List<bool>.generate(size * size, (_) => random.nextBool());

    bool isFinder(int row, int col, int top, int left) {
      final int r = row - top;
      final int c = col - left;
      if (r < 0 || c < 0 || r > 6 || c > 6) {
        return false;
      }
      final bool outer = r == 0 || r == 6 || c == 0 || c == 6;
      final bool inner = r >= 2 && r <= 4 && c >= 2 && c <= 4;
      return outer || inner;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cellSize = constraints.maxWidth / size;
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth,
          child: Stack(
            children: [
              for (int row = 0; row < size; row++)
                for (int col = 0; col < size; col++)
                  Positioned(
                    left: col * cellSize,
                    top: row * cellSize,
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      color: isFinder(row, col, 0, 0) ||
                              isFinder(row, col, 0, size - 7) ||
                              isFinder(row, col, size - 7, 0)
                          ? Colors.black
                          : (cells[row * size + col]
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
