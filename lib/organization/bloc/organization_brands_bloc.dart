import 'package:domain/brands/model/brand.dart';
import 'package:domain/brands/repository/brands_repository.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:domain/result/delayed_result.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OrganizationBrandsBlocEvent extends Equatable {
  const OrganizationBrandsBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadBrandsEvent extends OrganizationBrandsBlocEvent {
  final OrganizationType organizationType;

  const LoadBrandsEvent({required this.organizationType});

  @override
  List<Object?> get props => [organizationType];
}

class OrganizationBrandsState extends Equatable {
  final OrganizationType? organizationType;
  final DelayedResult<List<Brand>> brandsResult;

  const OrganizationBrandsState(
      {required this.organizationType, required this.brandsResult});

  OrganizationBrandsState copyWith(
          {OrganizationType? organizationType,
          DelayedResult<List<Brand>>? brandsResult}) =>
      OrganizationBrandsState(
          organizationType: organizationType ?? this.organizationType,
          brandsResult: brandsResult ?? this.brandsResult);

  @override
  List<Object?> get props => [organizationType, brandsResult];
}

class OrganizationBrandBloc
    extends Bloc<OrganizationBrandsBlocEvent, OrganizationBrandsState> {
  final BrandsRepository brandsRepository;

  OrganizationBrandBloc({required this.brandsRepository})
      : super(OrganizationBrandsState(
            organizationType: null, brandsResult: DelayedResult.inProgress()));

  @override
  Stream<OrganizationBrandsState> mapEventToState(
      OrganizationBrandsBlocEvent event) async* {
    if (event is LoadBrandsEvent) {
      yield* _mapLoadBrandsEventToState(event);
    }
  }

  Stream<OrganizationBrandsState> _mapLoadBrandsEventToState(
      LoadBrandsEvent event) async* {
    yield state.copyWith(brandsResult: DelayedResult.inProgress());

    try {
      final brands = await brandsRepository
          .getBrandsByOrganizationType(event.organizationType);
      yield state.copyWith(
          organizationType: event.organizationType,
          brandsResult: DelayedResult.success(brands));
    } on Exception catch (ex, st) {
      Fimber.e('Failed to load org brands', ex: ex, stacktrace: st);
      yield state.copyWith(brandsResult: DelayedResult.error(ex));
    }
  }
}
