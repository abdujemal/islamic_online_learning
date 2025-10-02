import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/auth/view/controller/register_state.dart';
import 'package:islamic_online_learning/features/auth/view/widget/add_new_group.dart';
import 'package:islamic_online_learning/features/auth/view/widget/group_card.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final String otpId;
  const RegisterPage({super.key, required this.otpId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _learningController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();

  final List<String> _previousLearnings = [];

  String? _gender;
  bool showAdd = false;
  Map<String, Object>? userData;

  void _addLearning(String value) {
    if (value.trim().isEmpty) return;
    if (!_previousLearnings.contains(value.trim())) {
      setState(() {
        _previousLearnings.add(value.trim());
      });
    }
    _learningController.clear();
  }

  void _removeLearning(String learning) {
    setState(() {
      _previousLearnings.remove(learning);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("ምዝገባ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (userData == null) ...[
                Expanded(
                  child: ListView(
                    children: [
                      // Name
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        decoration: const InputDecoration(
                          labelText: "ስም",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "ስምዎን ያስገቡ" : null,
                      ),
                      const SizedBox(height: 16),
                      // Age
                      TextFormField(
                        controller: _ageController,
                        focusNode: _ageFocusNode,
                        decoration: const InputDecoration(
                          labelText: "እድሜ",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "እድሜዎን ያስገቡ";
                          }
                          final age = int.tryParse(value);
                          if (age == null || age <= 0) {
                            return "ትክክለኛ እድሜዎን ያስገቡ";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Gender
                      DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: const InputDecoration(
                          labelText: "ፆታ",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("ወንድ")),
                          DropdownMenuItem(value: "Female", child: Text("ሴት")),
                        ],
                        onChanged: (value) => setState(() => _gender = value),
                        validator: (value) => value == null ? "ፆታ ይምረጡ" : null,
                      ),
                      const SizedBox(height: 16),

                      // Previous Learnings (Tags)
                      const Text(
                        "ከዚህ በፊት የቀሩት ኪታቦች",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _previousLearnings.map((learning) {
                          return Chip(
                            label: Text(learning),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () => _removeLearning(learning),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          TextField(
                            controller: _learningController,
                            onChanged: (v) {
                              setState(() {
                                if (v.isNotEmpty) {
                                  showAdd = true;
                                } else {
                                  showAdd = false;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "የኪታቡ ስም",
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: _addLearning,
                          ),
                          _learningController.text.isNotEmpty
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _addLearning(_learningController.text);
                                      },
                                      child: Chip(
                                        label: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.add),
                                            Text("አክል"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Submit
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_gender == null) {
                              toast("ፆታ ይምረጡ", ToastType.error, context);
                              return;
                            }
                            final data = {
                              "name": _nameController.text.trim(),
                              "age": int.tryParse(_ageController.text) ?? 0,
                              "gender": _gender!,
                              "previousLearnings": _previousLearnings,
                            };
                            setState(() {
                              userData = data;
                            });
                            // ref.read(sharedPrefProvider).then((pref) {
                            //   pref.remove(PrefConsts.otpId);
                            //   pref.remove(PrefConsts.token);
                            // });
                            ref
                                .read(registerNotifierProvider.notifier)
                                .getGroups(
                                  int.tryParse(_ageController.text) ?? 0,
                                  _gender!,
                                  context,
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: const Text("ቀጣይ"),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          userData = null;
                        });
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Text(
                        "ቡድን ይምረጡ",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        ref.read(registerNotifierProvider.notifier).getGroups(
                              int.tryParse(_ageController.text) ?? 0,
                              _gender!,
                              context,
                            );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "- ከታች ከተዘረዘሩት ቡድኖች መካከል ለእርሶ ተስማሚ የሆነ ሙጣለዓ/መወያያ ቀን እና ሙጣለዓ/መወያያ ሰዓት ያለውን ቡድን ይቀላቀሉ።"
                      "\n- አንድ ቡድን 5 ሰው ሲሞላ በቀጣዩ ቀን ቂርአት ይጀመራል። "
                      "\n- ለእርስዎ የሚስማማ ቡድን ካጡ አድስ ቡድን መፍጠር ይችላሉ።"),
                ),
                if (state.isLoadingGroups)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (!state.isLoadingGroups && state.groups.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.groups.length + 1,
                      itemBuilder: (context, index) {
                        if (index < state.groups.length) {
                          return GroupCard(
                            group: state.groups[index],
                            onJoin: () async {
                              ref
                                  .read(registerNotifierProvider.notifier)
                                  .register(
                                    int.parse(_ageController.text.trim()),
                                    _nameController.text.trim(),
                                    _gender!,
                                    state.groups[index].discussionTime,
                                    state.groups[index].discussionDay,
                                    state.groups[index].id,
                                    _previousLearnings,
                                    context,
                                    ref,
                                  );
                            },
                          );
                        }
                        return Container(
                          padding: EdgeInsets.all(7),
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          decoration: state.isAddingNewGroup
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Theme.of(context)
                                            .chipTheme
                                            .backgroundColor ??
                                        Colors.grey,
                                  ),
                                )
                              : null,
                          child: Column(
                            spacing: 15,
                            children: [
                              if (!state.isAddingNewGroup)
                                ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(registerNotifierProvider.notifier)
                                        .toggleAddingGroup();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    // minimumSize: const Size(80, 56),
                                  ),
                                  child: const Text("አድስ ቡድን ፍጠር"),
                                ),
                              if (state.isAddingNewGroup)
                                AddNewGroup(
                                  userData: userData,
                                )
                            ],
                          ),
                        );
                      },
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
