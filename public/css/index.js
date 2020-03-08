var today = new Date();
var offsetfix = Math.floor(server-today.getTime());
var tzdiff = today.getTimezoneOffset() * 60000;
var hoursLabel = document.getElementById('hours');
var minutesLabel = document.getElementById('minutes');
var secondsLabel = document.getElementById('seconds');
var decsLabel = document.getElementById('decs');
var falLabel = document.getElementById('fal');
var sucLabel = document.getElementById('suc');
var preLabel = document.getElementById('pre');
var ofsLabel = document.getElementById('ofs');
var lteLabel = document.getElementById('lte');

var da = 0;
var ne = 0;
var syncstart = 0;

function showds() {
	decsLabel.style.visibility='visible';
}
function hideds() {
	decsLabel.style.visibility='hidden';
}
function dosync() {
  $.ajax({url: "/css/timeapi2.php",cache:false, timeout:1800,
  beforeSend: function(xhr) {
	syncstart = new Date().getTime();
  },
  error: function(xhr){
	ne++;
	nextsync = 3000 + ne*2000;
	falLabel.innerHTML = ne;
	synctimer = setTimeout(dosync, nextsync);
  },
  success: function(result){
	today = new Date();
	da++;
	precision = syncstart - today.getTime();
	offsetfix = Math.floor(result - today.getTime());
	sucLabel.innerHTML = da;
	preLabel.innerHTML = precision/1000;
	if(precision >1000) preLabel.style.color='RED';
	  else preLabel.style.color='GREEN';
	ofsLabel.innerHTML = offsetfix/1000;
	lteLabel.innerHTML = hms;
	nextsync = 3000;
	if(da>5) nextsync = 10000;
	if(da>10) nextsync = 30000;
	if(precision<400 && da>4) nextsync = 60000;
	if(precision<150 && da>4) nextsync = 120000;
	synctimer = setTimeout(dosync, nextsync);
  }});
} // end of dosync()
function doTime() {
  var now = new Date().getTime();
  totalSeconds = now-offsetfix-tzdiff;
  s = pad(Math.floor(totalSeconds/1000)%60);
  m = pad(Math.floor(totalSeconds/60000)%60);
  h = pad(Math.floor(totalSeconds/3600000)%24);
  hms = h+':'+m+':'+s;
  document.title = hms;
  decsLabel.innerHTML = '.'+Math.floor(totalSeconds/100)%10;
  secondsLabel.innerHTML = s;
  minutesLabel.innerHTML = m;
  hoursLabel.innerHTML = h;
}
function pad(val) {
  var str = "0" + val;
  return (str.length===2 ? str : str.substring(1));
}

var synctimer = setTimeout(dosync, 2200);
document.getElementById('momenttime').innerHTML='In moment when this page was generated, the time was <b>'+today+'</b>';
setInterval(doTime, 100);
