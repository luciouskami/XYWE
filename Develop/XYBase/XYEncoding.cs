using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public static class XYEncoding
    {
        public static string ANSI_to_UTF8(string source)
        {
            return Encoding.UTF8.GetString(Encoding.Default.GetBytes(source));
        }
        public static string UTF8_to_ANSI(string source)
        {
            return Encoding.Default.GetString(Encoding.UTF8.GetBytes(source));
        }
    }
}
