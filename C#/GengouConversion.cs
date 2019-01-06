/* 
 * C#で西暦和暦変換
 *
 * Update: 2019/1/6
 * Yutaka Hirata
 */

using System;
using System.Globalization;

class GengouConversion {
  static void Main() {
    CultureInfo cl = new CultureInfo("ja-JP", false);
    cl.DateTimeFormat.Calendar = new JapaneseCalendar();
    DateTime dt = DateTime.Parse("2019/4/27 00:00:00");

    for (int d = 0; d < 10 ; d++) {
      string s = dt.ToString("ggyy年M月d日", cl);
      Console.WriteLine(dt.ToString("yyyy/MM/dd") + " は " + s + " です");

      dt = dt.AddDays(1);
    }   

    Console.WriteLine("\n今年は驚異の10連休です");
  }
}
