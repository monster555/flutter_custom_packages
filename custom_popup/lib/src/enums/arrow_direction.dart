enum ArrowDirection {
  top(topPadding: 0, quarterTurns: 2),
  bottom(bottomPadding: 0, quarterTurns: 4);

  const ArrowDirection({
    this.topPadding,
    this.bottomPadding,
    required this.quarterTurns,
  });

  final double? topPadding;
  final double? bottomPadding;
  final int quarterTurns;
}
