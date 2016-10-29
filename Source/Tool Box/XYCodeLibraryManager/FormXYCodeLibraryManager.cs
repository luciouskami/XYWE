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

namespace XYCodeLibraryManager {
    public partial class FormXYCodeLibraryManager : Form {
        public FormXYCreateCodeLibrary formXYCreateCodeLibrary = null;
        public string delaySelectCodeLibraryName = null;

        public FormXYCodeLibraryManager() {
            InitializeComponent();
        }

        private void FormXYCodeLibraryManager_Load(object sender, EventArgs e) {
            CodeLibrary.LoadExistsFromDisk();
            RefreshLbCodeLibrary();
        }

        private void FormXYCodeLibraryManager_Activated(object sender, EventArgs e) {
            RefreshLbCodeLibrary();
        }

        private void BtnCreateCodeLibrary_Click(object sender, EventArgs e) {
            if (formXYCreateCodeLibrary == null) {
                formXYCreateCodeLibrary = new FormXYCreateCodeLibrary();
                formXYCreateCodeLibrary.Visible = true;
                formXYCreateCodeLibrary.BringToFront();
                formXYCreateCodeLibrary.SucceedCreateCodeLibrary += libName => {
                    delaySelectCodeLibraryName = libName;
                };
                formXYCreateCodeLibrary.Disposed += (p1, p2) => {
                    formXYCreateCodeLibrary = null;
                };
            }
            else {
                formXYCreateCodeLibrary.WindowState = FormWindowState.Normal;
            }
            formXYCreateCodeLibrary.BringToFront();
        }

        private void BtnDeleteCodeLibrary_Click(object sender, EventArgs e) {
            var libName = LbCodeLibrary.Text;
            var lastSelectCodeLibraryIndex = LbCodeLibrary.SelectedIndex;
            LbCodeLibrary.SelectedIndex = -1;
            if (libName == "") {
                MessageBox.Show("你必须先选择一个代码库");
            }
            else if (CodeLibrary.Exists(libName)) {
                CodeLibrary.Delete(libName);
            }
            RefreshLbCodeLibrary(lastSelectCodeLibraryIndex);
        }

        private void BtnEditCodeLibraryMain_Click(object sender, EventArgs e) {
            var libName = LbCodeLibrary.Text;
            if (libName == "") {
                MessageBox.Show("你必须先选择一个代码库");
                return;
            }
            CodeLibrary.OpenMain(libName);
        }

        private void BtnBrowseCodeLibraryDirectory_Click(object sender, EventArgs e) {
            var libName = LbCodeLibrary.Text;
            if (libName == "") {
                MessageBox.Show("你必须先选择一个代码库");
                return;
            }
            CodeLibrary.OpenDirectory(libName);
        }

        private void BtnRefreshCodeLibrary_Click(object sender, EventArgs e) {
            var libName = LbCodeLibrary.Text;
            if (libName == "") {
                MessageBox.Show("你必须先选择一个代码库");
                return;
            }
            try {
                CodeLibrary.Refresh(libName);
                MessageBox.Show("代码库 " + libName + " 刷新成功！");
            }
            catch {
                MessageBox.Show("代码库 " + libName + " 刷新失败，到Wow9.Org反馈问题。\r\n（请注意附上错误的文件和截图，最好能够直接将编辑器目录打包反馈）");
            }
        }

        private void BtnPackCodeLibrary_Click(object sender, EventArgs e) {
            var libName = LbCodeLibrary.Text;
            if (libName == "") {
                MessageBox.Show("你必须先选择一个代码库");
                return;
            }
            CodeLibrary.Pack(libName);
        }

        private void RefreshLbCodeLibrary(int? lastSelectCodeLibraryIndex = null) {
            if (lastSelectCodeLibraryIndex == null) lastSelectCodeLibraryIndex = LbCodeLibrary.SelectedIndex;
            LbCodeLibrary.Items.Clear();
            CodeLibrary.listExists.ForEach(name => {
                LbCodeLibrary.Items.Add(name);
            });
            if (delaySelectCodeLibraryName != null) {
                LbCodeLibrary.SelectedItem = delaySelectCodeLibraryName;
                delaySelectCodeLibraryName = null;
            }
            else if (lastSelectCodeLibraryIndex >= 0) {
                LbCodeLibrary.SelectedIndex = Math.Min((int)lastSelectCodeLibraryIndex, LbCodeLibrary.Items.Count - 1);
            }
            else if (LbCodeLibrary.Items.Count > 0) {
                LbCodeLibrary.SelectedIndex = 0;
            }
        }
    }
}
