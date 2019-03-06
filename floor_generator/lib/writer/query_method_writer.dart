import 'package:code_builder/code_builder.dart';
import 'package:floor_generator/misc/annotation_expression.dart';
import 'package:floor_generator/misc/type_utils.dart';
import 'package:floor_generator/value_object/query_method.dart';
import 'package:floor_generator/writer/writer.dart';
import 'package:source_gen/source_gen.dart';

class QueryMethodWriter implements Writer {
  final LibraryReader library;
  final QueryMethod queryMethod;

  const QueryMethodWriter(final this.library, final this.queryMethod);

  @override
  Method write() {
    return _generateQueryMethod();
  }

  Method _generateQueryMethod() {
    _assertReturnsFutureOrStream();
    _assertQueryParameters();

    final builder = MethodBuilder()
      ..annotations.add(overrideAnnotationExpression)
      ..returns = refer(queryMethod.rawReturnType.displayName)
      ..name = queryMethod.name
      ..requiredParameters.addAll(_generateMethodParameters())
      ..body = Code(_generateMethodBody());

    if (!queryMethod.returnsStream || queryMethod.returnsVoid) {
      builder..modifier = MethodModifier.async;
    }

    return builder.build();
  }

  List<Parameter> _generateMethodParameters() {
    return queryMethod.parameters.map((parameter) {
      if (!isSupportedType(parameter.type)) {
        InvalidGenerationSourceError(
          'The type of this parameter is not supported.',
          element: parameter,
        );
      }

      return Parameter((builder) => builder
        ..name = parameter.name
        ..type = refer(parameter.type.displayName));
    }).toList();
  }

  String _generateMethodBody() {
    if (queryMethod.returnsVoid) {
      return "await _queryAdapter.queryNoReturn('${queryMethod.query}');";
    }

    _assertReturnsEntity();
    final mapper = '_${queryMethod.getEntity(library).name}Mapper';

    if (queryMethod.returnsStream) {
      return _generateStreamQuery(mapper);
    } else {
      return _generateQuery(mapper);
    }
  }

  String _generateQuery(final String mapper) {
    if (queryMethod.returnsList) {
      return "return _queryAdapter.queryList('${queryMethod.query}', $mapper);";
    } else {
      return "return _queryAdapter.query('${queryMethod.query}', $mapper);";
    }
  }

  String _generateStreamQuery(final String mapper) {
    final entityName = queryMethod.getEntity(library).name;

    if (queryMethod.returnsList) {
      return "return _queryAdapter.queryListStream('${queryMethod.query}', '$entityName', $mapper);";
    } else {
      return "return _queryAdapter.queryStream('${queryMethod.query}', '$entityName', $mapper);";
    }
  }

  void _assertQueryParameters() {
    final queryParameterNames = queryMethod.queryParameterNames;
    final methodSignatureParameterNames =
        queryMethod.parameters.map((parameter) => parameter.name).toList();

    final sameAmountParameters =
        queryParameterNames.length == methodSignatureParameterNames.length;

    final allParametersAreAvailable = queryParameterNames.every(
        (parameterName) =>
            methodSignatureParameterNames.any((name) => name == parameterName));

    if (!allParametersAreAvailable || !sameAmountParameters) {
      throw InvalidGenerationSourceError(
        "Parameters of method signature don't match with parameters in the query.",
        element: queryMethod.method,
      );
    }
  }

  void _assertReturnsFutureOrStream() {
    if (!queryMethod.rawReturnType.isDartAsyncFuture &&
        !queryMethod.returnsStream) {
      throw InvalidGenerationSourceError(
        'All queries have to return a Future or Stream.',
        element: queryMethod.method,
      );
    }
  }

  void _assertReturnsEntity() {
    if (!queryMethod.returnsEntity(library)) {
      throw InvalidGenerationSourceError(
        'The return type is not an entity.',
        element: queryMethod.method,
      );
    }
  }
}
