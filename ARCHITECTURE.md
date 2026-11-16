# Fitza — Architecture & Rules

Single source of truth for how this project is structured and how to add anything to it.
**Read this file before writing any code. If this file and the code disagree, fix the code.**

---

## Stack

| Concern           | Choice                            | Why                                          |
| ----------------- | --------------------------------- | -------------------------------------------- |
| State management  | **Riverpod** (`flutter_riverpod`) | Compile-safe DI, testable, no context bugs   |
| Navigation        | **GoRouter**                      | Declarative, deep links, auth redirects      |
| Backend           | **Supabase** (`supabase_flutter`) | Auth, DB, Storage, Realtime                  |
| Architecture      | **Clean Architecture** (3 layers) | Scalable, testable, feature-isolated         |

---

## Project Layout

```
lib/
├── main.dart                     # Entry point: bootstrap + ProviderScope
├── app.dart                      # MaterialApp.router + theme wiring
├── core/                         # Cross-feature infrastructure
│   ├── config/                   # AppConfig (dart-define env vars)
│   ├── constants/                # App-wide constants
│   ├── di/                       # core_providers.dart (supabaseClientProvider)
│   ├── error/                    # exceptions.dart, failures.dart
│   ├── router/                   # app_router.dart, route_names.dart
│   ├── theme/                    # app_theme.dart, spacing, context extensions
│   ├── utils/                    # result.dart (Result<T> type)
│   └── widgets/                  # Shared, feature-agnostic widgets
└── features/                     # One folder per feature — NEVER shared code here
    └── <feature>/                # e.g. auth, home, workout, profile
        ├── data/                 # Talks to the outside world
        │   ├── datasources/      # Remote/local API calls (throws AppExceptions)
        │   ├── models/           # JSON (de)serialization (xxx_model.dart)
        │   └── repositories/     # Implements domain repository (returns Results)
        ├── domain/               # Pure Dart. No Flutter, no Supabase imports
        │   ├── entities/         # Business objects (xxx_entity.dart)
        │   ├── repositories/     # Abstract contracts (xxx_repository.dart)
        │   └── usecases/         # One class per action (xxx_usecase.dart)
        └── presentation/         # UI + state
            ├── providers/        # Controllers & providers (xxx_providers.dart)
            ├── screens/          # Full-page widgets (xxx_screen.dart)
            └── widgets/          # Feature-local reusable widgets
```

---

## The Dependency Rule

```
presentation  →  domain  ←  data
```

- `domain` imports **nothing** from `data` or `presentation`, and has **zero
  Flutter/Supabase imports**.
- `data` may import `domain` (to implement its contracts).
- `presentation` may import `domain` (use cases + entities) — **never** `data`.
- `core` may be imported by anyone; `core` never imports `features`.

---

## How to create a SCREEN (the full recipe)

Example: adding a **Profile** feature.

### 1. Domain — entity

`lib/features/profile/domain/entities/profile_entity.dart`

```dart
class ProfileEntity {
  const ProfileEntity({required this.id, required this.fullName});
  final String id;
  final String fullName;
}
```

### 2. Domain — repository contract

`lib/features/profile/domain/repositories/profile_repository.dart`

```dart
import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/profile/domain/entities/profile_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<ProfileEntity>> getProfile({required String userId});
}
```

### 3. Domain — use case

`lib/features/profile/domain/usecases/get_profile_usecase.dart`

```dart
class GetProfileUseCase {
  const GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Future<Result<ProfileEntity>> call({required String userId}) =>
      _repository.getProfile(userId: userId);
}
```

### 4. Data — model

`lib/features/profile/data/models/profile_model.dart`

```dart
class ProfileModel {
  const ProfileModel({required this.id, required this.fullName});
  final String id;
  final String fullName;

  factory ProfileModel.fromMap(Map<String, dynamic> map) =>
      ProfileModel(id: map['id'] as String, fullName: map['full_name'] as String);

  ProfileEntity toEntity() => ProfileEntity(id: id, fullName: fullName);
}
```

### 5. Data — data source

`lib/features/profile/data/datasources/profile_remote_data_source.dart`

```dart
class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._client);
  final SupabaseClient _client;

  Future<ProfileModel> getProfile({required String userId}) async {
    try {
      final row = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromMap(row);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}
```

**Rule:** data sources **throw** `AppException`s (see `core/error/exceptions.dart`).
They never return `Result` or `Failure`.

### 6. Data — repository implementation

```dart
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);
  final ProfileRemoteDataSource _remote;

  @override
  Future<Result<ProfileEntity>> getProfile({required String userId}) async {
    try {
      final model = await _remote.getProfile(userId: userId);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }
}
```

**Rule:** repositories are the **only** place where exceptions become `Failure`s.

### 7. Presentation — providers

`lib/features/profile/presentation/providers/profile_providers.dart`

```dart
final profileRepositoryProvider = Provider<ProfileRepositoryImpl>(
  (ref) => ProfileRepositoryImpl(ProfileRemoteDataSource(ref.watch(supabaseClientProvider))),
);
final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
  (ref) => GetProfileUseCase(ref.watch(profileRepositoryProvider)),
);

class ProfileController extends AsyncNotifier<ProfileEntity?> {
  @override
  Future<ProfileEntity?> build() async {
    final result = await ref.watch(getProfileUseCaseProvider)
        .call(userId: ref.watch(authStateProvider).value!.id);
    return result.dataOrNull;
  }
}
final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, ProfileEntity?>(ProfileController.new);
```

**Rules:**
- Expose **one `xxx_providers.dart` per feature** — it is the DI composition root.
- UI reads state with `ref.watch(xxxProvider)` and triggers actions with
  `ref.read(xxxProvider.notifier)`.
- Prefer `AsyncNotifier` for mutable async state, `FutureProvider` for
  read-only async data, `Notifier` for sync mutable state.

### 8. Presentation — screen

`lib/features/profile/presentation/screens/profile_screen.dart`

```dart
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (p) => p == null
            ? const Text('No profile')
            : Text(p.fullName),
      ),
    );
  }
}
```

**Rules:**
- File/widget names end in `Screen` (full page) or descriptive widget name.
- Screens are `ConsumerWidget` (or `ConsumerStatefulWidget` when a controller
  is needed). `StatefulWidget` without Riverpod is a smell.
- All async UI states (`loading` / `error` / `data`) must be handled via
  `AsyncValue.when`.
- Never hard-code colors/spacing — use `context.colorScheme`, `context.textTheme`,
  and `AppSpacing`.

### 9. Register the route

`lib/core/router/app_router.dart` + `route_names.dart`:

```dart
// route_names.dart
static const String profile = 'profile';
static const String profilePath = '/profile';

// app_router.dart — inside routes:
GoRoute(
  path: RoutePaths.profilePath,
  name: RouteNames.profile,
  builder: (context, state) => const ProfileScreen(),
),
```

**Rules:**
- Navigate by name only: `context.goNamed(RouteNames.profile)`.
- Pass arguments via `extra` for objects, `pathParameters` for ids.
- Protected screens are guarded by the central `redirect` — never check auth
  inside individual screens.

---

## How to create anything else

| Thing                  | Rule                                                                                        |
| ---------------------- | ------------------------------------------------------------------------------------------- |
| **New feature**        | Copy the folder skeleton from `features/auth/` (it is the reference implementation).         |
| **Shared widget**      | Goes in `lib/core/widgets/` only if used by 2+ features. Otherwise keep it in the feature.   |
| **New exception**      | Add to `core/error/exceptions.dart`, map it in `FailureX.toFailure()`.                       |
| **New failure**        | Add to `core/error/failures.dart`.                                                          |
| **Theme change**       | Only in `core/theme/app_theme.dart`. Never style ad-hoc in screens.                          |
| **Supabase table**     | Enable **RLS** on every table. Add a model that mirrors the row. Query only from data sources. |
| **Supabase client**    | Only via `ref.watch(supabaseClientProvider)`. Never `Supabase.instance` in features.         |
| **New provider**       | Declare in the feature's `xxx_providers.dart`. Core providers go in `core/di/`.              |
| **Env var / secret**   | Add to `AppConfig` via `String.fromEnvironment`. Never commit secrets.                       |

---

## Error handling policy

```
Data source  → throws AppException
Repository   → catches, returns Result<T>  (FailureResult(e.toFailure()))
Use case     → passes Result through, adds business rules
Provider/UI  → pattern-matches Result / AsyncValue, shows user-friendly message
```

---

## Testing rules

- **Unit tests** for use cases and repositories (mock the data source).
- **Widget tests** for screens (override providers with `ProviderScope(overrides: [...])`).
- Supabase never appears in tests — always override `supabaseClientProvider`.

---

## Running the app

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon-key>
```

The launch configurations in `.vscode/launch.json` already pass these.
The **anon key is safe to embed** in a client app (protected by Row Level
Security). Never add the `service_role` key anywhere in this repo.
