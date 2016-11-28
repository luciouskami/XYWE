using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using Ini;

namespace XYBase
{
    public static class XYPath
    {
        public static class Dir
        {
            public static string Root = Path.GetFullPath(@"..");
            public static string Core = Root + @"\core";

            public static string Editor = Core + @"\editor";
            public static string EditorJass = Editor + @"\jass";
            public static string EditorPlugin = Editor + @"\plugin";
            public static string EditorPluginTesh = EditorPlugin + @"\tesh";
            public static string EditorPluginTeshStyle = EditorPluginTesh + @"\styles";
            public static string EditorShare = Editor + @"\share";
            public static string EditorShareMpq = EditorShare + @"\mpq";
            public static string EditorShareMpqLib(string libName) { return EditorShareMpq + @"\" + libName; }
            public static string EditorShareMpqUi(string libName) { return EditorShareMpqLib(libName) + @"\ui"; }
            public static string EditorShareScript = EditorShare + @"\script";

            public static string Source = Core + @"\source";
            public static string SourceJass = Source + @"\jass";
            public static string SourcePlugin = Source + @"\plugin";
            public static string SourceScript = Source + @"\script";
            public static string SourceUi = Source + @"\ui";
            public static string SourcePackage = Source + @"\package";
            public static string SourceTemplate = Source + @"\template";

            public static string Data = Core + @"\data";
            public static string DataUpdate = Data + @"\update";

            public static string Plugin = Core + @"\plugin";
            public static string Plugin_RSJB_WE_TextEditor_15_0 = Plugin + @"\人生脚步WE文本修改器15.0";
        }
        public static class File
        {
            public static string UpdateLock = Dir.Root + @"\disable_update.lock";

            public static string ProgramWe = Dir.Editor + @"\YDWE.exe";
            public static string MpqConfig = Dir.EditorShareMpq + @"\config";
            public static string MpqSort = Dir.EditorShareMpq + @"\sort";

            public static string DataIni = Dir.Data + @"\data.ini";
            public static string DataTip = Dir.Data + @"\tips.txt";
            public static string DataPackages = Dir.Data + @"\packages.ini";

            public static string DataUpdateFiles = Dir.DataUpdate + @"\files.zip";
            public static string DataUpdateLog = Dir.DataUpdate + @"\log.txt";
            public static string DataUpdateRemove = Dir.DataUpdate + @"\remove.txt";

            public static class Plugin
            {
                public static class RSJB_WE_TextEditor_15_0
                {
                    public static string Executor = Dir.Plugin_RSJB_WE_TextEditor_15_0 + @"\人生脚步WE文本修改器15.0.exe";
                    public static string IniConfig = Dir.Plugin_RSJB_WE_TextEditor_15_0 + @"\功能配置.ini";
                }
            }

            public static string XyweUiTip = Dir.SourceUi + @"\xywe\WorldEditStrings\Tip.txt";
        }
    }
}
