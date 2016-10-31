using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;

namespace XYBase
{
    public static class XYWeb
    {
        public static void DownloadDataAsync(string address, Action<byte[]> successAction)
        {
            using (var wc = new WebClient())
            {
                wc.Headers.Set(HttpRequestHeader.UserAgent, "XYWE"); // Server deny if no UserAgent
                var task = wc.DownloadDataTaskAsync(new Uri(address));
                task.ContinueWith(t =>
                {
                    try
                    {
                        if (t.Exception != null) return;

                        successAction(t.Result);
                    }
                    catch
                    {
                        // MessageBox.Show(e.Message);
                    }
                });
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
    }
}
