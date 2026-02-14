import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/payments/view/controller/provider.dart';
import 'package:islamic_online_learning/features/payments/view/widget/provider_detail_dialog.dart';

class PaymentVerificationPage extends ConsumerStatefulWidget {
  const PaymentVerificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentVerificationPageState();
}

class _PaymentVerificationPageState
    extends ConsumerState<PaymentVerificationPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(paymentNotifierProvider.notifier).getProviders(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _bankSelector(),
          ],
        ),
      ),
    );
  }

  Widget _bankSelector() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Bank",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ref.watch(paymentNotifierProvider).providerMap(
                  loading: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loaded: (_) => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1/1.1
                    ),
                    itemCount: _.providers.length,
                    itemBuilder: (context, index) => Card(
                      color: Theme.of(context).cardColor,
                      child: InkWell(
                        onTap: () {
                          //show dialog with provider details
                          showDialog(
                            context: context,
                            builder: (context) => ProviderDetailDialog(
                              provider: _.providers[index],
                            ),
                          );
                        },
                        child: Ink(
                          child: Column(children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: _.providers[index].logoUrl,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Text(
                                _.providers[index].name,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  empty: (_) => const Center(
                    child: Text("No payment providers available."),
                  ),
                  error: (_) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Error: ${_.providersError}"),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            ref
                                .read(paymentNotifierProvider.notifier)
                                .getProviders(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
          )
        ],
      ),
    );
  }
}
