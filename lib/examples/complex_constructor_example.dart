class DatabaseConfig {
  final String host;
  final int port;
  final String username;
  final String password;

  DatabaseConfig(this.host, this.port, this.username, this.password);
}

class Logger {
  final String logLevel;
  final String outputPath;

  Logger(this.logLevel, this.outputPath);
}

class CacheService {
  final int maxSize;
  final Duration ttl;

  CacheService(this.maxSize, this.ttl);
}

class UserService {
  final DatabaseConfig dbConfig;
  final Logger logger;
  final CacheService cache;
  final String apiKey;
  final int timeout;
  final bool enableRetry;
  final String environment;

  UserService({
    required this.dbConfig,
    required this.logger,
    required this.cache,
    required this.apiKey,
    required this.timeout,
    required this.enableRetry,
    required this.environment,
  });

  void fetchUser(String userId) {
    logger.logLevel;
  }
}

// Пример использования - создание объекта становится громоздким
void example() {
  // Сначала нужно создать все зависимости
  final dbConfig = DatabaseConfig('localhost', 5432, 'admin', 'password123');
  final logger = Logger('INFO', '/var/log/app.log');
  final cache = CacheService(1000, Duration(minutes: 30));

  // Затем передать их все в конструктор
  final userService = UserService(
    dbConfig: dbConfig,
    logger: logger,
    cache: cache,
    apiKey: 'sk_live_abc123xyz',
    timeout: 5000,
    enableRetry: true,
    environment: 'production',
  );

  userService.fetchUser('user_123');
}
