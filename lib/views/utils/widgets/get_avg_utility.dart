double getAvgRating(List<double> ratings) {
  return ratings.reduce((a, b) => a + b) / ratings.length;
}
