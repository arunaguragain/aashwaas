import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/features/wishlist/presentation/pages/add_wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/wishlist_card.dart';
import 'package:aashwaas/features/wishlist/presentation/view_model/wishlist_viewmodel.dart';
import 'package:aashwaas/features/donation/presentation/pages/add_donation_page.dart';
import 'package:aashwaas/features/wishlist/presentation/state/wishlist_state.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import '../widgets/wishlist_summary.dart';
import 'package:aashwaas/features/wishlist/presentation/pages/edit_wishlist_dialog.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wishlistViewModelProvider.notifier).getAllWishlists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(wishlistViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('My Wishlist'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () {
                AppRoutes.push(context, const AddWishlistPage());
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.status == WishlistViewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WishlistViewStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            );
          }

          final items = state.wishlists;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return WishlistSummary(
                  total: state.totalWishlistCount,
                  active: state.activeWishlists.length,
                  fulfilled: state.fulfilledWishlists.length,
                );
              }

              final w = items[index - 1];

              return WishlistCard(
                title: w.title,
                category: w.category,
                planned: w.plannedDate,
                notes: w.notes ?? '',
                onEdit: () async {
                  showDialog(
                    context: context,
                    builder: (_) => EditWishlistDialog(
                      initialTitle: w.title,
                      initialCategory: w.category,
                      initialPlanned: w.plannedDate,
                      initialNotes: w.notes ?? '',
                      onEdit: (title, category, planned, notes) {
                        ref
                            .read(wishlistViewModelProvider.notifier)
                            .updateWishlist(
                              wishlistId: w.wishlistId,
                              title: title,
                              category: category,
                              plannedDate: planned,
                              notes: notes,
                              donorId: w.donorId,
                            );
                      },
                    ),
                  );
                },
                onDelete: () {
                  if (w.wishlistId != null) {
                    ref
                        .read(wishlistViewModelProvider.notifier)
                        .deleteWishlist(w.wishlistId!);
                  }
                },
                onDonate: () {
                  AppRoutes.push(
                    context,
                    AddDonationScreen(
                      initialItemName: w.title,
                      initialCategory: w.category,
                      initialDescription: w.notes,
                      initialQuantity: '1',
                      initialCondition: 'Good',
                      initialPickupLocation: '',
                      onDonationCreated: () {
                        if (w.wishlistId != null) {
                          ref
                              .read(wishlistViewModelProvider.notifier)
                              .updateWishlist(
                                wishlistId: w.wishlistId,
                                title: w.title,
                                category: w.category,
                                plannedDate: w.plannedDate,
                                notes: w.notes,
                                donorId: w.donorId,
                                status: 'fulfilled',
                              );
                        }
                      },
                    ),
                  );
                },
                showDonate: w.status == WishlistStatus.active,
              );
            },
          );
        },
      ),
    );
  }
}
