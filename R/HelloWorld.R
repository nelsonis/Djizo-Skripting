HelloWorld <- function (x) {
  if (is.character(x)) {
    hello <- sprintf('Hello %s', x)
  } else {
    hello <- warning('Object of class character expected for x')
  }
  return(hello)
}