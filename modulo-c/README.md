# Módulo C – Desarrollo de API REST (PHP Nativo)

[🔙 Volver al inicio](../README.md#-módulos-de-competencia)

[📄 Ver prueba](./Proyecto%20Prueba_Modulo_C.pdf)

En este módulo se debía construir una **API REST completamente funcional utilizando únicamente PHP nativo**, sin apoyo de frameworks ni librerías externas.  
La persistencia de los datos debía realizarse mediante un **archivo JSON**, implementando manualmente la gestión de rutas, peticiones HTTP, validaciones y respuestas en formato JSON.

---

## Desempeño Personal

Logré **desarrollar la API en su totalidad**, cumpliendo con todos los requerimientos y afinando detalles para optimizar la estructura general del proyecto.

Para la implementación, diseñé un **enrutador propio basado en expresiones regulares**, lo que me permitió manejar rutas dinámicas y **path parameters** (por ejemplo, `/usuarios/{id}`) de forma flexible y eficiente.

Además, empleé una **arquitectura basada en el patrón Front Controller**, que facilitó la **separación de responsabilidades** y el control centralizado de las peticiones, mejorando la mantenibilidad del código.

Cada módulo de la API fue desarrollado siguiendo **principios de programación orientada a objetos (POO)**, asegurando una estructura clara, reutilizable y escalable.  
El resultado final fue una **API completamente funcional, estable y bien organizada**, con correcto manejo de errores, validaciones y respuestas JSON coherentes.

Este módulo representó uno de mis mejores desempeños en la competencia, obteniendo una **calificación perfecta de 15 puntos**, gracias a la solidez técnica, el orden del código y la correcta aplicación de buenas prácticas en desarrollo backend con PHP puro.

---

## Ejecutar el proyecto

1. Copia el contenido de la carpeta `/solution` dentro de una nueva carpeta llamada `api-peliculas` ubicada en `C:\xampp\htdocs\`.
2. Inicia el servidor **Apache** desde el panel de control de **XAMPP**.
3. Realiza peticiones HTTP (**GET**, **POST**, **PUT**, **DELETE**) para probar la API desde tu herramienta favorita, como **Postman** o **Insomnia**.
