#!/usr/bin/env pwsh


$old_prop = $(adb shell getprop debug.mono.log)

if ($old_prop -ne "timing")
{
    Write-Error "debug.mono.log: $old_prop"
    Write-Error "debug.mono.log is not set to 'timing'"
    Write-Error "Please run the following:"
    Write-Error "adb shell setprop debug.mono.log timing"
    exit 1
}

Write-Host "Building, deploying, and running app"
dotnet publish -t:Run -f net10.0-android

if ($? -ne $True)
{
    Write-Error "Could not build, deploy, or run the app."
    exit 1
}

Start-Sleep -Seconds 10

#adb shell run-as @PACKAGE_NAME@ cat files/.__override__/methods.txt > methods.txt

adb shell run-as com.companyname.methodstruncatetest cat files/.__override__/arm64-v8a/methods.txt > methods.txt

if ($? -ne $True)
{
    Write-Error "Unable to pull methods.txt"
    exit 1
}


Write-Host "Pulled methods.txt"