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
        static string serverVersion = "";

        public FormXYChecker()
        {
            InitializeComponent();
            try
            {
                if (XYWeb.GetInternetConnection())
                {
                    XYWeb.ReadXyweServerTextAsync("version/ask_update.php", content =>
                    {
                        if (content.Length == 0) QuitChecker();
                        else
                        {
                            MessageBox.Show("Find new version: " + serverVersion + ", XYWE will update on your next start.");
                            serverVersion = content;
                            DownloadResources();
                            MessageBox.Show("Find new version: " + serverVersion + ", XYWE will update on your next start.");
                        }
                    }, Quit, QuitChecker, 0);
                }
                else
                {
                    QuitChecker();
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        static void DownloadResources()
        {
            XYWeb.DownloadXyweServerFileAsync($"version/cache/{serverVersion}/{XYInfo.Version}.zip", XYPath.File.DataUpdateFiles, null, Quit, QuitChecker);
            XYWeb.DownloadXyweServerFileAsync($"version/cache/{serverVersion}/{XYInfo.Version}.txt", XYPath.File.DataUpdateRemove, null, Quit, QuitChecker);
            XYWeb.DownloadXyweServerFileAsync($"version/repository/{serverVersion}/log.txt", XYPath.File.DataUpdateLog, null, Quit, QuitChecker);
        }

        static void QuitChecker()
        {
            MessageBox.Show("");
            XYFile.RemoveDirectory(XYPath.Dir.DataUpdate);
            Application.Exit();
        }
        static void Quit(int _) { QuitChecker(); }
    }
}
