import os
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to the IDP Sample Service!"}


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_version_default():
    response = client.get("/version")
    assert response.status_code == 200
    assert response.json() == {
        "application": "idp-sample-service",
        "version": "1.0.0",
    }


def test_version_custom_env(monkeypatch):
    monkeypatch.setenv("APP_VERSION", "2.1.0-rc1")
    # Re-import or test env-driven behavior cleanly
    import importlib
    import app.main as main_module

    importlib.reload(main_module)
    test_client = TestClient(main_module.app)
    response = test_client.get("/version")
    assert response.status_code == 200
    assert response.json()["version"] == "2.1.0-rc1"
    monkeypatch.delenv("APP_VERSION", raising=False)
