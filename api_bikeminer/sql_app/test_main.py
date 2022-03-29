from urllib import response
from fastapi.testclient import TestClient

from .main import app


client = TestClient(app)


def test_token():
    response = client.post(
            "/token", 
            headers={"accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"},
            data={"username": "testUser", "password": "123"}
        )
    assert response.status_code == 200
