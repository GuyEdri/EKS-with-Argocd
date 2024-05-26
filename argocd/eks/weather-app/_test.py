import pytest
import requests

def test_site_is_reachable():
    url = "http://172.17.0.1:80/"
    response = requests.head(url)

    assert response.status_code == 200


if __name__ == "__main__":
    pytest.main()            
