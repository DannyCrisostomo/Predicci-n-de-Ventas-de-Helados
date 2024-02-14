#<------------------------------------------------------------------------------------------>
#<----------------------------TAREA ENTREGABLE DE UNA HELADERIA----------------------------->
#<------------------------------------------------------------------------------------------>

# Mostrara la ruta del directorio de trabajo
getwd()

# Para cambiar el directorio del trabajo

setwd("C:\Users\Danny VC\Desktop\big data\Codigo")
setwd("C:\\Users\\Danny VC\\Desktop\\big data\\Codigo")

# Instalar la biblioteca ggplot2 y crayon
install.packages("ggplot2")
install.packages("crayon")


# Cargar la biblioteca ggplot2
library(ggplot2)
library(crayon)

#<------------------------------------------------------------------------------------------>
#<------------------------------------------------------------------------------------------>
#<------------------------------------------------------------------------------------------>

# Creamos un data frame con la informacion de la heladeria 

heladeria <- data.frame(
  id_heladeria = 1:36,
  ubicacion = c(
    rep("Cuzco",8),
    rep("Pasco",5),
    rep("Lima",10),
    rep("Junin",2),
    rep("Ica",5),
    rep("Tumbes",6)
    )
)

# Creamos un data frame con los datos de ventas

ventas <-data.frame(
  id_heladeria = sample(1:36,1000,replace=TRUE),
  fecha = sample(seq(as.Date('2021/01/01'), as.Date('2023/12/31'),by="day"),1000,replace = TRUE),
  ventas_soles = rnorm(1000,mean = 1000,sd=500)
)

# Creamos un data frame con los datos de temperatura

temperaturas <-data.frame(
  fecha = seq(as.Date('2021/01/01'), as.Date('2023/12/31'),by="day"),
  temperatura_min = round(runif(1095,min = 10, max = 30),1),
  temperatura_max = round(runif(1095,min = 20, max = 40),1)
)

# Creamos un data frame con los datos de calendario laboral

calendario_laboral <-data.frame(
  fecha = seq(as.Date('2021/01/01'), as.Date('2023/12/31'),by="day"),
  dia_laboral = sample ( c (TRUE, FALSE),1095,replace = TRUE)
)

#<------------------------------------------------------------------------------------------>
#<-------------------DIAGRAMA DE DENSIDAD PARA PREDECIR LAS VENTAS FUTURAS------------------>
#<------------------------------------------------------------------------------------------>

# Calcular las ventas diarias totales de todas las heladerias

ventas_diarias_totales <-aggregate(ventas$ventas_soles, by=list(ventas$fecha),sum)
names(ventas_diarias_totales)<-c("fecha","ventas_totales")

# Crear un data frame con los datos de ventas totales diarias y la temperatura minima

ventas_temperaturas <- merge(ventas_diarias_totales, temperaturas, by= "fecha", all.x = TRUE)

# Crear un diagrama de fucion de densidad de las ventas totales diarias

ggplot(ventas_temperaturas, aes(x = ventas_totales)) +
  geom_density(fill = "#ff0045", alpha = 0.5) +
  labs(title = "Fusión de densidad de las ventas totales diarias",
       x = "Ventas totales diarias (en soles)",
       y = "Densidad") +
  theme_bw()

#<------------------------------------------------------------------------------------------>
#<-------------------------GRAFICO DE BARRA CANT. VENTAS POR HELADERIA---------------------->
#<------------------------------------------------------------------------------------------>

# Agrupar las ventas por heladeria y sumar ventas

ventas_por_heladeria = aggregate(ventas_soles ~ id_heladeria, data = ventas,sum)

# Crear el grafico de barras 

ggplot(data = ventas_por_heladeria, aes(x=id_heladeria , y=ventas_soles))+
  geom_bar(stat = "identity", fill= "steelblue")+
  labs(title = "Ventas de helados por heladeria", x= heladeria, y="Ventas (Soles)")

#<------------------------------------------------------------------------------------------>
#<-----------GRAFICO DE SERIE TEMPORAL PARA MODELAR EL COMPORTAMIENTO DE LAS VENTAS--------->
#<------------------------------------------------------------------------------------------>

# Instalar y cargar la biblioteca 'xts'

install.packages("xts")
library(xts)

# Creamos la serie temporal a partir del data frame

ventas_xts <-xts(ventas$ventas_soles, order.by = ventas$fecha)

# Creamos ekl grafico de serie temporal utilizando la funcion 'plot' 'xts'

plot (ventas_xts, main="Ventas de heladerias", ylab="ventas en soles")

#<------------------------------------------------------------------------------------------>
#<-----------GRAFICO DE DISPERSION (SCATTER) CON LOS DATOS DE VENTAS Y TEMPERATURAS--------->
#<------------------------------------------------------------------------------------------>

# Unimos los data frames de ventas y temperatura

datos <- merge (ventas,temperaturas, by="fecha")

# Creamos el grafico de dispercion

ggplot(data=datos, aes (x=temperatura_max, y=ventas_soles))+
  geom_point()+
  labs(title = "Ventas en funcion de la temperatura maxima", x="Temperatura maxima (°C)", y="Ventas (Soles)")

#<------------------------------------------------------------------------------------------>
#<----------GRAFICO DE REGRESION LINEAL DE LAS VENTAS EN FUNCION DE LA TEMPERATURAS--------->
#<------------------------------------------------------------------------------------------>

# Unimos los data frames de ventas y temperatura

datos <- merge(ventas,temperaturas,by="fecha") 

# Creamos el grefico de dispersion con la linea de regresion 

ggplot(data=datos, aes (x=temperatura_max, y=ventas_soles))+
  geom_point()+
  geom_smooth(method = "lm", se=FALSE)+
  labs(title = "Ventas en funcion de la temperatura maxima", x="Temperatura maxima (°C)", y="Ventas (Soles)")

#<------------------------------------------------------------------------------------------>
#<---------------------------------GRAFICO DE LINEAS APILADAS------------------------------->
#<------------------------------------------------------------------------------------------>
# Unimos la informacion de ventas y ubicacion de cada heladeria

ventas_ubicacion <-merge(ventas, heladeria, by="id_heladeria")

# Sumamos las ventas de cada ubicacion en cada dia y unirlas con los datos de temperatura y calendario laboral

install.packages("dplyr")
library(dplyr)

# Agregación de ventas por ubicación y unión con temperaturas y calendario laboral

ventas_temp_calendario <- ventas_ubicacion %>%
  group_by(fecha, ubicacion) %>%
  summarize(ventas_soles = sum(ventas_soles)) %>%
  left_join(temperaturas, by = "fecha") %>%
  left_join(calendario_laboral, by = "fecha")

#<------------------------------------------------------------------------------------------>
#<--MODELO DE REGRESION LINEAL PARA PREDECIR LA VENTAS DE FUTURAS POSTERIORES DEL AÑO 2023-->
#<------------------------------------------------------------------------------------------>

# Unimos los datos de ventas y temperatura usando la fecha como clave

ventas_temperatura <-merge(ventas, temperaturas, by="fecha")

# Calculamos la temperatura promedio para cada dia

ventas_temperatura$temperatura_promedio <- (ventas_temperatura$temperatura_min + ventas_temperatura$temperatura_max) / 2

# Ajustamos un modelo de regresion lineal

modelo <- lm(ventas_soles ~ temperatura_promedio, data =ventas_temperatura)

# Hacemos una prediccion para los años posteriores a 2023

nuevas_fechas <-seq(as.Date("2024-01-01"), as.Date("2025-12-31"), by="day")
nuevas_temperaturas <- data.frame(fecha=nuevas_fechas,
                                  temperatura_min = round(runif(length(nuevas_fechas), min=10, max = 30),1),
                                  temperatura_max = round(runif(length(nuevas_fechas), min=20, max = 40),1)
                                  )
nuevas_temperaturas$temperatura_promedio <- (nuevas_temperaturas$temperatura_min + nuevas_temperaturas$temperatura_max)
nuevas_predicciones <- predict(modelo,nuevas_temperaturas)

# Creamos un grafico de las ventas y las predicciones

ggplot(ventas_temperatura, aes(x = fecha, y = ventas_soles)) +
  geom_line(color = "orange") + 
  geom_line(aes(y = predict(modelo, ventas_temperatura)), color = "red") +
  geom_line(data = data.frame(fecha = nuevas_fechas, ventas_soles = nuevas_predicciones),
            aes(x = fecha, y = ventas_soles), color = "yellow") +
  labs(title = "Predicción de ventas para 2024 y 2025", x = "Fecha", y = "Ventas en Soles")


