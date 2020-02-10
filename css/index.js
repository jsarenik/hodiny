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
	falLabel.innerHTML = ne;
	nextsync = 3000 + ne*2000;
	synctimer = setTimeout(dosync, nextsync);
  },
  success: function(result){
	today = new Date();
	offsetfix = Math.round(syncstart-result);
	da++;
	sucLabel.innerHTML = da;
	precision = (today.getTime() - syncstart)/1000;
	preLabel.innerHTML = precision;
	if(precision >1) preLabel.style.color='RED';
	  else preLabel.style.color='GREEN';
	ofsLabel.innerHTML = offsetfix/1000;
	lteLabel.innerHTML = hms;
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

  decsLabel.innerHTML = '.'+Math.round(totalSeconds/100)%10;
  s = pad(Math.round(totalSeconds/1000)%60);
  m = pad(Math.round(totalSeconds/60000)%60);
  h = pad(Math.round(totalSeconds/3600000)%24);
  hms = h+':'+m+':'+s;
  document.title = hms;
  secondsLabel.innerHTML = s;
  minutesLabel.innerHTML = m;
  hoursLabel.innerHTML = h;
}
function pad(val) {
  var str = "0" + val;
  return (str.length===2 ? str : str.substring(1));
}
