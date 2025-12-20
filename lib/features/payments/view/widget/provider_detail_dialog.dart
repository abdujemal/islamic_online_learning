import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/payments/models/payment_provider.dart';
import 'package:islamic_online_learning/features/payments/view/controller/provider.dart';

class ProviderDetailDialog extends ConsumerStatefulWidget {
  final PaymentProvider provider;
  const ProviderDetailDialog({super.key, required this.provider});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProviderDetailDialogState();
}

class _ProviderDetailDialogState extends ConsumerState<ProviderDetailDialog> {
  final TextEditingController _tnxidController = TextEditingController();
  final FocusNode _tnxidFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentNotifierProvider);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.provider.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  // borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Text("Note",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 5),
                    const Text(
                      "Please make payment using the details below and provide the transaction ID.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text("Account Number: ${widget.provider.accountNumber}"),
              const SizedBox(height: 5),
              Text("Account Name: ${widget.provider.accountName}"),
              const SizedBox(height: 5),
              Text(
                "Total amount: ${state.tiers[state.selectedTier!].currency} ${state.tiers[state.selectedTier!].price}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: CachedNetworkImage(
                  imageUrl: widget.provider.guideUrl,
                  height: 200,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _tnxidController,
                  focusNode: _tnxidFocusNode,
                  decoration: const InputDecoration(
                    labelText: "Transaction ID (Ref No)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "ይህን ቦታ ይሙሉ!" : null,
                ),
              ),
              const SizedBox(height: 15),
              if (state.submitting) ...[
                const Center(child: CircularProgressIndicator()),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(paymentNotifierProvider.notifier)
                            .submitPayment(_tnxidController.text,
                                widget.provider.code, context);
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      side: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
