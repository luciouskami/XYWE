using System;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public class XYCompiler
    {
        const string Extension = "txt";

        public XYCompiler(string sourcePath, Dictionary<string, string> variables, XYCompiler parent = null)
        {
            if (Directory.Exists(sourcePath))
            {
                // sourcePath是目录
                this.sourcePath = sourcePath;
                this.mainPath = sourcePath + "\\__main__." + Extension;
            }
            else
            {
                // sourcePath是文件
                this.mainPath = sourcePath + "." + Extension;
                this.sourcePath = Path.GetDirectoryName(this.mainPath);
            }
            this.variables = variables != null ? variables : new Dictionary<string, string>();
            this.parent = parent;
        }
        string sourcePath;
        string mainPath;
        Dictionary<string, string> variables;

        XYCompiler parent = null;

        string output;
        List<string> outputContent;
        string outputLine;

        bool modeTrimTab;
        List<string> clearList;
        List<string> content;

        string commandMatchingExpression = @"\[\[@([^\]]+)]]";

        void InitializeOutput()
        {
            outputContent = new List<string>();
            modeTrimTab = false;
            clearList = new List<string>();
            content = new List<string>();
        }

        bool HasMain()
        {
            return File.Exists(mainPath);
        }

        void FillContent()
        {
            content.AddRange(File.ReadAllLines(mainPath, Encoding.UTF8));
        }

        void AnalyContent()
        {
            content.ForEach(AnalyLine);
        }

        void AnalyLine(string line)
        {
            outputLine = line;

            var matches = Regex.Matches(line, commandMatchingExpression);
            List<Command> commands = new List<Command>();
            foreach (Match match in matches) commands.Add(new Command(match.Groups[0].Value));

            foreach (Command command in commands)
            {
                var source = command.source;
                var target = AnalyCommand(command);
                
                outputLine = outputLine.Replace(source, target);
            }

            outputContent.Add(outputLine);
        }

        string AnalyCommand(Command command)
        {
            switch (command.name)
            {
                case "COMPILE-TRIM-TAB":
                    modeTrimTab = true;
                    return "";
                case "COMPILE-CLEAR":
                    clearList.Add(command.param);
                    return "";
                case "IMPORT":
                    return new XYCompiler(sourcePath + "\\" + command.param, null, this).Output();
                case "VAR":
                    return AnalyVariable(command.param);
                default:
                    throw new KeyNotFoundException("Unknown Command: " + command.name);
            }
        }

        string AnalyVariable(string name)
        {
            if (variables != null && variables.ContainsKey(name))
                return variables[name];
            else if (parent != null)
                return parent.AnalyVariable(name);
            else
                throw new KeyNotFoundException("Unknown Variable Name: " + name);
        }

        void CombineOutput()
        {
            output = string.Join("\r\n", outputContent);

            if (modeTrimTab)
            {
                outputContent = output.Split('\n').ToList();
                for (int i = 0; i < outputContent.Count; i++)
                {
                    outputContent[i] = outputContent[i].Trim('\t');
                }
                output = string.Join("\n", outputContent);
            }

            if (clearList.Count > 0)
            {
                foreach (var clear in clearList)
                {
                    output = output.Replace(clear, "");
                }
            }
        }

        public string Output()
        {
            InitializeOutput();
            if (!HasMain()) throw new FileNotFoundException($"This is not a Compileable directory.\r\nMain Path: {mainPath}\r\nSource Path: {sourcePath}");
            FillContent();
            AnalyContent();
            CombineOutput();

            return output;
        }
    }
}
