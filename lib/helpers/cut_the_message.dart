String cutMessage(String text) {
  if (text.length > 25) {
    return '${text.substring(0, 24)}...';
  }
  return text;
}