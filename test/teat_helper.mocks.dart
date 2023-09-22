// Mocks generated by Mockito 5.4.2 from annotations
// in islamic_online_learning/test/teat_helper.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:dartz/dartz.dart' as _i2;
import 'package:firebase_core/firebase_core.dart' as _i4;
import 'package:firebase_database/firebase_database.dart' as _i3;
import 'package:islamic_online_learning/core/failure.dart' as _i7;
import 'package:islamic_online_learning/features/main/data/Model/course_model.dart'
    as _i8;
import 'package:islamic_online_learning/features/main/domain/main_repo.dart'
    as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDatabaseReference_1 extends _i1.SmartFake
    implements _i3.DatabaseReference {
  _FakeDatabaseReference_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDataSnapshot_2 extends _i1.SmartFake implements _i3.DataSnapshot {
  _FakeDataSnapshot_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseApp_3 extends _i1.SmartFake implements _i4.FirebaseApp {
  _FakeFirebaseApp_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MainRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockMainRepo extends _i1.Mock implements _i5.MainRepo {
  MockMainRepo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Either<_i7.Failure, List<_i8.CourseModel>>> getCourses(
          int? page) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCourses,
          [page],
        ),
        returnValue:
            _i6.Future<_i2.Either<_i7.Failure, List<_i8.CourseModel>>>.value(
                _FakeEither_0<_i7.Failure, List<_i8.CourseModel>>(
          this,
          Invocation.method(
            #getCourses,
            [page],
          ),
        )),
      ) as _i6.Future<_i2.Either<_i7.Failure, List<_i8.CourseModel>>>);
}

/// A class which mocks [DataSnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockDataSnapshot extends _i1.Mock implements _i3.DataSnapshot {
  MockDataSnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.DatabaseReference get ref => (super.noSuchMethod(
        Invocation.getter(#ref),
        returnValue: _FakeDatabaseReference_1(
          this,
          Invocation.getter(#ref),
        ),
      ) as _i3.DatabaseReference);
  @override
  bool get exists => (super.noSuchMethod(
        Invocation.getter(#exists),
        returnValue: false,
      ) as bool);
  @override
  Iterable<_i3.DataSnapshot> get children => (super.noSuchMethod(
        Invocation.getter(#children),
        returnValue: <_i3.DataSnapshot>[],
      ) as Iterable<_i3.DataSnapshot>);
  @override
  bool hasChild(String? path) => (super.noSuchMethod(
        Invocation.method(
          #hasChild,
          [path],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i3.DataSnapshot child(String? path) => (super.noSuchMethod(
        Invocation.method(
          #child,
          [path],
        ),
        returnValue: _FakeDataSnapshot_2(
          this,
          Invocation.method(
            #child,
            [path],
          ),
        ),
      ) as _i3.DataSnapshot);
}

/// A class which mocks [FirebaseDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MFirebaseDatabase extends _i1.Mock implements _i3.FirebaseDatabase {
  MFirebaseDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FirebaseApp get app => (super.noSuchMethod(
        Invocation.getter(#app),
        returnValue: _FakeFirebaseApp_3(
          this,
          Invocation.getter(#app),
        ),
      ) as _i4.FirebaseApp);
  @override
  set app(_i4.FirebaseApp? _app) => super.noSuchMethod(
        Invocation.setter(
          #app,
          _app,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set databaseURL(String? _databaseURL) => super.noSuchMethod(
        Invocation.setter(
          #databaseURL,
          _databaseURL,
        ),
        returnValueForMissingStub: null,
      );
  @override
  Map<dynamic, dynamic> get pluginConstants => (super.noSuchMethod(
        Invocation.getter(#pluginConstants),
        returnValue: <dynamic, dynamic>{},
      ) as Map<dynamic, dynamic>);
  @override
  void useDatabaseEmulator(
    String? host,
    int? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #useDatabaseEmulator,
          [
            host,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.DatabaseReference reference() => (super.noSuchMethod(
        Invocation.method(
          #reference,
          [],
        ),
        returnValue: _FakeDatabaseReference_1(
          this,
          Invocation.method(
            #reference,
            [],
          ),
        ),
      ) as _i3.DatabaseReference);
  @override
  _i3.DatabaseReference ref([String? path]) => (super.noSuchMethod(
        Invocation.method(
          #ref,
          [path],
        ),
        returnValue: _FakeDatabaseReference_1(
          this,
          Invocation.method(
            #ref,
            [path],
          ),
        ),
      ) as _i3.DatabaseReference);
  @override
  _i3.DatabaseReference refFromURL(String? url) => (super.noSuchMethod(
        Invocation.method(
          #refFromURL,
          [url],
        ),
        returnValue: _FakeDatabaseReference_1(
          this,
          Invocation.method(
            #refFromURL,
            [url],
          ),
        ),
      ) as _i3.DatabaseReference);
  @override
  void setPersistenceEnabled(bool? enabled) => super.noSuchMethod(
        Invocation.method(
          #setPersistenceEnabled,
          [enabled],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setPersistenceCacheSizeBytes(int? cacheSize) => super.noSuchMethod(
        Invocation.method(
          #setPersistenceCacheSizeBytes,
          [cacheSize],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setLoggingEnabled(bool? enabled) => super.noSuchMethod(
        Invocation.method(
          #setLoggingEnabled,
          [enabled],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<void> goOnline() => (super.noSuchMethod(
        Invocation.method(
          #goOnline,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> goOffline() => (super.noSuchMethod(
        Invocation.method(
          #goOffline,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> purgeOutstandingWrites() => (super.noSuchMethod(
        Invocation.method(
          #purgeOutstandingWrites,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}
