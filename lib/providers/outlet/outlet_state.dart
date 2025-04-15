import 'package:equatable/equatable.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/models/outlet_config.dart';

class OutletState extends Equatable {
  const OutletState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class OutletNotSelected extends OutletState {}

class LoadItemStatus {
  final String category;
  final bool isLoaded;

  const LoadItemStatus({
    required this.category,
    required this.isLoaded,
  });
}

class OutletLoading extends OutletState {
  final String? message;
  final bool? config;
  final bool? categories;
  final bool? promotions;
  final List<LoadItemStatus>? items;

  const OutletLoading(
      {this.message,
      this.categories,
      this.promotions,
      this.items,
      this.config});

  @override
  List<Object> get props => [
        message ?? '',
        config ?? false,
        categories ?? false,
        promotions ?? false,
        items ?? [],
      ];

  @override
  bool get stringify => true;

  OutletLoading copyWith({
    String? message,
    bool? config,
    bool? categories,
    bool? promotions,
    List<LoadItemStatus>? items,
  }) {
    return OutletLoading(
      message: message ?? this.message,
      config: config ?? this.config,
      categories: categories ?? this.categories,
      promotions: promotions ?? this.promotions,
      items: items ?? this.items,
    );
  }
}

class OutletSelected extends OutletState {
  final Outlet outlet;
  final OutletConfig config;
  final bool? isSyncing;

  const OutletSelected(
      {required this.outlet, required this.config, this.isSyncing});

  @override
  List<Object> get props => [outlet, config];

  @override
  bool get stringify => true;
}

class OutletFailure extends OutletState {
  final String message;

  const OutletFailure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
