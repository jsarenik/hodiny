document.getElementById('ofs').innerHTML = offsetfix/1000;
document.getElementById('pre').innerHTML = (dtest-today)/1000;
var hoursLabel = document.getElementById("hours");
var minutesLabel = document.getElementById("minutes");
var secondsLabel = document.getElementById("seconds");
var decsLabel = document.getElementById("decs");
setInterval(doTime, 100);
synctimer = setTimeout(dosync, 2200);
var moment = new Date(client-offsetfix);
document.getElementById('momenttime').innerHTML='In moment when this page was generated, the time was <b>'+moment+'</b>';