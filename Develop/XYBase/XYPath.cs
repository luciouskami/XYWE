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
            public static string EditorShare = Editor + @"\share";
            public static string EditorShareMpq = EditorShare + @"\mpq";
            public static string EditorShareScript = EditorShare + @"\script";

            public static string Source = Core + @"\source";
            public static string SourceJass = Source + @"\jass";
            public static string SourceMpq = Source + @"\mpq";
            public static string SourceMpqUnits = SourceMpq + @"\units";
            public static string SourcePlugin = Source + @"\plugin";
            public static string SourceScript = Source + @"\script";
            public static string SourceUi = Source + @"\ui";
            public static string SourcePackage = Source + @"\package";

            public static string Data = Core + @"\data";

            public static string Jass = Editor + @"\jass";
            public static string Share = Editor + @"\share";
            public static string Plugin = Editor + @"\plugin";

            public static string JassXYLibrary = Jass + @"\XYLibrary";

            public static string Tesh = Plugin + @"\tesh";
            public static string TeshStyle = Tesh + @"\styles";

            public static string Mpq = Share + @"\mpq";


            public static string MpqLib(string libName) { return Mpq + @"\" + libName; }
            public static string MpqUi(string libName) { return MpqLib(libName) + @"\ui"; }
        }
        public static class File
        {
            public static string ProgramWe = Dir.Editor + @"\YDWE.exe";
            public static string MpqConfig = Dir.Mpq + @"\config";
            public static string MpqSort = Dir.Mpq + @"\sort";

            public static string XyweDataIni = Dir.Data + @"\data.ini";
            public static string XyweDataTip = Dir.Data + @"\tips.txt";
            public static string XyweDataPackages = Dir.Data + @"\packages.ini";
            public static string XyweUiTip = Dir.SourceUi + @"\xywe\WorldEditStrings\Tip.txt";
        }
    }
}
