using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace XYBase {
    public class UIConverter {
        public string uiPath;
        public UIConverter(string uiPath) {
            this.uiPath = uiPath;
        }

        List<List<string>> tableClass;
        List<List<string>> tableFunction;

        class APIClass {
            public string name;
            public string mark;
            public string iconPath;
        }
        class API {
            public string className;
            public string displayName;
            public string paramRule;
            public string editorTip;
            public string functionName;
            public string returnType;
            public string paramType;
            public string paramDefaultValue;
            public int paramCount;
        }
        List<APIClass> apiClassList = new List<APIClass>();
        List<API> apiActionList = new List<API>();
        List<API> apiFunctionList = new List<API>();
        Dictionary<string, string> classNameToMark = new Dictionary<string, string>();

        public void Convert() {
            GetFile();
            AnalyClass();
            AnalyFunction();
            MakeTriggerData();
            MakeTriggerStrings();
        }
        void GetFile() {
            tableClass = XYFile.LoadXlsx(uiPath + @"\Class.xlsx");
            tableFunction = XYFile.LoadXlsx(uiPath + @"\Function.xlsx");
        }
        void AnalyClass() {
            for (int i = 1; i < tableClass.Count; i++) {
                AnalyClassLine(tableClass[i]);
            }
        }
        void AnalyClassLine(List<string> line) {
            var apiClass = new APIClass();
            apiClass.name = line[0];
            apiClass.mark = line[1];
            apiClass.iconPath = line[2];
            classNameToMark.Add(apiClass.name, apiClass.mark);
            apiClassList.Add(apiClass);
        }
        void AnalyFunction() {
            for (int i = 1; i < tableFunction.Count; i++) {
                AnalyFunctionLine(tableFunction[i]);
            }
        }
        void AnalyFunctionLine(List<string> line) {
            var api = new API();
            api.className = line[0];
            api.displayName = line[1];
            var originParamRule = line[2];
            var originParamRuleGroup = originParamRule.Split(',');
            string paramRule = "";
            foreach (var paramRuleSingle in originParamRuleGroup) {
                if (paramRuleSingle[0] != '~') {
                    paramRule += '"' + paramRuleSingle + '"';
                }
                else {
                    paramRule += paramRuleSingle;
                }
                paramRule += ",";
            }
            api.paramRule = paramRule.Remove(paramRule.Length - 1);
            api.editorTip = line[3];
            api.functionName = line[4];
            api.returnType = line[5];
            api.paramCount = line[6].Split(new[] { "\r\n", "\n" }, StringSplitOptions.None).Length;
            api.paramType = line[6].Replace("\r\n", ",").Replace("\n", ",");
            api.paramDefaultValue = line[7].Replace("\r\n", ",").Replace("\n", ","); // TODO 解决这里可能因为\N造成的BUG
            if (api.returnType == "nothing") {
                apiActionList.Add(api);
            }
            else {
                apiFunctionList.Add(api);
                if (api.returnType[0] == '&') {
                    api.returnType = api.returnType.Replace("&", "");
                    apiActionList.Add(api);
                }
            }
        }
        void MakeTriggerData() {
            var output = "";
            output += "[TriggerCategories]";
            foreach (var single in apiClassList) {
                output += string.Format(
                    "\r\n{0}={1},{2}",
                    single.mark, single.name, single.iconPath);
            }
            output += "\r\n" + "[TriggerCalls]";
            foreach (var single in apiFunctionList) {
                output += string.Format(
                    "\r\n{0}=0,1,{1},{2}" +
                    "\r\n_{0}_Defaults={3}" +
                    "\r\n_{0}_Category={4}",
                    single.functionName, single.returnType, single.paramType,
                    single.paramDefaultValue, classNameToMark[single.className]);
            }
            output += "\r\n" + "[TriggerActions]";
            foreach (var single in apiActionList) {
                output += string.Format(
                    "\r\n{0}=0,{1}" +
                    "\r\n_{0}_Defaults={2}" +
                    "\r\n_{0}_Category={3}",
                    single.functionName, single.paramType,
                    single.paramDefaultValue, classNameToMark[single.className]);
            }
            File.WriteAllText(uiPath + @"\TriggerData.txt", output);
        }
        void MakeTriggerStrings() {
            var output = "";
            output += "[TriggerCallStrings]";
            foreach (var single in apiFunctionList) {
                output += string.Format(
                    "\r\n{0}=\"{1}\"" +
                    "\r\n{0}={2}" +
                    "\r\n{0}Hint=\"{3}\"",
                    single.functionName, single.displayName,
                    single.paramRule, single.editorTip);
            }
            output += "\r\n" + "[TriggerActionStrings]";
            foreach (var single in apiActionList) {
                output += string.Format(
                    "\r\n{0}=\"{1}\"" +
                    "\r\n{0}={2}" +
                    "\r\n{0}Hint=\"{3}\"",
                    single.functionName, single.displayName,
                    single.paramRule, single.editorTip);
            }
            File.WriteAllText(uiPath + @"\TriggerStrings.txt", output);
        }
    }
}
