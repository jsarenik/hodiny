var today = new Date();
var client = parseInt(today.getTime());
var offsetfix = parseInt((client-server)/10); <!-- deciseconds -->

var h = today.getHours();
var mi = today.getMinutes();
var s = today.getSeconds();
var ds = today.getMilliseconds();
ds = parseInt(ds/10);
var timeSeconds = (h*360000+mi*6000+s*100+ds); //h*3600+m*60+s
var startmoment = today;
var totalSeconds = timeSeconds-offsetfix;
var da = 0;
var ne = 0;
var starttime = 0;

function showds() {
	document.getElementById('decs').style.visibility='visible';
}
function hideds() {
	document.getElementById('decs').style.visibility='hidden';
}
function dosync() {
  $.ajax({url: "/css/timeapi2.php",cache:false, timeout:1800,
  beforeSend: function(xhr) {
	starttime = parseInt(new Date().getTime());
  },
  error: function(xhr){
	ne++;
	document.getElementById('fal').innerHTML = ne;
	nextsync = 3000 + 2*ne;
	synctimer = setTimeout(dosync, nextsync);
  },
  success: function(result){
	today = new Date();
	client = parseInt(today.getTime());
	offsetfix = parseInt((starttime-parseInt(result))/100);
	da++;
	document.getElementById('suc').innerHTML = da;
	precision = (client - starttime)/1000;
	document.getElementById('pre').innerHTML = precision;
	if(precision >1) document.getElementById('pre').style.color='RED'; else document.getElementById('pre').style.color='GREEN';
	document.getElementById('ofs').innerHTML = offsetfix/100;
	document.getElementById('lte').innerHTML = pad(parseInt(totalSeconds/360000)%24) + ':' + pad(parseInt(totalSeconds/6000)%60) + ':' + pad(parseInt(totalSeconds/100)%60);
	nextsync = 3000;
	if(da>5) nextsync = 10000;
	if(da>10) nextsync = 30000;
	if(precision<0.4 && da>4) nextsync = 60000;
	if(precision<0.15 && da>4) nextsync = 120000;
	synctimer = setTimeout(dosync, nextsync);
  }});
} // end of dosync()
function doTime() {
  var now = new Date();
  totalSeconds = parseInt((now - startmoment)/10+timeSeconds-offsetfix);
  totalSeconds = (totalSeconds+8640000)%8640000;

  decsLabel.innerHTML = '.'+(parseInt(totalSeconds/10)%10);
  secondsLabel.innerHTML = pad(parseInt(totalSeconds/100)%60);
  minutesLabel.innerHTML = pad(parseInt(totalSeconds/6000)%60);
  hoursLabel.innerHTML = pad(parseInt(totalSeconds/360000)%24);
  document.title = hoursLabel.innerHTML + ":" + minutesLabel.innerHTML + ":" + secondsLabel.innerHTML;
}
function pad(val) {
  var str = "0" + val;
  return (str.length===2 ? str : str.substring(1));
}
