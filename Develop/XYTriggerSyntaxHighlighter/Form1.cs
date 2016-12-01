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
using System.IO;

namespace XYTriggerSyntaxHighlighter
{
    public partial class XYTriggerSyntaxHighlighter : Form
    {
        public XYTriggerSyntaxHighlighter()
        {
            InitializeComponent();
        }

        DirectoryInfo dirStyleBase;
        List<DirectoryInfo> dirStyle;

        private void Form1_Load(object sender, EventArgs e)
        {
            try
            {
                dirStyleBase = new DirectoryInfo(XYPath.Dir.EditorPluginTeshStyle);
                dirStyle = dirStyleBase.GetDirectories().ToList();

                dirStyle.ForEach(style =>
                {
                    comboBox1.Items.Add(style.Name);
                });

                comboBox1.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.GetType() + "\r\n" +  ex.Message);
                Application.Exit();
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                var style = (string)comboBox1.SelectedItem;
                var dir = dirStyle.Where(d => d.Name == style).First();
                var files = dir.GetFiles("*");
                files.ToList().ForEach(file => {
                    file.CopyTo(XYPath.Dir.EditorPluginTesh + @"\" + file.Name, true);
                });
                MessageBox.Show("应用成功");
            }
            catch (Exception ex)
            {
                MessageBox.Show("应用时出现错误：" + ex.GetType() + "\r\n" + ex.Message);
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (comboBox1.SelectedIndex)
            {
                case 0: pictureBox1.Image = Properties.Resources._default; break;
                case 1: pictureBox1.Image = Properties.Resources.monokai; break;
                default: pictureBox1.Image = null; break;
            }
        }
    }
}
