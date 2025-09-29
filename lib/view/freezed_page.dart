import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controller/user/user_controller.dart';

class FreezedPage extends ConsumerStatefulWidget {
  const FreezedPage({super.key});

  @override
  ConsumerState<FreezedPage> createState() => _FreezedPageState();
}

class _FreezedPageState extends ConsumerState<FreezedPage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    // 練習問題：Freezed 4 - フォームの初期値に現在の情報を挿入
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ローカルストレージからユーザー情報を読み込む
      await ref.read(userControllerProvider.notifier).loadUserFromStorage();

      final user = ref.read(userControllerProvider);
      setState(() {
        _nameController.text = user.name;
        _selectedBirthDate = user.birthDate;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 練習問題：Freezed 2 - Userを保持するProviderを作成し、画面のユーザー情報部分に表示
    final user = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー情報管理'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // 画面上部：ユーザー情報表示
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ユーザー情報',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(label: '氏名', value: user.name, icon: Icons.person),
                const SizedBox(height: 12),
                _InfoRow(
                  label: '生年月日',
                  value: DateFormat('yyyy年MM月dd日').format(user.birthDate),
                  icon: Icons.cake,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: '更新日',
                  value: DateFormat(
                    'yyyy年MM月dd日 HH:mm',
                  ).format(user.lastUpdated),
                  icon: Icons.update,
                ),
              ],
            ),
          ),

          // 画面下部：入力フォーム
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ユーザー情報を更新',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 氏名入力
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '氏名',
                    hintText: '氏名を入力してください',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                // 生年月日選択
                InkWell(
                  onTap: _selectBirthDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cake, color: Colors.grey),
                        const SizedBox(width: 12),
                        Text(
                          _selectedBirthDate != null
                              ? DateFormat(
                                'yyyy年MM月dd日',
                              ).format(_selectedBirthDate!)
                              : '生年月日を選択してください',
                          style: TextStyle(
                            color:
                                _selectedBirthDate != null
                                    ? Colors.black
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 更新ボタン
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateUser,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      '更新',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  void _updateUser() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('氏名を入力してください')));
      return;
    }

    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('生年月日を選択してください')));
      return;
    }

    // 練習問題：Freezed 3 - 更新ボタンの機能を実装
    ref
        .read(userControllerProvider.notifier)
        .updateUser(name: name, birthDate: _selectedBirthDate!);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('ユーザー情報を更新しました')));
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade600),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
