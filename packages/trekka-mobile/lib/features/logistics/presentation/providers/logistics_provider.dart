import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_viewmodel.dart';

/// Provider for logistics journey state
final logisticsViewModelProvider =
    NotifierProvider<LogisticsViewModel, LogisticsState>(
      LogisticsViewModel.new,
    );
