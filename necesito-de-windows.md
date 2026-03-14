# Informacion necesaria desde Windows para hacer funcionar el display del AIO

## El problema actual

El script de macOS abre el dispositivo USB y envia datos correctamente,
pero el display del AIO no reacciona. Necesitamos saber exactamente
**que bytes envia el programa original de Windows** al dispositivo
USB (VID: 0x5131 / PID: 0x2007) para replicarlo identicamente.

---

## Que necesito capturar

### 1. El trafico USB HID exacto (PRIORITARIO)

**Programa a usar: USBPcap + Wireshark**

#### Pasos:
1. Descargar **USBPcap**: https://desowin.org/usbpcap/
2. Descargar **Wireshark**: https://www.wireshark.org/
3. Abrir Wireshark → seleccionar la interfaz USBPcap que corresponda
4. Iniciar la captura
5. Abrir "PC Monitor All.exe" y esperar que el display muestre datos
6. Detener la captura despues de 5-10 segundos
7. En Wireshark filtrar con: `usb.idVendor == 0x5131`
8. Exportar o hacer screenshot de los primeros 3-5 paquetes URB_INTERRUPT_OUT o SET_REPORT
9. Hacer clic en un paquete → expandir "HID Data" → copiar los bytes

**Lo que necesito ver:**
- Los bytes exactos del primer paquete enviado al dispositivo
- Cuantos bytes son en total (64 o 65?)
- Cual es el valor del byte[0] (es 0x00, 0x01 u otro?)

---

### 2. Alternativa mas simple: USBlyzer (trial gratuito)

Si Wireshark es complicado, usar **USBlyzer**:
1. Descargar: https://www.usblyzer.com/
2. Instalar y abrir
3. Menu → Start Capture → seleccionar el dispositivo "5131:2007"
4. Abrir PC Monitor All.exe
5. Detener captura
6. Buscar paquetes "URB_FUNCTION_HID_SET_REPORT" o "Output Report"
7. Copiar el contenido hexadecimal del primer paquete

---

### 3. Secuencia de inicializacion

Tambien necesito saber:
- Al abrir el programa, **el display se enciende inmediatamente** o tarda unos segundos?
- Si cierras el programa, **el display se apaga o queda congelado** en el ultimo valor?
- Existe algun **parpadeo o animacion inicial** cuando arranca el programa?

---

### 4. Log del programa (opcional)

En la carpeta del programa hay una carpeta `LOG/` con archivos `.txt`.
Abrir el mas reciente y copiar su contenido.

Ruta: `C:\Program Files (x86)\PC\PC Monitor All\LOG\`

---

## Resumen rapido

| Prioridad | Que capturar | Herramienta |
|-----------|-------------|-------------|
| Alta | Bytes HID crudos enviados al dispositivo | USBPcap + Wireshark |
| Alta | Bytes HID crudos (alternativa) | USBlyzer (trial) |
| Media | Comportamiento del display al iniciar/cerrar | Observacion directa |
| Baja | Logs del programa | Bloc de notas |

---

*Con los bytes exactos del primer paquete podemos ajustar el script
para que el display funcione identicamente a Windows.*
