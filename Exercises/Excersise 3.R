# Excersise 3
# Team Dzjio Skripting
# Gersom Zomer & Yannick Mijnheer

# Function
is.leap <- function(year){
 test = try(year + 10, silent = TRUE)
 if (class(test) == 'try-error'){
  stop("argument of class numeric expected", call. = FALSE)}
 else if (year < 1752) {
  warning(paste(toString(year),"is out of range"), call. = FALSE)}
 else if (year %% 4 != 0) {
  return(FALSE)}
 else if (year %% 100 != 0) {
  return(TRUE) }
 else if (year %% 400 != 0) {
  return(FALSE)}
 else 
   {return(TRUE)}
  }

# Function example
is.leap(2012)
is.leap(1912)
is.leap(2003)
is.leap(1609)
is.leap('henk')