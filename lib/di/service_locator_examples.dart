import 'package:get_it/get_it.dart';
import '../features/tasks/models/task.dart';

final locatorExamples = GetIt.instance;

class TasksStoreExample {
  final List<Task> tasks = [];
}

class SettingsStoreExample {
  String theme = 'light';
}

class TaskValidatorExample {
  bool validate(String title) {
    return title.isNotEmpty;
  }
}

void setupLocatorWithNamedInstances() {
  locatorExamples.registerSingleton<TasksStoreExample>(
    TasksStoreExample(),
    instanceName: 'mainStore',
  );

  locatorExamples.registerSingleton<TasksStoreExample>(
    TasksStoreExample(),
    instanceName: 'archiveStore',
  );
}

void setupLocatorWithOverwrite() {
  if (locatorExamples.isRegistered<TasksStoreExample>()) {
    locatorExamples.unregister<TasksStoreExample>();
  }
  locatorExamples.registerSingleton<TasksStoreExample>(TasksStoreExample());
}

void setupLocatorLazy() {
  locatorExamples.registerLazySingleton<SettingsStoreExample>(
    () => SettingsStoreExample(),
  );
}

void setupLocatorFactory() {
  locatorExamples.registerFactory<TaskValidatorExample>(
    () => TaskValidatorExample(),
  );
}
