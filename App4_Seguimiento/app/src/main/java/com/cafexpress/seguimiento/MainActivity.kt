package com.cafexpress.seguimiento

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import com.google.gson.Gson
import org.osmdroid.config.Configuration
import org.osmdroid.tileprovider.tilesource.TileSourceFactory
import org.osmdroid.util.GeoPoint
import org.osmdroid.views.MapView
import org.osmdroid.views.overlay.Marker
import org.osmdroid.views.overlay.Polyline
import java.io.File

class MainActivity : ComponentActivity() {

    private val gson = Gson()

    private var currentLocation = mutableStateOf<GeoPoint?>(null)
    private var pedidoActual = mutableStateOf<PedidoPreparado?>(null)
    private var isCompleted = mutableStateOf(false)

    private val locationReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "com.cafexpress.UPDATE_LOCATION") {
                val lat = intent.getDoubleExtra("lat", 0.0)
                val lng = intent.getDoubleExtra("lng", 0.0)
                if (lat != 0.0 && lng != 0.0) {
                    currentLocation.value = GeoPoint(lat, lng)
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val osmConfig = Configuration.getInstance()
        osmConfig.load(applicationContext, getSharedPreferences("osmdroid_seguimiento", Context.MODE_PRIVATE))
        osmConfig.userAgentValue = "Samira_Seguimiento_App"
        
        val baseDir = File(filesDir, "osm_seguimiento")
        if (!baseDir.exists()) baseDir.mkdirs()
        osmConfig.osmdroidBasePath = baseDir
        osmConfig.osmdroidTileCache = File(baseDir, "tiles")

        handleIntent(intent)

        setContent {
            MaterialTheme {
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    SeguimientoScreen(
                        pedido = pedidoActual.value,
                        currentLocation = currentLocation.value,
                        isCompleted = isCompleted.value
                    )
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        val filter = IntentFilter("com.cafexpress.UPDATE_LOCATION")
        registerReceiver(locationReceiver, filter, RECEIVER_EXPORTED)
    }

    override fun onPause() {
        super.onPause()
        try {
            unregisterReceiver(locationReceiver)
        } catch (e: Exception) {}
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent == null) return
        when (intent.action) {
            "com.cafexpress.SEGUIMIENTO_INICIO" -> {
                val json = intent.getStringExtra("pedido_completo")
                if (json != null) {
                    try {
                        pedidoActual.value = gson.fromJson(json, PedidoPreparado::class.java)
                        isCompleted.value = false
                    } catch (e: Exception) {
                        Log.e("Seguimiento", "Error decoding JSON: ${e.message}")
                    }
                }
            }
            "com.cafexpress.ENTREGA_COMPLETADA" -> {
                isCompleted.value = true
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SeguimientoScreen(
    pedido: PedidoPreparado?,
    currentLocation: GeoPoint?,
    isCompleted: Boolean
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Seguimiento en Vivo", color = Color.White) },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Color(0xFF1976D2))
            )
        }
    ) { padding ->
        Box(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
        ) {
            if (pedido != null) {
                MapaSeguimiento(pedido, currentLocation)
                
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)
                        .align(Alignment.TopCenter),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text("Pedido: ${pedido.pedidoOriginal.pedidoId}", fontWeight = FontWeight.Bold)
                        Text("Cliente: ${pedido.pedidoOriginal.cliente.nombre}")
                        Text("Repartidor en camino...", color = Color.Gray, fontSize = 14.sp)
                    }
                }

                if (isCompleted) {
                    // Resumen Final
                    AlertDialog(
                        onDismissRequest = { },
                        title = { Text("¡Entrega Completada!") },
                        text = { 
                            Column {
                                Text("Resumen del Recorrido:")
                                Text("Desde: ${pedido.pedidoOriginal.cafeteria.nombre}")
                                Text("Hasta: ${pedido.pedidoOriginal.entrega.direccion}")
                                Text("Distancia Total: ${pedido.pedidoOriginal.distanciaKm} km")
                            }
                        },
                        confirmButton = {
                            Button(onClick = { /* Cierra app o reinicia */ }) {
                                Text("Aceptar")
                            }
                        }
                    )
                }

            } else {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text("Esperando datos del pedido...")
                }
            }
        }
    }
}

@Composable
fun MapaSeguimiento(pedido: PedidoPreparado, currentLocation: GeoPoint?) {
    val context = androidx.compose.ui.platform.LocalContext.current
    
    val pickupPoint = remember { GeoPoint(pedido.puntoRecogida.lat, pedido.puntoRecogida.lng) }
    val deliveryPoint = remember { GeoPoint(pedido.pedidoOriginal.entrega.lat, pedido.pedidoOriginal.entrega.lng) }
    
    val mapView = remember {
        MapView(context).apply {
            setTileSource(TileSourceFactory.MAPNIK)
            setMultiTouchControls(true)
            controller.setZoom(16.0)
            controller.setCenter(deliveryPoint)
        }
    }

    val markerDelivery = remember {
        Marker(mapView).apply {
            position = deliveryPoint
            title = "Tú (Cliente)"
            setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM)
        }
    }
    
    val markerPickup = remember {
        Marker(mapView).apply {
            position = pickupPoint
            title = "Cafetería"
            setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_BOTTOM)
        }
    }

    val markerRepartidor = remember {
        Marker(mapView).apply {
            title = "Repartidor"
            setAnchor(Marker.ANCHOR_CENTER, Marker.ANCHOR_CENTER)
        }
    }

    val route = remember {
        Polyline(mapView).apply {
            outlinePaint.color = android.graphics.Color.BLUE
            outlinePaint.strokeWidth = 10f
            setPoints(listOf(pickupPoint, deliveryPoint))
        }
    }

    LaunchedEffect(currentLocation) {
        if (!mapView.overlays.contains(markerDelivery)) {
            mapView.overlays.add(markerPickup)
            mapView.overlays.add(markerDelivery)
            mapView.overlays.add(route)
            mapView.overlays.add(markerRepartidor)
        }

        if (currentLocation != null) {
            markerRepartidor.position = currentLocation
            mapView.controller.animateTo(currentLocation)
            mapView.invalidate()
        }
    }

    DisposableEffect(Unit) {
        mapView.onResume()
        onDispose {
            mapView.onPause()
        }
    }

    AndroidView(
        factory = { mapView },
        modifier = Modifier.fillMaxSize()
    )
}
