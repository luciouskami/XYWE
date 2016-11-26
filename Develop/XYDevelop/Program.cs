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
                default: Process.GetCurrentProcess().Kill(); return;
            }
            Initialize();
        }
        void CompileEditor()
        {
            string pathEditorSourceRoot = $@"{XYPath.Dir.Root}\Develop-Editor";
            string pathEditorSourceBuild = $@"{pathEditorSourceRoot}\Build";
            string pathEditorSourcePublish = $@"{pathEditorSourceBuild}\publish\Release";
            string pathEditorOutput = $@"{XYPath.Dir.Root}\core\editor";

            Console.WriteLine("Start Compile ...");

            var info = new ProcessStartInfo($@"{pathEditorSourceBuild}\Build_Release.bat");
            info.WorkingDirectory = pathEditorSourceBuild;
            Process.Start(info).WaitForExit();
            if (!Directory.Exists(pathEditorSourcePublish))
            {
                Console.WriteLine("Compile failed, try re-select.");
                return;
            }

            Console.WriteLine("Compile success! Moving file ...");
            XYFile.CopyDirectory(pathEditorSourcePublish, pathEditorOutput, true);
            Console.WriteLine("File move done!");
        }

        static void Main(string[] args) { new Program(args); }
        public Program(string[] args) { Initialize(); }
    }
}
