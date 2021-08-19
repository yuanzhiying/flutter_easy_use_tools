/// String扩展
extension StringExtension on String {
  /// 用于解决中英文混合排放，在Text中全部显示省略号问题
  /// 解决之前显示："测试..."
  /// 解决之后显示：测试:aabbccdeeffgghhiijjkk...
  /// 使用方法："字符串".notBreak
  String get notBreak => replaceAll('', '\u{200B}');

  /// 移除数字字符串前后的0，比如用于显示价格，前后无需0
  String get removeZero {
    // 去除前面的：r'^(0+)'
    // 去除后面的：r'0*$'
    if (this.contains('.') && (this.startsWith('0') || this.endsWith('0'))) {
      String tempString = this.replaceAll(RegExp(r'^(0+)'), '').replaceAll(RegExp(r'0*$'), '');
      if (tempString.startsWith('.')) {
        // 前面拼0
        tempString = '0$tempString';
      }
      if (tempString.endsWith('.')) {
        // 后面去点
        tempString = tempString.split('.')[0];
      }
      return tempString;
    }
    return this;
  }
}
