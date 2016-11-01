using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace XYBase
{
    public static class XYConfig
    {
        static void WriteConfig(string name, string[] config)
        {
            File.WriteAllLines(XYPath.File.MpqConfig, config);
            XYIni.Config["UI"] = name;
        }
        public static void TurnYDWE()
        {
            WriteConfig("YDWE", new[] { "ydwe", "ydtrigger", "japi" });
        }
        public static void TurnXYWE()
        {
            WriteConfig("XYWE", new[] { "base", "xywe" });
        }
        public static string GetCurrent()
        {
            return XYIni.Config["UI"];
        }
    }
}
