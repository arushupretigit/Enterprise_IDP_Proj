
import os

from fastapi import FastAPI

app = FastAPI(
    title="IDP Sample Service",
    description="A simple application for the Internal Developer Platform capstone",
    version="1.0.0",
)

APP_VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/")
def root():
    return {
        "message": "Welcome to the IDP Sample Service!"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.get("/version")
def version():
    return {
        "application": "idp-sample-service",
        "version": APP_VERSION
    }
