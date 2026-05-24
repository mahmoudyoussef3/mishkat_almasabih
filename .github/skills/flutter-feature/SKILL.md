# Flutter Feature Skill (Clean Architecture)

This skill is used for:

- Creating new Flutter features
- Understanding architecture structure
- Scaffolding layers (presentation / domain / data)
- Explaining data flow
- Designing Cubit/UseCase/Repository structure
- API integration patterns
- Dependency Injection setup

---

## When to use this skill

Use this skill when the user asks:

- "create feature"
- "new feature"
- "scaffold feature"
- "how does this architecture work"
- "how to structure X"
- "add endpoint / cubit / use case"
- "clean architecture setup"

---

# Architecture Overview

## Layer Flow

```
Presentation → Domain ← Data
```

Domain is independent.

Presentation and Data depend on Domain only.

---

## Full Flow

```
Screen → Cubit → UseCase → Repository Interface → Repository Impl → DataSource → API
```

```
UI → State → Entity → Entity → Model → JSON
```

---

# Feature Structure

```
lib/features/{feature_name}/
├── data/
│   ├── datasources/
│   ├── models/
│   │   ├── responses/
│   │   ├── requests/
│   │   └── shared/
│   ├── repos/
│
├── domain/
│   ├── entities/
│   ├── repos/
│   ├── usecases/
│
└── presentation/
    ├── bloc/
    ├── screens/
    └── widgets/
```

Shared logic → `core/`

---

# Layer Rules

## Domain

- Pure Dart only
- No Flutter imports
- No models or JSON

---

## Data

- Handles API / Firebase / local storage
- Maps models → entities
- Catches exceptions

---

## Presentation

- UI only
- Calls Cubit
- No business logic

---

# Code Patterns

## Entity

```dart
class Entity {
  final String id;
  final String name;

  const Entity({
    required this.id,
    required this.name,
  });
}
```

---

## Model

```dart
class Model extends Entity {
  const Model({
    required super.id,
    required super.name,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
```

---

## DataSource

```dart
class DataSource {
  final Dio dio;

  DataSource(this.dio);

  Future<ResponseModel> fetchData() async {
    final res = await dio.get('/endpoint');
    return ResponseModel.fromJson(res.data);
  }
}
```

---

## Repository Interface

```dart
abstract class Repository {
  Future<List<Entity>> getData();
}
```

---

## Repository Implementation

```dart
class RepositoryImpl implements Repository {
  final DataSource dataSource;

  RepositoryImpl(this.dataSource);

  @override
  Future<List<Entity>> getData() async {
    try {
      final res = await dataSource.fetchData();
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
```

---

## UseCase

```dart
class GetDataUseCase {
  final Repository repository;

  GetDataUseCase(this.repository);

  Future<List<Entity>> call() {
    return repository.getData();
  }
}
```

---

## Cubit

```dart
class FeatureCubit extends Cubit<FeatureState> {
  final GetDataUseCase useCase;

  FeatureCubit(this.useCase) : super(Initial());

  Future<void> load() async {
    emit(Loading());

    try {
      final data = await useCase();
      emit(Success(data));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
```

---

## State

```dart
sealed class FeatureState {}

class Initial extends FeatureState {}
class Loading extends FeatureState {}
class Success extends FeatureState {
  final List<Entity> data;
  Success(this.data);
}
class Error extends FeatureState {
  final String message;
  Error(this.message);
}
```

---

# Dependency Injection (GetIt)

```dart
getIt.registerLazySingleton(() => DataSource(getIt<Dio>()));

getIt.registerLazySingleton<Repository>(
  () => RepositoryImpl(getIt<DataSource>()),
);

getIt.registerLazySingleton(() => GetDataUseCase(getIt<Repository>()));

getIt.registerFactory(() => FeatureCubit(getIt<GetDataUseCase>()));
```

---

# Rules

## Architecture

- Cubit → UseCase only
- UseCase → Repository only
- Repository → DataSource only

---

## Safety

- Handle errors at repository boundary
- No business logic in UI
- No direct API calls in Cubit

---

## Quality

- Small files
- Clear naming
- No duplication
- Single responsibility

---

# Scaffolding Checklist

- [ ] Feature structure created
- [ ] Entity defined
- [ ] Model created
- [ ] DataSource implemented
- [ ] Repository split (interface + impl)
- [ ] UseCase created
- [ ] Cubit + State added
- [ ] DI registered
- [ ] Screen connected

---

# Output Behavior

When used, the assistant should:

1. Propose folder structure
2. Generate layer-by-layer code
3. Ensure clean architecture compliance
4. Avoid mixing responsibilities