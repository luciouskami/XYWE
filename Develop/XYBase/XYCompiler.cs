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

        public XYCompiler(string sourcePath, Dictionary<string, string> variables = null, XYCompiler parent = null)
        {
            if (Directory.Exists(sourcePath))
            {
                // sourcePath是目录
                this.mainPath = sourcePath + "\\__main__." + Extension;
                if (File.Exists(this.mainPath))
                {
                    // 找到main，执行编译
                    this.sourcePath = sourcePath;
                }
                else
                {
                    // 没找到main，报错
                    // TODO 没找到main，尝试遍历子目录？
                    throw new FileNotFoundException("Can't find __main__.txt at: " + sourcePath);
                }
            }
            else
            {
                // sourcePath是文件
                this.mainPath = sourcePath + "." + Extension; // 先假设COMPILE/IMPORT的文件没有填写后缀名
                if (!File.Exists(this.mainPath))
                {
                    // sourcePath填写了后缀名，将sourcePath不作处理直接赋值给mainPath
                    this.mainPath = sourcePath;
                }
                this.sourcePath = Path.GetDirectoryName(this.mainPath);
            }
            this.variables = variables;
            InheritParent(parent);
        }
        void InheritParent(XYCompiler parent)
        {
            if (parent == null) return;

            if (parent._targetRootPath != null) _targetRootPath = parent._targetRootPath;
            if (parent._modeTrimTab != null) _modeTrimTab = parent._modeTrimTab;
            if (parent._clearList != null) _clearList = new List<string>(parent._clearList);
        }
        string sourcePath;
        string mainPath;
        string _targetRootPath;
        /// <summary>
        /// 会被继承
        /// </summary>
        string targetRootPath
        {
            get
            {
                return _targetRootPath == null ? "" : _targetRootPath;
            }
            set
            {
                _targetRootPath = value;
            }
        }
        Dictionary<string, string> _variables;
        Dictionary<string, string> variables
        {
            get
            {
                if (_variables == null) _variables = new Dictionary<string, string>();
                return _variables;
            }
            set
            {
                _variables = value;
            }
        }

        XYCompiler parent = null;

        string output;
        List<string> outputContent;
        string outputLine;

        bool? _modeTrimTab;
        /// <summary>
        /// 会被继承
        /// </summary>
        bool modeTrimTab
        {
            get
            {
                return _modeTrimTab == true;
            }
            set
            {
                _modeTrimTab = value;
            }
        }

        /// <summary>
        /// 禁用除 END-VAR 以外的命令分析
        /// </summary>
        bool modeBlocking;
        string blockName;
        List<string> blockContent;

        bool modeEqual;
        bool equalBlock;

        List<string> _clearList;
        /// <summary>
        /// 会被继承(克隆)
        /// </summary>
        List<string> clearList
        {
            get
            {
                if (_clearList == null) _clearList = new List<string>();
                return _clearList;
            }
            set
            {
                _clearList = value;
            }
        }
        List<string> content;

        string commandMatchingExpression = @"\[\[@([^\]]+)]]";

        void InitializeOutput()
        {
            outputContent = new List<string>();
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

        /// <summary>
        /// 逐行解析文本和命令
        /// </summary>
        /// <param name="line"></param>
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

            // 1 在块变量模式时不将文本放到输出流
            // 2 只在非EQUAL或者满足EQUAL条件的情况下将文本放到输出流
            if (!modeBlocking
                && (
                    (modeEqual && equalBlock)
                    || !modeEqual))
            {
                // 如果本次编译命令后为空行，则不将本行输出到输出流
                bool isCommandEmptyLine = commands.Count > 0 && outputLine.Length == 0;
                if (!isCommandEmptyLine) outputContent.Add(outputLine);
            }
            else if (modeBlocking) blockContent.Add(outputLine);
        }

        string AnalyCommand(Command command)
        {
            if (command.name[0] == '#') return ""; // 注释符

            switch (command.name)
            {
                case "COMPILE":
                    CompileToPath(sourcePath + "\\" + command.paramGroup[0], command.paramGroup[1]);
                    return "";
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
                case "SET-VAR":
                    if (command.param.Contains(","))
                    {
                        // 行变量模式
                        variables[command.paramGroup[0]] = command.param.Split(new[] { ',' }, 2)[1];
                    }
                    else
                    {
                        // 块变量模式
                        modeBlocking = true;
                        blockName = command.param;
                        blockContent = new List<string>();
                    }
                    return "";
                case "END-VAR":
                    modeBlocking = false;
                    blockContent.RemoveAt(0); // 删除首行空行，这个空行是在SET-VAR被解析时加入的，不需要
                    variables[blockName] = string.Join("\r\n", blockContent);
                    return "";
                case "EQUAL":
                    modeEqual = true;
                    equalBlock = variables[command.paramGroup[0]] == command.paramGroup[1];
                    return "";
                case "END-EQUAL":
                    modeEqual = false;
                    return "";
                case "SET-TARGET-ROOT":
                    if (Path.IsPathRooted(command.param))
                        // 包含根路径，是绝对路径
                        targetRootPath = Path.GetFullPath(command.param);
                    else
                        // 不包含根路径，是相对路径
                        targetRootPath = Path.GetFullPath(sourcePath + "\\" + command.param);
                    return "";
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
            else if (XYInfo.CompilerDefaultVariables.ContainsKey(name))
                value = XYInfo.CompilerDefaultVariables[name];
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

        public string Output(bool executeMode = false)
        {
            InitializeOutput();
            if (!HasMain()) throw new FileNotFoundException($"This is not a Compileable directory.\r\nMain Path: {mainPath}\r\nSource Path: {sourcePath}");
            FillContent();
            AnalyContent();
            if (!executeMode)
            {
                CombineOutput();
                return output;
            }
            else return "";
        }

        void CompileToPath(string sourcePath, string targetPath)
        {
            var compiler = new XYCompiler(sourcePath, parent: this);
            compiler.OutputToPath(targetPath);
        }
        void OutputToPath(string targetRelativePath)
        {
            Output();
            var targetAbsolutePath = GetTargetFullPath(targetRelativePath);
            XYFile.CreateDirectoryForFile(targetAbsolutePath);
            File.WriteAllText(targetAbsolutePath, output);
        }
        string GetTargetFullPath(string targetPath)
        {
            if (Path.IsPathRooted(targetPath))
            {
                // 包含根路径，是绝对路径
                return Path.GetFullPath(targetPath);
            }
            else
            {
                // 不包含根路径，是相对路径（自动补全ROOT）
                return Path.GetFullPath(targetRootPath + "\\" + targetPath);
            }
        }
    }
}
