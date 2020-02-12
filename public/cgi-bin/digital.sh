#!/bin/sh

test -z "$tz" && exec cat $HERE/digital-notz.html

MYTZ=$(httpd -d "$tz") # Asia/Tokyo
MYN=${MYTZ##*/}
MYN=${MYN/_/ } # Tokyo

cat <<EOF
<!doctype html>
<html lang="en" style="width:100%; height:100%">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="/favicon.ico" rel="shortcut icon">
  <title>Digital clock for $MYN</title>
<style>
html {
  background:#99C;
}

body {
  font-family:arial, sans-serif;
  color:#333;
}

a { color:#000; }


</style>

<script>var today = new Date();</script>
<script src="/css/gettime.php?tz=$MYTZ"></script>
<script>
	var client = parseInt(today.getTime());
	var showdec = true;
	
	var timeSeconds = curds;	
	var startmoment = today;
	var totalSeconds = timeSeconds;
	var updating = false;

	var da = 0;
	var ne = 0;
	var starttime = 0;
	
	function showds() {
		showdec = true;
	}
	function hideds() {
		showdec = false;
	}
	
	function shows() {
		document.getElementById('seconds').style.display = 'inline-block';
		document.getElementById('decseconds').style.display = 'inline-block';
	}
	function hides() {
		document.getElementById('seconds').style.display = 'none';
		document.getElementById('decseconds').style.display = 'none';
	}

	function dosync() {
			$.ajax({url: "/css/gettime2.php?tz=$MYTZ",cache:false, timeout:1600, 
				beforeSend: function(xhr) {
					starttime = parseInt(new Date().getTime());
				}, 
				error: function(xhr){
					ne++;
					document.getElementById('fal').innerHTML = ne;
					nextsync = 3000;
					if(ne>5) nextsync = 10000;
					synctimer = setTimeout(dosync, nextsync);
				}, 
			success: function(result){
				today = new Date();
				client = parseInt(today.getTime());
				da++;
				startmoment = today;
				timeSeconds = parseInt(result);
				document.getElementById('suc').innerHTML = da;
				precision = (client - starttime)/1000;
				document.getElementById('pre').innerHTML = precision;
				if(precision >1) document.getElementById('pre').style.color='RED'; else document.getElementById('pre').style.color='GREEN';
				document.getElementById('lte').innerHTML = pad(parseInt(totalSeconds/360000)%24) + ':' + pad(parseInt(totalSeconds/6000)%60) + ':' + pad(parseInt(totalSeconds/100)%60);
					nextsync = 3000;
					if(da>5) nextsync = 10000;
					if(da>10) nextsync = 30000;
					if(precision<0.4) nextsync = 60000;
					if(precision<0.15) nextsync = 120000;
					synctimer = setTimeout(dosync, nextsync);
			}});
	}

	function doTime() {
		var now = new Date();
		totalSeconds = parseInt((now - startmoment)/10+timeSeconds);
		if(showdec == true) decsecondsLabel.innerHTML = '.'+(parseInt(totalSeconds/10)%10); else decsecondsLabel.innerHTML ='';
		secondsLabel.innerHTML = ':'+pad(parseInt(totalSeconds/100)%60);
		minutesLabel.innerHTML = pad(parseInt(totalSeconds/6000)%60);
		hoursLabel.innerHTML = pad(parseInt(totalSeconds/360000)%24);
		if(totalSeconds%8640000 < 1000 && updating == false) updateDate();
		if(totalSeconds%8640000 > 2000) updating = false;
//		document.getElementById('thedate').innerHTML = totalSeconds;
	}

	function updateDate() {
		document.getElementById('thedate').innerHTML = 'x';
		updating = true;
		syncdate();
	}
	
	function syncdate() {
			$.ajax({url: "/css/getdate2.php?tz=$MYTZ",cache:false, timeout:2500, 
				error: function(xhr){
					setTimeout(syncdate, 8000);
				}, 
			success: function(result){
				document.getElementById('thedate').innerHTML = result;
			}});
	}
	
	function pad(val) {
		var valString = val + "";
		if(valString.length < 2) return "0" + valString; else return valString;
	}

		var weekday = new Array(7);
		weekday[0]=  "Sunday";
		weekday[1] = "Monday";
		weekday[2] = "Tuesday";
		weekday[3] = "Wednesday";
		weekday[4] = "Thursday";
		weekday[5] = "Friday";
		weekday[6] = "Saturday";

		var month = new Array();
		month[0] = "January";
		month[1] = "February";
		month[2] = "March";
		month[3] = "April";
		month[4] = "May";
		month[5] = "June";
		month[6] = "July";
		month[7] = "August";
		month[8] = "September";
		month[9] = "October";
		month[10] = "November";
		month[11] = "December";

function calcTime(city, offset) {
    d = new Date();
    utc = d.getTime() + (d.getTimezoneOffset() * 60000);
    nd = new Date(utc + (1000*offset));
    return "The local time is " + nd.toLocaleString() + 'weekday: '+weekday[nd.getDay()] + ', ' + month[nd.getMonth()] + ' ' + nd.getDate() + ', ' + nd.getFullYear();
}

</script>

<script>
	function changebg(s) {
		if(s =='dark') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#000';
			thehtml.style.backgroundImage= "none";
			document.getElementsByTagName('body').item(0).style.color='#CCC';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#FFF';  
				}
			}  
		} 
		
		if(s=='light') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#FFF';
			thehtml.style.backgroundImage= "none";
			document.getElementsByTagName('body').item(0).style.color='#333';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#000';  
				}
			}  
		}

		if(s=='water') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#06C';
			thehtml.style.background = "url('water.jpg')";
			thehtml.style.backgroundSize = "100% 100%";
			document.getElementsByTagName('body').item(0).style.color='#FF3';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#FF0';
				}
			}  
		}

		if(s=='stars') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#059';
			thehtml.style.background = "url('stars.jpg')";
			thehtml.style.backgroundSize = "100% 100%";
			document.getElementsByTagName('body').item(0).style.color='#CC3';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#CC0';
				}
			}  
		}

		if(s=='winter') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#222';
			thehtml.style.background = "url('winter.jpg')";
			thehtml.style.backgroundSize = "100% 100%";
			document.getElementsByTagName('body').item(0).style.color='#F66';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#C00';
				}
			}  
		}

		if(s=='desert') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#C96';
			thehtml.style.background = "#C96 url('desert.jpg')";
			thehtml.style.backgroundSize = "100% 100%";
			document.getElementsByTagName('body').item(0).style.color='#000';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#300';
				}
			}  
		}

		if(s=='fire') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#F60';
			thehtml.style.background = "#F60 url('fire.jpg')";
			thehtml.style.backgroundSize = "100% 100%";
			document.getElementsByTagName('body').item(0).style.color='#000';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#300';
				}
			}  
		}

		if(s=='green') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#363';
			thehtml.style.background = "#363 url('green.jpg')";
			thehtml.style.backgroundSize = "100% 100%";
			document.getElementsByTagName('body').item(0).style.color='#CFF';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#FFF';
				}
			}  
		}

		if(s=='sky') {
			thehtml = document.getElementsByTagName('html').item(0);
			thehtml.style.backgroundColor='#9CF';
			thehtml.style.background = "#9CF url('sky.jpg')";
			thehtml.style.backgroundSize = "100% 100%";
			document.getElementsByTagName('body').item(0).style.color='#FFF';
			var links = document.getElementsByTagName("a");
			for(var i=0;i<links.length;i++)
			{
				if(links[i].href)
				{
					links[i].style.color = '#CFF';
				}
			}  
		}

	}
</script>

<script src="/css/jquery.min.js"></script>

  <!--[if lt IE 9]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
</head>

<body>
<div><a href="/more/">&larr; back to clock.zone</a></div>
<h3 style="margin:0;">Digital clock, time in $MYN:</h3>
<div style="font-size:72px; font-size:16vw;"><label id="hours">-</label>:<label id="minutes">-</label><label id="seconds">:</label><label id="decseconds" style="font-size:36px; font-size:5vw;">-</label></div>
<div id="thedate" style="font-size:24px">Wednesday, 12 February 2020</div>
<hr>
<p>Decimal seconds: <a href="javascript:showds();">Show</a> / <a href="javascript:hideds();">Hide</a>, Seconds: <a href="javascript:shows();">Show</a> / <a href="javascript:hides();">Hide</a></p>
<p style="clear:both">Backgrounds: 
<a href="javascript:changebg('dark');">Dark</a> , 
<a href="javascript:changebg('light');">Light</a> , 
<a href="javascript:changebg('water');">Water</a>, 
<a href="javascript:changebg('stars');">Stars</a>, 
<a href="javascript:changebg('winter');">Winter</a>, 
<a href="javascript:changebg('desert');">Desert</a>, 
<a href="javascript:changebg('fire');">Fire</a>, 
<a href="javascript:changebg('green');">Green</a>, 
<a href="javascript:changebg('sky');">Sky</a>
</p>

<hr>

<div>Sync precision: &plusmn;<span id="pre" style="font-weight:bold;">0</span> s</div>
    <div>Sync succ:<span id="suc">0</span></div>
    <div>Latest sync:<span id="lte">0</span></div>
    <div>Sync fail:<span id="fal">0</span></div>
<script>
		document.getElementById('lte').innerHTML = pad(parseInt(totalSeconds/360000)%24) + ':' + pad(parseInt(totalSeconds/6000)%60) + ':' + pad(parseInt(totalSeconds/100)%60);
  		document.getElementById('pre').innerHTML = (dtest-today)/1000;
        var hoursLabel = document.getElementById("hours");
        var minutesLabel = document.getElementById("minutes");
        var secondsLabel = document.getElementById("seconds");
        var decsecondsLabel = document.getElementById("decseconds");
        setInterval(doTime, 100);
		synctimer = setTimeout(dosync, 2200);
		
    </script>
                
<p style="clear:both">Shown digital clock is current time for &quot;<strong>$MYTZ</strong>&quot; time zone. This clock is synchronised with our dedicated server time. Background images are from <a href="https://pixabay.com" target="_blank">pixabay.com</a>.</p>

</body>
</html>
EOF
