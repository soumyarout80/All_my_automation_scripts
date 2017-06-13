<?php
    error_reporting( error_reporting() & ~E_NOTICE )

    ?>

<html>
<head>
<title>mypage</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>

<script type="text/javascript">


$( document ).ready(function() {

                    $('#details').on('change', function() {

                                     var val1;
                                     var val2;
                                     val1 = $("#vertical").val();
                                     val2 = $("#details").val();

                                     alert(val1)
                                     alert(val2);
                                     $.ajax({

                                            type:"post",
                                            url:"process.php",
                                            data:"val1="+val1+"&val2="+val2,
                                            success:function(data){
                                            $("#main").html(data);
                                            }

                                            });
                                     });

                    });
</script>
</head>
<body>
<center>


<?php

    if ($_SERVER["REQUEST_METHOD"] == "POST") {

        if (empty($_POST["val1"])) {
            $clusterErr = "Cluster is required";
        }
        if(empty($_POST['val2'])){
            $actionErr = "Action is required";
        }

        if($_SERVER["REQUEST_METHOD"] == "POST" && (!empty($_POST["val1"])) && (!empty($_POST["val2"])) )
        {

            $val1 = $_POST["val1"];
            $val2 = $_POST["val2"];

            $output .= "<pre>".shell_exec('sh sss.sh "'.$val1.'" "'.$val2.'" 2>&1 ')."</pre>";
          }
    }

    ?>

<form name="myform" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <input type='button' name='refresh' value ='Reload page' style = 'float: right;' onclick='window.location.reload(true);'>
<table>
<tr>
<td><B>Select  Cluster to Manage:</B>
<select name= "val1" style = "position: relative">
<option value='' selected> -- Select -- </option>
<option value='hudson'> Hudson</option>
<option value='internal-hudson'> Internal-Hudson</option>
<option value='aggregator'> Aggregators </option>
<option value='electronicslow'> ElectronicsLow</option>

<option value='electronicshigh'> ElectronicsHigh</option>
<option value='lifestyle'> Lifestyle</option>
<option value='books'> Books</option>
<option value='internal-aggregator'> Internal-Aggregator </option>
<option value='internal-electronicslow'> Internal-ElectronicsLow </option>
<option value='internal-electronicshigh'> Internal-ElectronicsHigh </option>
<option value='internal-lifestyle'> Internal-Lifestyle </option>
<option value='internal-books'> Internal-Books </option>
<option value='completion'> Completion</option>
<option value='rols'> Rols</option>
<option value='precomput'> Precomput</option>
</select>
<span class="error">* <?php echo $clusterErr;?></span>

</td>
</tr>

<tr>
<td>

<BR/><B align="justify"> Action on selected cluster:</B>

<select name="val2" style = "position: relative">
<option value=''> -- Select -- </option>
<option value='detail'> Detail Status</option>
<option value='down'>  Cluster Down </option>
</select>
<span class="error">* <?php echo $actionErr;?></span>


</td>
</tr>
<tr align='center'>
<td>
<input type='submit' name='submit' value='submit'>
</td>
</tr>
</table>
</form>

<?php
    echo "<pre>$output</pre>";
    ?>
</center>


</body>
</html>

