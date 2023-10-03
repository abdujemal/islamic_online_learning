import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class Fav extends ConsumerStatefulWidget {
  const Fav({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavState();
}

class _FavState extends ConsumerState<Fav> {

  @override
  Widget build(BuildContext context) {
    return const Text("Fav");
  }
}