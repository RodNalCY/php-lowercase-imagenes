<?php

// Ruta de la carpeta
// $directory = 'fotosllantas';
$directory = "/home/elsol/wordpress/extranet/wp-content/plugins/extelsol/imagenes/fotosllantas";
// Extensiones de archivos de imagen a procesar
$imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];

// Llamada a la función
renameImagesToLowercase($directory, $imageExtensions);

// Función para renombrar carpetas a minúsculas recursivamente
function renameImagesToLowercase($dir, $imageExtensions)
{
    // File Log de Imagenes
    $logFile = "lowercase_log.txt";
    if (is_dir($dir)) {
        $filesAndFolders = scandir($dir);

        foreach ($filesAndFolders as $item) {
            // Variable para almacenar el mensaje
            $message = "";
            // Ignora las carpetas especiales '.' y '..'
            if ($item != '.' && $item != '..') {
                $oldPath = $dir . DIRECTORY_SEPARATOR . $item;
                $newName = mb_strtolower($item); // Convierte el nombre a minúsculas
                $newPath = $dir . DIRECTORY_SEPARATOR . $newName;

                // Renombra carpetas y continúa con recursividad
                if (is_dir($oldPath)) {
                    if ($oldPath !== $newPath) {
                        rename($oldPath, $newPath);
                        $message = "Directory : $oldPath => $newPath\n";
                        echo $message . "<br>";
                        file_put_contents($logFile, $message . "\n", FILE_APPEND);
                    }
                    // Llama recursivamente para procesar el contenido de la carpeta
                    renameImagesToLowercase($newPath, $imageExtensions);

                    // Renombra solo archivos de imagen
                } else if (is_file($oldPath)) {
                    $extension = pathinfo($oldPath, PATHINFO_EXTENSION);
                    if (in_array(strtolower($extension), $imageExtensions)) {
                        if ($oldPath !== $newPath) {
                            rename($oldPath, $newPath);
                            $message =  "Image : $oldPath => $newPath\n";
                            echo $message . "<br>";
                            file_put_contents($logFile, $message . "\n", FILE_APPEND);
                        }
                    }
                }
            }
        }

        // echo $message;
    } else {
        $message = "La ruta especificada no es un directorio.\n";
        echo $message . "<br>";
        file_put_contents($logFile, $message . "\n", FILE_APPEND);
    }
}
