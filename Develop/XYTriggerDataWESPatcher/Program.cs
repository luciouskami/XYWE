using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Threading.Tasks;
using XYBase;
using System.Text.RegularExpressions;

namespace XYTriggerDataWESPatcher
{
    class Program
    {
        static void Main(string[] args)
        {
            var triggerDataFilePath = args[0] + "\\TriggerData.txt";
            var worldEditorStringsFilePath = args[0] + "\\WorldEditStrings.txt";

            var triggerDataText = File.ReadAllText(triggerDataFilePath, Encoding.UTF8);
            var worldEditorStringsLines = File.ReadAllLines(worldEditorStringsFilePath, Encoding.UTF8);

            var wesMap = new Dictionary<string, string>();
            foreach (var line in worldEditorStringsLines)
            {
                if (line.Length == 0 || line[0] != 'W') continue;
                var group = line.Split('=');
                var key = group[0];
                var value = group[1];
                wesMap[key] = value;
            }
            
            var reWES = new Regex(@"(WESTRING_[\w_]+)");
            var matchesWES = reWES.Matches(triggerDataText);

            foreach (Match match in matchesWES)
            {
                for (int index = 1; index < match.Groups.Count; index++)
                {
                    var key = match.Groups[index].Value;
                    if (!wesMap.ContainsKey(key))
                    {
                        Console.WriteLine("不存在值的键: {0}", key);
                        Console.ReadKey();
                    }
                    else
                    {
                        var value = wesMap[key];
                        triggerDataText = reWES.Replace(triggerDataText, value, 1);
                        Console.WriteLine("{0}: {1}", key, value);
                    }
                }
            }
            File.WriteAllText(AppDomain.CurrentDomain.BaseDirectory + "\\TriggerData.txt", triggerDataText);

            Console.Write("Count: " + matchesWES.Count);
            Console.ReadKey();
        }
    }
}
