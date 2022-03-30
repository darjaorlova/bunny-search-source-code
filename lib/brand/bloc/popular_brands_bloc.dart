import 'package:domain/brands/model/brand.dart';
import 'package:domain/brands/repository/brands_repository.dart';
import 'package:domain/result/delayed_result.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PopularBrandsBlocEvent extends Equatable {
  const PopularBrandsBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadBrandsEvent extends PopularBrandsBlocEvent {}

class PopularBrandsState extends Equatable {
  final DelayedResult<List<Brand>> brandsResult;

  const PopularBrandsState({required this.brandsResult});

  PopularBrandsState copyWith({DelayedResult<List<Brand>>? brandsResult}) =>
      PopularBrandsState(brandsResult: brandsResult ?? this.brandsResult);

  @override
  List<Object?> get props => [brandsResult];
}

class PopularBrandBloc
    extends Bloc<PopularBrandsBlocEvent, PopularBrandsState> {
  final BrandsRepository brandsRepository;

  PopularBrandBloc({required this.brandsRepository})
      : super(PopularBrandsState(brandsResult: DelayedResult.inProgress()));

  @override
  Stream<PopularBrandsState> mapEventToState(
      PopularBrandsBlocEvent event) async* {
    if (event is LoadBrandsEvent) {
      yield* _mapLoadBrandsEventToState(event);
    }
  }

  Stream<PopularBrandsState> _mapLoadBrandsEventToState(
      LoadBrandsEvent event) async* {
    yield state.copyWith(brandsResult: DelayedResult.inProgress());

    try {
      final brands = await brandsRepository.getAllPopularBrands();
      yield state.copyWith(brandsResult: DelayedResult.success(brands));
    } on Exception catch (ex, st) {
      Fimber.e('Failed to load popular brands', ex: ex, stacktrace: st);
      yield state.copyWith(brandsResult: DelayedResult.error(ex));
    }
  }
}
