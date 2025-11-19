# Nota sobre CORS en FastAPI

## Problema
Si ves errores como estos en la terminal de FastAPI:
```
INFO:     127.0.0.1:59553 - "OPTIONS /categories/ HTTP/1.1" 400 Bad Request
INFO:     127.0.0.1:64103 - "OPTIONS /products/ HTTP/1.1" 400 Bad Request
```

Esto significa que el backend FastAPI no está configurado correctamente para manejar las peticiones preflight (OPTIONS) de CORS.

## Solución
En tu backend FastAPI (archivo `main.py` o donde tengas la configuración), agrega lo siguiente:

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especifica los orígenes permitidos
    allow_credentials=True,
    allow_methods=["*"],  # Permite todos los métodos (GET, POST, PATCH, DELETE, OPTIONS)
    allow_headers=["*"],  # Permite todos los headers, incluyendo Authorization
)
```

## Para producción
En producción, cambia `allow_origins=["*"]` por:
```python
allow_origins=[
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    # Agrega los orígenes de tu app en producción
]
```

## Endpoints importantes
- **Node.js (Autenticación)**: `http://127.0.0.1:3000/api/auth/login`
- **FastAPI (Productos/Categorías)**: `http://127.0.0.1:8000/products/`, `/categories/`

## Autenticación JWT
Después de hacer login en Node.js, el token JWT se guarda automáticamente y se incluye en todas las peticiones a FastAPI usando el header `Authorization: Bearer <token>`.

