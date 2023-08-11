import time
import requests
import subprocess
import socketio
from dotenv import load_dotenv
from crontab import CronTab
import os

load_dotenv()

socket_url=os.getenv('SOCKET_URL')
cliRic=os.getenv("CLI_RIC")
cliPass=os.getenv("CLI_PASS")

sio = socketio.Client()

@sio.on('connect')
def on_connect():
    print("Connected to server")
    connect()

sio.connect(socket_url)

connected = False
geoLoc = None
whoami = None

def connect():
    global connected, geoLoc, whoami

    response = requests.get("https://freeipapi.com/api/json")
    if response.status_code == 200:
        geoLoc = response.json()
        payload = {
            "cliRic": cliRic,
            "password": cliPass,
            "geoLoc": geoLoc
        }
        sio.emit('client_connect', payload)

connect()

@sio.on('client_connected')
def on_client_connected(data):
    global connected, whoami
    whoami = data
    connected = True
    print('Connected to server')

@sio.on('new_message')
def on_new_message(data):
    parts = [data['message'][i:i+72] for i in range(0, len(data['message']), 72)]
    maxMessage = len(parts)
    currentMessage = 1

    for part in parts:
        if maxMessage > 1:
            part += f" .{currentMessage} of {maxMessage}."
        message = f"{data['fromCall'].upper()}: {part}"
        print(message)
        subprocess.run(['RemoteCommand', '7642', 'page', data['toRic'], message])
        currentMessage += 1

    sio.emit('message_sent', data['_id'])

@sio.on('rubric_message')
def on_rubric_message(data):
    subprocess.run(['sudo', 'RemoteCommand', '7642', 'page', data['toRubric'], data['message']])

def heartbeat():
    if whoami:
        sio.emit('heartbeat', whoami['_id'])

if __name__ == "__main__":
    while True:
        sio.wait()
