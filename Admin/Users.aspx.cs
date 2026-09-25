using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using binary.Core.BLL;
using binary.Models;

namespace binary.Admin
{
    public partial class AdminUsers : System.Web.UI.Page
    {
        private static readonly Dictionary<string, string> ActionMessages = new Dictionary<string, string>
        {
            { "user-saved", "User saved successfully." },
            { "user-deleted", "User deleted." },
        };

        private static string WithMsg(string url, string msg)
        {
            string baseUrl = url;
            int qIndex = url.IndexOf('?');
            if (qIndex >= 0)
            {
                string path = url.Substring(0, qIndex);
                var kept = url.Substring(qIndex + 1).Split('&')
                    .Where(p => p.Length > 0 && !p.StartsWith("msg=", StringComparison.OrdinalIgnoreCase))
                    .ToList();
                baseUrl = kept.Count > 0 ? path + "?" + string.Join("&", kept) : path;
            }
            return baseUrl + (baseUrl.IndexOf('?') >= 0 ? "&" : "?") + "msg=" + msg;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // admin authorization is enforced centrally by AdminMaster (runs earlier, in Init)
            if (!IsPostBack)
            {
                string msgKey = Request.QueryString["msg"];
                string msgText;
                if (!string.IsNullOrEmpty(msgKey) && ActionMessages.TryGetValue(msgKey, out msgText))
                {
                    litActionSuccess.Text = msgText;
                    pnlActionSuccess.Visible = true;
                }

                int userId;
                string idParam = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idParam) && int.TryParse(idParam, out userId) && userId > 0)
                {
                    LoadUserForEdit(userId);
                }
                else if (Request.QueryString["new"] == "1")
                {
                    hfUserId.Value = "";
                    litFormTitle.Text = "Add User";
                    pnlPasswordField.Visible = true;
                    litSelfEditNote.Visible = false;
                    ddlRole.Enabled = true;
                    chkActive.Enabled = true;
                    pnlUserForm.Visible = true;
                }
            }

            BindUsers();
        }

        private void LoadUserForEdit(int userId)
        {
            try
            {
                User u = new UserBLL().GetProfile(userId);
                hfUserId.Value = u.UserID.ToString();
                litFormTitle.Text = "Edit User";
                txtFirstName.Text = u.FirstName;
                txtLastName.Text = u.LastName;
                txtEmail.Text = u.Email;
                ddlRole.SelectedValue = u.RoleID.ToString();
                chkActive.Checked = u.IsActive;
                pnlPasswordField.Visible = false;

                bool isSelf = userId == AuthBLL.CurrentUserId;
                ddlRole.Enabled = !isSelf;
                chkActive.Enabled = !isSelf;
                litSelfEditNote.Visible = isSelf;

                pnlUserForm.Visible = true;
            }
            catch (ValidationException)
            {
                Response.Redirect("~/Admin/Users.aspx");
            }
        }

        // Every user is rendered; search, filters, sorting and paging happen in the browser
        // (Scripts/binary-ui.js), so filtering never reloads the page.
        private void BindUsers()
        {
            rptUsers.DataSource = new UserBLL().GetAllUsers();
            rptUsers.DataBind();
        }

        // what the search box matches against: full name and email, lower-cased
        protected string GetUserSearchText(object dataItem)
        {
            var user = (binary.Models.User)dataItem;
            return HttpUtility.HtmlAttributeEncode((user.FirstName + " " + user.LastName + " " + user.Email).ToLowerInvariant());
        }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            try
            {
                int roleId = int.Parse(ddlRole.SelectedValue);
                bool isActive = chkActive.Checked;
                var bll = new UserBLL();

                int userId;
                if (!string.IsNullOrEmpty(hfUserId.Value) && int.TryParse(hfUserId.Value, out userId) && userId > 0)
                {
                    if (userId == AuthBLL.CurrentUserId)
                    {
                        // never let an admin change their own role/status, even if the disabled
                        // controls were somehow tampered with client-side
                        User current = bll.GetProfile(userId);
                        roleId = current.RoleID;
                        isActive = current.IsActive;
                    }

                    bll.AdminUpdateUser(userId, txtFirstName.Text, txtLastName.Text, txtEmail.Text, roleId, isActive);
                    Response.Redirect(WithMsg("~/Admin/Users.aspx", "user-saved"));
                }
                else
                {
                    bll.AdminCreateUser(txtFirstName.Text, txtLastName.Text, txtEmail.Text, txtPassword.Text, roleId, isActive);
                    Response.Redirect(WithMsg("~/Admin/Users.aspx", "user-saved"));
                }
            }
            catch (ValidationException vex)
            {
                litUserError.Text = Server.HtmlEncode(vex.Message);
                pnlUserError.Visible = true;
                pnlUserForm.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Save user failed: {0}", ex);
                litUserError.Text = "Something went wrong saving this user. Please try again.";
                pnlUserError.Visible = true;
                pnlUserForm.Visible = true;
            }
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteUser") return;

            int userId = Convert.ToInt32(e.CommandArgument);
            if (userId == AuthBLL.CurrentUserId)
            {
                litUserError.Text = "You cannot delete your own account.";
                pnlUserError.Visible = true;
                return;
            }

            try
            {
                new UserBLL().DeleteUser(userId);
                Response.Redirect(WithMsg(Request.RawUrl, "user-deleted"));
            }
            catch (ValidationException vex)
            {
                litUserError.Text = Server.HtmlEncode(vex.Message);
                pnlUserError.Visible = true;
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;   // Response.Redirect ends the request this way; not an error
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Delete user {0} failed: {1}", userId, ex);
                litUserError.Text = "Something went wrong. Please try again.";
                pnlUserError.Visible = true;
            }
        }
    }
}
