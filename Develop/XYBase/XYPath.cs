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

            public static string Jass = Editor + @"\jass";
            public static string Share = Editor + @"\share";
            public static string Plugin = Editor + @"\plugin";

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
            public static string ProgramWe = Dir.Editor + @"\YDWE.exe";
            public static string MpqConfig = Dir.Mpq + @"\config";
            public static string MpqSort = Dir.Mpq + @"\sort";

            public static string XyweUiWes = Dir.MpqUiXywe + @"\WorldEditStrings.txt";
        }
    }
}
