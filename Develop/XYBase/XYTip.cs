using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Windows.Forms;

namespace XYBase
{
    public static class XYTip
    {
        static List<string> _tips;
        static List<string> tips
        {
            get
            {
                if (_tips == null)
                    _tips = new List<string>(File.ReadAllText(XYPath.File.XyweTip).Split(new[] { "\n" }, StringSplitOptions.RemoveEmptyEntries));
                return _tips;
            }
        }

        public static void Refresh()
        {
            List<int> usedTipIndex = new List<int>();
            List<int> usableTipIndex = new List<int>();

            foreach (var indexText in XYIni.Tips["UsedIndex"].Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries))
            {
                var index = Convert.ToInt32(indexText);
                if (index < tips.Count)
                    usedTipIndex.Add(index);
            }
            if (usedTipIndex.Count == tips.Count)
            {
                usedTipIndex.Clear();
                XYIni.Tips["UsedIndex"] = "";
            }
            for (int i = 0; i < tips.Count; i++)
                if (!usedTipIndex.Contains(i))
                    usableTipIndex.Add(i);

            var tipIndex = usableTipIndex[XYRandom.GetNonnegativeInteger(usableTipIndex.Count)];
            var tipId = tipIndex + 1;
            var area1 = $"Tip {tipId}/{tips.Count} {tips[tipIndex]}";
            var area2 = "";
            var area3 = "";

            File.WriteAllText(XYPath.File.XyweTip,
                $"WESTRING_WELCOME_SMALLTEXT1=\"{area1}\"\r\n" +
                $"WESTRING_WELCOME_SMALLTEXT2=\"{area2}\"\r\n" +
                $"WESTRING_WELCOME_LEGALTEXT=\"{area3}\"", Encoding.UTF8);
            XYIni.Tips["UsedIndex"] = $"{XYIni.Tips["UsedIndex"]},{tipIndex}";
        }

        public static void UpdateTipAsync()
        {
            // Only updated once a day
            if (DateTime.Now.Subtract(DateTime.Parse(XYIni.Tips["LastCheckTime"])).Days == 0) return;
            XYIni.Tips["LastCheckTime"] = DateTime.Now.ToString();

            XYWeb.DownloadXYWikiTextAsync("Tip库", data =>
            {
                var timeText = data[0];
                data.RemoveAt(0);

                for (int i = 0; i < data.Count; i++) data[i] = data[i].Remove(0, 2);

                var serverTime = DateTime.Parse(timeText);
                if (serverTime.Subtract(DateTime.Parse(XYIni.Tips["LastUpdateTime"])).TotalSeconds > 0)
                {
                    File.WriteAllLines(XYPath.File.XyweTip, data);
                    XYIni.Tips["LastUpdateTime"] = timeText;
                }
            });
        }
    }
}
