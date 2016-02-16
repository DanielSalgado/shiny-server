### Fan Plot ###

# usar la funcion polygon para pintar triangulos
library(RColorBrewer)
library(rootSolve)

### input: vector de alturas y angulos
### output: usa la función polygon para dibujar en una grafica los triangulos 
###         correspondientes a las alturas, angulos y colores dados.
plot_triangles <- function(alturas, angulos, colores){
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

### input: vector de valores originales de x
### output: vector de alphas ajustados, su suma da pi y la proporción
###         de los apotemas resultantes
obten_angulos <- function(x, y){
  return(2*atan(x/(2*y)))
}

### input: vectores de valores originales de x e y
### output: k , la constante que relacióna h y b (las variables por las que hay que multiplicar
###         los vectores originales para que se preserven las proporciones y los angulos
###         sumen pi, b = 2k*h)
obten_k <- function(x, y){
  z <- x/y
  f <- function(k) (sum(atan(k*z)) - pi/2)
  k <- uniroot(f, c(-1000,1000))$root
  return(k)
}

#### Creación de la grafica ####
print_plot <- function(titulo="Main Title", x, y, orden="No", 
                       Y_label="Afinidad", X_label="Penetración", max_side = 5,
                       colores = brewer.pal(N, "Set3")){
  orden_indices <- 1:length(x) #Orden de indices original
  #se preserva el color por triangulo
  if( orden == "X"){
    orden_indices <- order(x, decreasing = TRUE)
  } else {
    if (orden == "Y"){
      orden_indices <- order(y, decreasing = TRUE)
    }
  }
  x <- x[orden_indices]
  y <- y[orden_indices]
  colores <- colores[orden_indices]
  N <- length(x)
  ylim <- c(0,max_side)
  xlim <- c(-1*max_side,max_side)
  h_max <- min(max(xlim), max(ylim)) 
  
  #### Base plot area ####
  #png(filename=file, width = 800, height = 400, pointsize = 14)
  plot(x=0, y=0, ylim=ylim, xlim=xlim, pch = 20, axes = FALSE,
       xlab=Y_label, ylab=X_label, asp = 1, main = titulo)
  
  k <- obten_k(x, y) #k es la proporción entre las bases y las alturas.
  h <- h_max/max(y)
  b <- 2*k*h
  x_mod <- x*b
  alturas <- y*h
  angulos <- obten_angulos(x_mod, alturas)
  # Dados un vector de alturas y un vector de angulos crea la gráfica.
  plot_triangles(alturas, angulos, colores)  
  
  #### Dibujando los ejes ####
  
  #Eje X
  axis(1, col.axis = "black", at = c(min(xlim), 0, max(xlim)),
       labels = c(round(max(y)), "0", round(max(y))))
  #Calculando los catetos opuestos
  cat_op <- x_mod
  cat_max <- max(cat_op)
  #Eje Y
  
  Ym <- mean(ylim)
  Y_0 <- (Ym-(cat_max/2))
  Y_max <- (Ym+(cat_max/2))
  Y100 <- ((Y_max - Y_0)/round(max(x)) * 100 ) + Y_0
  Y_labels <- c("0", round(max(x)*100))
  Y_at <- c(Y_0, Y_max )
  axis(2, col.axis = "black", at = Y_at,
       labels = Y_labels)
  #dev.off()
}


