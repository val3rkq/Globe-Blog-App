String formatCountOfSth(int count) {
  String countString = count.toString();
  if (count >= 1000000) {
    double formattedCount = (count / 1000000);
    if (formattedCount.toString()[formattedCount.toString().length - 1] == '0') {
      formattedCount.toInt();
    }
    if (formattedCount < 10) {
      return '${formattedCount.toStringAsFixed(1)}M';
    } else {
      return '${formattedCount.toInt()}M';
    }
  } else if (count >= 1000) {
    double formattedCount = (count / 1000);
    if (formattedCount.toString()[formattedCount.toString().length - 1] == '0') {
      formattedCount.toInt();
    }
    if (formattedCount < 10) {
      return '${formattedCount.toStringAsFixed(1)}K';
    } else {
      return '${formattedCount.toInt()}K';
    }
  } else {
    return countString;
  }
}
