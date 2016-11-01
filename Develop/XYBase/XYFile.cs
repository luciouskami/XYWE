using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace XYBase
{
    public delegate void ForFileAction(string fullName);
    public delegate void OnSyncSuccessAction(string fullName);
    public delegate void OnCompileSuccessAction(string fullName);

    public static class XYFile
    {
        public static List<List<string>> LoadXlsx(string filePath, string sheetName = "Sheet1")
        {
            // http://blog.163.com/china__xuhua/blog/static/19972316920111028105011136/
            var strConn = string.Format("Provider=Microsoft.Ace.OleDb.12.0; data source={0}; Extended Properties='Excel 12.0; HDR=NO; IMEX=1'", filePath);
            var conn = new System.Data.OleDb.OleDbConnection(strConn);
            conn.Open();
            var ds = new System.Data.DataSet();
            var odda = new System.Data.OleDb.OleDbDataAdapter(string.Format("SELECT * FROM [{0}$]", sheetName), conn);
            odda.Fill(ds, sheetName);
            conn.Close();
            var list = new List<List<string>>();
            var colsCount = ds.Tables[0].Columns.Count;
            var rowsCount = ds.Tables[0].Rows.Count;
            for (int y = 0; y < rowsCount; y++)
            {
                var colList = new List<string>();
                var row = ds.Tables[0].Rows[y];
                for (int x = 0; x < colsCount; x++)
                {
                    var col = row[x];
                    colList.Add(Convert.ToString(col));
                }
                list.Add(colList);
            }
            return list;
        }
        public static void CopyDirectory(string sourcePath, string destinationPath, bool overwrite = false)
        {
            var info = new DirectoryInfo(sourcePath);
            Directory.CreateDirectory(destinationPath);
            foreach (var fsi in info.GetFileSystemInfos())
            {
                var pathDst = destinationPath + @"\" + fsi.Name;
                if (fsi is FileInfo)
                {
                    File.Copy(fsi.FullName, pathDst, overwrite);
                }
                else
                {
                    Directory.CreateDirectory(pathDst);
                    CopyDirectory(fsi.FullName, pathDst, overwrite);
                }
            }
        }
        public static void ForEachFile(string directoryPath, ForFileAction forFileAction)
        {
            var dirInfo = new DirectoryInfo(directoryPath);
            foreach (var fsi in dirInfo.GetFileSystemInfos())
            {
                var fullName = fsi.FullName;
                if (fsi is FileInfo)
                {
                    forFileAction(fullName);
                }
                else
                {
                    ForEachFile(fullName, forFileAction);
                }
            }
        }
        /// <summary>
        /// sourcePath: Directory, targetPath: File
        /// </summary>
        /// <param name="sourcePath"></param>
        /// <param name="targetPath"></param>
        public static void Compile(string sourcePath, string targetPath)
        {
            var compiler = new XYCompiler(sourcePath, null);
            var output = compiler.Output();
            if (!Directory.Exists(targetPath)) Directory.CreateDirectory(Path.GetDirectoryName(targetPath));
            File.WriteAllText(targetPath, output, Encoding.UTF8);
        }
        public static void SyncFile(string sourcePath, string targetPath, OnSyncSuccessAction action = null)
        {
            if (!File.Exists(sourcePath)) throw new FileNotFoundException(sourcePath);

            if (!File.Exists(targetPath) ||
                (File.Exists(targetPath) &&
                    File.GetLastWriteTimeUtc(sourcePath) != File.GetLastWriteTimeUtc(targetPath)))
            {
                var dirPath = Path.GetDirectoryName(targetPath);
                if (!Directory.Exists(dirPath))
                    Directory.CreateDirectory(dirPath);
                File.Copy(sourcePath, targetPath, true);
                action?.Invoke(sourcePath);
            }
        }
        public static void SyncDirectory(string sourcePath, string targetPath, OnSyncSuccessAction action = null, string[] ignoreFileName = null)
        {
            ForEachFile(sourcePath, fullName =>
            {
                var fileName = Path.GetFileName(fullName);
                if (ignoreFileName != null && ignoreFileName.Contains(fileName)) return;
                string _sourcePath = fullName;
                string _targetPath = fullName.Replace(sourcePath, targetPath);
                SyncFile(_sourcePath, _targetPath, action);
            });
        }
    }
}
