using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;
using Microsoft.VisualBasic;
using XYBase;

namespace XYMpqLibraryManager {
    public partial class FormXYMpqLibraryManager : Form {
        private FormXYCreateMpqLibrary formXYCreateMpqLibrary = null;
        private string selectUI = "";
        private bool ignoreCheck = false;

        public FormXYMpqLibraryManager() {
            InitializeComponent();
            Disposed += FormXYMpqLibraryManager_Disposed;
        }

        private void FormXYMpqLibraryManager_Disposed(object sender, EventArgs e) {
            XYMpq.SaveEnable();
            XYMpq.SaveExistSort();
        }

        private void FormXYMpqLibraryManager_Load(object sender, EventArgs e) {
            LoadUIAndRefreshCheckedListBox();
        }

        private void FormXYMpqLibraryManager_Activated(object sender, EventArgs e) {
            LoadUIAndRefreshCheckedListBox();
            XYMpq.SaveEnable();
        }

        private void ClbUI_SelectedIndexChanged(object sender, EventArgs e) {
            if (ClbUI.SelectedIndex == -1) return;
            RefreshSelectUI();
        }

        private void ClbUI_ItemCheck(object sender, ItemCheckEventArgs e) {
            if (ignoreCheck) return;

            var name = (string)ClbUI.Items[e.Index];
            switch (e.NewValue) {
                case CheckState.Unchecked: {
                    if (XYMpq.listEnable.Contains(name)) XYMpq.listEnable.Remove(name);
                    break;
                }
                case CheckState.Checked: {
                    if (!XYMpq.listEnable.Contains(name)) XYMpq.listEnable.Add(name);
                    break;
                }
            }

            XYMpq.SaveEnable();
            XYMpq.SaveExistSort();
        }

        private void BtnEditClass_Click(object sender, EventArgs e) {
            if (selectUI == "") {
                MessageBox.Show("你必须先选择一个UI");
                return;
            }
            TryEditXlsx("Class");
        }

        private void BtnEditFunction_Click(object sender, EventArgs e) {
            if (selectUI == "") {
                MessageBox.Show("你必须先选择一个UI");
                return;
            }
            TryEditXlsx("Function");
        }

        private void BtnRefreshLibraryUI_Click(object sender, EventArgs e) {
            if (selectUI == "") {
                MessageBox.Show("你必须先选择一个UI");
                return;
            }
            RefreshLibraryUI();

            XYMpq.SaveEnable();
            XYMpq.SaveExistSort();
        }

        private void BtnCreate_Click(object sender, EventArgs e) {
            if (formXYCreateMpqLibrary == null) {
                formXYCreateMpqLibrary = new FormXYCreateMpqLibrary();
                formXYCreateMpqLibrary.Visible = true;
                formXYCreateMpqLibrary.Disposed += new EventHandler((obj, args) => {
                    if (formXYCreateMpqLibrary.success) {
                        LoadUIAndRefreshCheckedListBox();
                        ClbUI.SelectedIndex = ClbUI.Items.IndexOf(formXYCreateMpqLibrary.uiName);
                    }
                    formXYCreateMpqLibrary = null;
                });
            }
            else {
                formXYCreateMpqLibrary.WindowState = FormWindowState.Normal;
            }
            formXYCreateMpqLibrary.BringToFront();
        }

        private void BtnDelete_Click(object sender, EventArgs e) {
            if (selectUI == "") {
                MessageBox.Show("你必须先选择一个UI");
                return;
            }
            else {
                var result = MessageBox.Show("点击确定将会删除函数库UI：" + selectUI, "确认删除函数库UI", MessageBoxButtons.YesNo);
                if (result == DialogResult.Yes) {
                    Microsoft.VisualBasic.FileIO.FileSystem.DeleteDirectory(
                        XYPath.Dir.MpqLib(selectUI),
                        Microsoft.VisualBasic.FileIO.UIOption.OnlyErrorDialogs,
                        Microsoft.VisualBasic.FileIO.RecycleOption.SendToRecycleBin);
                    LoadUIAndRefreshCheckedListBox();
                }
            }
        }

        private void LoadUIAndRefreshCheckedListBox() {
            XYMpq.LoadExist();
            XYMpq.LoadExistSort();
            XYMpq.LoadEnable();
            RefreshCheckedList();
            ReSelectItemIfExist();
        }

        private void RefreshCheckedList() {
            ClbUI.Items.Clear();

            XYMpq.listExistSort.ForEach(ui => {
                ClbUI.Items.Add(ui);
            });

            ignoreCheck = true;
            XYMpq.listEnable.ForEach(ui => {
                ClbUI.SetItemChecked(ClbUI.Items.IndexOf(ui), true);
            });
            ignoreCheck = false;
        }

        private void ReSelectItemIfExist() {
            var index = ClbUI.Items.IndexOf(selectUI);
            if (index != -1) {
                ClbUI.SelectedIndex = index;
            }
            else {
                selectUI = "";
            }
        }

        private void TryEditXlsx(string xlsxName) {
            var path = XYPath.Dir.MpqUi(selectUI) + @"\" + xlsxName + @".xlsx";
            if (File.Exists(path)) {
                Process.Start(path);
            }
            else {
                ShowNotFindXlsxError(path);
            }
        }

        private void RefreshSelectUI() {
            selectUI = ClbUI.GetItemText(ClbUI.Items[ClbUI.SelectedIndex]);
        }

        private void RefreshLibraryUI() {
            XYMpq.SaveEnable();
            XYMpq.SaveExistSort();

            var dirUI = XYPath.Dir.MpqUi(selectUI);

            var fileClass = dirUI + @"\Class.xlsx";
            if (!File.Exists(fileClass)) { ShowNotFindXlsxError(fileClass); return; }

            var fileFunction = dirUI + @"\Function.xlsx";
            if (!File.Exists(fileFunction)) { ShowNotFindXlsxError(fileFunction); return; }

            var uc = new UIConverter(dirUI);
            uc.Convert();

            MessageBox.Show("成功刷新UI：" + selectUI);
        }

        private void ShowNotFindXlsxError(string path) {
            MessageBox.Show("没有找到表格" + path + "，本编辑器只支持按照咸鱼函数库规范制作的UI。\r\n\r\n通过右下角的链接查看咸鱼函数库规范。");
        }

        private void BtnBrowseDirectory_Click(object sender, EventArgs e) {
            if (selectUI == "") {
                MessageBox.Show("你必须先选择一个UI");
                return;
            }
            Process.Start(XYPath.Dir.MpqUi(selectUI));
        }

        private void BtnHigher_Click(object sender, EventArgs e) {
            if (selectUI == "") {
                MessageBox.Show("你必须先选择一个UI");
                return;
            }
            XYMpq.HigherExistSort(selectUI);
            LoadUIAndRefreshCheckedListBox();
        }

        private void BtnLower_Click(object sender, EventArgs e) {
            if (selectUI == "") {
                MessageBox.Show("你必须先选择一个UI");
                return;
            }
            XYMpq.LowerExistSort(selectUI);
            LoadUIAndRefreshCheckedListBox();
        }
    }
}
