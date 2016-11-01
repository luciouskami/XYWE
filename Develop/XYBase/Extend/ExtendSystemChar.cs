using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace XYBase {
    public static class ExtendSystemChar {
        private static Regex chineseRegex = new Regex("[\u4E00-\u9FA5]");
        public static bool IsChinese(this char c) {
            return chineseRegex.Match(c.ToString()).Success;
        }
    }
}
