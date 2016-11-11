using System.IO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using XYBase;

namespace XYChecker
{
    public partial class FormXYChecker : Form
    {
        string serverVersion = "";

        public FormXYChecker()
        {
            InitializeComponent();
            label2.Text = "... Updating ...";

            if (XYWeb.GetInternetConnection())
            {
                XYWeb.ReadXyweServerTextAsync($"version/ask_update.php?a={XYInfo.Version}", content =>
                {
                    if (content.Length == 0
                        || content == XYInfo.Version) Quit();
                    else
                    {
                        if (!Directory.Exists(XYPath.Dir.DataUpdate))
                            Directory.CreateDirectory(XYPath.Dir.DataUpdate);

                        serverVersion = content;
                        DownloadResources();
                    }
                }, Quit, Quit, 0);
            }
            else Quit();
        }

        void DownloadResources()
        {
            var pathArchive = $"version/cache/{serverVersion}/{XYInfo.Version}.zip";
            XYWeb.DownloadXyweServerFileAsync(pathArchive, XYPath.File.DataUpdateFiles, () =>
            {
                if (File.ReadAllBytes(XYPath.File.DataUpdateFiles).Length == 0) File.Delete(XYPath.File.DataUpdateFiles);

                var pathRemove = $"version/cache/{serverVersion}/{XYInfo.Version}.txt";
                XYWeb.DownloadXyweServerFileAsync(pathRemove, XYPath.File.DataUpdateRemove, () =>
                {
                    if (File.ReadAllBytes(XYPath.File.DataUpdateRemove).Length == 0) File.Delete(XYPath.File.DataUpdateRemove);

                    XYWeb.DownloadXyweServerFileAsync($"version/repository/{serverVersion}/log.txt", XYPath.File.DataUpdateLog, () =>
                    {
                        label2.Text = serverVersion;
                        WindowState = FormWindowState.Normal;
                    }, Quit, Quit, successWhenNotFound: false);
                }, Quit, Quit, successWhenNotFound: true);
            }, Quit, Quit, successWhenNotFound: true);
        }

        void Quit() { Application.Exit(); }
        void Quit(int _) { Quit(); }

        private void FormXYChecker_Load(object sender, EventArgs e)
        {
        }
    }
}
