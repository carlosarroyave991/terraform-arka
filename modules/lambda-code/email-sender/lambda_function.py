import json
import urllib3
import os

def lambda_handler(event, context):
    try:
        # Parse del JSON del evento
        if isinstance(event, str):
            body = json.loads(event)
        else:
            body = event
        
        # Extraer datos del JSON
        to_email = body['to']
        subject = body['subject']
        email_body = body['body']
        
        # Configuración SendGrid
        api_key = os.environ.get('SENDGRID_API_KEY', 'TU_API_KEY_AQUI')
        
        # Preparar datos para SendGrid
        data = {
            "personalizations": [{
                "to": [{"email": to_email}],
                "subject": subject
            }],
            "from": {"email": "carlosarroyave991@gmail.com"},
            "content": [{
                "type": "text/plain",
                "value": email_body
            }]
        }
        
        # Enviar email usando SendGrid API
        http = urllib3.PoolManager()
        response = http.request(
            'POST',
            'https://api.sendgrid.com/v3/mail/send',
            body=json.dumps(data),
            headers={
                'Authorization': f'Bearer {api_key}',
                'Content-Type': 'application/json'
            }
        )
        
        if response.status == 202:
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Email enviado exitosamente',
                    'status': response.status
                })
            }
        else:
            return {
                'statusCode': 500,
                'body': json.dumps({
                    'error': f'Error enviando email: {response.status}',
                    'details': response.data.decode('utf-8')
                })
            }
        
    except KeyError as e:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'error': f'Campo requerido faltante: {str(e)}'
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': f'Error interno: {str(e)}'
            })
        }