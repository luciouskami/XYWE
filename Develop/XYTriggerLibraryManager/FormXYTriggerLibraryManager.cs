using XYBase;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace XYTriggerLibraryManager
{
    public partial class FormXYTriggerLibraryManager : Form
    {
        public FormXYTriggerLibraryManager()
        {
            InitializeComponent();
        }
        List<string> listExist, listEnabled, listDisabled;

        private void FormXYTriggerLibraryManager_Load(object sender, EventArgs e)
        {
            LoadPackage();
            RefreshUI();
        }
        private void btnEnable_Click(object sender, EventArgs e)
        {
            var items = lbDisabled.SelectedItems;
            if (items.Count != 1)
            {
                MessageBox.Show("必须选择一个未使用的触发库。");
                return;
            }

            EnablePackage((string)items[0]);
        }
        private void btnDisable_Click(object sender, EventArgs e)
        {
            var items = lbEnabled.SelectedItems;
            if (items.Count != 1)
            {
                MessageBox.Show("必须选择一个使用中的触发库。");
                return;
            }

            DisablePackage((string)items[0]);
        }
        private void btnUp_Click(object sender, EventArgs e)
        {
            var items = lbEnabled.SelectedItems;
            if (items.Count != 1)
            {
                MessageBox.Show("必须选择一个使用中的触发库。");
                return;
            }

            UpSelectPackage();
        }
        private void btnDown_Click(object sender, EventArgs e)
        {
            var items = lbEnabled.SelectedItems;
            if (items.Count != 1)
            {
                MessageBox.Show("必须选择一个使用中的触发库。");
                return;
            }

            DownSelectPackage();
        }

        #region Prevent Double Side Select
        bool lbDisabled_PreventNextChange = false;
        private void lbDisabled_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lbDisabled_PreventNextChange)
            {
                lbDisabled_PreventNextChange = false;
                return;
            }

            if (lbEnabled.SelectedIndex != -1)
            {
                lbEnabled_PreventNextChange = true;
                lbEnabled.SelectedIndex = -1;
                lbEnabled.Refresh();
            }
        }
        bool lbEnabled_PreventNextChange = false;
        private void lbEnabled_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lbEnabled_PreventNextChange)
            {
                lbEnabled_PreventNextChange = false;
                return;
            }

            if (lbDisabled.SelectedIndex != -1)
            {
                lbDisabled_PreventNextChange = true;
                lbDisabled.SelectedIndex = -1;
                lbDisabled.Refresh();
            }
        }
        #endregion

        void LoadPackage()
        {
            listExist = XYPackage.GetExist();
            listEnabled = XYPackage.GetEnabled();

            listDisabled = new List<string>();
            listExist.ForEach(name =>
            {
                if (listEnabled.Contains(name)) return;
                listDisabled.Add(name);
            });
        }
        void RefreshUI()
        {
            UpdateDisabledPackageUI();
            UpdateEnabledPackageUI();
        }

        void EnablePackage(string name)
        {
            UpdateEnabledPackageData(name);
            UpdateEnabledPackageUI();
            UpdateDisabledPackageUI();
        }
        void DisablePackage(string name)
        {
            UpdateDisabledPackageData(name);
            UpdateEnabledPackageUI();
            UpdateDisabledPackageUI();
        }
        
        void UpdateEnabledPackageData(string name)
        {
            listEnabled.Add(name);
            listDisabled.Remove(name);
            XYPackage.PatchEnable(listEnabled);
        }
        void UpdateDisabledPackageData(string name)
        {
            listEnabled.Remove(name);
            listDisabled.Add(name);
            XYPackage.PatchEnable(listEnabled);
        }

        void UpdateEnabledPackageUI()
        {
            lbEnabled.Items.Clear();
            listEnabled.ForEach(name =>
            {
                lbEnabled.Items.Add(name);
            });
        }
        void UpdateDisabledPackageUI()
        {
            lbDisabled.Items.Clear();
            listDisabled.ForEach(name =>
            {
                lbDisabled.Items.Add(name);
            });
        }

        void UpSelectPackage()
        {
            var name = (string)lbEnabled.SelectedItem;
            var index = listEnabled.IndexOf(name);
            if (index > 0)
            {
                listEnabled.RemoveAt(index);
                listEnabled.Insert(index - 1, name);
                XYPackage.PatchEnable(listEnabled);
                UpdateEnabledPackageUI();
                lbEnabled.SelectedIndex = index - 1;
            }
        }
        void DownSelectPackage()
        {
            var name = (string)lbEnabled.SelectedItem;
            var maxIndex = listEnabled.Count - 1;
            var index = listEnabled.IndexOf(name);
            if (index < maxIndex)
            {
                listEnabled.RemoveAt(index);
                listEnabled.Insert(index + 1, name);
                XYPackage.PatchEnable(listEnabled);
                UpdateEnabledPackageUI();
                lbEnabled.SelectedIndex = index + 1;
            }
        }
    }
}
