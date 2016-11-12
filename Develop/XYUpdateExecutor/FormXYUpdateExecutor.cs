/*
咸鱼更新执行器：
    完全独立性：
        与咸鱼更新器不同，执行器必须保证完全独立性，不可使用任何与XYWE相关的函数或功能，因为执行器需要权限对XYWE本身进行完全更新。
    固定性：
        完成编写后永远不更改原有功能，可添加额外功能但必须保证原有功能不变。
    功能：
	    Check "./core/data/update" exist
        Unarchive "files.zip" and patch all files to xywe
        Remove files in "remove.txt"
        Leave log.txt, XYWE dispaly it on start.
*/

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.IO.Compression;
using System.Diagnostics;

namespace XYUpdateExecutor
{
    public partial class FormXYUpdateExecutor : Form
    {
        string pathFile = @"core\data\update\files.zip";
        string pathRemove = @"core\data\update\remove.txt";

        public FormXYUpdateExecutor()
        {
            GotoRoot();
            if (!IsUpdateDisabled())
            {
                try
                {
                    ExecuteUpdate_PatchFile();
                    ExecuteUpdate_Remove();
                    ClearUpdateResource();

                    GotoCore();
                    StartXYWE();
                    ExitExecutor();
                    return;
                }
                catch
                {
                    ShowError();
                    ExitExecutor();
                    return;
                }
            }
        }

        bool IsUpdateDisabled()
        {
            return File.Exists("disable_update.lock");
        }

        void ShowError()
        {
            MessageBox.Show("在升级XYWE的过程中出现异常，请确保在启动XYWE前已关闭所有咸鱼工具和WE！");
        }

        void ExecuteUpdate_PatchFile()
        {
            if (File.Exists(pathFile))
            {
                ClearArchiveCache();
                ZipFile.ExtractToDirectory(pathFile, @"core\data\update\files");
                CopyDirectory(@"core\data\update\files", @".", true);
            }
        }

        void ExecuteUpdate_Remove()
        {
            if (File.Exists(pathRemove))
            {
                var lines = File.ReadAllLines(pathRemove).ToList();
                foreach (var line in lines)
                {
                    if (line.Length == 0) continue;
                    if (File.Exists(line)) File.Delete(line);
                }
            }
        }

        void ClearUpdateResource()
        {
            File.Delete(pathFile);
            File.Delete(pathRemove);
        }

        void StartXYWE()
        {
            Process.Start(@"XYWE.exe");
        }

        void GotoRoot()
        {
            Environment.CurrentDirectory = Path.GetFullPath(Environment.CurrentDirectory + @"\..");
        }
        void GotoCore()
        {
            Environment.CurrentDirectory = Path.GetFullPath(Environment.CurrentDirectory + @"\core");
        }

        void ExitExecutor()
        {
            Process.GetCurrentProcess().Kill();
        }

        void ClearArchiveCache()
        {
            if (Directory.Exists(@"core\data\update\files"))
                Directory.Delete(@"core\data\update\files", true);
        }

        void CopyDirectory(string sourcePath, string destinationPath, bool overwrite = false)
        {
            var info = new DirectoryInfo(sourcePath);
            Directory.CreateDirectory(destinationPath);
            foreach (var fsi in info.GetFileSystemInfos())
            {
                var pathDst = destinationPath + @"\" + fsi.Name;
                if (fsi is FileInfo)
                {
                    File.Copy(fsi.FullName, pathDst, overwrite);
                }
                else
                {
                    Directory.CreateDirectory(pathDst);
                    CopyDirectory(fsi.FullName, pathDst, overwrite);
                }
            }
        }
    }
}
