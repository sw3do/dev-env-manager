# Web Application Example

This example provides an environment prepared for modern web application development.

## Included Tools

- **Node.js 20**: For frontend development
- **Python 3.11**: For backend API development
- **PostgreSQL 15**: Database
- **Redis**: Cache and session management
- **Development Tools**: Git, curl, wget, jq, tree

## Quick Start

```bash
# Enter development environment
nix develop

# Create frontend (React)
npx create-react-app frontend
cd frontend
npm start

# Create backend (FastAPI)
mkdir backend
cd backend
python -m venv venv
source venv/bin/activate
pip install fastapi uvicorn sqlalchemy psycopg2-binary

# Start database
mkdir postgres-data
pg_ctl -D ./postgres-data initdb
pg_ctl -D ./postgres-data -l postgres.log start

# Start Redis
redis-server
```

## Project Structure

```
web-app/
├── frontend/          # React application
├── backend/           # FastAPI backend
├── postgres-data/     # PostgreSQL data
├── flake.nix         # Nix configuration
└── README.md         # This file
```

## Example Backend (FastAPI)

```python
# backend/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Web App API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI!"}

@app.get("/api/health")
def health_check():
    return {"status": "healthy"}
```

## Running

```bash
# Run backend
cd backend
uvicorn main:app --reload --port 8000

# Run frontend (different terminal)
cd frontend
npm start
```