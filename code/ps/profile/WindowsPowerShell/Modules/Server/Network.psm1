
function Restart-Network ()
{
  iisreset /noforce
  net stop sptimerv4
  net start sptimerv4
}
