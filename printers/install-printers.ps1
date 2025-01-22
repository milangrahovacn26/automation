$driverName = "HP Printer Driver"
$driverPath = ".\driver\driver.inf"

$printerName = "Printer 1"
$printerIp = "10"
$portName = "IP_$PrinterIp"

# Step 1: Install the driver using pnputil if it's not already installed
Invoke-Command {
    pnputil.exe -a $using:driverPath
}

# check if printer, ports and drivers are already installed
$driverExists = Get-PrinterDriver -name $driverName -ErrorAction SilentlyContinue
$portExists = Get-PrinterPort -Name $portName -ErrorAction SilentlyContinue
$printerExists = Get-Printer | Where-Object { $_.Name -eq $printerName }


# Install driver if not installed
if (-not $driverExists) {
    Write-Host "Driver not found. Installing driver..."
    try {
        Add-PrinterDriver -Name $using:driverName -InfPath $using:driverPath
        Write-Host "Driver installed successfully."
    } catch {
        Write-Host "Failed to install the driver: $_"
    }
} else {
    Write-Host "Driver already installed."
}

# Install port if not installed
if ($portExists) {
    Write-Host "Port already exists."
    try {
        Remove-PrinterPort -Name $portName
        Write-Host "Port '$portName' removed successfully."
    } catch {
        Write-Host "Failed to remove the port: $_"
    }
} else {
    Write-Host "Port does not exist. Adding port..."
    try {
        Add-PrinterPort -Name $portName -PrinterHostAddress $printerIp
        Write-Host "Port added successfully."
    } catch {
        Write-Host "Failed to add port: $_"
    }
}

# Re-install the printer
if ($printerExists) {
    Write-Host "Printer already exists."
    Write-Host "Removing printer '$printerName'..."
    try {
        Remove-Printer -Name $printerName
        Write-Host "Printer '$printerName' removed successfully."
    } catch {
        Write-Host "Failed to remove the printer: $_"
    }
} else {
    Write-Host "Printer does not exist. Adding printer..."
    try {
        Add-Printer -Name $printerName -DriverName $driverName -PortName $portName
        Write-Host "Printer added successfully."
    } catch {
        Write-Host "Failed to add printer: $_"
    }
}
