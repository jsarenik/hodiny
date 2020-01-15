#!/busybox/sh

export PATH=/busybox
echo "Content-Type: text/html; charset=UTF-8"
echo

eval $(echo "$QUERY_STRING"|awk -F'&' '{for(i=1;i<=NF;i++){print $i}}')
test -z "$tz" && { cat index-old.html; exit; }

MYTZ=$(/busybox/httpd -d "$tz")

cat <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="favicon.ico" rel="shortcut icon">
  <link rel="stylesheet" href="/css/style.css">
  <title>Tokyo analog clock</title>
<script>var today = new Date();</script>
<script src="/css/gettime.php?tz=$MYTZ"></script>
<script type="text/javascript" src="/css/raphael-min.js"></script>
<script>
	var client = parseInt(today.getTime());
	var showdec = true;

	var timeSeconds = curds;	
	var startmoment = today;
	var totalSeconds = timeSeconds;
	
	var da = 0;
	var ne = 0;
	var starttime = 0;
	
	function showds() {
		showdec = true;
	}
	function hideds() {
		showdec = false;
	}
		function draw_clock(){
			canvas = Raphael("clock_id",200, 200);
			var clock = canvas.circle(100,100,95);
			 clock.attr({"fill":"#f5f5f5","stroke":"#444444","stroke-width":"2"})  
			 var hour_sign;
			for(i=0;i<12;i++){
				var start_x = 100+Math.round(80*Math.cos(30*i*Math.PI/180));
				var start_y = 100+Math.round(80*Math.sin(30*i*Math.PI/180));
				var end_x = 100+Math.round(90*Math.cos(30*i*Math.PI/180));
				var end_y = 100+Math.round(90*Math.sin(30*i*Math.PI/180));    
				hour_sign = canvas.path("M"+start_x+" "+start_y+"L"+end_x+" "+end_y);
				
			}    
			hour_hand = canvas.path("M100 100L100 50");
			hour_hand.attr({stroke: "#449944", "stroke-width": 6});
			minute_hand = canvas.path("M100 100L100 40");
			minute_hand.attr({stroke: "#994444", "stroke-width": 4});
			second_hand = canvas.path("M100 110L100 25");
			second_hand.attr({stroke: "#444444", "stroke-width": 2});
			var pin = canvas.circle(100, 100, 5);
			pin.attr("fill", "#000000");    

			ampm = canvas.text(20, 10, "XM");
			ampm.attr({stroke: "#555599"});	

			update_clock()
			setInterval("update_clock()",100);
		}
            
		function update_clock(){
			//++totalSeconds;
			var now = new Date();
			totalSeconds = (now - startmoment)/10+timeSeconds;
			var hours = parseInt(totalSeconds/360000)%24;
			var minutes = parseInt(totalSeconds/6000)%60;
			var seconds = parseInt(totalSeconds/100)%60;
			var decseconds = parseInt(totalSeconds)%100;
			hour_hand.rotate(30*hours+(minutes/2.5), 100, 100);
			minute_hand.rotate(6*minutes, 100, 100);
			if(showdec) showsec = parseInt(seconds+decseconds/100); else showsec = seconds+decseconds/100
			second_hand.rotate(6*showsec, 100, 100);
			if(hours<12) ampm.attr({"text": "AM"}); else ampm.attr({"text": "PM"});
			
			document.getElementById("exacttime").innerHTML = ("0" + hours).slice(-2)+":"+("0" + minutes).slice(-2);
			
		}
 	function pad(val) {
		var valString = val + "";
		if(valString.length < 2) return "0" + valString; else return valString;
	}

	function dosync() {
			$.ajax({url: "/css/gettime2.php?tz=Asia/Tokyo",cache:false, timeout:1800, 
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
					if(precision<0.4 && da>4) nextsync = 60000;
					if(precision<0.15 && da>4) nextsync = 120000;
					synctimer = setTimeout(dosync, nextsync);
			}});
	}

        </script>

<script src="/css/jquery.min.js"></script>
  
  <!--[if lt IE 9]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
</head>

<body>
  <div class="container">

    <header class="header clearfix">
      <div class="logo"><a href="http://clock.zone/">Clock.Zone</a></div>

      <nav class="menu_main">
        <ul>
          <li><a href="/">Home</a></li>
          <li><a href="/about">About</a></li>
          <li><a href="/gmt/">GMT</a></li>
          <li><a href="/analog">Analog</a></li>
          <li><a href="/more/">More Clocks</a></li>
          <li><a href="/tools/">Tools</a></li>
          <li><a href="/widget/">Widgets</a></li>
        </ul>
      </nav>
    </header>


    <div class="info">
      <article class="hero clearfix">
        <div class="col_100">
        <h1 style="margin:0;">Exact time analog clock for Tokyo</h1>
            <div class="col_50">
        <div id="clock_id"></div>
            </div>
            
            <div class="col_50">
                <div>Sync precision: &plusmn;<span id="pre" style="font-weight:bold;">0</span> s</div>
                <div>Sync succ:<span id="suc">0</span></div>
                <div>Latest sync:<span id="lte">0</span></div>
                <div>Sync fail:<span id="fal">0</span></div>
                <div style="margin-top:10px;">Tokyo time digital clock: <span id="exacttime"></span></div>
            </div>

<p style="clear:both">Settings: seconds <a href="javascript:hideds();">Soft</a> / <a href="javascript:showds();">Jump</a><br>
This analog clock is also showing accurate exact time from our server (not your device clock). Second-hand jumps on the beginning of second. </p>
            

</div>
      </article>


      <article class="article clearfix">
          <p>Navigation: <a href="/">Clock.Zone</a> / <a href="/analog">Analog clock</a> / <a href="/analog?tz=$MYTZ">Japan</a> </p>
        <div class="col_50">
          <h1>Analog clock for Asia/Tokyo time zone</h1>


          
          <p>In page creation moment, exact local time was <strong>Thursday, 16 January 2020 (5:53 AM)</strong> in <strong>Asia/Tokyo</strong> timezone.</p>
          <p>This is exact time analog clock for <strong>Asia/Tokyo</strong> time zone, synchronized with time on clock.zone dedicated server. Second-hand always jumps on the beginning of the second. Precision of the time synchronisation can be seen next to the clock (Sync precision). </p>
          <p>&nbsp;</p>
</div>
        
        <div class="col_50">
          <h2>Tokyo location?</h2>
          <p>Country: <a href="/japan">Japan</a></p>
          <p>Continent: <a href="/asia/">Asia</a></p>
          <p>Difference from Greenwich mean time: <a href="/gmt/+9">GMT+9</a></p>
          <p>Position of Tokyo on time zone map you can find on <a href="/asia/tokyo">Tokyo digital clock</a> page.</p>
          <h2>Support the webmaster</h2>

          <p>If you like clock.zone, please, support me. That's one small click for man, one giant spiritual support for me :-) </p>
</div>

        <div class="clearfix"></div>
    <hr>

        <script>draw_clock()</script>

  <script>
		document.getElementById('lte').innerHTML = pad(parseInt(totalSeconds/36000)%24) + ':' + pad(parseInt(totalSeconds/600)%60) + ':' + pad(parseInt(totalSeconds/10)%60);
  		document.getElementById('pre').innerHTML = (dtest-today)/1000;
		synctimer = setTimeout(dosync, 2200);
    </script>

<p>Your feedback is welcome. </p>

      </article>
    </div>
    
    <footer class="footer clearfix">
      <div class="copyright">2015 &copy; Clock.zone</div>

      <nav class="menu_bottom">
        <ul>
          <li><a href="/termsofuse">Terms of use</a></li>
          <li><a href="/contact">Contact</a></li>
        </ul>
      </nav>
    </footer>

  </div>
</body>
</html>
EOF
