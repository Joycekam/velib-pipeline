import requests

URL_STATUS = "https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole/station_status.json"
URL_INFO = "https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole/station_information.json"

def fetch(url):

    reponse = requests.get(url, timeout=30)
    reponse.raise_for_status()

    return reponse.json()

status = fetch(URL_STATUS)
info = fetch(URL_INFO)

stations_status = status["data"]["stations"]
stations_info = info["data"]["stations"]

print("Nombre de stations (status) :", len(stations_status))
print("Nombre de stations (info) :", len(stations_info))
print()

#Quelques exemples de données
print("Exemple d'une station (status) :", stations_status[0])
print()
print("Exemple d'une station (info) :", stations_info[0])

