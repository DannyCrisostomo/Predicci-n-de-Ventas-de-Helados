---
# 🍦 Predicción de ventas de helados de una Heladería 🍨

Este proyecto simula el análisis de datos y la generación de gráficos para una heladería, utilizando R para el análisis y ggplot2 para la visualización.

## 📂 Estructura de Archivos

- 📁 **Documentación**: Contiene archivos relacionados con la documentación del proyecto.
  - 📄 `diagramas.pdf`: PDF con los diagramas generados.
  - 📄 `ejercicio_jado.docx`: Documento Word con el ejercicio de JADO.

## 🛠️ Requisitos y Dependencias

- R (>= 3.0.0)
- ggplot2 (>= 3.0.0)
- xts (>= 0.12.1)
- dplyr (>= 1.0.0)
- crayon (>= 1.3.4)

## 📊 Análisis y Visualización de Datos

Este proyecto utiliza datos simulados para analizar las ventas y las temperaturas de una heladería, y generar gráficos para visualizar los datos.

### Ejemplo de Código

```R
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

# Agrupar las ventas por heladeria y sumar ventas

ventas_por_heladeria = aggregate(ventas_soles ~ id_heladeria, data = ventas,sum)

# Crear el grafico de barras 

ggplot(data = ventas_por_heladeria, aes(x=id_heladeria , y=ventas_soles))+
  geom_bar(stat = "identity", fill= "steelblue")+
  labs(title = "Ventas de helados por heladeria", x= heladeria, y="Ventas (Soles)")

```

## 📈 Resultados

- Se pudo visualizar la relación entre las ventas y las temperaturas, así como predecir las ventas futuras utilizando modelos de regresión lineal.

## 🚀 Ejecución del Proyecto

1. Clona el repositorio: `git clone https://github.com/tu_usuario/tu_repositorio.git`
2. Instala las dependencias: `install.packages(c("ggplot2", "xts", "dplyr", "crayon"))`
3. Ejecuta los scripts R en tu entorno de desarrollo.

## 📜 Licencia

Este proyecto está bajo la licencia MIT. Para más detalles, consulta el archivo [LICENSE](LICENSE).

---

Recuerda personalizar este README según las necesidades específicas de tu proyecto. ¡Espero que te sea útil!
