package app.mylekha.plugins.bluetooth_scanner

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.os.Build
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.Exception
import java.util.*
import kotlin.collections.ArrayList

/** BluetoothScannerPlugin */
public class BluetoothScannerPlugin : FlutterPlugin, MethodCallHandler {
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "bluetooth_scanner")
        channel.setMethodCallHandler(BluetoothScannerPlugin());
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "bluetooth_scanner")
            channel.setMethodCallHandler(BluetoothScannerPlugin())
        }
    }

    var bluetoothAdapter: BluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
    var bluetoothDevice: BluetoothDevice? = null
    var bluetoothSocket: BluetoothSocket? = null
    var uuid: UUID? = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
    var address: String = "DC:0D:30:8A:B7:56";
    private var isEnable: Boolean? = true;
    var devices: Set<BluetoothDevice>? = setOf();

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {


        when (call.method) {
            "startDiscovery" -> {
                var res = startDiscovery()
                result.success(res)

            }
            "cancelDiscovery" -> {
                var res = cancelDiscovery()
                result.success(res)

            }
            "connect" -> {
                var res = connect()
                result.success(res)

            }
            "disconnect" -> {
                var res = disconnect()
                result.success(res)

            }
            "getBondedDevice" -> {
                var res: Set<BluetoothDevice> = getBondedDevice()

                var list: ArrayList<Map<String, String>> = arrayListOf<Map<String, String>>()
                for (it in res) {
                    list.add(mapOf<String, String>(
                            "name" to "${it.name}",
                            "address" to "${it.address}",
                            "bonded" to "${it.bondState}",
                            "type" to "${it.type}",
                            "uuids" to "${it.uuids}"))

                }

                result.success(list)

            }
            "write" -> {
                var bytes: List<Int> ?= call.argument<List<Int>>("bytes")
                var res = write(bytes!!)
                result.success(res)

            }
            "isConnected" -> {
                var res = isConnected();
                result.success(res)

            }
            "isEnable" -> {
                isEnable = bluetoothAdapter.isEnabled;
                var res = isEnable.toString();
                result.success(res)

            }
            "enable" -> {
                var res = enable();
                result.success(res)

            }
            "disable" -> {
                var res = disable();
                result.success(res)

            }
            else -> {
                result.notImplemented()
            }
        }
    }

    //startDiscovery
    private fun startDiscovery(): Boolean {
        var result: Boolean = bluetoothAdapter.startDiscovery();
        return result
    }

    //cancelDiscovery
    private fun cancelDiscovery(): Boolean {
        var result: Boolean = bluetoothAdapter.cancelDiscovery();
        return result
    }

    //connect
    private fun connect(): Boolean {
        var result: Boolean = false;
        try {
            bluetoothDevice = bluetoothAdapter!!.getRemoteDevice(address);
            bluetoothSocket = bluetoothDevice!!.createRfcommSocketToServiceRecord(uuid);
            if (this.bluetoothSocket != null)
                bluetoothSocket!!.connect();
            result = true;
        } catch (e: Exception) {
            println("Error: $e")
            result = false;
        }
        return result
    }

    //disconnect
    private fun disconnect(): Boolean {
        var result: Boolean = false;
        try {
            bluetoothSocket!!.close();
            result = true;
        } catch (e: Exception) {
            println("Error: $e")
            result = false;
        }
        return result
    }

    //getBondedDevice
    private fun getBondedDevice(): Set<BluetoothDevice> {
        devices = bluetoothAdapter!!.bondedDevices;
        return devices!!
    }

    //write
    private fun write(bytes: List<Int>): String {
        var result: String = "write";
        try {
            if (bluetoothSocket!!.isConnected) {
                bytes.forEach { bluetoothSocket!!.outputStream.write(it); }
                bluetoothSocket!!.close();
            }
            result = "completed!"
        } catch (e: Exception) {
            result = "Error: $e"
        }

        return result
    }

    //isConnected
    private fun isConnected(): Boolean {
        var result: Boolean = bluetoothSocket!!.isConnected;
        return result
    }

    //enable
    private fun enable(): Boolean {
        var result: Boolean = bluetoothAdapter!!.enable();
        isEnable = true;
        return result
    }

    //disable
    private fun disable(): Boolean {
        var result: Boolean = bluetoothAdapter!!.disable();
        isEnable = false;
        return result
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
