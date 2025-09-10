param(
    [string]$version = "17"
)

switch ($version) {
    "17" {
        setx JAVA_HOME "C:\Java\jdk-17"
        setx PATH "%JAVA_HOME%\bin;%PATH%"
        Write-Host "Java 17 activado"
    }
    "23" {
        setx JAVA_HOME "C:\Program Files\Java\jdk-23"
        setx PATH "%JAVA_HOME%\bin;%PATH%"
        Write-Host "Java 23 activado"
    }
    default {
        Write-Host "Versión desconocida. Usa 17 o 23"
    }
}

