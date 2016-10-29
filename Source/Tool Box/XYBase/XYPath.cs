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
            // Application.StartupPath
            // Dll: Editor\core\xywe
            // Login: Editor
#if DEBUG
            public static string Editor = Path.GetFullPath(Application.StartupPath + @"\..\..\..\..\..\Editor");
#else
            public static string Editor = Path.GetFullPath(@"..\..");
#endif
            public static string Core = Editor + @"\core";

            public static string Ydwe = Core + @"\ydwe";
            public static string Xywe = Core + @"\xywe";

            public static string Jass = Ydwe + @"\jass";
            public static string Share = Ydwe + @"\share";
            public static string Plugin = Ydwe + @"\plugin";

            public static string JassXYLibrary = Jass + @"\XYLibrary";

            public static string Tesh = Plugin + @"\tesh";
            public static string TeshStyle = Tesh + @"\styles";

            public static string Mpq = Share + @"\mpq";

            public static string MpqLib(string libName) { return Mpq + @"\" + libName; }
            public static string MpqUi(string libName) { return MpqLib(libName) + @"\ui"; }

            public static string MpqLibXywe = Mpq + @"\xywe";
            public static string MpqUiXywe = MpqLibXywe + @"\ui";
            public static string MpqUiTemplateXywe = MpqLibXywe + @"\ui-template";
        }
        public static class File
        {
            public static string ProgramWe = Dir.Ydwe + @"\YDWE.exe";
            public static string MpqConfig = Dir.Mpq + @"\config";
            public static string MpqSort = Dir.Mpq + @"\sort";

            public static string XyweUiWes = Dir.MpqUiXywe + @"\WorldEditStrings.txt";
        }
    }
}
