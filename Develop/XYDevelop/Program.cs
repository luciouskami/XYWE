using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using XYBase;
using System.Diagnostics;
using System.IO;

namespace XYDevelop
{
    class Program
    {
        void Initialize()
        {
            Console.WriteLine(@"
Select Command:
    1 - Compile Editor (YDWE, XY Edition)
    Other - Exit
");
            var key = Console.ReadKey(true).KeyChar;
            Console.WriteLine("Execute Command: " + key);
            switch (key)
            {
                case '1': CompileEditor(); break;
                default: return;
            }
            Initialize();
        }
        void CompileEditor()
        {
            string pathImport = $@"{XYPath.Dir.Root}\Import";
            string pathSource = $@"{pathImport}\YDWE-Overwrite";
            string pathTarget = $@"{pathImport}\YDWE";
            string pathBuild = $@"{pathTarget}\Build";
            string pathPublish = $@"{pathBuild}\publish\Release";
            string pathEditor = $@"{XYPath.Dir.Root}\core\editor";

            XYFile.SyncDirectory(pathSource, pathTarget, fullName =>
            {
                Console.WriteLine("Overwrite File: " + fullName.Replace(pathSource, ""));
            });
            Console.WriteLine("Start Compile ...");

            var info = new ProcessStartInfo($@"{pathBuild}\Build_Release.bat");
            info.WorkingDirectory = pathBuild;
            Process.Start(info).WaitForExit();
            if (!Directory.Exists(pathPublish))
            {
                Console.WriteLine("Compile failed, try re-select.");
                return;
            }

            Console.WriteLine("Compile success! Moving file ...");
            XYFile.CopyDirectory(pathPublish, pathEditor, true);
            Console.WriteLine("File move done!");
        }

        static void Main(string[] args) { new Program(args); }
        public Program(string[] args) { Initialize(); }
    }
}
