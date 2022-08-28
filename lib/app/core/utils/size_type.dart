enum SizeType {
  extraSmall(150),
  small(350),
  medium(550),
  large(750),
  extraLarge(950);

  final double size;

  const SizeType(this.size);

  factory SizeType.fromWidth(double width) {
    if (width > SizeType.extraLarge.size) return SizeType.extraLarge;
    if (width > SizeType.large.size) return SizeType.large;
    if (width > SizeType.medium.size) return SizeType.medium;
    if (width > SizeType.small.size) return SizeType.small;

    return SizeType.extraSmall;
  }
}
