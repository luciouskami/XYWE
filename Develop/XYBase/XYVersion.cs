using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace XYBase
{
    public static class XYVersion
    {
        static string GetLastCheckObsoleteTime()
        {
            return SafeReadIni("LastCheckObsoleteTime", "2015/09/14 22:33:33");
        }
        static string GetObsolete()
        {
            return SafeReadIni("Obsolete", "false");
        }
        static string SafeReadIni(string key, string defaultValue)
        {
            var value = XYIni.Config[key];
            if (value.Length == 0)
            {
                value = defaultValue;
                XYIni.Config[key] = value;
            }
            return value;
        }
    }
}
