using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using XYBase;
using System.IO;

namespace XYChecker
{
    static class Program
    {
        // [STAThread]
        static void Main()
        {
            Load();
        }
        static string archivePath = "";

        private static void Load()
        {
            XYWeb.ReadXyweServerTextAsync("version/version.txt", content =>
            {
                if (IsVersionBlocked(content))
                {
                    QuitApplication();
                }
                else
                {
                    AskServerForArchivePath();
                    DownloadArchive();
                    CreateUpdateRequireMark();
                    QuitApplication();
                }
            }, retry =>
            {
                QuitApplication();
            }, () =>
            {
                QuitApplication();
            }, 0);
        }

        private static void CreateUpdateRequireMark()
        {
            File.Create(XYPath.File.XyweDataUpdateRequire);
        }

        private static void DownloadArchive()
        {
            XYWeb.DownloadXyweServerFileAsync(archivePath, XYPath.File.XyweDataUpdateArchive, () =>
            {
                QuitApplication();
            }, failedAction: QuitApplication);
        }

        private static void AskServerForArchivePath()
        {
            XYWeb.ReadXyweServerTextAsync("version/get_archive.php?a=" + XYInfo.Version, content =>
            {
                archivePath = content;
            }, retry =>
            {
                QuitApplication();
            }, () =>
            {
                QuitApplication();
            });
        }

        private static bool IsVersionBlocked(string version)
        {
            return version.Length == 0;
        }
        private static void QuitApplication()
        {
            MessageBox.Show("About to exit");
            Application.Exit();
        }
    }
}
