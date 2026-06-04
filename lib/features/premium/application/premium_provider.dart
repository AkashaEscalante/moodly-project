import 'package:flutter_riverpod/flutter_riverpod.dart';

final isPremiumProvider = StateProvider<bool>((ref) => false);

final chatMessageCountProvider = StateProvider<int>((ref) => 0);

const int kFreeChatLimit = 5;
