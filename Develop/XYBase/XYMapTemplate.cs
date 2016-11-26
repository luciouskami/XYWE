using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace XYBase
{
    public static class XYMapTemplate
    {
        private const string configFileName = "config.json";

        private static void ForEachTemplateDirectory(ForDirectoryAction forDirectoryAction)
        {
            XYFile.ForEachSubDirectory(XYPath.Dir.SourceTemplate, forDirectoryAction, false);
        }

        public static List<string> GetMapTemplateDirectoryNameList()
        {
            return XYFile.GetSubDirectoriesName(XYPath.Dir.SourceTemplate);
        }
        /// <summary>
        /// Format: [0+2N]id [1+2N]name
        /// </summary>
        /// <returns></returns>
        public static List<string> GetMapTemplateNameList()
        {
            List<string> mapTemplateNameList = new List<string>();
            ForEachTemplateDirectory(fullName =>
            {
                var id = System.IO.Path.GetFileName(fullName);
                var json = XYFile.LoadJson<JsonMapTemplate>(fullName + @"\" + configFileName);
                mapTemplateNameList.AddRange(new[] { id, json.name });
                return false;
            });
            return mapTemplateNameList;
        }

        public static JsonMapTemplate GetMapTemplateData(string name)
        {
            var path = XYPath.Dir.SourceTemplate + $@"\{name}\{configFileName}";
            return XYFile.LoadJson<JsonMapTemplate>(path);
        }
        private static string GetMapTemplateProperty(string name, string propertyName)
        {
            var json = GetMapTemplateData(name);
            return (string)XYUtil.GetObjectPropertyValue(json, propertyName);
        }
        public static string GetMapTemplateAuthor(string name)
        {
            return GetMapTemplateProperty(name, "author");
        }
        public static string GetMapTemplateVersion(string name)
        {
            return GetMapTemplateProperty(name, "version");
        }
        public static string GetMapTemplateDescription(string name)
        {
            return GetMapTemplateProperty(name, "description");
        }
        public static string GetMapTemplateWebsite(string name)
        {
            return GetMapTemplateProperty(name, "website");
        }
    }
}
