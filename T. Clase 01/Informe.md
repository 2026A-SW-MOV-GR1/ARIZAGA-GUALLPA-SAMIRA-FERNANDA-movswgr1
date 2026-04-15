# Informe: Arquitecturas y Estrategias en el Desarrollo Móvil Moderno
## **Fecha:** 15 de abril de 2026
## **Autores:** Samira Arízaga & Sebastián Sarasti


### Parte 1: El Viaje Arquitectónico del Desarrollo Móvil

Para entender si estas tecnologías siguen siendo relevantes, analicemos cómo resuelven el problema de renderizar píxeles en una pantalla:

1. **Desarrollo Nativo Puro (Swift/Kotlin)**
   * **Cómo funciona:** Usa los SDKs oficiales de Apple y Google. El código compila directamente a lenguaje de máquina (ARM) y se comunica sin intermediarios con las APIs del sistema operativo.
   * **Relevancia actual:** Altísima. Sigue siendo el estándar de oro para aplicaciones que requieren máxima seguridad, uso intensivo de hardware (cámaras, sensores) o computación espacial (AR).

2. **La Era del WebView (Cordova, Ionic inicial)**
   * **Cómo funciona:** Una aplicación nativa vacía que contiene un componente de navegador web (WebView). La app está escrita en HTML/CSS/JS.
   * **Relevancia actual:** Baja para apps de consumo masivo. Manipular el DOM web dentro de un móvil consume mucha memoria y no alcanza los 60 FPS estables. Se mantiene para aplicaciones empresariales internas muy sencillas.

3. **El Puente Nativo-JavaScript (React Native)**
   * **Cómo funciona:** Existen dos hilos principales: el hilo Nativo (UI) y el hilo de JavaScript (lógica). Se comunican pasando mensajes serializados en JSON a través de un "Bridge" (Puente) asíncrono.
   * **Relevancia actual:** Alta. Permite compartir hasta un 80% del código entre plataformas. Sin embargo, el "puente" tradicional es un cuello de botella para eventos de alta frecuencia (como animaciones complejas). *Nota: React Native está mitigando esto con su nueva arquitectura (JSI/Fabric), eliminando la serialización JSON.*

4. **El Motor de Renderizado Propio (Flutter)**
   * **Cómo funciona:** No usa componentes nativos ni puentes. Dart compila a código C/C++ y usa su propio motor gráfico (Skia, o el nuevo Impeller) para dibujar cada píxel directamente en el "canvas" de la pantalla usando OpenGL o Metal.
   * **Relevancia actual:** Muy alta. Al controlar cada píxel, garantiza que la UI se vea exactamente igual en iOS y Android, eliminando inconsistencias y ofreciendo un rendimiento muy cercano al nativo puro.


### Parte 2: Análisis Crítico (Instagram vs. Google Maps)

#### Ingeniería Inversa de la Decisión
* **¿Por qué Instagram apostó por integrar React Native?**
  Instagram comenzó como una app 100% nativa. Decidieron integrar React Native progresivamente (por ejemplo, en las vistas de notificaciones push o configuraciones) para aumentar la velocidad de iteración. React Native les permitía compartir código entre iOS y Android y hacer actualizaciones *Over-the-Air* (enviar código JS directamente a la app sin pasar por la revisión de las tiendas). Buscaban velocidad de entrega en features no críticos gráficamente.
* **¿Por qué Google Maps usa un núcleo Nativo/C++?**
  Un mapa interactivo no es una UI estándar; es un entorno de renderizado en tiempo real. Google Maps utiliza un núcleo compartido escrito en C++ para toda la lógica de negocio, enrutamiento y cálculos de geometría vectorial. La capa de presentación interactúa directamente con OpenGL/Vulkan/Metal para renderizar los mapas 3D. Un framework declarativo estándar no podría soportar la carga matemática y gráfica de los "vector tiles" (mosaicos vectoriales) a 60 FPS sin agotar la batería.

#### Análisis de Rendimiento y Arquitectura
* **Desafíos en Google Maps:**
  El principal desafío es el consumo de memoria y batería al mantener cálculos en tiempo real de ubicación (GPS), giroscopio y renderizado de mallas 3D, todo al mismo tiempo. Al usar C++ a bajo nivel, logran la eficiencia extrema requerida, envolviendo este motor gráfico en UI Nativa (SwiftUI/Jetpack Compose) para los menús y botones.
* **Cuellos de botella (el "Puente") en Instagram:**
  En componentes hechos con React Native, el scroll infinito de imágenes y videos es el peor escenario para el "bridge" asíncrono. El hilo de JS debe calcular la posición de cada nueva imagen y enviar los comandos al hilo Nativo en milisegundos. Si el puente se satura con mensajes JSON, los fotogramas se caen (frame drops). Tuvieron que implementar arquitecturas como `RecyclerListView` para reciclar componentes de UI en memoria y evitar saturar el puente, mitigando este *antipatrón* de rendimiento.

#### El Desafío de las Nuevas Pantallas (AR y Foldables)
* **¿Qué tecnología se adapta mejor?**
  Si el futuro es la Realidad Aumentada interactiva pura, **ambas fallarían** en su estado actual para el núcleo de la experiencia. Flutter dibuja en 2D (canvas) y requeriría reconstruir su motor (Impeller) para entornos espaciales 3D. React Native tendría que delegar el 90% del trabajo a módulos nativos pesados (ARKit/ARCore), haciendo que JS sea un intermediario inútil. Para AR, el desarrollo **Nativo** (junto con motores como Unity/Unreal) es mandatorio.

#### Veredicto Crítico
**Decisión:** Para una aplicación con mapas 3D, notificaciones de altísima frecuencia y soporte fluido para pantallas plegables, la elección debe ser **Nativo Puro (o una arquitectura híbrida estricta: Núcleo en C++ con UI Nativa Kotlin/Swift)**.

**Fundamentación de Ingeniería:**
1. **Mapas 3D:** Requieren acceso directo y de bajo nivel a las APIs gráficas del dispositivo. Pasar matrices de transformación 3D a través del puente de React Native destruirá el rendimiento.
2. **Notificaciones de alta frecuencia:** Saturarían el *event loop* de JavaScript o requerirían manejo en canales de plataforma de Flutter, añadiendo latencia.
3. **Foldables:** Exigen recálculos de *layout* instantáneos (al abrir o cerrar la pantalla) preservando el ciclo de vida de la aplicación. Los SDKs nativos tienen gestores de estado (ViewModel/State) diseñados a nivel del sistema operativo específicamente para transicionar estas configuraciones de hardware sin pérdida de memoria. Intentar forzar una herramienta *cross-platform* aquí terminaría en un código lleno de parches específicos por plataforma, arruinando la mantenibilidad del software.


### Pregunta Final: ¿Qué es un aplicativo nativo y cómo se clasifican?

Un **aplicativo nativo** es aquel software desarrollado específicamente para un sistema operativo determinado (iOS o Android), utilizando los lenguajes de programación, los kits de desarrollo de software (SDKs) y los compiladores oficiales provistos por los creadores del SO (Apple o Google). Tienen acceso irrestricto al hardware y a las APIs del dispositivo.

**Clasificación de Aplicaciones Nativas:**

1. **Nativas Tradicionales (Enfoque Imperativo):**
   * Usan lenguajes maduros y manipulación directa de vistas.
   * *Android:* Java o Kotlin usando XML para el diseño de interfaces.
   * *iOS:* Objective-C o Swift usando Storyboards/UIKit.
2. **Nativas Modernas (Enfoque Declarativo):**
   * Paradigma actual donde la interfaz reacciona automáticamente a los cambios de estado del código. Son el estándar moderno de la industria.
   * *Android:* Kotlin con **Jetpack Compose**.
   * *iOS:* Swift con **SwiftUI**.
3. **Nativas de Bajo Nivel / Sistemas:**
   * Desarrolladas para rendimiento extremo (motores gráficos, criptografía, procesamiento de audio/video).
   * *Android:* Utilizan el NDK (Native Development Kit) con C/C++.
   * *iOS:* Utilizan C o C++ interactuando directamente con los frameworks base del sistema.