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

namespace XYMapCreator
{
    public partial class FormXYMapCreator : Form
    {
        private List<string> mapTemplateNameList;

        public FormXYMapCreator()
        {
            InitializeComponent();
        }

        private void FormXYMapCreator_Load(object sender, EventArgs e)
        {
            RefreshTemplateList();
        }

        private void RefreshTemplateList()
        {
            lbMapType.Items.Clear();
            mapTemplateNameList = XYMapTemplate.GetMapTemplateNameList();
            bool idMode = true;
            string display = "";
            mapTemplateNameList.ForEach(value =>
            {
                if (idMode)
                {
                    display = value;
                }
                else
                {
                    display = value + "|" + display;
                    lbMapType.Items.Add(display);
                }
                idMode = !idMode;
            });
        }

        private string GetIdOfConfigName(string display)
        {
            var group = display.Split('|');
            return group[group.Length - 1];
        }

        private void lbMapType_SelectedIndexChanged(object sender, EventArgs e)
        {
            var name = GetIdOfConfigName((string)lbMapType.SelectedItem);
            var config = XYMapTemplate.GetMapTemplateData(name);

            tbAuthor.Text = config.author;
            tbDescription.Text = config.description;
            tbVersion.Text = config.version;
        }

        private void btnCreate_Click(object sender, EventArgs e)
        {

        }
    }
}
