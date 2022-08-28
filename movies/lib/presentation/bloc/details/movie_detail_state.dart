part of 'movie_detail_bloc.dart';

@immutable
abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

/* Movie Details */
class MovieDetailLoading extends MovieDetailState {
}

class MovieDetailError extends MovieDetailState {
  final String messageDetailError;
  final String messageRecommendationError;

  MovieDetailError(this.messageDetailError, this.messageRecommendationError);

  @override
  List<Object> get props => [
        messageDetailError,
        messageRecommendationError,
      ];
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail movieDetail;
  final List<Movie> movieRecommendations;

  MovieDetailHasData(this.movieDetail, this.movieRecommendations);

  @override
  List<Object> get props => [movieDetail];
}
