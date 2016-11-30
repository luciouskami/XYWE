using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;

namespace XYBase
{
    public static class XYPlugin
    {
        public static void KillAll()
        {
            RSJB_WE_TextEditor_16_0.KillAll();
        }
        public static class RSJB_WE_TextEditor_16_0
        {
            public const string FileNameWithoutExtension = "人生脚步WE文本修改器16.0";
            private const string PluginId = "RSJB_WE_TriggerEditor_16_0";
            public static Process[] GetAllProcess()
            {
                return Process.GetProcessesByName(FileNameWithoutExtension);
            }
            public static void ForEachProcess(Action<Process> action)
            {
                foreach (var proc in GetAllProcess())
                {
                    action(proc);
                }
            }
            public static void KillAll()
            {
                ForEachProcess(proc => proc.Kill());
            }
            public static bool IsWorking()
            {
                return GetAllProcess().Length > 0;
            }
            public static void SafeStart()
            {
                KillAll();
                Process.Start(XYPath.File.Plugin.RSJB_WE_TextEditor_16_0.Executor);
            }
            public static void SetEnableState(bool state)
            {
                XYIni.Plugin[PluginId] = Convert.ToString(state);
            }
            public static bool GetEnableState()
            {
                return XYIni.Plugin[PluginId] == "True";
            }
            public static void OpenConfigFile()
            {
                Process.Start(XYPath.File.Plugin.RSJB_WE_TextEditor_16_0.IniConfig);
            }
        }
    }
}
