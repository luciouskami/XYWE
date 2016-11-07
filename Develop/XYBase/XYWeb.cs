using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Windows.Forms;
using System.IO.Compression;

namespace XYBase
{
    public static class XYWeb
    {
        public static async void DownloadDataAsync(string address, Action<byte[]> successAction)
        {
            using (var wc = new WebClient())
            {
                wc.Headers.Set(HttpRequestHeader.UserAgent, "XYWE"); // Server deny if no UserAgent
                var task = wc.DownloadDataTaskAsync(new Uri(address));
                await task;
                if (task.Exception != null) throw task.Exception;
                successAction(task.Result);
            }
        }
        public static async void DownloadFileAsync(string address, string localFileName, Action successAction)
        {
            using (var wc = new WebClient())
            {
                wc.Headers.Set(HttpRequestHeader.UserAgent, "XYWE"); // Server deny if no UserAgent
                var task = wc.DownloadFileTaskAsync(new Uri(address), localFileName);
                await task;
                if (task.Exception != null) throw task.Exception;
                successAction();
            }
        }

        public static void DownloadXYWikiTextAsync(string xyweSubPageName, Action<List<string>> successAction, Encoding encode = null)
        {
            if (encode == null) encode = Encoding.UTF8;

            DownloadDataAsync($"https://xywiki.com/?title=XYWE:{xyweSubPageName}&action=edit", data =>
            {
                var page = encode.GetString(data).Split('\n');

                var texts = new List<string>();
                var read = false;
                foreach (var row in page)
                    if (row == "----")
                        if (!read)
                            read = true;
                        else
                            break;
                    else if (read)
                        texts.Add(row);

                successAction(texts);
            });
        }

        public static void DownloadXyweServerTextAsync(string path, Action<List<string>> successAction, Encoding encode = null)
        {
            if (encode == null) encode = Encoding.UTF8;

            DownloadDataAsync($"https://wow9.org/xywe_server/{path}", data =>
            {
                successAction(encode.GetString(data).Split('\n').ToList());
            });
        }
        public static void DownloadXyweServerFileAsync(string path, string localFileName, Action successAction)
        {
            DownloadFileAsync(path, localFileName, successAction);
        }
    }
}
