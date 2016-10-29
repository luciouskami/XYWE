using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Windows.Forms;

namespace XYBase {
    public static class XYMpq {
        public static readonly string pathRoot = XYPath.Dir.Ydwe + @"\share\mpq";
        public static readonly string pathConfig = pathRoot + @"\config";
        public static readonly string pathSort = pathRoot + @"\sort";

#if DEBUG
        public static readonly List<string> listSystemDirectory = new List<string>(new[] { "units", "xywe" });
        public static readonly List<string> listSystemLibrary = new List<string>();
#else
        public static readonly List<string> listSystemDirectory = new List<string>(new[] { "units", "base", "xywe" });
        public static readonly List<string> listSystemLibrary = new List<string>(new[] { "base", "xywe" });
#endif
        public static readonly List<string> listExist = new List<string>();
        public static readonly List<string> listEnable = new List<string>();
        public static List<string> listDisable { get { return listExist.Except(listEnable).ToList(); } }
        public static readonly List<string> listExistSort = new List<string>();

        public static bool IsSystemDirectory(string name) {
            return listSystemDirectory.Contains(name);
        }

        public static bool IsSystemLibrary(string name) {
            return listSystemLibrary.Contains(name);
        }

        public static bool IsExist(string name) {
            return listExist.Contains(name);
        }

        public static bool IsEnable(string name) {
            return listEnable.Contains(name);
        }

        public static void LoadExist() {
            listExist.Clear();
            new DirectoryInfo(XYPath.Dir.Mpq).GetDirectories().ToList().ForEach(subDir => {
                if (!IsSystemDirectory(subDir.Name)) {
                    listExist.Add(subDir.Name);
                }
            });
        }

        public static void LoadExistSort() {
            listExistSort.Clear();
            File.ReadAllLines(XYPath.File.MpqSort, Encoding.UTF8).ToList().ForEach(name => {
                if (IsSystemDirectory(name) || name == "" || !IsExist(name)) return;
                listExistSort.Add(name);
            });
            listExist.ForEach(name => {
                if (!listExistSort.Contains(name)) {
                    listExistSort.Add(name);
                }
            });
            SaveExistSort();
        }

        public static void SaveExistSort() {
            File.WriteAllLines(XYPath.File.MpqSort, listExistSort, Encoding.UTF8);
        }

        private static void ChangeExistSort(string name, int dir) {
            var index = listExistSort.IndexOf(name);
            var item = listExistSort[index];
            var targetIndex = index + dir;
            if (targetIndex >= listExistSort.Count) {
                targetIndex = listExistSort.Count - 1;
            }
            else if (targetIndex < 0) {
                targetIndex = 0;
            }
            listExistSort.RemoveAt(index);
            listExistSort.Insert(targetIndex, item);
            SaveExistSort();
            SaveEnable();
        }
        public static void HigherExistSort(string name) {
            ChangeExistSort(name, -1);
        }
        public static void LowerExistSort(string name) {
            ChangeExistSort(name, +1);
        }

        public static void LoadEnable() {
            listEnable.Clear();
            File.ReadAllLines(XYPath.File.MpqConfig, Encoding.UTF8).ToList().ForEach(name => {
                if (IsSystemDirectory(name) || name == "" || !IsExist(name)) return;
                listEnable.Add(name);
            });
        }

        public static void SaveEnable() {
            var enables = new List<string>(listSystemLibrary);
            foreach (var enable in listEnable) enables.Add(enable);
            var enablesSort = new List<string>(listSystemLibrary);
            listExistSort.ForEach(match => {
                if (enables.Contains(match)) {
                    enablesSort.Add(match);
                }
            });
            File.WriteAllLines(XYPath.File.MpqConfig, enablesSort, Encoding.UTF8);
        }

        public static void Create(string name) {
            var pathMpqUi = XYPath.Dir.MpqUi(name);
            XYFile.CopyDirectory(XYPath.Dir.MpqUiTemplateXywe, pathMpqUi);
            SaveEnable();
        }

        public static string TriggerDataPatchWorldEditStrings(string pathTriggerData, string pathWorldEditStrings)
        {
            return "";
        }
    }
}
