# Debug de Conexión con FastAPI

## Pasos para diagnosticar el problema

### 1. Verificar que FastAPI esté corriendo
- Debe estar en: `http://127.0.0.1:8000`
- Prueba en el navegador: `http://127.0.0.1:8000/docs`

### 2. Verificar CORS en FastAPI
Asegúrate de tener esto en tu `main.py` de FastAPI:

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# IMPORTANTE: Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, usa orígenes específicos
    allow_credentials=True,
    allow_methods=["*"],  # GET, POST, PATCH, DELETE, OPTIONS
    allow_headers=["*"],  # Incluye Authorization para JWT
)
```

### 3. Verificar el formato de respuesta del API

FastAPI puede devolver respuestas en diferentes formatos:

**Opción 1: Lista directa**
```json
[
  {"product_id": 1, "name": "Producto 1", ...},
  {"product_id": 2, "name": "Producto 2", ...}
]
```

**Opción 2: En objeto 'data'**
```json
{
  "data": [
    {"product_id": 1, "name": "Producto 1", ...}
  ]
}
```

**Opción 3: En objeto 'items'**
```json
{
  "items": [
    {"product_id": 1, "name": "Producto 1", ...}
  ]
}
```

El código ahora maneja todos estos formatos automáticamente.

### 4. Verificar autenticación JWT

El token JWT se envía automáticamente en el header:
```
Authorization: Bearer <tu_token>
```

Verifica en tu backend FastAPI que:
- Acepta el header `Authorization`
- Valida el token JWT correctamente
- Los endpoints requieren autenticación

### 5. Prueba manual con curl o Postman

```bash
# Obtener token primero (desde Node.js)
curl -X POST http://127.0.0.1:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"tu@email.com","password":"tu_password"}'

# Luego usar el token con FastAPI
curl -X GET http://127.0.0.1:8000/products/ \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

### 6. Revisar logs en la terminal

Si ves errores como:
- `OPTIONS /products/ HTTP/1.1" 400 Bad Request` → Problema de CORS
- `GET /products/ HTTP/1.1" 401 Unauthorized` → Problema de token JWT
- `Connection refused` → FastAPI no está corriendo

### 7. Verificar estructura de datos

Asegúrate de que los modelos coincidan con lo que devuelve FastAPI:

**ProductModel espera:**
- `product_id` (int)
- `name` (string)
- `description` (string, opcional)
- `price` (number)
- `stock` (int)
- `category_id` (int)
- `active` (bool)
- etc.

**CategoryModel espera:**
- `category_id` (int)
- `name` (string)
- `description` (string, opcional)

Si tu API usa nombres diferentes, actualiza los modelos en:
- `lib/features/products/data/models/product_model.dart`
- `lib/features/categories/data/models/category_model.dart`

