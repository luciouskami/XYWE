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
                this.mainPath = sourcePath + "." + Extension; // 先假设COMPILE/IMPORT的文件没有填写后缀名
                if (!File.Exists(this.mainPath))
                {
                    // 如果填写了后缀名，就会找不到文件，因此将sourcePath不作处理直接重新赋值给mainPath
                    this.mainPath = sourcePath;
                }
                this.sourcePath = Path.GetDirectoryName(this.mainPath);
            }
            this.variables = variables != null ? variables : XYInfo.CompilerDefaultVariables;
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
            string encode = "", value;
            if (name.Contains('@'))
            {
                var info = name.Split('@');
                name = info[0];
                encode = info[1];
            }
            
            if (variables != null && variables.ContainsKey(name))
                value = variables[name];
            else if (parent != null)
                value = parent.AnalyVariable(name);
            else
                throw new KeyNotFoundException("Unknown Variable Name: " + name);

            if (encode == "ANSI")
                return XYEncoding.UTF8_to_ANSI(value);
            else if (encode == "") // Default: UTF8
                return value;
            else
                throw new EncoderFallbackException("Unknown Encoding Type: " + encode);
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
