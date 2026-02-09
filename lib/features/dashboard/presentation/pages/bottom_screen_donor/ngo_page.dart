import 'package:aashwaas/features/ngo/presentation/state/ngo_state.dart';
import 'package:aashwaas/features/ngo/presentation/view_model/ngo_viewmodel.dart';
import 'package:aashwaas/features/ngo/presentation/widgets/ngo_card.dart';
import 'package:aashwaas/features/ngo/presentation/widgets/ngo_empty_results.dart';
import 'package:aashwaas/features/ngo/presentation/widgets/ngo_search_bar.dart';
import 'package:aashwaas/features/ngo/domain/entities/ngo_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NgoScreen extends ConsumerStatefulWidget {
  const NgoScreen({super.key});

  @override
  ConsumerState<NgoScreen> createState() => _NgoScreenState();
}

class _NgoScreenState extends ConsumerState<NgoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNgos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNgos() async {
    await ref.read(ngoViewModelProvider.notifier).getAllNgos();
  }

  @override
  Widget build(BuildContext context) {
    final ngoState = ref.watch(ngoViewModelProvider);
    final theme = Theme.of(context);

    Widget content;

    if (ngoState.status == NgoStatus.loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (ngoState.status == NgoStatus.error) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ngoState.errorMessage ?? 'Error loading NGOs'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadNgos, child: const Text('Retry')),
          ],
        ),
      );
    } else if (ngoState.ngos.isEmpty) {
      content = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apartment, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No NGOs available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Please check back later',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    } else {
      final filtered = _filterNgos(ngoState.ngos, _searchQuery);
      content = RefreshIndicator(
        onRefresh: _loadNgos,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            NgoSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              const NgoEmptyResults()
            else
              ...filtered.map(
                (ngo) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NgoCard(ngo: ngo),
                ),
              ),
          ],
        ),
      );
    }
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(child: content),
    );
  }

  List<NgoEntity> _filterNgos(List<NgoEntity> ngos, String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return ngos;
    }
    return ngos.where((ngo) {
      final name = ngo.name.toLowerCase();
      final address = ngo.address.toLowerCase();
      final contact = ngo.contactPerson.toLowerCase();
      final email = ngo.email.toLowerCase();
      final phone = ngo.phone.toLowerCase();
      final areas = ngo.focusAreas.join(' ').toLowerCase();
      return name.contains(trimmed) ||
          address.contains(trimmed) ||
          contact.contains(trimmed) ||
          email.contains(trimmed) ||
          phone.contains(trimmed) ||
          areas.contains(trimmed);
    }).toList();
  }
}
