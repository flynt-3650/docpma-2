import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../presentation/providers/network_providers.dart';

class NetworkDemoScreen extends ConsumerStatefulWidget {
  const NetworkDemoScreen({super.key});

  @override
  ConsumerState<NetworkDemoScreen> createState() => _NetworkDemoScreenState();
}

class _NetworkDemoScreenState extends ConsumerState<NetworkDemoScreen> {
  final _countryController = TextEditingController(text: 'russia');

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(networkDemoNotifierProvider);
    final notifier = ref.read(networkDemoNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Сетевой слой (ПР13)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Демонстрация 2 API + 5 методов HTTP',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Последнее действие: ${state.lastAction}'),
                  const SizedBox(height: 8),
                  if (state.isLoading) const LinearProgressIndicator(),
                  if (state.error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withAlpha(51)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _Section(
            title: 'API #1: JSONPlaceholder (posts)',
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: state.isLoading ? null : notifier.getPosts,
                      child: const Text('GET /posts'),
                    ),
                    ElevatedButton(
                      onPressed: state.isLoading ? null : notifier.createPost,
                      child: const Text('POST /posts'),
                    ),
                    ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : notifier.updatePostPut,
                      child: const Text('PUT /posts/1'),
                    ),
                    ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : notifier.patchPostTitle,
                      child: const Text('PATCH /posts/1'),
                    ),
                    OutlinedButton(
                      onPressed: state.isLoading ? null : notifier.deletePost,
                      child: const Text('DELETE /posts/1'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (state.lastPost != null)
                  Card(
                    child: ListTile(
                      title: Text(state.lastPost!.title),
                      subtitle: Text(state.lastPost!.body),
                      trailing: Text('id: ${state.lastPost!.id ?? '-'}'),
                    ),
                  ),
                if (state.posts.isNotEmpty)
                  Card(
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text('Посты (первые 10)'),
                          subtitle: Text('GET /posts?userId=1'),
                        ),
                        const Divider(height: 1),
                        for (final post in state.posts.take(10))
                          ListTile(
                            dense: true,
                            title: Text(
                              post.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              post.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _Section(
            title: 'API #2: REST Countries',
            child: Column(
              children: [
                TextField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Страна (латиницей)',
                    hintText: 'например: russia, france, japan',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    final name = value.trim();
                    if (name.isEmpty) return;
                    notifier.getCountry(name);
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          final name = _countryController.text.trim();
                          if (name.isEmpty) return;
                          notifier.getCountry(name);
                        },
                  child: const Text('GET /name/{name}'),
                ),
                const SizedBox(height: 12),
                if (state.country != null)
                  Card(
                    child: ListTile(
                      leading: state.country!.flagPng == null
                          ? const Icon(Icons.flag_outlined)
                          : Image.network(
                              state.country!.flagPng!,
                              width: 48,
                              height: 32,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.flag_outlined),
                            ),
                      title: Text(state.country!.name),
                      subtitle: Text(
                        'Столица: ${state.country!.capital ?? '—'}',
                      ),
                      trailing: Text(state.country!.cca2 ?? ''),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Подсказка: логи запросов/ответов смотрите в консоли (LoggingInterceptor).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
