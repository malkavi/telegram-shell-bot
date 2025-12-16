# Docker Setup for Telegram Shell Bot

Este documento explica cómo ejecutar el Telegram Shell Bot usando Docker.

## Requisitos

- Docker
- Docker Compose (opcional pero recomendado)

## Configuración

### 1. Configurar variables de entorno

Copia el archivo `.env.example` a `.env` y configura tus valores:

```bash
cp .env.example .env
```

Edita el archivo `.env` y configura:

- `TELEGRAM_API_TOKEN`: Token de tu bot obtenido de [@BotFather](https://telegram.me/BotFather)
- `ENABLED_USERS`: Tu ID de usuario de Telegram (separados por comas si son varios)

Para obtener tu ID de usuario de Telegram, puedes usar [@userinfobot](https://t.me/userinfobot)

### 2. Crear directorios necesarios

```bash
mkdir -p upload scripts
```

## Ejecución

### Opción 1: Usando Docker Compose (Recomendado)

```bash
docker-compose up -d
```

Para ver los logs:
```bash
docker-compose logs -f
```

Para detener el bot:
```bash
docker-compose down
```

### Opción 2: Usando Docker directamente

Construir la imagen:
```bash
docker build -t telegram-shell-bot .
```

Ejecutar el contenedor:
```bash
docker run -d \
  --name telegram-shell-bot \
  --restart unless-stopped \
  -e TELEGRAM_API_TOKEN="tu_token_aqui" \
  -e ENABLED_USERS="tu_user_id_aqui" \
  -v $(pwd)/upload:/app/upload \
  -v $(pwd)/scripts:/app/scripts \
  telegram-shell-bot
```

## Volúmenes

El contenedor utiliza los siguientes volúmenes:

- `./upload`: Directorio donde se guardan los archivos subidos al bot
- `./scripts`: Directorio para scripts personalizados que puedes ejecutar con `/script`

## Seguridad

⚠️ **IMPORTANTE**: Este bot ejecuta comandos shell, lo que puede ser peligroso si no se configura correctamente.

### Recomendaciones de seguridad:

1. **NUNCA uses el usuario root** para ejecutar el bot
2. **Configura correctamente** `ENABLED_USERS` con IDs de usuarios específicos
3. **NO uses** `-999999` en producción (deshabilita la autenticación)
4. Si necesitas hacer público el bot, configura:
   - `CMD_WHITE_LIST` en `settings.py` para limitar comandos permitidos
   - O establece `ONLY_SHORTCUT_CMD=True` para permitir solo comandos del menú

### Ejecución en contenedor

El contenedor ejecuta el bot en un entorno aislado, lo que añade una capa de seguridad. Sin embargo, ten en cuenta que:

- Los comandos se ejecutan **dentro del contenedor**, no en tu host
- El contenedor tiene acceso limitado a recursos del sistema
- Los archivos se guardan en los volúmenes montados

## Comandos útiles

Ver logs en tiempo real:
```bash
docker-compose logs -f telegram-shell-bot
```

Reiniciar el bot:
```bash
docker-compose restart telegram-shell-bot
```

Ejecutar comandos dentro del contenedor:
```bash
docker-compose exec telegram-shell-bot bash
```

Actualizar y reiniciar:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Troubleshooting

### El bot no responde

1. Verifica que el token sea correcto
2. Revisa los logs: `docker-compose logs telegram-shell-bot`
3. Asegúrate de que tu user ID esté en `ENABLED_USERS`

### Los comandos no funcionan

Recuerda que los comandos se ejecutan **dentro del contenedor**, no en tu máquina host. El sistema de archivos y las herramientas disponibles son las del contenedor.

### Necesito ejecutar comandos en el host

⚠️ **Advertencia**: Esto es un riesgo de seguridad significativo.

Si realmente necesitas ejecutar comandos en el host, tendrías que montar el socket de Docker (no recomendado) o usar SSH para conectarte al host desde el contenedor.
