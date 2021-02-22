#while($true) {
#    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#    $cpuTime = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
#    $availMem = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
#    $date + ' > CPU: ' + $cpuTime.ToString("#,0.000") + '%, Avail. Mem.: ' + $availMem.ToString("N0") + 'MB (' + (104857600 * $availMem / $totalRam).ToString("#,0.0") + '%)'
#    Start-Sleep -s 2
#}

$totalRam = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).Sum
$computerName =  [Environment]::MachineName
$cores=[System.Environment]::ProcessorCount 
$listener = New-Object System.Net.HttpListener; 
$listener.Prefixes.Add('http://*:80/'); 
$listener.Start();Write-Host('Listening at http://*:80/'); 
while ($listener.IsListening) 
{ 
    $context = $listener.GetContext(); 
    $response = $context.Response; 
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $cpuTime = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $availMem = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
    $content = @{ totalMemMb=$totalRam/1048576; 
                  date=$date; 
                  computerName=$computerName;
                  cores=$cores;
                  availableMemMb= $availMem.ToString("N0");
                  availableMemPercent=(104857600 * $availMem / $totalRam).ToString("#,0.0");
                  cpu=$cpuTime.ToString("#,0.000") }  | ConvertTo-Json 
    #$content = $date + ' > CPU: ' + $cpuTime.ToString("#,0.000") + '%, Total Mem: ' + $totalRam + 'MB, Avail. Mem.: ' + $availMem.ToString("N0") + 'MB (' + (104857600 * $availMem / $totalRam).ToString("#,0.0") + '%)'
    #$content='<html><body><H1>Red Hat OpenShift + Windows Container Workloads</H1></body></html>'; 
    Write-Output $content
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content); 
    $response.ContentLength64 = $buffer.Length; 
    $response.OutputStream.Write($buffer, 0, $buffer.Length); 
    $response.Close(); 
};
