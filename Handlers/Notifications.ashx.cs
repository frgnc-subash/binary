using System;
using System.Web;
using System.Web.SessionState;
using binary.Core.BLL;

namespace binary.Handlers
{
    // lightweight JSON endpoint used by the notification drawer (no full-page postback)
    public class NotificationsHandler : IHttpHandler, IRequiresSessionState
    {
        public bool IsReusable
        {
            get { return false; }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            if (!AuthBLL.IsLoggedIn)
            {
                Respond(context, 401, false);
                return;
            }

            // plain cross-site form posts can't set this header, which blocks forged requests
            if (context.Request.HttpMethod != "POST" || context.Request.Headers["X-Requested-With"] != "XMLHttpRequest")
            {
                Respond(context, 400, false);
                return;
            }

            try
            {
                // there is deliberately no "delete" action: notifications can only be read or archived
                int userId = AuthBLL.CurrentUserId;
                var bll = new NotificationBLL();
                int id;
                int.TryParse(context.Request.Form["id"], out id);

                switch (context.Request.Form["action"])
                {
                    case "markallread":
                        bll.MarkAllRead(userId);
                        break;
                    case "markread":
                        if (id <= 0) { Respond(context, 400, false); return; }
                        bll.MarkRead(userId, id);
                        break;
                    case "archive":
                        if (id <= 0) { Respond(context, 400, false); return; }
                        bll.Archive(userId, id);
                        break;
                    case "unarchive":
                        if (id <= 0) { Respond(context, 400, false); return; }
                        bll.Unarchive(userId, id);
                        break;
                    default:
                        Respond(context, 400, false);
                        return;
                }

                Respond(context, 200, true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Notifications handler failed for user {0}: {1}", AuthBLL.CurrentUserId, ex);
                Respond(context, 500, false);
            }
        }

        private static void Respond(HttpContext context, int statusCode, bool ok)
        {
            context.Response.StatusCode = statusCode;
            context.Response.Write(ok ? "{\"ok\":true}" : "{\"ok\":false}");
        }
    }
}
