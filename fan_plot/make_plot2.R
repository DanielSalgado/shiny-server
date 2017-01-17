max_side <- 5
# # variables para pruebas
# x <- c(0.98861, 0.952992, 0.894802, 0.604266, 0.598053, 0.535929, 0.39387, 0.225305)
# y <- c(100, 100, 138, 115, 99, 147, 101, 106)
# Ylab <- "Eje horizontal"
# Xlab <- "Eje vertical"
# colores <- brewer.pal(length(x), "Set3")

# Dibuja los nombres de ejes, titulo y origen.
base_plot <- function( Y_label, X_label, titulo){
  ylim <- c(0,max_side)
  xlim <- c(-1*max_side,max_side)
  h_max <- max_side 
  
  #### Base plot area ####
  plot(x=0, y=0, ylim=ylim, xlim=xlim, pch = 20, axes = FALSE,
       xlab=X_label, ylab=Y_label, asp = 1, main = titulo)
}

# Regresa la constante que relaciona bases con alturas
get_k <- function(x, y){
  z <- x/y
  f <- function(k) (sum(atan(k*z)) - pi/2)
  k <- uniroot(f, c(-1000,1000))$root
  return(k)
}

# Regresa bases y alturas
get_height_and_bases <- function(x, y){
  k <- get_k(x, y)
  h <- max_side/max(y)
  b <- 2*k*h
  bases <- x*b
  alturas <- y*h
  df <- data.frame(bases = bases, alturas = alturas)
  return(df)
}

# Regresa los indices ordenados
orderInput <- function(bases, alturas, orden = "No"){
  indices_ordenados <- switch(orden,
                              bases = order(bases, decreasing = TRUE),
                              alturas = order(alturas, decreasing = TRUE),
                              No = 1:length(bases))
  return(indices_ordenados)
}

# Regresa angulos dados las bases y las alturas
get_degrees <- function(bases, alturas){
  return(2*atan(bases/(2*alturas)))
}

# Dibuja los triangulos en el orden dado
plot_triangles <- function(bases, alturas, colores){  
  angulos <- get_degrees(bases, alturas)
  a_acumulado <- 0
  N = length(alturas)
  for (i in 1:N){
    a <- a_acumulado + angulos[i]
    betha <- pi - a
    gamma <- betha + angulos[i]
    Ax <- cos(gamma)*alturas[i]
    Ay <- sin(gamma)*alturas[i]
    Bx <- cos(betha)*alturas[i]
    By <- sin(betha)*alturas[i]
    Px <- c(0, Ax, Bx)
    Py <- c(0, Ay, By)
    polygon(x = Px, y = Py, col = colores[i], xpd = TRUE)
    a_acumulado <- a_acumulado + angulos[i]
  }
}

# Dibuja los ejes
plot_axes <- function(xlim = c(-1*max_side, max_side), 
                      ylim = c(0, max_side), max_altura, max_base, cat_max){
  #Eje X
  if(cat_max > max_side) {
    cat_max <- max_side
  }
  axis(1, col.axis = "black", at = c(-5, 0, 5),
       labels = c(round(max_altura), "0", round(max_altura)))  
  
  #Eje Y
  Ym <- ylim[2]/2
  Y_0 <- (Ym-(cat_max/2))
  Y_max <- (Ym+(cat_max/2))
  Y_labels <- c("0", round(max_base, 2))
  Y_at <- c(Y_0, Y_max )
  axis(2, col.axis = "black", at = Y_at,
       labels = Y_labels)
}

# Siempre se sigue este orden de funciones:
# base_plot()
# get_height_and_bases()
# orderInput()
# plot_triangles()
# plot_axes()