using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Windows.Forms;

namespace XYBase
{
    public static class XYConfig
    {
        static void SetConfig(string name)
        {
            XYIni.Config["UI"] = name;
        }
        static void WriteConfig(IEnumerable<string> config)
        {
            File.WriteAllLines(XYPath.File.MpqConfig, config);
        }
        public static void TurnYDWE()
        {
            SetConfig("YDWE");
        }
        public static void TurnXYWE()
        {
            SetConfig("XYWE");
        }
        public static string GetCurrentStandardUI()
        {
            return XYIni.Config["UI"];
        }
        public static void RefreshConfig()
        {
            var config = new List<string>();
            var current = GetCurrentStandardUI();
            switch (current)
            {
                case "YDWE":
                    config.AddRange(new[] { "ydwe", "ydtrigger", "japi" });
                    break;
                case "XYWE":
                    config.AddRange(new[] { "base", "xywe" });
                    break;
                default:
                    MessageBox.Show("不明的基础函数库方案：" + current + "，你是否擅自修改了data/data.ini文件？");
                    break;
            }

            /* TODO 未来通过更新器推送触发器库
            var enabled = XYPackage.GetCurrentEnabled();
            enabled.Reverse(); // config处理逻辑的顺序是颠倒的，因此在这里进行Reverse来消除颠倒，从而能正常使用排序功能
            config.AddRange(enabled); */

            WriteConfig(config);
        }
    }
}
