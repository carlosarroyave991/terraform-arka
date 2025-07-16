# Lambda Email Sender

Esta función Lambda envía correos electrónicos usando Amazon SES.

## Configuración previa

1. **Verificar el email remitente en SES:**
   ```bash
   aws ses verify-email-identity --email-address carlosarroyave991@cotecnova.edu.co
   ```
   - Ve a tu email institucional y confirma la verificación

2. **Modo Sandbox (inicial):**
   - Solo puedes enviar a emails verificados
   - Verifica también el email de destino para pruebas:
   ```bash
   aws ses verify-email-identity --email-address destinatario@ejemplo.com
   ```

3. **Salir del Sandbox (para producción):**
   - Solicita en la consola AWS SES
   - Una vez aprobado, envías a cualquier email
   - **Costo:** Primeros 62,000 emails/mes GRATIS

## Formato del JSON de entrada

```json
{
    "to": "destinatario@ejemplo.com",
    "subject": "Asunto del correo",
    "body": "Contenido del mensaje"
}
```

**Remitente fijo:** carlosarroyave991@cotecnova.edu.co

## Ejemplo de uso

### Invocar desde AWS CLI:
```bash
aws lambda invoke \
  --function-name dev-email-sender \
  --payload file://test_event.json \
  response.json
```

### Invocar desde API Gateway:
```bash
curl -X POST https://tu-api-gateway-url/send-email \
  -H "Content-Type: application/json" \
  -d '{
    "to": "carlosarroyave991@gmail.com",
    "subject": "recordatorio",
    "body": "pongase top"
  }'
```

## Respuestas

### Éxito (200):
```json
{
  "statusCode": 200,
  "body": "{\"message\": \"Email enviado exitosamente\", \"messageId\": \"0000014a-f896-4c4b-b19f-6c7c5e73dc00-000000\"}"
}
```

### Error (400/500):
```json
{
  "statusCode": 400,
  "body": "{\"error\": \"Campo requerido faltante: 'to'\"}"
}
```