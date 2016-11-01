using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using XYBase;

namespace XYWE
{
    public partial class FormXYWE : Form
    {
        static FormXYWE Last = null;

        public FormXYWE()
        {
            InitializeComponent();
            Last = this;
        }

        void FormXYWE_Load(object sender, EventArgs e)
        {
            LlVersion.Text = XYInfo.Version;
            XYTip.UpdateTipAsync();
            XYVersion.VerifyObsoleteAsync(ObsoleteAction);
        }
        void ObsoleteAction()
        {
            LlVersion.Text = LlVersion.Text + "(旧)";
            LlVersion.LinkColor = System.Drawing.Color.Red;
        }

        void LlVersion_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            XYProcess.Website.StartOfficial();
        }

        void BtnStartXYWE_Click(object sender, EventArgs e)
        {
            // Change Text
            var text = BtnStartXYWE.Text;
            BtnStartXYWE.Text = "正在启动XYWE中……";

            // Refresh Tip
            XYTip.Refresh();

            // Sync Source
            XYFile.SyncDirectory(XYPath.Dir.SourceJass, XYPath.Dir.EditorJass);
            XYFile.SyncDirectory(XYPath.Dir.SourceMpq, XYPath.Dir.EditorShareMpq);
            XYFile.SyncDirectory(XYPath.Dir.SourcePlugin, XYPath.Dir.EditorPlugin);
            XYFile.SyncDirectory(XYPath.Dir.SourceScript, XYPath.Dir.EditorShareScript, ignoreFileName: new[] { "uiloader.lua", "ydwe_on_startup.lua" });

            // Compile UI
            XYFile.Compile(XYPath.Dir.SourceUi + @"\base\TriggerData", XYPath.Dir.EditorShareMpq + @"\base\TriggerData.txt");
            XYFile.Compile(XYPath.Dir.SourceUi + @"\base\TriggerStrings", XYPath.Dir.EditorShareMpq + @"\base\TriggerStrings.txt");
            XYFile.Compile(XYPath.Dir.SourceUi + @"\base\WorldEditStrings", XYPath.Dir.EditorShareMpq + @"\base\WorldEditStrings.txt");

            // Compile Script
            XYFile.Compile(XYPath.Dir.SourceScript + @"\uiloader.lua", XYPath.Dir.EditorShareScript + @"\uiloader.lua");
            XYFile.Compile(XYPath.Dir.SourceScript + @"\ydwe_on_startup.lua", XYPath.Dir.EditorShareScript + @"\ydwe_on_startup.lua");

            // Recover Text
            BtnStartXYWE.Text = text;

            // Start XYWE
            XYProcess.Application.StartXYWE();
        }

        void BtnXYCodeLibraryManager_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYCodeLibraryManager();
        }

        void BtnXYUILibraryManager_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYMpqLibraryManager();
        }

        private void BtnXYTextColorMaker_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYTextColorMaker();
        }

        private void BtnXYTriggerSyntaxHighlighter_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYTriggerSyntaxHighlighter();
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            XYProcess.Website.StartCommunity();
        }
    }
}
