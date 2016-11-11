using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using XYBase;

namespace XYUpdater
{
    /// <summary>
    /// 仅XYUpdater内使用的服务端相关的函数
    /// </summary>
    static class Server
    {
        public static void GetNewestVersion(Action<string> onSuccessAction, Action<int> onRetryAction = null, Action onFailedAction = null)
        {
            XYWeb.ReadXyweServerTextAsync("version/version_new.txt", onSuccessAction, onRetryAction, onFailedAction, 0);
        }
        public static void GetVersionList(Action<string[]> onSuccessAction, Action<int> onRetryAction = null, Action onFailedAction = null)
        {
            XYWeb.ReadXyweServerTextAsync("version/version_list.txt", content =>
            {
                onSuccessAction(content.Split(new[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries));
            }, onRetryAction, onFailedAction, 0);
        }

        public static void GetVersionLog(string versionName, Action<string> onSuccessAction, Action<int> onRetryAction = null, Action onFailedAction = null)
        {
            // TODO 确认是否可使用特殊字符
            XYWeb.ReadXyweServerTextAsync($"version/{versionName}/log.txt", onSuccessAction, onRetryAction, onFailedAction);
        }
        // TODO Get Version Difference
    }
}
