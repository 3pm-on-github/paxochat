# https://github.com/eletrixtime/paxochat
# Code is bad i know, this is just a PoC

from flask import Flask,request
import random
import time

app = Flask(__name__)

USERS = []
i = 0
MESSAGES = []

@app.route("/api/ping")
def API_Ping():
    global i  # goffy ahh variable
    i += 1
    a = i
    USERS.append(a)
    return str(a)

@app.route("/api/send")
def API_Send():
    global MESSAGES
    if not int(request.args["id"]) in USERS:
        return "INVALID-ID",403
    x = f"User{request.args["id"]} : {request.args["text"]}"
    MESSAGES.append({
        "id":request.args["id"],
        "timestamp":time.time(),
        "content": request.args["text"],
        "paxo_formatted":x
    })
    return "SENDED"
@app.route("/api/last")
def API_last_msg():
    EXCLUDE_ID = request.args.get("ex_id")

    if not MESSAGES:
        return "NO-MESSAGE", 404

    last_msg = MESSAGES[-1]
    
    if str(last_msg["id"]) == str(EXCLUDE_ID):
        return "NO-MESSAGE", 204  
    
    return last_msg["paxo_formatted"]

if __name__ == "__main__":
    app.run(port=5000,host="0.0.0.0")
