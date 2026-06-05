# Examen-Proyecto

Aplicación móvil desarrollada en Flutter para el taller práctico de la materia **Aplicaciones Móviles**. El proyecto integra tres módulos que conectan la interfaz con servicios web, persistencia local híbrida y almacenamiento seguro en Android.

## Objetivo general

Implementar una solución en Flutter que permita:

- Consumir una API REST de forma asíncrona;
- Alternar entre almacenamiento SQL y NoSQL dentro de la misma interfaz;
- Guardar y recuperar configuraciones o secretos usando mecanismos nativos de Android expuestos desde Flutter.

## Módulos implementados

### 1. Comunicación de red con JSONPlaceholder

Se desarrolló una pantalla independiente para interactuar con la API de prueba [JSONPlaceholder](https://jsonplaceholder.typicode.com/).

Funcionalidad principal:

- Ingresar un ID para consultar un post con `GET /posts/{id}`;
- Mostrar `title` y `body` en un formulario editable;
- Actualizar la información con `PUT /posts/{id}`;
- Reflejar en pantalla la respuesta exitosa del servidor.

### 2. Persistencia dual: SQL + NoSQL

La aplicación incluye un mecanismo para alternar entre dos orígenes de datos locales desde la barra superior.

Características del módulo:

- Modo SQL con base de datos local SQLite;
- Modo NoSQL con almacenamiento local orientado a objetos/documentos;
- Eecarga inmediata del listado al cambiar el interruptor;
- Contraste visual del origen de datos usado en cada momento.

### 3. Almacenamiento seguro y configuración en Android

Se añadió la pantalla **Gestión de Secretos y Configuración** para guardar y recuperar pares clave-valor según el mecanismo seleccionado.

Opciones trabajadas en el proyecto:

- `SharedPreferences` para preferencias simples;
- `DataStore` para almacenamiento moderno de configuración;
- `EncryptedSharedPreferences` para datos sensibles.

Importante:

- **No se implementó Android Keystore System** en este proyecto.
- La interacción con APIs nativas de Android se realiza desde Flutter mediante el puente correspondiente.

## Tecnologías utilizadas

- Flutter
- Dart
- HTTP para consumo de APIs REST
- SQLite con `sqflite`
- NoSQL local con `Hive`
- `SharedPreferences`
- Canal nativo de Android para acceso a almacenamiento seguro

## Estructura general

La aplicación está organizada en una navegación inferior con tres secciones principales:

1. Módulo de red;
2. Módulo de persistencia dual;
3. Módulo de secretos y configuración.

## Observaciones

- El proyecto fue diseñado con enfoque académico y demostrativo.
- Los cambios realizados en la API externa solo afectan el estado visual, ya que JSONPlaceholder es un servicio de prueba.
- El objetivo principal es evidenciar cómo Flutter puede integrarse con servicios externos y capacidades nativas del sistema operativo Android.
