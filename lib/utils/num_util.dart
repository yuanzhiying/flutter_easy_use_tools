/// 数字操作工具类
class NumUtil {
  /// 小数点后保留几位小数
  static String formatNum(double num, int position) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) < position) {
      // 小数点后有几位小数
      return num.toStringAsFixed(position).substring(0, num.toString().lastIndexOf(".") + position + 1).toString();
    } else {
      return num.toString().substring(0, num.toString().lastIndexOf(".") + position + 1).toString();
    }
  }
}
