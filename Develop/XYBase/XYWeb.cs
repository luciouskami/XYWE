﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Windows.Forms;
using System.IO.Compression;
using System.Net.Http;
using System.Threading;

namespace XYBase
{
    public static class XYWeb
    {
#if DEBUG
        static string xyweServerAddress = "http://127.0.0.1:82/xywe_server";
#else
        static string xyServerAddress = "https://wow9.org/xywe_server";
#endif

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
        public static async void DownloadFileAsync(string address, string localFileName, Action successAction, Action<int> retryAction = null, Action failedAction = null, int cacheTime = 2592000)
        {
            using (var wc = new WebClient())
            {
                wc.Headers.Set(HttpRequestHeader.UserAgent, "XYWE"); // Server deny if no UserAgent
                
                int retry = 0, retryCount = 5;

                Retry:
                var task = wc.DownloadFileTaskAsync(new Uri(address), localFileName);
                try
                {
                    await task;
                    successAction();
                }
                catch (Exception e)
                {
                    if (++retry <= retryCount)
                    {
                        retryAction?.Invoke(retry);
                        await Task.Delay(1000);
                        goto Retry;
                    }
                    failedAction?.Invoke();
#if DEBUG
                    MessageBox.Show("下载文件数据失败: " + e.Message);
#endif
                }
            }
        }
        /// <summary>
        /// <para>默认缓存30天</para>
        /// </summary>
        public static async void ReadTextAsync(string address, Action<string> successAction, Action<int> retryAction = null, Action failedAction = null, int cacheTime = 2592000)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("User-Agent", "XYWE");
#if DEBUG
                cacheTime = 0; // 测试版不使用缓存，发布版默认使用30天的缓存时间
#endif
                client.DefaultRequestHeaders.Add("Cache-Control", "max-age=" + cacheTime);

                int retry = 0, retryCount = 5;

                Retry:
                var task = client.GetStringAsync(address);
                string content = "";
                try
                {
                    content = await task;
                    successAction(content);
                }
                catch (Exception e)
                {
                    if (++retry <= retryCount)
                    {
                        retryAction?.Invoke(retry);
                        await Task.Delay(1000);
                        goto Retry;
                    }
                    failedAction?.Invoke();
#if DEBUG
                    MessageBox.Show("下载文件数据失败: " + e.Message);
                    // throw new HttpRequestException(); 会在不相关的位置报错，原因待研究
#endif
                }
            }
        }

        public static void DownloadXYWikiTextAsync(string xyweSubPageName, Action<List<string>> successAction, Encoding encode = null)
        {
            if (encode == null) encode = Encoding.UTF8;

            DownloadDataAsync($"https://xywiki.com/?title=XYWE:{xyweSubPageName}&action=edit", data =>
            {
                var page = encode.GetString(data).Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);

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

            DownloadDataAsync($"{xyweServerAddress}/{path}", data =>
            {
                successAction(encode.GetString(data).Split(new[] { "\r\n", "\n" }, StringSplitOptions.None).ToList());
            });
        }
        public static void DownloadXyweServerFileAsync(string path, string localFileName, Action successAction, Action<int> retryAction = null, Action failedAction = null, int cacheTime = 2592000)
        {
            DownloadFileAsync($"{xyweServerAddress}/{path}", localFileName, successAction, retryAction, failedAction, cacheTime);
        }

        /// <summary>
        /// <para>默认缓存30天</para>
        /// </summary>
        public static void ReadXyweServerTextAsync(string path, Action<string> successAction, Action<int> retryAction = null, Action failedAction = null, int cacheTime = 2592000)
        {
            ReadTextAsync($"{xyweServerAddress}/{path}", successAction, retryAction, failedAction, cacheTime);
        }
    }
}
