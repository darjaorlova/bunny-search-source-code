import 'package:bunny_search/organization/model/organization_details.dart';
import 'package:bunny_search/organization/model/organizations_mapper.dart';
import 'package:domain/brands/model/brand.dart';
import 'package:domain/brands/repository/brands_repository.dart';
import 'package:domain/result/delayed_result.dart';
import 'package:domain/storage/key_value_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

const _keySupportDialogShown = 'key_show_support_dialog';

abstract class HomeBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEvent extends HomeBlocEvent {}

class SearchEvent extends HomeBlocEvent {
  final String searchTerm;

  SearchEvent({required this.searchTerm});

  @override
  List<Object?> get props => [searchTerm];
}

class SetSupportDialogShownEvent extends HomeBlocEvent {}

class HomeBlocState extends Equatable {
  final String searchTerm;
  final Optional<DelayedResult<List<Brand>>> searchResult;
  final DelayedResult<List<OrganizationDetails>> organizationsResult;
  final List<Brand> popularBrands;
  final bool showSupportDialog;

  const HomeBlocState(
      {required this.searchTerm,
      required this.searchResult,
      required this.organizationsResult,
      required this.popularBrands,
      required this.showSupportDialog});

  HomeBlocState copyWith(
          {String? searchTerm,
          Optional<DelayedResult<List<Brand>>>? searchResult,
          DelayedResult<List<OrganizationDetails>>? organizationsResult,
          List<Brand>? popularBrands,
          bool? showSupportDialog}) =>
      HomeBlocState(
          searchTerm: searchTerm ?? this.searchTerm,
          searchResult: searchResult ?? this.searchResult,
          organizationsResult: organizationsResult ?? this.organizationsResult,
          popularBrands: popularBrands ?? this.popularBrands,
          showSupportDialog: showSupportDialog ?? this.showSupportDialog);

  @override
  List<Object?> get props => [
        searchTerm,
        searchResult,
        organizationsResult,
        popularBrands,
        showSupportDialog
      ];
}

class HomeBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  final BrandsRepository brandsRepository;
  final KeyValueStorage keyValueStorage;

  HomeBloc({required this.brandsRepository, required this.keyValueStorage})
      : super(HomeBlocState(
            searchTerm: '',
            searchResult: Optional.absent(),
            organizationsResult: DelayedResult.inProgress(),
            popularBrands: [],
            showSupportDialog: false));

  @override
  Stream<HomeBlocState> mapEventToState(HomeBlocEvent event) async* {
    if (event is LoadEvent) {
      yield* _mapLoadEventToState();
    } else if (event is SearchEvent) {
      yield* _mapSearchEventToState(event);
    } else if (event is SetSupportDialogShownEvent) {
      await keyValueStorage.setBool(_keySupportDialogShown, true);
      yield state.copyWith(showSupportDialog: false);
    }
  }

  @override
  Stream<Transition<HomeBlocEvent, HomeBlocState>> transformEvents(
      Stream<HomeBlocEvent> events,
      TransitionFunction<HomeBlocEvent, HomeBlocState> transitionFn) {
    final nonTransformedStream = events.where((event) => event is! SearchEvent);

    final debounceSetSearchTermStream = events
        .where((event) => event is SearchEvent)
        .debounceTime(Duration(milliseconds: 500));

    return super.transformEvents(
        MergeStream([
          nonTransformedStream,
          debounceSetSearchTermStream,
        ]),
        transitionFn);
  }

  Stream<HomeBlocState> _mapLoadEventToState() async* {
    yield state.copyWith(organizationsResult: DelayedResult.inProgress());

    try {
      // TODO when searching also make sure db is available
      final supportDialogShown =
          (await keyValueStorage.getBool(_keySupportDialogShown)) == true;
      await brandsRepository.loadAllBrands();
      final organizations = await brandsRepository.getAllOrganizations();
      final mapped = organizations
          .map((o) => OrganizationsMapper.toOrganizationDetails(o))
          .toList();
      final popular = await brandsRepository.getAllPopularBrands();
      yield state.copyWith(
          organizationsResult: DelayedResult.success(mapped),
          popularBrands: popular.take(15).toList(),
          showSupportDialog: !supportDialogShown
      );
    } on Exception catch (ex, st) {
      Fimber.e('Failed to load organizations', ex: ex, stacktrace: st);
      yield state.copyWith(organizationsResult: DelayedResult.error(ex));
    }
  }

  Stream<HomeBlocState> _mapSearchEventToState(SearchEvent event) async* {
    if (event.searchTerm.isEmpty) {
      yield state.copyWith(
          searchTerm: event.searchTerm, searchResult: Optional.absent());
      return;
    }

    yield state.copyWith(
        searchTerm: event.searchTerm,
        searchResult: Optional.of(DelayedResult.inProgress()));

    try {
      final results = await brandsRepository.search(event.searchTerm);
      yield state.copyWith(
          searchResult: Optional.of(DelayedResult.success(results)));
    } on Exception catch (ex, st) {
      Fimber.w('Failed to find brand: ${event.searchTerm}',
          ex: ex, stacktrace: st);
    }
  }
}
