using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.IO.Compression;
using System.Windows.Forms;

namespace XYBase {
    public static class CodeLibrary {
#if DEBUG
        public static string pathRoot = XYPath.Dir.EditorJass + @"\XYLibrary";
#else
        public static string pathRoot = XYPath.Dir.Jass + @"\XYInclude";
#endif

        public static string JassHolder(string name) {
            return
                "// =============================" + "\r\n" +
                "// " + name + "\r\n" +
                "// 由 咸鱼地图编辑器 " + XYInfo.Version + " 于 " + DateTime.Now + " 生成。" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 如果你不知道接下来的修改会造成什么影响，请不要修改下方内容。" + "\r\n" +
                "// 关于如何编写代码库，可以到 http://xianyu.wiki/p/XYWE 找到相关内容。" + "\r\n" +
                "// =============================" + "\r\n" +
                "#ifndef " + name + "Included" + "\r\n" +
                "#define " + name + "Included" + "\r\n" +
                "" + "\r\n" +
#if DEBUG
                "#include \"XYLibrary/" + name +"/Main.j\"" + "\r\n" +
#else
                "#include \"XYInclude/" + name + "/Main.j\"" + "\r\n" +
#endif
                "" + "\r\n" +
                "#endif";
        }
        public static string JassMain(string name) {
            return
                "// =============================" + "\r\n" +
                "// 函数库信息" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 名字：" + name + "" + "\r\n" +
                "// 版本：1.0.0.0" + "\r\n" +
                "// 作者：..." + "\r\n" +
                "// Email：..." + "\r\n" +
                "// ...：..." + "\r\n" +
                "// =============================" + "\r\n" +
                "" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 除非你确切知道接下来所做的修改会造成什么影响，否则不要尝试修改下方的任何内容" + "\r\n" +
                "// =============================" + "\r\n" +
                "" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 导入库区域" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 示例：" + "\r\n" +
                "#include \"XYLibrary/XYBase/XYBase.j\"" + "\r\n" +
                "" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 宏定义区域" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 示例：" + "\r\n" +
                "#define H2I GetHandleId" + "\r\n" +
                "#define SH StringHash" + "\r\n" +
                "" + "\r\n" +
                "//! zinc" + "\r\n" +
                "" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 主逻辑区域" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 示例：" + "\r\n" +
                "library " + name + "Base {" + "\r\n" +
                "    private function A() -> integer {" + "\r\n" +
                "        return 0;" + "\r\n" +
                "    }" + "\r\n" +
                "    public function B() -> integer {" + "\r\n" +
                "        return 1;" + "\r\n" +
                "    }" + "\r\n" +
                "}" + "\r\n" +
                "library " + name + "Debug requires " + name + "Base {" + "\r\n" +
                "    private function onInit() {" + "\r\n" +
                "        BJDebugMsg(I2S(B()));" + "\r\n" +
                "    }" + "\r\n" +
                "}" + "\r\n" +
                "" + "\r\n" +
                "//! endzinc" + "\r\n" +
                "" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 宏定义撤销区域" + "\r\n" +
                "// =============================" + "\r\n" +
                "// 示例：" + "\r\n" +
                "#undef H2I" + "\r\n" +
                "#undef SH" + "\r\n";
        }

        public static readonly List<string> listExists = new List<string>();

        public static CreateState Create(string name) {
            var pathDirLib = pathRoot + @"\" + name;

            if (Directory.Exists(pathDirLib)) return CreateState.ConflictName;

            var pathFileConfig = pathDirLib + @"\" + name + ".cfg";
            var pathFileHolder = pathDirLib + @"\" + name + ".j";
            var pathFileMain = pathDirLib + @"\Main.j";

            Directory.CreateDirectory(pathDirLib);
            File.WriteAllText(pathFileConfig, "", Encoding.Default);
            File.WriteAllText(pathFileHolder, JassHolder(name), Encoding.UTF8);
            File.WriteAllText(pathFileMain, JassMain(name), Encoding.UTF8);
            listExists.Add(name); // 通过管理器创建代码库后，即时刷新存在的代码库列表
            return CreateState.Success;
        }
        public static bool OpenDirectory(string name) {
            var pathDirLib = pathRoot + @"\" + name;

            if (Directory.Exists(pathDirLib)) {
                Process.Start(pathDirLib);
                return true;
            }
            else {
                return false;
            }
        }
        public static bool OpenMain(string name) {
            var pathFileMain = pathRoot + @"\" + name + @"\Main.j";

            if (File.Exists(pathFileMain)) {
                Process.Start(pathFileMain);
                return true;
            }
            else {
                return false;
            }
        }
        public static bool Exists(string name) {
            var pathDirLib = pathRoot + @"\" + name;
            return Directory.Exists(pathDirLib);
        }
        public static void Delete(string name) {
            var pathDirLib = pathRoot + @"\" + name;

            if (Directory.Exists(pathDirLib)) {
                var result = MessageBox.Show("确定要删除代码库 " + name + " 吗？", "删除代码库",
                    MessageBoxButtons.OKCancel, MessageBoxIcon.Warning);
                if (result == DialogResult.OK) {
                    Directory.Delete(pathDirLib, true);
                    listExists.Remove(name); // 通过管理器删除存在的代码库时，同步更新列表，不从本地重新检测
                }
            }
        }
        public static void Refresh(string name) {
            var pathDirLib = pathRoot + @"\" + name;

            var pathFileConfig = pathDirLib + @"\" + name + ".cfg";
            var pathFileHolder = pathDirLib + @"\" + name + ".j";

            var publicFunctions = new List<string>();
            var rePublicFunction = new Regex(@"public function ([a-zA-Z0-9]+)");

            XYFile.ForEachFile(pathDirLib, fullName => {
                var fileName = Path.GetFileName(fullName);
                if (fileName == name + ".cfg" || fileName == name + ".j") return;

                var content = File.ReadAllText(fullName);
                var matches = rePublicFunction.Matches(content);
                foreach (Match match in matches) publicFunctions.Add(match.Groups[1].Value);
            });

            File.WriteAllLines(pathFileConfig, publicFunctions, Encoding.Default);
        }
        public static void Pack(string name) {
            var pathDirLib = pathRoot + @"\" + name;

            var dlg = new SaveFileDialog();
            dlg.Filter = "咸鱼代码库Zip压缩包(*.zip)|*.zip";
            dlg.DefaultExt = "zip";
            dlg.Title = "保存代码库到……";
            dlg.InitialDirectory = Path.GetFullPath(XYPath.Dir.Root);
            dlg.FileName = name;
            dlg.AddExtension = true;
            dlg.OverwritePrompt = true;
            switch (dlg.ShowDialog()) {
                case DialogResult.OK: {
                    ZipFile.CreateFromDirectory(pathDirLib, dlg.FileName, CompressionLevel.Optimal, true);
                    break;
                }
            }
        }
        public static void LoadExistsFromDisk() {
            listExists.Clear();
            if (!Directory.Exists(pathRoot)) Directory.CreateDirectory(pathRoot);
            new DirectoryInfo(pathRoot).GetDirectories().ToList().ForEach(subDir => {
                listExists.Add(subDir.Name);
            });
        }
    }
}
