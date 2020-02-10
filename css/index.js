var today = new Date();
var client = today.getTime();
var offsetfix = client-server;
var timeSeconds = today.getTime();
var da = 0;
var ne = 0;
var syncstart = 0;

function showds() {
	document.getElementById('decs').style.visibility='visible';
}
function hideds() {
	document.getElementById('decs').style.visibility='hidden';
}
function dosync() {
  $.ajax({url: "/css/timeapi2.php",cache:false, timeout:1800,
  beforeSend: function(xhr) {
	syncstart = new Date().getTime();
  },
  error: function(xhr){
	ne++;
	document.getElementById('fal').innerHTML = ne;
	nextsync = 3000 + ne*2000;
	synctimer = setTimeout(dosync, nextsync);
  },
  success: function(result){
	today = new Date();
	client = today.getTime();
	offsetfix = syncstart-result;
	da++;
	document.getElementById('suc').innerHTML = da;
	precision = (client - syncstart)/1000;
	document.getElementById('pre').innerHTML = precision;
	if(precision >1) document.getElementById('pre').style.color='RED'; else document.getElementById('pre').style.color='GREEN';
	document.getElementById('ofs').innerHTML = offsetfix;
	document.getElementById('lte').innerHTML = hms;
	nextsync = 3000;
	if(da>5) nextsync = 10000;
	if(da>10) nextsync = 30000;
	if(precision<0.4 && da>4) nextsync = 60000;
	if(precision<0.15 && da>4) nextsync = 120000;
	synctimer = setTimeout(dosync, nextsync);
  }});
} // end of dosync()
function doTime() {
  var now = new Date().getTime();
  totalSeconds = now-offsetfix;

  decsLabel.innerHTML = '.'+(totalSeconds/10)%10;
  s = pad(totalSeconds/100)%60;
  m = pad(totalSeconds/6000)%60;
  h = pad(totalSeconds/360000)%24;
  hms = h + ':' + m + ':' + s;
  document.title = hms;
  secondsLabel.innerHTML = s;
  minutesLabel.innerHTML = m;
  hoursLabel.innerHTML = h;
}
function pad(val) {
  var str = "0" + val;
  return (str.length===2 ? str : str.substring(1));
}
