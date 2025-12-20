import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/payments/view/controller/provider.dart';
import 'package:islamic_online_learning/features/payments/view/widget/payment_card.dart';
import 'package:islamic_online_learning/features/payments/view/widget/payment_card_shimmer.dart';

import '../../../main/presentation/widgets/the_end.dart';

class PaymentsPage extends ConsumerStatefulWidget {
  const PaymentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends ConsumerState<PaymentsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(paymentNotifierProvider.notifier).getPayments(context);
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          loadMore();
        }
      });
    });
  }

  Future loadMore() async {
    ref
        .read(paymentNotifierProvider.notifier)
        .getPayments(context, loadMore: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       ref.read(paymentNotifierProvider.notifier).getPayments(context);
        //     },
        //     icon: Icon(
        //       Icons.refresh,
        //     ),
        //   )
        // ],
      ),
      body: SafeArea(
        child: ref.watch(paymentNotifierProvider).paymentMap(
              loading: (_) => ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return PaymentCardShimmer();
                },
              ),
              loaded: (_) => RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(paymentNotifierProvider.notifier)
                      .getPayments(context);
                },
                child: ListView.builder(
                  itemCount: _.payments.length + 1,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index == _.payments.length) {
                      return _.paymentsIsLoadingMore
                          ? PaymentCardShimmer()
                          : _.paymentsHasNoMore
                              ? TheEnd()
                              : SizedBox();
                    }
                    return PaymentCard(
                      payment: _.payments[index],
                    );
                  },
                ),
              ),
              empty: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No more data"),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(paymentNotifierProvider.notifier)
                            .getPayments(context);
                      },
                      icon: Icon(
                        Icons.refresh,
                      ),
                    )
                  ],
                ),
              ),
              error: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _.paymentsError ?? "_",
                      style: TextStyle(color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(paymentNotifierProvider.notifier)
                            .getPayments(context);
                      },
                      icon: Icon(
                        Icons.refresh,
                      ),
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
