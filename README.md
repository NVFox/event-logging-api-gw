# Plataforma de Procesamiento de Eventos con Microservicios

Una arquitectura de microservicios reactiva diseñada para el procesamiento eficiente de eventos, registro y notificaciones push utilizando Spring Boot, RabbitMQ y MongoDB.

## Descripción General de la Arquitectura

Este proyecto sigue varios principios y patrones arquitectónicos, separando las responsabilidades en capas distintas para garantizar la mantenibilidad, la capacidad de prueba y la escalabilidad. La arquitectura se basa en los siguientes conceptos clave:

### Arquitectura Limpia y Desacoplada

La aplicación está estructurada en capas concéntricas:
- **Capa de Dominio** (núcleo): Contiene entidades y lógica de negocio
- **Capa de Casos de Uso / Aplicación**: Implementa reglas de negocio específicas de la aplicación
- **Capa de infraestructura**: Convierte datos entre casos de uso y maneja interacciones con agentes externos, como controladores

Esta separación asegura que las reglas de negocio sean independientes de la interfaz de usuario, la base de datos y los sistemas externos, permitiendo que cada componente sea desarrollado, probado y mantenido de manera independiente.

### Comunicación asíncrona entre componentes

La comunicación entre servicios se logra a través de brokers de mensajería (RabbitMQ), lo que permite:
- **Procesamiento Asíncrono**: Los servicios pueden operar independientemente sin acoplamiento directo
- **Event Sourcing**: Los cambios de estado se capturan como una secuencia de eventos inmutables
- **Tolerancia a Fallos**: Los mensajes persisten en la cola si los servicios no están disponibles temporalmente
- **Distribución de Carga**: El trabajo puede equilibrarse entre múltiples instancias de servicio

### Arquitectura Orientada a Microservicios

La plataforma se divide en tres microservicios especializados, cada uno con una responsabilidad única:
- **Procesador de Eventos**: Recibe y enruta eventos a través del sistema
- **Registrador de Auditoría - Logeo**: Registra todas las acciones para cumplimiento normativo y depuración
- **Servicio de Notificaciones**: Entrega notificaciones push a los usuarios finales

### Programación Reactiva

La aplicación aprovecha Spring WebFlux y Project Reactor para:
- **E/S no bloqueante**: Maximizar el rendimiento con un consumo menor de recursos
- **Manejo de Contrapresión**: Prevenir el agotamiento de recursos durante carga alta
- **Programación Funcional**: Permitir operaciones declarativas y componibles en flujos de datos
- **Resiliencia**: Mecanismos de reintento y manejo de errores incorporados

### Pipelines de CI

La plataforma incluye pipelines de CI para automatizar la construcción de microservicios. Esto asegura que automáticamente al pushear nuevos cambios, se actualicen los archivos correspondientes al repositorio y estén listos para despliegue a un ambiente productivo.

## Componentes

### 1. Servicio de Procesamiento de Eventos

Este servicio actúa como el centro para la ingesta y enrutamiento de eventos.

**Características Principales:**
- Expone endpoints API RESTful para la presentación de eventos
- Valida y transforma eventos entrantes
- Enruta eventos a colas apropiadas según su tipo y contenido
- Implementa cortocircuitos para fallos en servicios descendentes
- Proporciona capacidades de regulación de eventos para la gestión del tráfico

**Stack Tecnológico:**
- Spring Boot WebFlux
- Configuración de Productor RabbitMQ
- MongoDB para persistencia de eventos
- Lógica personalizada de validación y transformación de eventos

### 2. Servicio de Registro de Auditoría

Este servicio mantiene un registro completo de todas las actividades del sistema.

**Características Principales:**
- Consume eventos de colas de auditoría dedicadas
- Enriquece eventos con metadatos (marca de tiempo, contexto de usuario)
- Persiste eventos en MongoDB en un formato estandarizado
- Proporciona capacidades de consulta para análisis histórico

**Stack Tecnológico:**
- Spring Boot con Consumidor RabbitMQ
- Colecciones de series temporales en MongoDB
- Repositorios reactivos para acceso eficiente a datos
- Estrategias de indexación personalizadas para consultas optimizadas

### 3. Servicio de Notificaciones

Este servicio gestiona la entrega de notificaciones push a usuarios finales a través de múltiples canales.

**Características Principales:**
- Consume solicitudes de notificación de colas dedicadas
- Rastrea el estado de entrega y métricas de participación
- Maneja contenido de notificación basado en plantillas

**Stack Tecnológico:**
- Spring Boot con Consumidor RabbitMQ
- Integración con proveedores de notificaciones push

## Comenzando

### Requisitos Previos

- Docker y Docker Compose
- Java 17 o superior
- Maven 3.6+

## Configuración (WIP - Trabajando en ello...)

Cada servicio puede ser configurado utilizando perfiles de Spring y variables de entorno. Consulta los READMEs individuales de los servicios para opciones de configuración detalladas.

* **Servicio de procesamiento de eventos**: https://github.com/NVFox/pevent-registering-ms
* **Servicio de registro de auditoría**: https://github.com/NVFox/pevent-logger-ms
* **Servicio de notificaciones**: https://github.com/NVFox/pevent-notification-ms

Cada servicio tiene su propio Dockerfile, y adicionalmente se incluye en cada repositorio paquetes (imágenes de docker) pre construidas y listas para ejecutar desde un archivo `docker-compose.yml`.