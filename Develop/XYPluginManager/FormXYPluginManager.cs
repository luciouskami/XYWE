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

namespace XYPluginManager
{
    public partial class FormXYPluginManager : Form
    {
        public FormXYPluginManager()
        {
            InitializeComponent();
        }

        private void FormXYPluginManager_Load(object sender, EventArgs e)
        {
            PatchConfig(cb启用关键词自动配色, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty.关键词自动配色);
            PatchConfig(cb启用单位技能查找框, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty.单位技能查找框);
            PatchConfig(cb启用物编属性值转换, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty.物编属性转换);
            PatchConfig(cb启用触发名字查找框, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty.触发名称查找框);
            PatchConfig(cb启用触发技能查找框, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty.触发技能查找框);
            PatchConfig(cb启用魔法效果查找框, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty.魔法效果查找框);
            PatchConfig(cb替换原属性输入框, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty.替换原输入框);
            PatchConfig(cb替换原文本输入框, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty.文本框替换);
        }
        private void PatchConfig(CheckBox cb, XYPlugin.RSJB_WE_TextEditor_15_0.ConfigProperty prop)
        {
            cb.Checked = XYPlugin.RSJB_WE_TextEditor_15_0.GetConfig(prop);
        }
    }
}
