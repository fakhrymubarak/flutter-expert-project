part of 'tv_show_detail_bloc.dart';

@immutable
abstract class TvShowDetailState extends Equatable {
  const TvShowDetailState();

  @override
  List<Object> get props => [];
}

/* TvShow Details */
class TvShowDetailLoading extends TvShowDetailState {
}

class TvShowDetailError extends TvShowDetailState {
  final String messageDetailError;
  final String messageRecommendationError;

  TvShowDetailError(this.messageDetailError, this.messageRecommendationError);

  @override
  List<Object> get props => [
        messageDetailError,
        messageRecommendationError,
      ];
}

class TvShowDetailHasData extends TvShowDetailState {
  final TvShowDetail tvShowDetail;
  final List<TvShow> tvShowRecommendations;

  TvShowDetailHasData(this.tvShowDetail, this.tvShowRecommendations);

  @override
  List<Object> get props => [tvShowDetail];
}
