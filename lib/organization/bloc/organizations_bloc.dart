import 'package:bunny_search/organization/model/organization_details.dart';
import 'package:bunny_search/organization/model/organizations_mapper.dart';
import 'package:domain/brands/repository/brands_repository.dart';
import 'package:domain/result/delayed_result.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OrganizationsBlocEvent extends Equatable {
  const OrganizationsBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvent extends OrganizationsBlocEvent {}

class OrganizationsState extends Equatable {
  final DelayedResult<List<OrganizationDetails>> orgResult;

  const OrganizationsState({required this.orgResult});

  OrganizationsState copyWith({
    DelayedResult<List<OrganizationDetails>>? orgResult,
  }) =>
      OrganizationsState(orgResult: orgResult ?? this.orgResult);

  @override
  List<Object?> get props => [orgResult];
}

class OrganizationsBloc
    extends Bloc<OrganizationsBlocEvent, OrganizationsState> {
  final BrandsRepository brandsRepository;

  OrganizationsBloc({required this.brandsRepository})
      : super(const OrganizationsState(orgResult: DelayedResult.inProgress()));

  @override
  Stream<OrganizationsState> mapEventToState(
    OrganizationsBlocEvent event,
  ) async* {
    if (event is LoadEvent) {
      yield* _mapLoadEventToState();
    }
  }

  Stream<OrganizationsState> _mapLoadEventToState() async* {
    yield state.copyWith(orgResult: const DelayedResult.inProgress());

    try {
      final organizations = await brandsRepository.getAllOrganizations();
      final mapped = organizations
          .map((o) => OrganizationsMapper.toOrganizationDetails(o))
          .toList();
      yield state.copyWith(orgResult: DelayedResult.success(mapped));
    } on Exception catch (ex, st) {
      Fimber.e('Failed to load all orgz', ex: ex, stacktrace: st);
      yield state.copyWith(orgResult: DelayedResult.error(ex));
    }
  }
}
