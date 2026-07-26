package com.cafexpress.seguimiento

data class PedidoPreparado(
    val pedidoOriginal: PedidoContrato,
    val puntoRecogida: PuntoRecogida,
    val estadoPreparacion: String,
    val distanciaLocalClienteKm: Double,
    val distanciaPuntoRecogidaClienteKm: Double,
    val observaciones: String? = null
)

data class PedidoContrato(
    val version: String,
    val origen: String,
    val pedidoId: String,
    val timestamp: String,
    val cliente: Cliente,
    val cafeteria: Cafeteria,
    val items: List<ItemPedido>,
    val entrega: EntregaInfo,
    val distanciaKm: Double,
    val subtotal: Double,
    val costoEnvio: Double,
    val total: Double
)

data class Cliente(
    val nombre: String,
    val telefono: String
)

data class Cafeteria(
    val id: String,
    val nombre: String,
    val direccion: String,
    val lat: Double,
    val lng: Double
)

data class ItemPedido(
    val nombre: String,
    val tamano: String,
    val extras: List<String>,
    val cantidad: Int,
    val precioUnitario: Double,
    val total: Double
)

data class EntregaInfo(
    val lat: Double,
    val lng: Double,
    val direccion: String,
    val referencias: String? = null
)

data class PuntoRecogida(
    val lat: Double,
    val lng: Double,
    val descripcion: String
)
