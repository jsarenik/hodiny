#!/busybox/sh

echo "Content-Type: text/html"
echo

test "$QUERY_STRING" != "" \
  && eval $(echo "$QUERY_STRING" \
    | grep -o '[a-zA-Z][[:alnum:]]*=[-[:alnum:]/_+%]\+')

test "$title" = "" && title="Clock" || title=$(/busybox/httpd -d "$title")
test "$timezone" = "" && timezone="Europe/London" || timezone=$(/busybox/httpd -d "$timezone")
MYTZ="?tz=$timezone"
test "$fontcol" = "" && fontcol=222
test "$bgcol" = "" && bgcol=DDD

TW=24
test "$h24" = "0" && TW=12 || TWC="//"
test "$weekday" = "1" && WEEKDAY='<div id="weekday" >3</div>' || DAYC="//"
test "$showsec" = "0" && { SECVIS="visibility: hidden;"; SEC="//"; }

cat <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="/favicon.ico" rel="shortcut icon">
  <title>$title</title>

<script>var today = new Date();</script>
<script src="../css/gettime.php$MYTZ"></script>
<script>
	var client = parseInt(today.getTime());
	var showdec = true;
	
	var timeSeconds = curds;	
	var startmoment = today;
	var totalSeconds = timeSeconds;
	var first = true;

	var starttime = 0;
	
	function dosync() {
			$.ajax({url: "../css/gettime2.php$MYTZ",cache:false, timeout:1900,
				beforeSend: function(xhr) {
					starttime = parseInt(new Date().getTime());
				}, 
				error: function(xhr){
					synctimer = setTimeout(dosync, 10000);
				}, 
			success: function(result){
				today = new Date();
				client = parseInt(today.getTime());
				startmoment = today;
				timeSeconds = parseInt(result);
				synctimer = setTimeout(dosync, 300000);
			}});
	}

	function doTime() {
		var now = new Date();
		totalSeconds = parseInt((now - startmoment)/10+timeSeconds);
		$SEC secondsLabel.innerHTML = pad(parseInt(totalSeconds/100)%60);
		minutesLabel.innerHTML = pad(parseInt(totalSeconds/6000)%60);
		hoursLabel.innerHTML = pad(parseInt(totalSeconds/360000)%$TW);
		var hours = parseInt(totalSeconds/360000)%24;
		$TWC if(hours<12) ampm="AM"; else ampm="PM";
		$TWC ampmLabel.innerHTML = ampm;
		if(  (totalSeconds%8640000) < 100   && first == true) {
			wday++;
			if(wday>6) wday = 0;
			$DAYC dayLabel.innerHTML = weekday[wday];
			first = false
		}
		if( (totalSeconds%8640000) > 900 ) {
			first = true;
		}
		//dayLabel.innerHTML = weekday[wday];
//			document.getElementById('testing').innerHTML = totalSeconds; //ez nem fog kelleni //////////////////////////////
		
	}

	function pad(val) {
		var valString = val + "";
		if(valString.length < 2) return "0" + valString; else return valString;
	}


</script>
<script src="../css/jquery.min.js"></script>

  <!--[if lt IE 9]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
</head>

<body style="text-align:center; line-height:24px; padding:0; margin:0; background-color:#$bgcol; color:#$fontcol;">
    <p style="margin:0; padding:0; font-size:12px">$title</p>
	<p style="font-size:36px; margin:0;"><label id="hours" style="font-size:36px;">--</label>:<label id="minutes" style="font-size:36px;">--</label><label id="seconds" style="font-size:18px;"></label><label id="ampm" style="font-size:22px;"></label></p>
$WEEKDAY
<script>
var weekday = new Array(7);
weekday[0]=  "Sunday";
weekday[1] = "Monday";
weekday[2] = "Tuesday";
weekday[3] = "Wednesday";
weekday[4] = "Thursday";
weekday[5] = "Friday";
weekday[6] = "Saturday";
var wday = 3;

var hoursLabel = document.getElementById("hours");
var minutesLabel = document.getElementById("minutes");
$SEC var secondsLabel = document.getElementById("seconds");
$TWC var ampmLabel = document.getElementById("ampm");
$DAYC var dayLabel = document.getElementById("weekday");
$DAYC dayLabel.innerHTML=weekday[wday];
setInterval(doTime, 200);
synctimer = setTimeout(dosync, 2200);
</script>

<!--<div id="testing">y</div>-->
        
</body>
</html>
EOF
