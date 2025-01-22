$printerName = "v8-floor1-printer3"
$printerIp = "10.0.6.13"
$portName = "IP_$PrinterIp"

# Step 1: Uninstall the printer
$printer = Get-Printer | Where-Object { $_.Name -eq $printerName }

if ($printer) {
    Write-Host "Uninstalling printer '$printerName'..."
    try {
        Remove-Printer -Name $printerName
        Write-Host "Printer '$printerName' uninstalled successfully."
    } catch {
        Write-Host "Failed to uninstall the printer: $_"
    }
} else {
    Write-Host "Printer '$printerName' not found."
}

# Step 2: Uninstall the printer port
$port = Get-WmiObject -Class Win32_TCPIPPrinterPort | Where-Object { $_.Name -eq $portName }

if ($port) {
    Write-Host "Removing port '$portName'..."
    try {
        Remove-PrinterPort -Name $portName
        Write-Host "Port '$portName' removed successfully."
    } catch {
        Write-Host "Failed to remove port: $_"
    }
} else {
    Write-Host "Port '$portName' not found."
}