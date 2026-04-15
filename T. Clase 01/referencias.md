Parte 1: Evolución, el "Puente" y el Motor de Renderizado Propio
Para respaldar la explicación sobre cómo evolucionaron los híbridos, el funcionamiento del puente nativo-JS (React Native) y el motor de renderizado (Flutter).

[1] A. Biørn-Hansen, C. Rieger, T. M. Grønli, S. M. Majchrzak, and G. Ghinea, "An Empirical Investigation of Performance Overhead in Cross-Platform Mobile Development Architectures," IEEE Transactions on Software Engineering, vol. 46, no. 4, pp. 384-399, April 2020.
(Responde a: Evolución arquitectónica, cuellos de botella de CPU/GPU en frameworks y comparación técnica entre nativo y multiplataforma).

[2] Google LLC, "Flutter Architectural Overview," flutter.dev, 2024. [Online]. Available: https://docs.flutter.dev/resources/architectural-overview. (accessed Apr. 15, 2026).
(Responde a: Cómo funciona por debajo el motor de renderizado propio usando Skia/Impeller y compilación AOT en C++).

Parte 2: Análisis Crítico de Instagram y Google Maps (Rendimiento)
Para fundamentar por qué el "puente" asíncrono afecta a aplicaciones de feeds infinitos (Instagram) y por qué una app de mapas requiere acceso nativo a las APIs gráficas.

[3] Meta Platforms, "The New Architecture - The Bridge and JSI," React Native Documentation, 2024. [Online]. Available: https://reactnative.dev/architecture/overview. (accessed Apr. 15, 2026).
(Responde a: El cuello de botella del puente basado en JSON que tuvo que enfrentar Instagram/Discord y cómo las arquitecturas reactivas lo están mitigando).

[4] S. Xanthopoulos and S. Xinogalos, "A comparative analysis of cross-platform GUI development models," in 2013 17th Panhellenic Conference on Informatics, 2013, pp. 248-253.
(Responde a: La necesidad de usar un núcleo compartido en C/C++ invocado vía JNI para cálculos vectoriales de alta demanda, como es el caso de la arquitectura de Google Maps).

Parte 3: Nuevas Pantallas (Foldables) y Realidad Aumentada (AR)
Para respaldar el veredicto sobre la gestión del estado en redimensionamientos de milisegundos y la latencia 3D.

[5] Google LLC, "Support foldable and dual-screen devices: Handling Configuration Changes," Android Developers Guidelines, 2024. [Online]. Available: https://developer.android.com/guide/topics/large-screens/build-for-foldables. (accessed Apr. 15, 2026).
(Responde a: La exigencia de arquitecturas reactivas donde el estado de la aplicación pueda transicionar sin perder datos al cambiar el tamaño de la pantalla).

[6] W. S. El-Kassas, B. A. Abdullah, A. H. Yousef, and A. M. Cleid, "Taxonomy of Cross-Platform Mobile Applications Development Approaches," Ain Shams Engineering Journal, vol. 8, no. 2, pp. 163-190, 2017.
(Responde a: El desafío de adaptar motores 2D a entornos XR/AR y por qué dependen de implementaciones nativas directas o motores 3D acoplados).

Parte 4: Definición y Clasificación de Aplicaciones Nativas
Para responder la pregunta final del taller sobre el cambio del paradigma imperativo al declarativo en el desarrollo nativo moderno.

[7] Apple Inc., "State and Data Flow in SwiftUI," Apple Developer Documentation, 2024. [Online]. Available: https://developer.apple.com/documentation/swiftui/state-and-data-flow. (accessed Apr. 15, 2026).
(Responde a: La clasificación de aplicativos nativos modernos usando enfoques declarativos acoplados directamente al ciclo de vida del sistema operativo).