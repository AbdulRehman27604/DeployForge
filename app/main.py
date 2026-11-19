
from fastapi import FastAPI

app = FastAPI(
    title="DeployForge API",
    description="Cloud-Native Infrastructure and Deployment Automation Platform",
    version="1.0.0"
)

@app.get("/")
def home():
    return {
        "message": "Welcome to DeployForge",
        "status": "running"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy"
    }

@app.get("/info")
def application_info():
    return {
        "application": "DeployForge",
        "version": "1.0.0",
        "environment": "development"
    }
