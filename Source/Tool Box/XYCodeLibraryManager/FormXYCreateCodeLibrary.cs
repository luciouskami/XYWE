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
using XYBase;

namespace XYCodeLibraryManager {
    public partial class FormXYCreateCodeLibrary : Form {
        public delegate void OnSucceedCreateCodeLibrary(string libName);
        public event OnSucceedCreateCodeLibrary SucceedCreateCodeLibrary;

        public FormXYCreateCodeLibrary() {
            InitializeComponent();
        }

        private void BtnConfirm_Click(object sender, EventArgs e) {
            var newLibName = TbCodeLibraryName.Text;
            if (newLibName == "") {
                MessageBox.Show("请输入代码库名字。");
                FocusTbCodeLibraryName();
            }
            else {
                var firstChar = newLibName[0];
                if (char.IsDigit(firstChar)) {
                    MessageBox.Show("第一个字符不能是数字。");
                    FocusTbCodeLibraryName();
                }
                else if (newLibName.Any(c => !char.IsLetterOrDigit(c) || c.IsChinese())) {
                    MessageBox.Show("名字只允许使用大小写的英文字母和数字。");
                    FocusTbCodeLibraryName();
                }
                else {
                    switch (CodeLibrary.Create(newLibName)) {
                        case CreateState.Success: {
                            SucceedCreateCodeLibrary(newLibName);
                            Dispose();
                            break;
                        }
                        case CreateState.ConflictName: {
                            MessageBox.Show("已存在相同名字的代码库，换一个名字。");
                            FocusTbCodeLibraryName();
                            return;
                        }
                    }
                }
            }
        }
        private void FocusTbCodeLibraryName() {
            TbCodeLibraryName.Focus();
            TbCodeLibraryName.Select(0, 99);
        }
    }
}
